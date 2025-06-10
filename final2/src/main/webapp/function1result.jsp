<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="Dao.AccountRecordDao" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>操作成功</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <style type="text/tailwindcss">
        @layer utilities {
            .content-auto {
                content-visibility: auto;
            }
            .record-table {
                @apply w-full border-collapse;
            }
            .record-table th {
                @apply p-3 text-left bg-gray-100 text-gray-600 font-medium border border-gray-200;
            }
            .record-table td {
                @apply p-3 bg-white text-gray-800 border border-gray-200;
            }
            .btn-hover {
                @apply hover:shadow-lg hover:-translate-y-0.5 transition-all duration-300;
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen flex items-center justify-center p-4 font-sans">
    <div class="w-full max-w-md bg-white rounded-2xl shadow-xl overflow-hidden transform hover:shadow-2xl transition-all duration-300">
        <!-- 顶部装饰条 -->
        <div class="h-2 bg-gradient-to-r from-green-500 to-teal-400"></div>
        
        <div class="p-6 md:p-8">
            <div class="text-center mb-6">
                <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-green-100 mb-4">
                    <i class="fa-solid fa-check-circle text-3xl text-green-600"></i>
                </div>
                <h1 class="text-2xl font-bold text-gray-800 mb-2">操作成功</h1>
                <p class="text-gray-600">账务记录已成功添加</p>
            </div>
            
            <!-- 记录详情卡片 -->
            <div class="bg-white rounded-xl p-0 shadow-sm mb-8 border border-gray-100">
                <div class="p-4 border-b border-gray-100">
                    <h2 class="text-lg font-semibold text-gray-700 flex items-center">
                        <i class="fa-solid fa-file-invoice-dollar text-green-600 mr-2"></i>
                        记录详情
                    </h2>
                </div>
                
                <%
                AccountRecordDao.AccountRecord record = (AccountRecordDao.AccountRecord) request.getAttribute("record");
                if (record != null) {
                %>
                <table class="record-table">
                    <tbody>
                        <tr>
                            <th>用户</th>
                            <td><%= record.getUserId() != null ? record.getUserId() : "暂无用户信息" %></td>
                        </tr>
                        <tr>
                            <th>日期</th>
                            <td><%= record.getDate() != null ? record.getDate() : "暂无日期信息" %></td>
                        </tr>
                        <tr>
                            <th>类型</th>
                            <td><%= record.getType() != null ? record.getType() : "暂无类型信息" %></td>
                        </tr>
                        <tr>
                            <th>金额</th>
                            <td><%= record.getAmount() != 0 ? String.format("%.2f", record.getAmount()) : "暂无金额信息" %></td>
                        </tr>
                        <tr>
                            <th>类别</th>
                            <td><%= record.getCategory() != null ? record.getCategory() : "暂无类别信息" %></td>
                        </tr>
                        <tr>
                            <th>备注</th>
                            <td><%= record.getRemark() != null ? record.getRemark() : "暂无备注信息" %></td>
                        </tr>
                    </tbody>
                </table>
                
                <% } else { %>
                <div class="p-6">
                    <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-4">
                        <div class="flex items-start">
                            <div class="flex-shrink-0 pt-0.5">
                                <i class="fa-solid fa-exclamation-triangle text-red-500"></i>
                            </div>
                            <div class="ml-3">
                                <h3 class="text-sm font-medium text-red-800">记录缺失</h3>
                                <div class="mt-1 text-sm text-red-700">
                                    <p>没有获取到对应的账务记录信息，请检查以下内容：</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-gray-100 p-3 rounded-lg overflow-x-auto text-xs">
                        <pre class="text-gray-700"><%
                        Enumeration<String> attributeNames = request.getAttributeNames();
                        while (attributeNames.hasMoreElements()) {
                            String attributeName = attributeNames.nextElement();
                            out.println(attributeName);
                        }
                        %></pre>
                    </div>
                    
                    <p class="text-center text-red-600 text-sm mt-4">
                        若问题依旧存在，请联系管理员
                    </p>
                </div>
                <% } %>
            </div>
            
            <!-- 操作按钮 -->
            <div class="flex flex-col sm:flex-row gap-3">
                <a href="content.jsp" class="flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-3 px-4 rounded-lg shadow-sm btn-hover flex items-center justify-center space-x-2">
                    <i class="fa-solid fa-home"></i>
                    <span>返回主页面</span>
                </a>
                <a href="function1.jsp" class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg shadow-sm btn-hover flex items-center justify-center space-x-2">
                    <i class="fa-solid fa-plus-circle"></i>
                    <span>返回添加页面</span>
                </a>
            </div>
            
            <!-- 退出按钮 -->
            <div class="mt-3">
                <form action="LogoutServlet" method="post">
                    <button type="submit" class="w-full bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium py-3 px-4 rounded-lg shadow-sm btn-hover flex items-center justify-center space-x-2">
                        <i class="fa-solid fa-sign-out-alt"></i>
                        <span>退出账号</span>
                    </button>
                </form>
            </div>
        </div>
        
        <!-- 页脚 -->
        <div class="bg-gray-50 text-gray-500 text-xs px-6 py-3 border-t border-gray-100 text-center">
            <p>© 2025 账务管理系统 | 操作时间: <%= new java.util.Date() %></p>
        </div>
    </div>
</body>
</html>