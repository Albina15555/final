//package Dao;
//
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//
//public class UserDao {
//    private static final String DB_URL = "jdbc:sqlite:D:/大学/大二/大二上/课程/java web/java web/11.1/jxgl.db";
//
//    // 获取数据库连接的方法，可根据实际情况调整配置等内容
//    public static Connection getConnection() throws SQLException {
//        try {
//            Class.forName("org.sqlite.JDBC");
//        } catch (ClassNotFoundException e) {
//            throw new SQLException("加载数据库驱动失败", e);
//        }
//        return DriverManager.getConnection(DB_URL);
//    }
//
//    // 验证用户登录的方法，使用try-with-resources确保连接自动关闭
//    public static boolean validateUser(String username, String password) throws SQLException {
//        String sql = "SELECT COUNT(*) FROM user_table WHERE username =? AND password =?";
//        try (Connection connection = getConnection();
//             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
//            preparedStatement.setString(1, username);
//            preparedStatement.setString(2, password);
//            try (ResultSet rs = preparedStatement.executeQuery()) {
//                if (rs.next()) {
//                    int count = rs.getInt(1);
//                    return count > 0;
//                }
//            }
//        }
//        return false;
//    }
//
//    // 新增方法，根据用户名和密码获取对应的用户ID
//    public static String getUserIdByUsernameAndPassword(String username, String password) throws SQLException {
//        String sql = "SELECT user_id FROM user_table WHERE username =? AND password =?";
//        try (Connection connection = getConnection();
//             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
//            preparedStatement.setString(1, username);
//            preparedStatement.setString(2, password);
//            try (ResultSet rs = preparedStatement.executeQuery()) {
//                if (rs.next()) {
//                    return rs.getString("user_id");
//                }
//            }
//        }
//        return null;}
//     // 新增：用户注册方法
//        public static boolean registerUser(String username, String password, String email) throws SQLException {
//            String sql = "INSERT INTO user_table (username, password, email) VALUES (?, ?, ?)";
//            try (Connection connection = getConnection();
//                 PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
//                preparedStatement.setString(1, username);
//                preparedStatement.setString(2, password);
//                preparedStatement.setString(3, email);
//                int rowsAffected = preparedStatement.executeUpdate();
//                return rowsAffected > 0;
//            }
//        }
//
//        // 新增：检查用户名是否已存在
//        public static boolean checkUsernameExists(String username) throws SQLException {
//            String sql = "SELECT COUNT(*) FROM user_table WHERE username = ?";
//            try (Connection connection = getConnection();
//                 PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
//                preparedStatement.setString(1, username);
//                try (java.sql.ResultSet rs = preparedStatement.executeQuery()) {
//                    if (rs.next()) {
//                        return rs.getInt(1) > 0;
//                    }
//                }
//            }
//            return false;
//        }
//    }
package Dao;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class UserDao {
    private static final String DB_URL =  "jdbc:sqlite:D:/大学/大二/大二上/课程/java web/java web/11.1/jxgl.db";

    // 获取数据库连接
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            throw new SQLException("加载数据库驱动失败", e);
        }
        return DriverManager.getConnection(DB_URL);
    }
    
    // 验证用户登录
    public static boolean validateUser(String username, String password) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user_table WHERE username =? AND password =?";
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // 根据用户名和密码获取用户ID
    public static String getUserIdByUsernameAndPassword(String username, String password) throws SQLException {
        String sql = "SELECT user_id FROM user_table WHERE username =? AND password =?";
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                return rs.next() ? rs.getString("user_id") : null;
            }
        }
    }

    // 用户注册
    public static boolean registerUser(String username, String password, String email) throws SQLException {
        String sql = "INSERT INTO user_table (username, password, email) VALUES (?, ?, ?)";
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            preparedStatement.setString(3, email);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    // 检查用户名是否已存在
    public static boolean checkUsernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user_table WHERE username = ?";
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, username);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
    public Map<Integer, Map<String, String>> getAllUserRoles() {
        Map<Integer, Map<String, String>> result = new HashMap<>();
        String sql = "SELECT u.user_id, u.username, r.role_name " +
                     "FROM user_table u " +
                     "JOIN user_role ur ON u.user_id = ur.user_id " +
                     "JOIN role r ON ur.role_id = r.role_id";
        
        try (Connection conn = getConnection();
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
            // 生产环境中应该记录日志
            System.err.println("查询用户角色失败: " + e.getMessage());
        }
        return result;
    }
}