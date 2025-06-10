package Dao;

import entity.Role;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDao {
    // 使用UserDao中的数据库连接方法
    private Connection getConnection() throws SQLException {
        return UserDao.getConnection();
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
}