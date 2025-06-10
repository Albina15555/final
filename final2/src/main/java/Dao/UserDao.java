package Dao;

import utils.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class UserDao {
    // 验证用户登录
    public static boolean validateUser(String username, String password) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user_table WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // 根据用户名和密码获取用户ID
    public static String getUserIdByUsernameAndPassword(String username, String password) throws SQLException {
        String sql = "SELECT user_id FROM user_table WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getString("user_id") : null;
            }
        }
    }

    // 用户注册
    public static boolean registerUser(String username, String password, String email) throws SQLException {
        String sql = "INSERT INTO user_table (username, password, email) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, email);
            return pstmt.executeUpdate() > 0;
        }
    }

    // 检查用户名是否已存在
    public static boolean checkUsernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user_table WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // 获取所有用户角色
    public Map<Integer, Map<String, String>> getAllUserRoles() {
        Map<Integer, Map<String, String>> result = new HashMap<>();
        String sql = "SELECT u.user_id, u.username, r.role_name " +
                "FROM user_table u " +
                "JOIN user_role ur ON u.user_id = ur.user_id " +
                "JOIN role r ON ur.role_id = r.role_id";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                String userName = rs.getString("username");
                String roleName = rs.getString("role_name");
                
                Map<String, String> userInfo = new HashMap<>();
                userInfo.put("userName", userName);
                userInfo.put("roleName", roleName);
                
                result.put(userId, userInfo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("查询用户角色失败: " + e.getMessage());
        }
        return result;
    }
}