<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>保存结果</title>
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
            .success-animation {
                animation: success-pulse 1.5s ease-in-out;
            }
            @keyframes success-pulse {
                0% { transform: scale(0.8); opacity: 0; }
                50% { transform: scale(1.1); }
                100% { transform: scale(1); opacity: 1; }
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
            <div class="bg-white rounded-2xl p-8 card-shadow success-animation">
                <div class="text-center mb-8">
                    <div class="inline-flex items-center justify-center w-20 h-20 rounded-full bg-success/10 text-success mb-4">
                        <i class="fa fa-check-circle text-4xl"></i>
                    </div>
                    <h2 class="text-2xl font-bold text-neutral-600">保存成功</h2>
                    <p class="text-neutral-400 mt-2">您的账务记录已成功保存</p>
                </div>
                
                <div class="bg-neutral-50 rounded-xl p-5 border border-neutral-200 mb-8">
                    <h3 class="font-medium text-neutral-600 mb-3 flex items-center">
                        <i class="fa fa-folder-open text-primary mr-2"></i> 保存路径
                    </h3>
                    <div class="bg-white p-4 rounded-lg border border-neutral-200 text-sm font-mono text-neutral-500 break-all">
                        C:/Users/Administrator/Desktop/records.txt
                    </div>
                </div>
                
                <div class="space-y-3">
                    <a href="content.jsp" class="btn-hover w-full bg-primary text-white py-3 px-6 rounded-xl text-center font-medium flex items-center justify-center">
                        <i class="fa fa-arrow-left mr-2"></i> 返回主页面
                    </a>
                    <a href="javascript:history.back()" class="btn-hover w-full bg-neutral-200 text-neutral-600 py-3 px-6 rounded-xl text-center font-medium flex items-center justify-center">
                        <i class="fa fa-repeat mr-2"></i> 返回上一页
                    </a>
                </div>
            </div>
            
            <div class="mt-6 flex justify-center">
                <form action="LogoutServlet" method="post" class="inline">
                    <button type="submit" class="btn-hover text-danger hover:text-danger/80 transition-colors flex items-center">
                        <i class="fa fa-sign-out mr-1"></i> 退出账号
                    </button>
                </form>
            </div>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="bg-white border-t border-neutral-200 py-4">
        <div class="container mx-auto px-4 text-center text-neutral-400 text-sm">
            <p>© 2025 账务管理系统 | 保留所有权利</p>
        </div>
    </footer>
</body>
</html>