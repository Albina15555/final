package Dao;

import entity.Permission;
import entity.Role;
import entity.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PermissionDao {
    // 使用UserDao中的数据库连接方法
    private Connection getConnection() throws SQLException {
        return UserDao.getConnection();
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
                    permission.setPermissionCode(rs.getString("permission_code"));
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
    
 // PermissionDao.java 修复事务回滚
    public boolean deletePermission(int permissionId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 开始事务
            
            // 删除关联数据
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
    
    // 分配权限
    public boolean assignPermission(int userId, String roleName, String permissionValue) {
        // 1. 获取角色ID
        String sql1 = "SELECT role_id FROM role WHERE role_name = ?";
        
        // 2. 获取权限ID
        String sql2 = "SELECT permission_id FROM permission WHERE permission_name = ? OR permission_id = ?";
        
        // 3. 检查用户是否已有该角色
        String sql3 = "SELECT * FROM user_role WHERE user_id = ? AND role_id = ?";
        
        // 4. 如果没有，则添加用户-角色关联
        String sql4 = "INSERT INTO user_role (user_id, role_id) VALUES (?, ?)";
        
        // 5. 检查角色是否已有该权限
        String sql5 = "SELECT * FROM role_permission WHERE role_id = ? AND permission_id = ?";
        
        // 6. 如果没有，则添加角色-权限关联
        String sql6 = "INSERT INTO role_permission (role_id, permission_id) VALUES (?, ?)";
        
        try (Connection conn = getConnection()) {
            // 开启事务
            conn.setAutoCommit(false);
            
            int roleId;
            try (PreparedStatement pstmt1 = conn.prepareStatement(sql1)) {
                pstmt1.setString(1, roleName);
                try (ResultSet rs = pstmt1.executeQuery()) {
                    if (!rs.next()) {
                        throw new SQLException("角色不存在: " + roleName);
                    }
                    roleId = rs.getInt("role_id");
                }
            }
            
            int permissionId;
            try (PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
                pstmt2.setString(1, permissionValue); // 尝试按名称查找
                pstmt2.setString(2, permissionValue); // 尝试按ID查找
                try (ResultSet rs = pstmt2.executeQuery()) {
                    if (!rs.next()) {
                        throw new SQLException("权限不存在: " + permissionValue);
                    }
                    permissionId = rs.getInt("permission_id");
                }
            }
            
            // 检查用户是否已有该角色
            boolean hasRole;
            try (PreparedStatement pstmt3 = conn.prepareStatement(sql3)) {
                pstmt3.setInt(1, userId);
                pstmt3.setInt(2, roleId);
                try (ResultSet rs = pstmt3.executeQuery()) {
                    hasRole = rs.next();
                }
            }
            
            // 如果没有该角色，则添加用户-角色关联
            if (!hasRole) {
                try (PreparedStatement pstmt4 = conn.prepareStatement(sql4)) {
                    pstmt4.setInt(1, userId);
                    pstmt4.setInt(2, roleId);
                    pstmt4.executeUpdate();
                }
            }
            
            // 检查角色是否已有该权限
            boolean hasPermission;
            try (PreparedStatement pstmt5 = conn.prepareStatement(sql5)) {
                pstmt5.setInt(1, roleId);
                pstmt5.setInt(2, permissionId);
                try (ResultSet rs = pstmt5.executeQuery()) {
                    hasPermission = rs.next();
                }
            }
            
            // 如果没有该权限，则添加角色-权限关联
            if (!hasPermission) {
                try (PreparedStatement pstmt6 = conn.prepareStatement(sql6)) {
                    pstmt6.setInt(1, roleId);
                    pstmt6.setInt(2, permissionId);
                    pstmt6.executeUpdate();
                }
            }
            
            // 提交事务
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            // 回滚事务
            try (Connection conn = getConnection()) {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        }
    }
    
}