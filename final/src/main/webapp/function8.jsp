<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="entity.OperationLog" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>操作日志 - 账务管理系统</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; }
        .btn-primary {
            background-color: #165DFF;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: all 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #0E42D2;
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
        .btn-pagination {
            min-width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            border: 1px solid #E5E7EB;
            color: #4B5563;
            background-color: white;
            transition: all 0.2s ease;
        }
        .btn-pagination:hover {
            background-color: #F9FAFB;
            border-color: #D1D5DB;
        }
        .btn-pagination.active {
            background-color: #165DFF;
            color: white;
            border-color: #165DFF;
        }
        .btn-pagination.active:hover {
            background-color: #0E42D2;
        }
        .pagination-container {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        /* 操作类型标签样式 */
        .op-type-view { background-color: #EBF8FF; color: #0C4A6E; }
        .op-type-api { background-color: #ECFDF5; color: #065F46; }
        .op-type-data { background-color: #FEF3C7; color: #92400E; }
        .op-type-system { background-color: #FEE2E2; color: #B91C1C; }
        .op-type-permission { background-color: #F5F3FF; color: #7E22CE; }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
    <!-- 顶部导航栏 -->
    <header class="w-full bg-white shadow-md fixed top-0 z-30">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-3">
                <div class="flex items-center space-x-3">
                    <div class="w-14 h-14 rounded-xl flex items-center justify-center mr-5 bg-blue-100 text-blue-600">
                        <i class="fa-solid fa-file-lines text-2xl"></i>
                    </div>
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">操作日志</h1>
                </div>
                <div class="flex items-center space-x-4">
                    <!-- 返回主界面按钮 -->
                    <a href="content.jsp" class="btn-secondary flex items-center space-x-1">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span class="hidden sm:inline">返回主页</span>
                    </a>
                    
                    <!-- 退出登录按钮 -->
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
            <h2 class="text-[clamp(1.8rem,4vw,2.5rem)] font-bold text-gray-800 mb-3">操作日志</h2>
            <p class="text-gray-600 max-w-2xl mx-auto">系统操作记录，记录所有用户的关键操作（按日志ID降序排列，最新操作在前）</p>
        </div>
        
        <!-- 日志查询表单 -->
        <div class="bg-white rounded-xl shadow-md p-6 mb-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fa-solid fa-filter text-blue-600 mr-2"></i>
                日志查询
            </h3>
            <form action="LogServlet" method="get" class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div>
                    <label for="type" class="block text-sm font-medium text-gray-700 mb-1">操作类型</label>
                    <select id="type" name="type" class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">所有类型</option>
                        <option value="添加记录" <%= request.getParameter("type") != null && request.getParameter("type").equals("添加记录") ? "selected" : "" %>>添加记录</option>
                        <option value="编辑记录" <%= request.getParameter("type") != null && request.getParameter("type").equals("编辑记录") ? "selected" : "" %>>编辑记录</option>
                        <option value="删除记录" <%= request.getParameter("type") != null && request.getParameter("type").equals("删除记录") ? "selected" : "" %>>删除记录</option>
                        <option value="查询记录" <%= request.getParameter("type") != null && request.getParameter("type").equals("查询记录") ? "selected" : "" %>>查询记录</option>
                        <option value="权限管理" <%= request.getParameter("type") != null && request.getParameter("type").equals("权限管理") ? "selected" : "" %>>权限管理</option>
                        <option value="查看日志" <%= request.getParameter("type") != null && request.getParameter("type").equals("查看日志") ? "selected" : "" %>>查看日志</option>
                        <option value="用户登录" <%= request.getParameter("type") != null && request.getParameter("type").equals("用户登录") ? "selected" : "" %>>用户登录</option>
                        <option value="页面访问" <%= request.getParameter("type") != null && request.getParameter("type").equals("页面访问") ? "selected" : "" %>>页面访问</option>
                        <option value="API GET请求" <%= request.getParameter("type") != null && request.getParameter("type").equals("API GET请求") ? "selected" : "" %>>API GET请求</option>
                        <option value="API POST请求" <%= request.getParameter("type") != null && request.getParameter("type").equals("API POST请求") ? "selected" : "" %>>API POST请求</option>
                    </select>
                </div>
                <div>
                    <label for="startTime" class="block text-sm font-medium text-gray-700 mb-1">开始时间</label>
                    <input type="date" id="startTime" name="startTime" value="<%= request.getParameter("startTime") != null ? request.getParameter("startTime") : "" %>"
                           class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label for="endTime" class="block text-sm font-medium text-gray-700 mb-1">结束时间</label>
                    <input type="date" id="endTime" name="endTime" value="<%= request.getParameter("endTime") != null ? request.getParameter("endTime") : "" %>"
                           class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div class="md:col-span-4 flex items-end">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-search mr-2"></i>
                        <span>查询日志</span>
                    </button>
                </div>
            </form>
        </div>
        
        <!-- 日志列表 -->
        <% 
        // 从请求中获取日志列表及分页信息，处理null值
        List<OperationLog> logs = (List<OperationLog>) request.getAttribute("logs");
        Integer totalRecordsObj = (Integer) request.getAttribute("totalRecords");
        Integer currentPageObj = (Integer) request.getAttribute("currentPage");
        Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
        String type = request.getParameter("type");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        
        // 设置默认值避免NPE
        int totalRecords = totalRecordsObj != null ? totalRecordsObj : 0;
        int currentPage = currentPageObj != null ? currentPageObj : 1;
        int totalPages = totalPagesObj != null ? totalPagesObj : 0;
        
        // 如果logs为空，初始化为空列表
        if (logs == null) {
            logs = new ArrayList<>();
        }
        %>
        
        <div class="bg-white rounded-xl shadow-md p-6">
            <h3 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fa-solid fa-file-lines text-purple-600 mr-2"></i>
                操作日志列表（共 <%= totalRecords %> 条记录，当前第 <%= currentPage %> 页）
            </h3>
            
            <!-- 分页导航 -->
            <div class="flex justify-between items-center mb-6">
                <div class="text-sm text-gray-500">
                    <% if (totalRecords > 0) { %>
                        显示第 <%= (currentPage-1)*10 + 1 %> 到第 <%= Math.min(currentPage*10, totalRecords) %> 条，共 <%= totalRecords %> 条记录
                    <% } else { %>
                        暂无操作日志记录
                    <% } %>
                </div>
                <div class="pagination-container">
                    <% if (currentPage > 1) { %>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=1" class="btn-pagination">
                        <i class="fa-solid fa-angle-double-left"></i>
                    </a>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=<%= currentPage-1 %>" class="btn-pagination">
                        <i class="fa-solid fa-angle-left"></i>
                    </a>
                    <% } else { %>
                    <span class="btn-pagination" disabled>
                        <i class="fa-solid fa-angle-double-left" style="color: #9CA3AF;"></i>
                    </span>
                    <span class="btn-pagination" disabled>
                        <i class="fa-solid fa-angle-left" style="color: #9CA3AF;"></i>
                    </span>
                    <% } %>
                    
                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=<%= i %>" 
                       class="btn-pagination <%= currentPage == i ? "active" : "" %>">
                        <%= i %>
                    </a>
                    <% } %>
                    
                    <% if (currentPage < totalPages) { %>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=<%= currentPage+1 %>" class="btn-pagination">
                        <i class="fa-solid fa-angle-right"></i>
                    </a>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=<%= totalPages %>" class="btn-pagination">
                        <i class="fa-solid fa-angle-double-right"></i>
                    </a>
                    <% } else { %>
                    <span class="btn-pagination" disabled>
                        <i class="fa-solid fa-angle-right" style="color: #9CA3AF;"></i>
                    </span>
                    <span class="btn-pagination" disabled>
                        <i class="fa-solid fa-angle-double-right" style="color: #9CA3AF;"></i>
                    </span>
                    <% } %>
                </div>
            </div>
            
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">日志ID</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作用户</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作时间</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作类型</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作描述</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">IP地址</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <% 
                        if (!logs.isEmpty()) {
                            for (OperationLog log : logs) {
                                String typeClass = "op-type-view";
                                String detailedDesc = log.getOperationDesc();
                                
                                // 完善操作描述（增强字符串处理安全性）
                                if (log.getOperationType().equals("添加记录")) {
                                    typeClass = "op-type-data";
                                    if (detailedDesc.contains("添加了新的账务记录")) {
                                        detailedDesc = "添加了一条新的账务记录";
                                    }
                                } else if (log.getOperationType().equals("编辑记录")) {
                                    typeClass = "op-type-data";
                                    if (detailedDesc.contains("编辑了账务记录")) {
                                        detailedDesc = "编辑了一条账务记录";
                                    }
                                } else if (log.getOperationType().equals("删除记录")) {
                                    typeClass = "op-type-data";
                                    if (detailedDesc.contains("删除了账务记录")) {
                                        detailedDesc = "删除了一条账务记录";
                                    }
                                } else if (log.getOperationType().equals("查询记录")) {
                                    typeClass = "op-type-data";
                                    if (detailedDesc.contains("查询账务记录")) {
                                        detailedDesc = "查询了账务记录";
                                    }
                                } else if (log.getOperationType().equals("用户登录")) {
                                    typeClass = "op-type-system";
                                    if (detailedDesc.contains("用户登录系统")) {
                                        detailedDesc = "用户成功登录系统";
                                    }
                                } else if (log.getOperationType().equals("查看日志")) {
                                    typeClass = "op-type-system";
                                    if (detailedDesc.contains("查看系统操作日志")) {
                                        detailedDesc = "查看了系统操作日志";
                                    }
                                } else if (log.getOperationType().equals("页面访问")) {
                                    typeClass = "op-type-view";
                                    if (detailedDesc.contains("访问页面")) {
                                        // 安全处理字符串拆分
                                        String[] parts = detailedDesc.split("：");
                                        detailedDesc = "访问了系统页面: " + (parts.length > 1 ? parts[1] : detailedDesc);
                                    }
                                } else if (log.getOperationType().equals("API GET请求")) {
                                    typeClass = "op-type-api";
                                    if (detailedDesc.contains("执行GET请求")) {
                                        // 安全处理字符串拆分
                                        String[] parts = detailedDesc.split("：");
                                        detailedDesc = "执行了GET请求: " + (parts.length > 1 ? parts[1] : detailedDesc);
                                    }
                                } else if (log.getOperationType().equals("API POST请求")) {
                                    typeClass = "op-type-api";
                                    if (detailedDesc.contains("执行POST请求")) {
                                        // 安全处理字符串拆分
                                        String[] parts = detailedDesc.split("：");
                                        detailedDesc = "执行了POST请求: " + (parts.length > 1 ? parts[1] : detailedDesc);
                                    }
                                } else if (log.getOperationType().equals("权限管理")) {
                                    typeClass = "op-type-permission";
                                    if (detailedDesc.contains("访问权限管理页面")) {
                                        detailedDesc = "访问了权限管理功能";
                                    }
                                }
                                
                        %>
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= log.getLogId() %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= log.getUsername() %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= log.getOperationTimeStr() %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= typeClass %>">
                                    <%= log.getOperationType() %>
                                </span>
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-500"><%= detailedDesc %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= log.getIpAddress() %></td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="6" class="px-6 py-4 text-center text-sm text-gray-500">
                                <i class="fa-solid fa-info-circle text-gray-400 mr-2"></i>暂无操作日志记录
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- 分页导航（底部重复显示） -->
            <div class="mt-6 flex justify-between items-center">
                <div class="text-sm text-gray-500">
                    <% if (totalRecords > 0) { %>
                        显示第 <%= (currentPage-1)*10 + 1 %> 到第 <%= Math.min(currentPage*10, totalRecords) %> 条，共 <%= totalRecords %> 条记录
                    <% } else { %>
                        暂无操作日志记录
                    <% } %>
                </div>
                <div class="pagination-container">
                    <% if (currentPage > 1) { %>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=1" class="btn-pagination">
                        <i class="fa-solid fa-angle-double-left"></i>
                    </a>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=<%= currentPage-1 %>" class="btn-pagination">
                        <i class="fa-solid fa-angle-left"></i>
                    </a>
                    <% } else { %>
                    <span class="btn-pagination" disabled>
                        <i class="fa-solid fa-angle-double-left" style="color: #9CA3AF;"></i>
                    </span>
                    <span class="btn-pagination" disabled>
                        <i class="fa-solid fa-angle-left" style="color: #9CA3AF;"></i>
                    </span>
                    <% } %>
                    
                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=<%= i %>" 
                       class="btn-pagination <%= currentPage == i ? "active" : "" %>">
                        <%= i %>
                    </a>
                    <% } %>
                    
                    <% if (currentPage < totalPages) { %>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=<%= currentPage+1 %>" class="btn-pagination">
                        <i class="fa-solid fa-angle-right"></i>
                    </a>
                    <a href="LogServlet?type=<%= type != null ? type : "" %>&startTime=<%= startTime != null ? startTime : "" %>&endTime=<%= endTime != null ? endTime : "" %>&page=<%= totalPages %>" class="btn-pagination">
                        <i class="fa-solid fa-angle-double-right"></i>
                    </a>
                    <% } else { %>
                    <span class="btn-pagination" disabled>
                        <i class="fa-solid fa-angle-right" style="color: #9CA3AF;"></i>
                    </span>
                    <span class="btn-pagination" disabled>
                        <i class="fa-solid fa-angle-double-right" style="color: #9CA3AF;"></i>
                    </span>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="w-full bg-white py-6 border-t border-gray-200 mt-16">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 text-center text-gray-500 text-sm">
            <p>账务管理系统 &copy; 2025 | 操作日志记录系统</p>
        </div>
    </footer>
</body>
</html>