<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Permission" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>权限管理 - 账务管理系统</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; }
        .role-section { margin-bottom: 2rem; }
        .role-title { 
            font-size: 1.25rem; 
            font-weight: 600; 
            margin-bottom: 0.5rem; 
            display: flex; 
            align-items: center; 
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
        }
        .admin-role { background-color: #EEF2FF; color: #4338CA; }
        .user-role { background-color: #ECFDF5; color: #065F46; }
        .finance-role { background-color: #FEF3C7; color: #92400E; }
        .checkr-role { background-color: #E0F2FE; color: #0369A1; } /* 新增CHECKR角色样式 */
        .permission-table { width: 100%; }
        .btn-primary {
            background-color: #6366F1;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: all 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #4F46E5;
        }
        .btn-secondary {
            background-color: #F3F4F6;
            color: #4B5563;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: all 0.2s ease;
        }
        .btn-secondary:hover {
            background-color: #E5E7EB;
        }
        .role-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        .permission-badge {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            border-radius: 9999px;
            font-size: 0.7rem;
            margin: 0.1rem;
            background-color: #f3f4f6;
            color: #4b5563;
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
<div class="container mx-auto px-4 mt-4">
    <% if (request.getAttribute("successMessage") != null) { %>
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
            <strong class="font-bold">成功!</strong>
            <span class="block sm:inline"><%= request.getAttribute("successMessage") %></span>
        </div>
    <% } %>
    
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
            <strong class="font-bold">错误!</strong>
            <span class="block sm:inline"><%= request.getAttribute("errorMessage") %></span>
        </div>
    <% } %>
</div>
    <!-- 顶部导航栏 -->
    <header class="w-full bg-white shadow-md fixed top-0 z-30">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-3">
                <div class="flex items-center space-x-3">
                    <div class="w-14 h-14 rounded-xl flex items-center justify-center mr-5 bg-blue-100 text-blue-600">
                        <i class="fa-solid fa-shield-alt text-2xl"></i>
                    </div>
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">权限管理</h1>
                </div>
                <div class="flex items-center space-x-4">
                    <a href="content.jsp" class="btn-secondary flex items-center space-x-1">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span class="hidden sm:inline">返回主页</span>
                    </a>
                    <a href="LogoutServlet" class="btn-primary flex items-center space-x-1">
                        <i class="fa-solid fa-sign-out-alt"></i>
                        <span class="hidden sm:inline">退出登录</span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <main class="max-w-6xl mx-auto pt-28 pb-16 px-4">
        <div class="text-center mb-10">
            <h2 class="text-[clamp(1.8rem,4vw,2.5rem)] font-bold text-gray-800 mb-3">权限管理</h2>
            <p class="text-gray-600 max-w-2xl mx-auto">按角色分类展示系统权限配置</p>
        </div>

        <!-- 权限列表：按角色分组展示 -->
        <div class="bg-white rounded-xl shadow-md p-6">
            <% 
            List<Permission> userPerms = (List<Permission>) request.getAttribute("userPerms");
            if (userPerms == null) {
                userPerms = new ArrayList<>();
            }

            // 按角色名称分组权限
            Map<String, List<Permission>> permsByRole = userPerms.stream()
                .collect(Collectors.groupingBy(Permission::getRoleName));
            %>

            <% if (!permsByRole.isEmpty()) { %>
                <% for (Map.Entry<String, List<Permission>> entry : permsByRole.entrySet()) { 
                    String roleName = entry.getKey();
                    List<Permission> perms = entry.getValue();
                    
                    // 正确匹配角色名称
                    String displayRoleName = roleName;
                    if ("admin".equalsIgnoreCase(roleName)) {
                        displayRoleName = "管理员";
                    } else if ("user".equalsIgnoreCase(roleName)) {
                        displayRoleName = "普通用户";
                    } else if ("finance".equalsIgnoreCase(roleName)) {
                        displayRoleName = "财务人员";
                    } else if ("checkr".equalsIgnoreCase(roleName)) {
                        displayRoleName = "审核财务人员";
                    }
                    
                    // 修复权限过滤逻辑
                    List<Permission> uniquePerms = new ArrayList<>();
                    Set<Integer> seenIds = new HashSet<>();
                    for (Permission perm : perms) {
                        if (!seenIds.contains(perm.getPermissionId())) {
                            uniquePerms.add(perm);
                            seenIds.add(perm.getPermissionId());
                        }
                    }
                    
                    // 根据角色名称设置不同的样式类
                    String roleClass = "user-role";
                    if ("admin".equalsIgnoreCase(roleName)) {
                        roleClass = "admin-role";
                    } else if ("finance".equalsIgnoreCase(roleName)) {
                        roleClass = "finance-role";
                    } else if ("checkr".equalsIgnoreCase(roleName)) {
                        roleClass = "checkr-role"; // 为CHECKR角色设置单独样式
                    }
                %>
                <div class="role-section">
                    <!-- 角色标题 -->
                    <div class="role-title <%= roleClass %>">
                        <i class="fa-solid fa-user-shield mr-2"></i>
                        <span><%= displayRoleName.toUpperCase() %> 角色权限</span>
                        <span class="ml-auto text-sm font-normal text-gray-600">
                            <i class="fa-solid fa-users mr-1"></i>
                            共 <%= uniquePerms.size() %> 项权限
                        </span>
                    </div>

                    <!-- 权限表格 -->
                    <div class="overflow-x-auto">
                        <table class="permission-table min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">权限ID</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">权限名称</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">描述</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <% for (Permission perm : uniquePerms) { %>
                                <tr class="hover:bg-gray-50 transition-colors">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= perm.getPermissionId() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= perm.getPermissionName() %></td>
                                    <td class="px-6 py-4 text-sm text-gray-500"><%= perm.getDescription() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <!-- 修改为功能链接 -->
                                        <a href="edit_permission.jsp?permission_id=<%= perm.getPermissionId() %>" 
                                           class="text-blue-600 hover:text-blue-800 text-sm mr-3">
                                            <i class="fa-solid fa-edit mr-1"></i>编辑
                                        </a>
                                        <a href="DeletePermissionServlet?permission_id=<%= perm.getPermissionId() %>" 
                                           class="text-red-600 hover:text-red-800 text-sm"
                                           onclick="return confirm('确定要删除此权限吗？')">
                                            <i class="fa-solid fa-trash mr-1"></i>删除
                                        </a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <div class="text-center text-gray-500 py-8">
                    <div class="flex flex-col items-center">
                        <i class="fa-solid fa-shield-alt text-gray-300 text-5xl mb-4"></i>
                        <p class="text-lg">暂无权限数据</p>
                        <p class="text-sm mt-1">请联系系统管理员分配权限</p>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- 权限配置表单 -->
        <div class="bg-white rounded-xl shadow-md p-6 mt-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fa-solid fa-sliders text-purple-600 mr-2"></i>
                权限配置
            </h3>
            <form action="#" method="post" class="space-y-4">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                        <label for="user" class="block text-sm font-medium text-gray-700 mb-1">选择用户</label>
                        <select id="user" name="user" class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500">
                            <option value="">请选择用户</option>
                            <% 
                            // 从权限列表中提取不重复的用户
                            Map<Integer, String> userMap = new HashMap<>();
                            for (Map.Entry<String, List<Permission>> entry : permsByRole.entrySet()) {
                                for (Permission perm : entry.getValue()) {
                                    userMap.put(perm.getUserId(), perm.getUserName());
                                }
                            }
                            
                            for (Map.Entry<Integer, String> userEntry : userMap.entrySet()) {
                            %>
                            <option value="<%= userEntry.getKey() %>"><%= userEntry.getValue() %> (ID: <%= userEntry.getKey() %>)</option>
                            <% } %>
                        </select>
                    </div>
                    <div>
                        <label for="role" class="block text-sm font-medium text-gray-700 mb-1">选择角色</label>
                        <select id="role" name="role" class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500">
                            <option value="">请选择角色</option>
                            <option value="admin">管理员</option>
                            <option value="user">普通用户</option>
                            <option value="checkr">审核财务人员</option>
                        </select>
                    </div>
                    <div>
                        <label for="permission" class="block text-sm font-medium text-gray-700 mb-1">分配权限</label>
                        <select id="permission" name="permission" class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500">
                            <option value="">请选择权限</option>
                            <option value="view_record">查看账务记录</option>
                            <option value="add_record">添加账务记录</option>
                            <option value="edit_record">编辑账务记录</option>
                            <option value="delete_record">删除账务记录</option>
                            <option value="view_log">查看系统操作日志（详细）</option>
                            <option value="manage_permission">管理用户权限设置</option>
                            <option value="view_all_records">查看所有记录</option>
                            <option value="save_record">保存记录为txt</option>
                            <option value="sort_record">排序</option>
                            <option value="analyze_statistics">分析</option>
                        </select>
                    </div>
                </div>
                <div class="flex justify-end">
                    <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white font-medium py-2 px-6 rounded-md transition-colors flex items-center">
                        <i class="fa-solid fa-plus-circle mr-2"></i>
                        分配权限
                    </button>
                </div>
            </form>
        </div>

        <!-- 用户与角色对应显示框 -->
        <div id="user-role-display" class="mt-6 bg-white rounded-xl shadow-md p-6 border-l-4 border-purple-500">
            <h3 class="text-lg font-semibold text-gray-800 mb-3 flex items-center">
                <i class="fa-solid fa-user-tag text-purple-600 mr-2"></i>
                用户与角色对应关系
            </h3>
            
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">用户ID</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">用户名</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">角色</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <% 
                    // 获取所有用户及其角色
                    Map<Integer, Map<String, String>> userRoles = (Map<Integer, Map<String, String>>) request.getAttribute("userRoles");
                    if (userRoles == null) userRoles = new HashMap<>();
                    
                    for (Map.Entry<Integer, Map<String, String>> entry : userRoles.entrySet()) {
                        int userId = entry.getKey();
                        String userName = entry.getValue().get("userName");
                        String roleName = entry.getValue().get("roleName");
                        String displayRoleName = getDisplayRoleName(roleName);
                    %>
                    <tr>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= userId %></td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= userName %></td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="role-badge <%= getRoleClass(roleName) %>">
                                <%= displayRoleName %>
                            </span>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="w-full bg-white py-6 border-t border-gray-200 mt-16">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 text-center text-gray-500 text-sm">
            <p>账务管理系统 &copy; 2025 | 权限管理模块</p>
        </div>
    </footer>

    <!-- 辅助方法声明 -->
    <%!
    // 辅助方法：获取角色显示名称
    private String getDisplayRoleName(String roleName) {
        if (roleName == null) return "未知角色";
        switch (roleName.toLowerCase()) {
            case "admin": return "管理员";
            case "user": return "普通用户";
            case "finance": return "财务人员";
            case "checkr": return "审核财务人员";
            default: return roleName;
        }
    }

    // 辅助方法：获取角色对应的CSS类
    private String getRoleClass(String roleName) {
        if (roleName == null) return "";
        switch (roleName.toLowerCase()) {
            case "admin": return "admin-role";
            case "user": return "user-role";
            case "finance": return "finance-role";
            case "checkr": return "checkr-role";
            default: return "";
        }
    }
    %>

    <script>
        // 获取DOM元素
        const userSelect = document.getElementById('user');
        const roleSelect = document.getElementById('role');
        const permissionSelect = document.getElementById('permission');
        const selectedUserDisplay = document.getElementById('selected-user');
        const selectedRoleDisplay = document.getElementById('selected-role');
        const rolePermissionsDisplay = document.getElementById('role-permissions');
        
        // 角色与权限的映射关系（中文描述）
        const rolePermissions = {
            'admin': ['查看账务记录', '添加账务记录', '编辑账务记录', '删除账务记录', 
                      '查看系统操作日志（详细）', '管理用户权限设置', '查看所有记录', 
                      '保存记录', '排序', '分析'],
            'user': ['查看账务记录', '添加账务记录', '编辑账务记录', '查看自己的记录', '排序'],
            'finance': ['查看账务记录', '添加财务记录', '编辑财务记录', '查看财务报表', 
                       '生成财务统计', '导出财务数据'],
            'checkr': ['查看账务记录', '添加账务记录', '编辑账务记录', '删除账务记录', 
                       '查看所有记录', '排序', '分析']
        };
        
        // 更新显示函数
        function updateDisplay() {
            // 更新用户显示
            const selectedUserId = userSelect.value;
            const selectedUserText = userSelect.options[userSelect.selectedIndex].text;
            
            if (selectedUserId) {
                selectedUserDisplay.innerHTML = `<span class="font-medium">${selectedUserText}</span>`;
            } else {
                selectedUserDisplay.innerHTML = `<span class="text-gray-400">请选择用户</span>`;
            }
            
            // 更新角色显示
            const selectedRoleId = roleSelect.value;
            const selectedRoleText = roleSelect.options[roleSelect.selectedIndex].text;
            
            if (selectedRoleId) {
                // 根据角色设置徽章样式
                let badgeClass = 'bg-gray-100 text-gray-800';
                if (selectedRoleId === 'admin') {
                    badgeClass = 'bg-blue-100 text-blue-800';
                } else if (selectedRoleId === 'user') {
                    badgeClass = 'bg-green-100 text-green-800';
                } else if (selectedRoleId === 'finance') {
                    badgeClass = 'bg-yellow-100 text-yellow-800';
                } else if (selectedRoleId === 'checkr') {
                    badgeClass = 'bg-sky-100 text-sky-800'; // CHECKR角色的徽章样式
                }
                
                selectedRoleDisplay.innerHTML = `<span class="role-badge ${badgeClass}">${selectedRoleText}</span>`;
            } else {
                selectedRoleDisplay.innerHTML = `<span class="text-gray-400">请选择角色</span>`;
            }
            
            // 更新权限显示
            if (selectedUserId && selectedRoleId) {
                const permissions = rolePermissions[selectedRoleId] || [];
                if (permissions.length > 0) {
                    // 生成权限徽章
                    const badges = permissions.map(perm => 
                        `<span class="permission-badge">${perm}</span>`
                    ).join('');
                    rolePermissionsDisplay.innerHTML = badges;
                } else {
                    rolePermissionsDisplay.innerHTML = `<span class="text-gray-400">无特殊权限</span>`;
                }
                
                // 自动更新权限下拉框的选项
                updatePermissionOptions(selectedRoleId);
            } else {
                rolePermissionsDisplay.innerHTML = `<span class="text-gray-400">请选择用户和角色</span>`;
                // 重置权限下拉框
                resetPermissionOptions();
            }
        }
        
        // 更新权限下拉框选项
        function updatePermissionOptions(roleId) {
            // 保存当前选择
            const currentValue = permissionSelect.value;
            
            // 清空选项
            while (permissionSelect.options.length > 1) {
                permissionSelect.remove(1);
            }
            
            // 根据角色添加选项
            const permissions = rolePermissions[roleId] || [];
            const permissionValues = {
                '查看账务记录': 'view_record',
                '添加账务记录': 'add_record',
                '编辑账务记录': 'edit_record',
                '删除账务记录': 'delete_record',
                '查看系统操作日志（详细）': 'view_log',
                '管理用户权限设置': 'manage_permission',
                '查看所有记录': 'view_all_records',
                '保存记录': 'save_record',
                '排序': 'sort_record',
                '分析': 'analyze_statistics''
            };
            
            permissions.forEach(perm => {
                const value = permissionValues[perm] || perm.toLowerCase().replace(/ /g, '_');
                const option = document.createElement('option');
                option.value = value;
                option.textContent = perm;
                permissionSelect.appendChild(option);
            });
            
            // 尝试恢复之前的选择
            if (currentValue && Array.from(permissionSelect.options).some(o => o.value === currentValue)) {
                permissionSelect.value = currentValue;
            }
        }
        
        // 重置权限下拉框
        function resetPermissionOptions() {
            // 保存当前选择
            const currentValue = permissionSelect.value;
            
            // 清空选项
            while (permissionSelect.options.length > 1) {
                permissionSelect.remove(1);
            }
            
            // 添加默认选项
            const fullPermissions = [
                { value: 'view_record', text: '查看账务记录' },
                { value: 'add_record', text: '添加账务记录' },
                { value: 'edit_record', text: '编辑账务记录' },
                { value: 'delete_record', text: '删除账务记录' },
                { value: 'view_log', text: '查看系统操作日志（详细）' },
                { value: 'manage_permission', text: '管理用户权限设置' },
                { value: 'view_all_records', text: '查看所有记录' },
                { value: 'save_record', text: '保存记录' },
                { value: 'sort_record', text: '排序' },
                { value: 'analyze_statistics', text: '分析' },
            ];
            
            fullPermissions.forEach(perm => {
                const option = document.createElement('option');
                option.value = perm.value;
                option.textContent = perm.text;
                permissionSelect.appendChild(option);
            });
            
            // 尝试恢复之前的选择
            if (currentValue && Array.from(permissionSelect.options).some(o => o.value === currentValue)) {
                permissionSelect.value = currentValue;
            }
        }
        
        // 添加事件监听器
        userSelect.addEventListener('change', updateDisplay);
        roleSelect.addEventListener('change', updateDisplay);
        
        // 初始化显示
        updateDisplay();
    </script>
</body>
</html>