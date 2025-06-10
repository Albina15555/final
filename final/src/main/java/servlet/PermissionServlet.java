package servlet;

import Dao.PermissionDao;
import Dao.UserDao;
import entity.Permission;
import filter.PermissionChecker;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PermissionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // 处理未登录情况
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        PermissionDao permissionDao = new PermissionDao();
        UserDao userDao = new UserDao();
        
        // 检查用户是否为管理员
        boolean isAdmin = PermissionChecker.hasPermission(session, "function10");
        
        // 获取所有权限
        List<Permission> userPerms;
        if (isAdmin) {
            // 管理员获取所有用户的权限
            userPerms = permissionDao.getAllUserPermissions();
            System.out.println("管理员获取了所有用户的权限");
        } else {
            // 非管理员仅获取自身权限
            userPerms = permissionDao.getUserRolePermissions(userId);
            System.out.println("非管理员获取了自身权限");
        }
        
        // 获取所有用户的角色映射（仅管理员需要）
        Map<Integer, Map<String, String>> userRoles = new HashMap<>();
        if (isAdmin) {
            userRoles = userDao.getAllUserRoles();
        }
        
        // 获取成功和错误消息参数 (修复了变量名)
        String success = req.getParameter("success"); // 使用 req 而不是 request
        String error = req.getParameter("error");    // 使用 req 而不是 request
        
        if (success != null) {
            req.setAttribute("successMessage", success);
        }
        
        if (error != null) {
            req.setAttribute("errorMessage", error);
        }
        
        // 设置请求属性
        req.setAttribute("userPerms", userPerms);
        req.setAttribute("userRoles", userRoles);
        
        // 转发到权限管理页面
        req.getRequestDispatcher("/function10.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}