//package servlet;
//
//import java.io.IOException;
//import java.sql.SQLException;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import Dao.UserDao;
//
//@WebServlet("/RegisterServlet")
//public class RegisterServlet extends HttpServlet {
//    private static final long serialVersionUID = 1L;
//
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        // 直接跳转到注册页面（通过login.jsp的选项卡切换）
//        request.getRequestDispatcher("login.jsp").forward(request, response);
//    }
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//        if ("register".equals(action)) {
//            String username = request.getParameter("username");
//            String password = request.getParameter("password");
//            String email = request.getParameter("email");
//
//            try {
//                // 检查用户名是否已存在
//                if (UserDao.checkUsernameExists(username)) {
//                    request.setAttribute("error", "用户名已存在，请更换用户名");
//                    request.getRequestDispatcher("login.jsp").forward(request, response);
//                    return;
//                }
//
//                // 执行注册
//                boolean success = UserDao.registerUser(username, password, email);
//                if (success) {
//                    request.setAttribute("message", "注册成功，请登录");
//                    request.getRequestDispatcher("login.jsp").forward(request, response);
//                } else {
//                    request.setAttribute("error", "注册失败，请稍后再试");
//                    request.getRequestDispatcher("login.jsp").forward(request, response);
//                }
//            } catch (SQLException e) {
//                e.printStackTrace();
//                request.setAttribute("error", "系统错误，请稍后再试");
//                request.getRequestDispatcher("login.jsp").forward(request, response);
//            }
//        }
//    }
//}
package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Dao.UserDao;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");

            try {
                // 检查用户名是否已存在
                if (UserDao.checkUsernameExists(username)) {
                    request.setAttribute("error", "用户名已存在，请更换用户名");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // 执行注册
                boolean success = UserDao.registerUser(username, password, email);
                if (success) {
                    request.setAttribute("message", "注册成功，请登录");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "注册失败，请稍后再试");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "注册失败: " + e.getMessage(), e);
                request.setAttribute("error", "数据库错误：" + e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "未知错误: " + e.getMessage(), e);
                request.setAttribute("error", "系统错误：" + e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }
}