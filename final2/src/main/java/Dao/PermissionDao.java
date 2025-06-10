package Dao;

import entity.Permission;
import entity.Role;
import entity.User;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PermissionDao {
    // 获取数据库连接（使用DBConnection工具类）
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // 获取指定用户的权限（非管理员场景）
    public List<Permission> getUserRolePermissions(int userId) {
        List<Permission> result = new ArrayList<>();
        String sql = "SELECT " +
                "p.permission_id AS permission_id, " +
                "p.permission_name AS permission_name, " +
                "p.description AS description, " +
                "r.role_id AS role_id, " +
                "r.role_name AS role_name, " +
                "ut.user_id AS user_id, " +
                "ut.username AS username " +
                "FROM user_table ut " +
                "JOIN user_role ur ON ut.user_id = ur.user_id " +
                "JOIN role r ON ur.role_id = r.role_id " +
                "JOIN role_permission rp ON r.role_id = rp.role_id " +
                "JOIN permission p ON rp.permission_id = p.permission_id " +
                "WHERE ut.user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Permission perm = new Permission();
                    perm.setPermissionId(rs.getInt("permission_id"));
                    perm.setPermissionName(rs.getString("permission_name"));
                    perm.setDescription(rs.getString("description"));
                    perm.setRoleId(rs.getInt("role_id"));
                    perm.setRoleName(rs.getString("role_name"));
                    perm.setUserId(rs.getInt("user_id"));
                    perm.setUserName(rs.getString("username"));
                    result.add(perm);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // 获取所有用户的权限（管理员场景）
    public List<Permission> getAllUserPermissions() {
        List<Permission> result = new ArrayList<>();
        String sql = "SELECT " +
                "p.permission_id AS permission_id, " +
                "p.permission_name AS permission_name, " +
                "p.description AS description, " +
                "r.role_id AS role_id, " +
                "r.role_name AS role_name, " +
                "ut.user_id AS user_id, " +
                "ut.username AS username " +
                "FROM user_table ut " +
                "JOIN user_role ur ON ut.user_id = ur.user_id " +
                "JOIN role r ON ur.role_id = r.role_id " +
                "JOIN role_permission rp ON r.role_id = rp.role_id " +
                "JOIN permission p ON rp.permission_id = p.permission_id " +
                "ORDER BY ut.user_id";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Permission perm = new Permission();
                perm.setPermissionId(rs.getInt("permission_id"));
                perm.setPermissionName(rs.getString("permission_name"));
                perm.setDescription(rs.getString("description"));
                perm.setRoleId(rs.getInt("role_id"));
                perm.setRoleName(rs.getString("role_name"));
                perm.setUserId(rs.getInt("user_id"));
                perm.setUserName(rs.getString("username"));
                result.add(perm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // 获取所有权限
    public List<Permission> getAllPermissions() {
        List<Permission> result = new ArrayList<>();
        String sql = "SELECT * FROM permission";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Permission perm = new Permission();
                perm.setPermissionId(rs.getInt("permission_id"));
                perm.setPermissionName(rs.getString("permission_name"));
                perm.setDescription(rs.getString("description"));
                result.add(perm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // 根据ID获取权限
    public Permission getPermissionById(int permissionId) {
        Permission permission = null;
        String sql = "SELECT * FROM permission WHERE permission_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, permissionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    permission = new Permission();
                    permission.setPermissionId(rs.getInt("permission_id"));
                    permission.setPermissionName(rs.getString("permission_name"));
                    permission.setDescription(rs.getString("description"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permission;
    }

    // 更新权限信息
    public boolean updatePermission(Permission permission) {
        String sql = "UPDATE permission SET permission_name = ?, description = ? WHERE permission_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, permission.getPermissionName());
            pstmt.setString(2, permission.getDescription());
            pstmt.setInt(3, permission.getPermissionId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 删除权限（带事务处理）
    public boolean deletePermission(int permissionId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 开始事务
            
            // 删除角色-权限关联
            try (PreparedStatement pstmt1 = conn.prepareStatement("DELETE FROM role_permission WHERE permission_id=?")) {
                pstmt1.setInt(1, permissionId);
                pstmt1.executeUpdate();
            }
            
            // 删除权限
            try (PreparedStatement pstmt2 = conn.prepareStatement("DELETE FROM permission WHERE permission_id=?")) {
                pstmt2.setInt(1, permissionId);
                int rows = pstmt2.executeUpdate();
                conn.commit(); // 提交事务
                return rows > 0;
            }
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            return false;
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
    
    // 分配权限（带事务处理，修复conn作用域问题）
    public boolean assignPermission(int userId, String roleName, String permissionValue) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 开启事务
            
            // 获取角色ID
            int roleId = getRoleId(roleName, conn);
            
            // 获取权限ID
            int permissionId = getPermissionId(permissionValue, conn);
            
            // 检查用户是否已有该角色
            boolean hasRole = checkUserHasRole(userId, roleId, conn);
            
            // 如果没有该角色，则添加用户-角色关联
            if (!hasRole) {
                addUserRole(userId, roleId, conn);
            }
            
            // 检查角色是否已有该权限
            boolean hasPermission = checkRoleHasPermission(roleId, permissionId, conn);
            
            // 如果没有该权限，则添加角色-权限关联
            if (!hasPermission) {
                addRolePermission(roleId, permissionId, conn);
            }
            
            // 提交事务
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            // 回滚事务
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            // 关闭连接
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    // 辅助方法：获取角色ID
    private int getRoleId(String roleName, Connection conn) throws SQLException {
        String sql = "SELECT role_id FROM role WHERE role_name = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, roleName);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("role_id");
                }
                throw new SQLException("角色不存在: " + roleName);
            }
        }
    }
    
    // 辅助方法：获取权限ID
    private int getPermissionId(String permissionValue, Connection conn) throws SQLException {
        String sql = "SELECT permission_id FROM permission WHERE permission_name = ? OR permission_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, permissionValue);
            pstmt.setString(2, permissionValue);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("permission_id");
                }
                throw new SQLException("权限不存在: " + permissionValue);
            }
        }
    }
    
    // 辅助方法：检查用户是否有指定角色
    private boolean checkUserHasRole(int userId, int roleId, Connection conn) throws SQLException {
        String sql = "SELECT * FROM user_role WHERE user_id = ? AND role_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, roleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    // 辅助方法：添加用户-角色关联
    private void addUserRole(int userId, int roleId, Connection conn) throws SQLException {
        String sql = "INSERT INTO user_role (user_id, role_id) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, roleId);
            pstmt.executeUpdate();
        }
    }
    
    // 辅助方法：检查角色是否有指定权限
    private boolean checkRoleHasPermission(int roleId, int permissionId, Connection conn) throws SQLException {
        String sql = "SELECT * FROM role_permission WHERE role_id = ? AND permission_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roleId);
            pstmt.setInt(2, permissionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    // 辅助方法：添加角色-权限关联
    private void addRolePermission(int roleId, int permissionId, Connection conn) throws SQLException {
        String sql = "INSERT INTO role_permission (role_id, permission_id) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roleId);
            pstmt.setInt(2, permissionId);
            pstmt.executeUpdate();
        }
    }
}