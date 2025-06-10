<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>账户登录</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#007BFF',
                        secondary: '#6c757d',
                        success: '#28a745',
                        danger: '#dc3545',
                        light: '#f8f9fa',
                        dark: '#343a40',
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif'],
                    },
                }
            }
        }
    </script>
    <style type="text/tailwindcss">
        @layer utilities {
            .content-auto {
                content-visibility: auto;
            }
            .form-input-focus {
                @apply ring-2 ring-primary/50 ring-offset-1;
            }
            .card-shadow {
                @apply shadow-lg shadow-black/5;
            }
            .transition-custom {
                @apply transition-all duration-300 ease-in-out;
            }
            .tab-active {
                @apply text-primary border-primary;
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen flex items-center justify-center p-4 font-sans">
    <div class="w-full max-w-md bg-white rounded-2xl card-shadow overflow-hidden transform hover:scale-[1.01] transition-custom">
        <!-- 顶部装饰条 -->
        <div class="h-2 bg-gradient-to-r from-primary to-blue-400"></div>
        
        <div class="p-8">
            <!-- 登录/注册切换选项卡 -->
            <div class="flex mb-8">
                <button id="login-tab" class="tab-active flex-1 py-2 text-lg font-medium border-b-2 transition-custom">
                    登录
                </button>
                <button id="register-tab" class="text-gray-500 flex-1 py-2 text-lg font-medium border-b-2 border-transparent transition-custom">
                    注册
                </button>
            </div>
            
            <!-- 登录表单 -->
            <form id="login-form" action="LoginServlet" method="post" class="space-y-5">
                <input type="hidden" name="action" value="login">
                
                <div class="space-y-2">
                    <label for="login-username" class="block text-sm font-medium text-gray-700">用户名</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                            <i class="fa-solid fa-user"></i>
                        </span>
                        <input type="text" id="login-username" name="username" 
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:border-primary form-input-focus transition-custom"
                               placeholder="请输入用户名">
                    </div>
                </div>
                
                <div class="space-y-2">
                    <label for="login-password" class="block text-sm font-medium text-gray-700">密码</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                            <i class="fa-solid fa-lock"></i>
                        </span>
                        <input type="password" id="login-password" name="password" 
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:border-primary form-input-focus transition-custom"
                               placeholder="请输入密码">
                    </div>
                </div>
                
                <button type="submit" 
                        class="w-full bg-primary hover:bg-primary/90 text-white font-medium py-3 px-4 rounded-lg transition-custom transform hover:translate-y-[-2px] hover:shadow-lg flex items-center justify-center space-x-2">
                    <span>登录</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>
            
            <!-- 注册表单 -->
            <form id="register-form" action="RegisterServlet" method="post" class="space-y-5 hidden">
                <input type="hidden" name="action" value="register">
                
                <div class="space-y-2">
                    <label for="register-username" class="block text-sm font-medium text-gray-700">用户名</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                            <i class="fa-solid fa-user-plus"></i>
                        </span>
                        <input type="text" id="register-username" name="username" 
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:border-primary form-input-focus transition-custom"
                               placeholder="请设置用户名">
                    </div>
                </div>
                
                <div class="space-y-2">
                    <label for="register-password" class="block text-sm font-medium text-gray-700">密码</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                            <i class="fa-solid fa-lock"></i>
                        </span>
                        <input type="password" id="register-password" name="password" 
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:border-primary form-input-focus transition-custom"
                               placeholder="请设置密码">
                    </div>
                </div>
                
                <div class="space-y-2">
                    <label for="register-email" class="block text-sm font-medium text-gray-700">邮箱</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                            <i class="fa-solid fa-envelope"></i>
                        </span>
                        <input type="email" id="register-email" name="email" 
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:border-primary form-input-focus transition-custom"
                               placeholder="请输入邮箱">
                    </div>
                </div>
                
                <button type="submit" 
                        class="w-full bg-success hover:bg-success/90 text-white font-medium py-3 px-4 rounded-lg transition-custom transform hover:translate-y-[-2px] hover:shadow-lg flex items-center justify-center space-x-2">
                    <span>注册</span>
                    <i class="fa-solid fa-check"></i>
                </button>
            </form>
            
            <!-- 提示信息 -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="mt-6 p-4 bg-danger/10 border border-danger/20 rounded-lg">
                <div class="flex items-start">
                    <div class="flex-shrink-0 pt-0.5">
                        <i class="fa-solid fa-exclamation-circle text-danger"></i>
                    </div>
                    <div class="ml-3">
                        <h3 class="text-sm font-medium text-danger">操作失败</h3>
                        <div class="mt-1 text-sm text-danger/80">
                            <p><%= error %></p>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }

                String message = (String) request.getAttribute("message");
                if (message != null) {
            %>
            <div class="mt-6 p-4 bg-success/10 border border-success/20 rounded-lg">
                <div class="flex items-start">
                    <div class="flex-shrink-0 pt-0.5">
                        <i class="fa-solid fa-check-circle text-success"></i>
                    </div>
                    <div class="ml-3">
                        <h3 class="text-sm font-medium text-success">操作成功</h3>
                        <div class="mt-1 text-sm text-success/80">
                            <p><%= message %></p>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
        
        <!-- 底部信息 -->
        <div class="bg-gray-50 px-8 py-4 text-center text-sm text-gray-500 border-t border-gray-100">
            <p>© 2025 版权所有</p>
        </div>
    </div>
    
    <script>
        // 登录/注册表单切换功能
        document.addEventListener('DOMContentLoaded', function() {
            const loginTab = document.getElementById('login-tab');
            const registerTab = document.getElementById('register-tab');
            const loginForm = document.getElementById('login-form');
            const registerForm = document.getElementById('register-form');
            
            loginTab.addEventListener('click', function() {
                loginTab.classList.add('tab-active');
                loginTab.classList.remove('text-gray-500', 'border-transparent');
                registerTab.classList.remove('tab-active');
                registerTab.classList.add('text-gray-500', 'border-transparent');
                
                loginForm.classList.remove('hidden');
                registerForm.classList.add('hidden');
            });
            
            registerTab.addEventListener('click', function() {
                registerTab.classList.add('tab-active');
                registerTab.classList.remove('text-gray-500', 'border-transparent');
                loginTab.classList.remove('tab-active');
                loginTab.classList.add('text-gray-500', 'border-transparent');
                
                registerForm.classList.remove('hidden');
                loginForm.classList.add('hidden');
            });
        });
    </script>
</body>
</html>