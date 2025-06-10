package servlet;

import Dao.PermissionDao;
import filter.PermissionChecker;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeletePermissionServlet")
public class DeletePermissionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // 检查用户是否登录
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // 检查用户是否有删除权限
        if (!PermissionChecker.hasPermission(session, "function10")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有删除权限的权限");
            return;
        }
        
        // 获取权限ID参数
        String permissionIdParam = request.getParameter("permission_id");
        if (permissionIdParam == null || permissionIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少权限ID参数");
            return;
        }
        
        try {
            int permissionId = Integer.parseInt(permissionIdParam);
            PermissionDao permissionDao = new PermissionDao();
            
            // 执行删除操作
            boolean success = permissionDao.deletePermission(permissionId);
            
            if (success) {
                // 重定向回权限管理页面，带成功消息
                response.sendRedirect("PermissionServlet?success=权限删除成功");
            } else {
                // 重定向回权限管理页面，带错误消息
                response.sendRedirect("PermissionServlet?error=权限删除失败");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的权限ID格式");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}