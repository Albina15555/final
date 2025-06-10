
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.Permission" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑权限 - 账务管理系统</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <style>
        /* 样式不变 */
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
    <!-- 顶部导航栏 -->
    <header class="w-full bg-white shadow-md fixed top-0 z-30">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-3">
                <div class="flex items-center space-x-3">
                    <div class="w-14 h-14 rounded-xl flex items-center justify-center mr-5 bg-blue-100 text-blue-600">
                        <i class="fa-solid fa-lock text-2xl"></i>
                    </div>
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">权限编辑</h1>
                </div>
                <div class="flex items-center space-x-4">
                    <a href="PermissionServlet" class="btn-primary flex items-center space-x-1">
                        <i class="fa-solid fa-arrow-left mr-1"></i>
                        <span>返回权限管理</span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <main class="max-w-4xl mx-auto pt-28 pb-16 px-4">
        <div class="text-center mb-10">
            <h2 class="text-2xl font-bold text-gray-800">编辑权限信息</h2>
            <p class="text-gray-600 mt-2">修改权限详细信息并进行更新</p>
        </div>
        
        <%
        // 获取权限ID参数
        String permissionIdParam = request.getParameter("permission_id");
        Permission permission = null;
        if (permissionIdParam != null && !permissionIdParam.isEmpty()) {
            int permissionId = Integer.parseInt(permissionIdParam);
            
            // 在实际应用中，从数据库获取权限信息
            // 这里使用模拟数据
            permission = new Permission();
            permission.setPermissionId(permissionId);
            permission.setPermissionName("查看账务记录");
            permission.setPermissionCode("view_record"); // 使用新增的方法
            permission.setDescription("允许查看财务系统中的账务记录数据");
        }
        %>
        
        <div class="bg-white form-card p-8">
            <form id="editPermissionForm" action="UpdatePermissionServlet" method="post">
                <input type="hidden" name="permission_id" value="<%= (permission != null) ? permission.getPermissionId() : "" %>">
                
                <div class="space-y-6">
                    <!-- 权限ID -->
                    <div class="flex items-center py-2">
                        <label class="block w-32 text-sm font-medium text-gray-700">权限ID</label>
                        <div class="text-gray-600 font-mono"><%= (permission != null) ? permission.getPermissionId() : "新权限" %></div>
                    </div>
                    
                    <!-- 权限名称 -->
                    <div>
                        <label for="permission_name" class="block text-sm font-medium text-gray-700 mb-1">权限名称</label>
                        <input type="text" id="permission_name" name="permission_name" required
                               value="<%= (permission != null) ? permission.getPermissionName() : "" %>"
                               class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <!-- 权限代码 -->
                    <div>
                        <label for="permission_code" class="block text-sm font-medium text-gray-700 mb-1">权限代码</label>
                        <input type="text" id="permission_code" name="permission_code" required
                               value="<%= (permission != null) ? permission.getPermissionCode() : "" %>"
                               class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <!-- 描述 -->
                    <div>
                        <label for="description" class="block text-sm font-medium text-gray-700 mb-1">描述</label>
                        <textarea id="description" name="description" rows="4"
                                  class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500"><%= (permission != null) ? permission.getDescription() : "" %></textarea>
                    </div>
                    
                    <!-- 适用角色 -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">适用角色</label>
                        <div class="flex flex-wrap gap-3 mt-2">
                            <label class="inline-flex items-center">
                                <input type="checkbox" name="roles" value="admin" class="rounded border-gray-300 text-purple-600 focus:ring-purple-500" checked>
                                <span class="ml-2 text-gray-700">管理员</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" name="roles" value="user" class="rounded border-gray-300 text-purple-600 focus:ring-purple-500">
                                <span class="ml-2 text-gray-700">普通用户</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="checkbox" name="roles" value="checkr" class="rounded border-gray-300 text-purple-600 focus:ring-purple-500">
                                <span class="ml-2 text-gray-700">审核财务人员</span>
                            </label>
                        </div>
                    </div>
                </div>
                
                <div class="flex justify-between mt-10">
                    <button type="button" class="btn-secondary flex items-center space-x-1" onclick="history.back()">
                        <i class="fa-solid fa-ban mr-1"></i>
                        <span>取消修改</span>
                    </button>
                    
                    <button type="submit" class="btn-primary flex items-center space-x-1 px-6">
                        <i class="fa-solid fa-floppy-disk mr-1"></i>
                        <span>保存更改</span>
                    </button>
                </div>
            </form>
        </div>
    </main>

    <footer class="w-full bg-white py-6 border-t border-gray-200">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 text-center text-gray-500 text-sm">
            <p>账务管理系统 &copy; 2025 | 权限管理模块</p>
        </div>
    </footer>

    <script>
    <script>
    // 表单提交验证
    document.getElementById('editPermissionForm').addEventListener('submit', function(event) {
        const nameInput = document.getElementById('permission_name');
        const codeInput = document.getElementById('permission_code');
        
        if (!nameInput.value.trim() || !codeInput.value.trim()) {
            event.preventDefault();
            alert('权限名称和代码不能为空');
            return false;
        }
        
        return true;
    });
</script>
    </script>
</body>
</html>