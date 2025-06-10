<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>保存账务记录</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#165DFF',
                        secondary: '#36BFFA',
                        success: '#00B42A',
                        danger: '#F53F3F',
                        neutral: {
                            100: '#F2F3F5',
                            200: '#E5E6EB',
                            300: '#C9CDD4',
                            400: '#86909C',
                            500: '#4E5969',
                            600: '#1D2129',
                        }
                    },
                    fontFamily: {
                        inter: ['Inter', 'system-ui', 'sans-serif'],
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
            .card-shadow {
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            }
            .btn-hover {
                @apply transition-all duration-300 hover:shadow-lg hover:-translate-y-1;
            }
            .text-gradient {
                @apply bg-clip-text text-transparent bg-gradient-to-r from-primary to-secondary;
            }
        }
    </style>
</head>
<body class="bg-neutral-100 font-inter min-h-screen flex flex-col">
    <!-- 顶部导航 -->
    <header class="bg-white shadow-sm sticky top-0 z-10">
        <div class="container mx-auto px-4 py-4 flex justify-between items-center">
            <div class="flex items-center space-x-3">
                <i class="fa fa-book text-primary text-2xl"></i>
                <h1 class="text-xl font-semibold text-neutral-600">账务管理系统</h1>
            </div>
            <div class="flex items-center space-x-4">
                <a href="content.jsp" class="text-neutral-500 hover:text-primary transition-colors">
                    <i class="fa fa-home mr-1"></i> 首页
                </a>
                <a href="javascript:void(0)" class="text-neutral-500 hover:text-primary transition-colors">
                    <i class="fa fa-question-circle mr-1"></i> 帮助
                </a>
            </div>
        </div>
    </header>

    <!-- 主要内容 -->
    <main class="flex-grow container mx-auto px-4 py-8">
        <div class="max-w-md mx-auto">
            <div class="bg-white rounded-2xl p-8 card-shadow transform transition-all duration-300 hover:shadow-xl">
                <div class="text-center mb-8">
                    <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 text-primary mb-4">
                        <i class="fa fa-save text-3xl"></i>
                    </div>
                    <h2 class="text-2xl font-bold text-neutral-600">保存账务记录</h2>
                    <p class="text-neutral-400 mt-2">确认信息后点击保存按钮</p>
                </div>
                
                <div class="space-y-6 mb-8">
                    <div class="bg-neutral-50 rounded-xl p-5 border border-neutral-200">
                        <div class="flex items-start">
                            <div class="text-primary mr-3 mt-1">
                                <i class="fa fa-info-circle text-xl"></i>
                            </div>
                            <div>
                                <h3 class="font-medium text-neutral-600 mb-1">提示信息</h3>
                                <p class="text-neutral-500 text-sm">
                                    账务记录将保存到默认位置
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <button id="saveBtn" class="btn-hover w-full bg-gradient-to-r from-primary to-secondary text-white py-4 px-6 rounded-xl text-center font-medium flex items-center justify-center">
                    <i class="fa fa-save mr-2"></i> 保存记录
                </button>
                
                <div class="mt-6 text-center text-sm text-neutral-400">
                    <p><i class="fa fa-info-circle mr-1"></i> 保存后可在结果页面查看详细路径</p>
                </div>
            </div>
            
            <div class="mt-6 flex flex-col space-y-3">
                <a href="content.jsp" class="btn-hover bg-white text-neutral-600 py-3 px-6 rounded-xl text-center font-medium flex items-center justify-center">
                    <i class="fa fa-arrow-left mr-2"></i> 返回主页面
                </a>
                <form action="LogoutServlet" method="post" class="inline">
                    <button type="submit" class="btn-hover w-full bg-danger text-white py-3 px-6 rounded-xl text-center font-medium flex items-center justify-center">
                        <i class="fa fa-sign-out mr-2"></i> 退出账号
                    </button>
                </form>
            </div>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="bg-white border-t border-neutral-200 py-4">
        <div class="container mx-auto px-4 text-center text-neutral-400 text-sm">
            <p>账务管理系统</p>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const saveBtn = document.getElementById('saveBtn');
            
            // 保存按钮点击事件
            saveBtn.addEventListener('click', function() {
                saveBtn.disabled = true;
                saveBtn.innerHTML = '<i class="fa fa-spinner fa-spin mr-2"></i> 保存中...';
                
                saveRecords();
            });
            
            // 保存记录函数
            function saveRecords() {
                var contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
                var url = contextPath + "/saveRecords";
                var xhr = new XMLHttpRequest();
                xhr.open("POST", url, true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        // 重置按钮状态
                        saveBtn.disabled = false;
                        saveBtn.innerHTML = '<i class="fa fa-save mr-2"></i> 保存记录';
                        
                        if (xhr.status === 200) {
                            // 保存成功，跳转到结果页面
                            window.location.href = "function7result.jsp";
                        } else {
                            // 保存失败，显示错误信息
                            alert("保存记录失败，请稍后重试。");
                        }
                    }
                };
                xhr.send();
            }
        });
    </script>
</body>
</html>