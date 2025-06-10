<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Permission" %>
<%@ page import="filter.PermissionChecker" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>功能目录 - 账务管理系统</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#165DFF',
                        secondary: '#36CFC9',
                        accent: '#722ED1',
                        success: '#00B42A',
                        warning: '#FF7D00',
                        danger: '#F53F3F',
                        info: '#86909C',
                    },
                    fontFamily: {
                        inter: ['Inter', 'system-ui', 'sans-serif'],
                    },
                    boxShadow: {
                        'card': '0 4px 20px rgba(0, 0, 0, 0.08)',
                        'card-hover': '0 10px 30px rgba(0, 0, 0, 0.12)',
                    }
                }
            }
        }
    </script>
    <style type="text/tailwindcss">
        @layer utilities {
            .content-auto {
                content-visibility: auto;
            }
            .function-card {
                @apply bg-white rounded-2xl shadow-card p-6 mb-6 transition-all duration-300 hover:shadow-card-hover hover:-translate-y-1 border-l-4 cursor-pointer;
            }
            .function-icon {
                @apply w-14 h-14 rounded-xl flex items-center justify-center mr-5 text-2xl font-medium transition-transform duration-300 hover:scale-110;
            }
            .btn-primary {
                @apply bg-primary hover:bg-primary/90 text-white font-medium py-3 px-6 rounded-lg shadow-sm transition-all duration-300 flex items-center justify-center space-x-2;
            }
            .btn-primary:hover {
                @apply transform translate-y-[-2px] shadow-md;
            }
            .section-title {
                @apply text-[clamp(1.8rem,4vw,2.5rem)] font-bold text-gray-800 mb-4 after:content-[''] after:block after:h-1 after:w-20 after:bg-primary after:mt-2;
            }
            .section-desc {
                @apply text-gray-600 text-lg max-w-2xl mx-auto mb-10;
            }
            .card-title {
                @apply font-bold text-lg md:text-xl text-gray-800 mb-1;
            }
            .card-desc {
                @apply text-gray-500 text-sm;
            }
            .permission-disabled {
                @apply opacity-50 cursor-not-allowed border-gray-300;
            }
            .permission-disabled .function-icon {
                @apply bg-gray-100 text-gray-400;
            }
            .permission-disabled .card-title {
                @apply text-gray-500;
            }
            .permission-disabled .card-desc {
                @apply text-gray-400;
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen font-inter text-gray-700">
    <!-- 顶部导航栏 -->
    <header class="w-full bg-white shadow-md fixed top-0 z-30 transition-all duration-300" id="navbar">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-3">
                <div class="flex items-center space-x-3">
                    <div class="function-icon bg-primary/10 text-primary">
                        <i class="fa-solid fa-book-open"></i>
                    </div>
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">账务管理系统</h1>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-gray-600 hidden md:inline-flex items-center space-x-1">
                        <i class="fa-solid fa-user-circle"></i>
                        <span><%= session.getAttribute("username") != null ? session.getAttribute("username") : "未登录" %></span>
                    </span>
                    <a href="login.jsp" class="text-danger hover:text-danger/80 transition-colors flex items-center space-x-1">
                        <i class="fa-solid fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- 主内容区 -->
    <main class="w-full max-w-6xl mx-auto pt-28 pb-16 px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
            <h2 class="section-title">功能目录</h2>
            <p class="section-desc">选择您需要的功能，系统提供全面的账务管理操作</p>
        </div>

        <!-- 功能卡片网格 - 动态显示/隐藏 -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            <!-- 添加记录 -->
            <% if (PermissionChecker.hasPermission(session, "function1")) { %>
            <div class="function-card border-green-500">
                <div class="flex items-start">
                    <div class="function-icon bg-green-50 text-green-500">
                        <i class="fa-solid fa-plus"></i>
                    </div>
                    <div>
                        <h3 class="card-title">添加记录</h3>
                        <p class="card-desc">添加新的账务记录</p>
                    </div>
                </div>
                <form action="FunctionServlet" method="post" class="mt-5">
                    <input type="hidden" name="function" value="function1">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-plus-circle"></i>
                        <span>添加</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-plus"></i>
                    </div>
                    <div>
                        <h3 class="card-title">添加记录</h3>
                        <p class="card-desc">无权限访问</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- 查询记录 -->
            <% if (PermissionChecker.hasPermission(session, "function2")) { %>
            <div class="function-card border-blue-500">
                <div class="flex items-start">
                    <div class="function-icon bg-blue-50 text-blue-500">
                        <i class="fa-solid fa-search"></i>
                    </div>
                    <div>
                        <h3 class="card-title">查询记录</h3>
                        <p class="card-desc">按条件搜索账务记录</p>
                    </div>
                </div>
                <form action="FunctionServlet" method="post" class="mt-5">
                    <input type="hidden" name="function" value="function2">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-search"></i>
                        <span>查询</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-search"></i>
                    </div>
                    <div>
                        <h3 class="card-title">查询记录</h3>
                        <p class="card-desc">无权限访问</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- 显示记录 -->
            <% if (PermissionChecker.hasPermission(session, "function3")) { %>
            <div class="function-card border-purple-500">
                <div class="flex items-start">
                    <div class="function-icon bg-purple-50 text-purple-500">
                        <i class="fa-solid fa-list"></i>
                    </div>
                    <div>
                        <h3 class="card-title">显示记录</h3>
                        <p class="card-desc">查看所有账务记录</p>
                    </div>
                </div>
                <form action="FunctionServlet" method="post" class="mt-5">
                    <input type="hidden" name="function" value="function3">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-list-alt"></i>
                        <span>显示</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-list"></i>
                    </div>
                    <div>
                        <h3 class="card-title">显示记录</h3>
                        <p class="card-desc">无权限访问</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- 编辑记录 -->
            <% if (PermissionChecker.hasPermission(session, "function4")) { %>
            <div class="function-card border-yellow-500">
                <div class="flex items-start">
                    <div class="function-icon bg-yellow-50 text-yellow-500">
                        <i class="fa-solid fa-pencil"></i>
                    </div>
                    <div>
                        <h3 class="card-title">编辑记录</h3>
                        <p class="card-desc">修改已有的账务记录</p>
                    </div>
                </div>
                <form action="FunctionServlet" method="post" class="mt-5">
                    <input type="hidden" name="function" value="function4">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-pencil-alt"></i>
                        <span>编辑</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-pencil"></i>
                    </div>
                    <div>
                        <h3 class="card-title">编辑记录</h3>
                        <p class="card-desc">无权限访问</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- 删除记录 -->
            <% if (PermissionChecker.hasPermission(session, "function5")) { %>
            <div class="function-card border-red-500">
                <div class="flex items-start">
                    <div class="function-icon bg-red-50 text-red-500">
                        <i class="fa-solid fa-trash"></i>
                    </div>
                    <div>
                        <h3 class="card-title">删除记录</h3>
                        <p class="card-desc">删除不需要的记录</p>
                    </div>
                </div>
                <form action="FunctionServlet" method="post" class="mt-5">
                    <input type="hidden" name="function" value="function5">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-trash-alt"></i>
                        <span>删除</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-trash"></i>
                    </div>
                    <div>
                        <h3 class="card-title">删除记录</h3>
                        <p class="card-desc">无权限访问</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- 统计分析 -->
            <% if (PermissionChecker.hasPermission(session, "function6")) { %>
            <div class="function-card border-teal-500">
                <div class="flex items-start">
                    <div class="function-icon bg-teal-50 text-teal-500">
                        <i class="fa-solid fa-chart-bar"></i>
                    </div>
                    <div>
                        <h3 class="card-title">统计分析</h3>
                        <p class="card-desc">查看财务统计报表</p>
                    </div>
                </div>
                <form action="FunctionServlet" method="post" class="mt-5">
                    <input type="hidden" name="function" value="function6">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span>统计</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-chart-bar"></i>
                    </div>
                    <div>
                        <h3 class="card-title">统计分析</h3>
                        <p class="card-desc">无权限访问</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- 保存记录 -->
            <% if (PermissionChecker.hasPermission(session, "function7")) { %>
            <div class="function-card border-indigo-500">
                <div class="flex items-start">
                    <div class="function-icon bg-indigo-50 text-indigo-500">
                        <i class="fa-solid fa-save"></i>
                    </div>
                    <div>
                        <h3 class="card-title">保存记录</h3>
                        <p class="card-desc">保存当前操作记录</p>
                    </div>
                </div>
                <form action="FunctionServlet" method="post" class="mt-5">
                    <input type="hidden" name="function" value="function7">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-save"></i>
                        <span>保存</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-save"></i>
                    </div>
                    <div>
                        <h3 class="card-title">保存记录</h3>
                        <p class="card-desc">无权限访问</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- 排序记录 -->
            <% if (PermissionChecker.hasPermission(session, "function9")) { %>
            <div class="function-card border-amber-500">
                <div class="flex items-start">
                    <div class="function-icon bg-amber-50 text-amber-500">
                        <i class="fa-solid fa-sort"></i>
                    </div>
                    <div>
                        <h3 class="card-title">排序记录</h3>
                        <p class="card-desc">按条件排序账务记录</p>
                    </div>
                </div>
                <form action="FunctionServlet" method="post" class="mt-5">
                    <input type="hidden" name="function" value="function9">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-sort-amount-up"></i>
                        <span>排序</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-sort"></i>
                    </div>
                    <div>
                        <h3 class="card-title">排序记录</h3>
                        <p class="card-desc">无权限访问</p>
                    </div>
                </div>
            </div>
            <% } %>

           <!-- 查看日志 -->
			<% if (PermissionChecker.hasPermission(session, "function8")) { %>
			<div class="function-card border-blue-500">
			    <div class="flex items-start">
			        <div class="function-icon bg-blue-50 text-blue-500">
			            <i class="fa-solid fa-file-text"></i>
			        </div>
			        <div>
			            <h3 class="card-title">查看日志</h3>
			            <p class="card-desc">查看系统操作日志</p>
			        </div>
			    </div>
			    <form action="function8.jsp" method="get" class="mt-5">
			        <button type="submit" class="btn-primary w-full">
			            <i class="fa-solid fa-history"></i>
			            <span>日志</span>
			        </button>
			    </form>
			</div>
			<% } else { %>
			<div class="function-card permission-disabled">
			    <div class="flex items-start">
			        <div class="function-icon">
			            <i class="fa-solid fa-file-text"></i>
			        </div>
			        <div>
			            <h3 class="card-title">查看日志</h3>
			            <p class="card-desc">无权限访问</p>
			        </div>
			    </div>
			</div>
			<% } %>
            <!-- 权限管理 -->
            <% if (PermissionChecker.hasPermission(session, "function10")) { %>
            <div class="function-card border-purple-700">
                <div class="flex items-start">
                    <div class="function-icon bg-purple-50 text-purple-600">
                        <i class="fa-solid fa-user-shield"></i>
                    </div>
                    <div>
                        <h3 class="card-title">权限管理</h3>
                        <p class="card-desc">管理用户权限设置</p>
                    </div>
                </div>
                <form action="PermissionServlet" method="get" class="mt-5">
                    <button type="submit" class="btn-primary w-full">
                        <i class="fa-solid fa-lock"></i>
                        <span>权限管理</span>
                    </button>
                </form>
            </div>
            <% } else { %>
            <div class="function-card permission-disabled">
                <div class="flex items-start">
                    <div class="function-icon">
                        <i class="fa-solid fa-user-shield"></i>
                    </div>
                    <div>
                        <h3 class="card-title">权限管理</h3>
                        <p class="card-desc">仅管理员可访问</p>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <!-- 退出按钮 -->
        <div class="mt-12 text-center">
            <a href="login.jsp" class="btn-danger inline-flex items-center justify-center px-8 py-3">
                <i class="fa-solid fa-sign-out-alt mr-2"></i>
                <span>退出系统</span>
            </a>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="w-full bg-white py-6 border-t border-gray-200 mt-16">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 text-center text-gray-500 text-sm">
            <p>账务管理系统 &copy; 2025</p>
        </div>
    </footer>

    <script>
        // 导航栏滚动效果
        window.addEventListener('scroll', function() {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 10) {
                navbar.classList.add('py-2', 'shadow-lg');
                navbar.classList.remove('py-3', 'shadow-md');
            } else {
                navbar.classList.add('py-3', 'shadow-md');
                navbar.classList.remove('py-2', 'shadow-lg');
            }
        });
    </script>
</body>
</html>