package Dao;

import entity.Role;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDao {
    // 获取数据库连接（使用DBConnection工具类）
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // 获取所有角色
    public List<Role> getAllRoles() {
        List<Role> result = new ArrayList<>();
        String sql = "SELECT * FROM role";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                result.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // 根据ID获取角色
    public Role getRoleById(int roleId) {
        Role role = null;
        String sql = "SELECT * FROM role WHERE role_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    role.setDescription(rs.getString("description"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return role;
    }
    
    // 添加角色
    public boolean addRole(Role role) {
        String sql = "INSERT INTO role (role_name, description) VALUES (?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, role.getRoleName());
            pstmt.setString(2, role.getDescription());
            
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                // 获取生成的角色ID
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        role.setRoleId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // 更新角色
    public boolean updateRole(Role role) {
        String sql = "UPDATE role SET role_name = ?, description = ? WHERE role_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, role.getRoleName());
            pstmt.setString(2, role.getDescription());
            pstmt.setInt(3, role.getRoleId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // 删除角色（带事务处理）
    public boolean deleteRole(int roleId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 开始事务
            
            // 删除角色-用户关联
            try (PreparedStatement pstmt1 = conn.prepareStatement("DELETE FROM user_role WHERE role_id=?")) {
                pstmt1.setInt(1, roleId);
                pstmt1.executeUpdate();
            }
            
            // 删除角色-权限关联
            try (PreparedStatement pstmt2 = conn.prepareStatement("DELETE FROM role_permission WHERE role_id=?")) {
                pstmt2.setInt(1, roleId);
                pstmt2.executeUpdate();
            }
            
            // 删除角色
            try (PreparedStatement pstmt3 = conn.prepareStatement("DELETE FROM role WHERE role_id=?")) {
                pstmt3.setInt(1, roleId);
                int rows = pstmt3.executeUpdate();
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
}