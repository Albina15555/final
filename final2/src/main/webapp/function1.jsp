<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加账务记录</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#007BFF',
                        success: '#28a745',
                        danger: '#dc3545',
                        warning: '#ffc107',
                        info: '#17a2b8',
                        light: '#f8f9fa',
                        dark: '#343a40',
                    },
                    fontFamily: {
                        inter: ['Inter', 'sans-serif'],
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
            .form-focus {
                @apply focus:ring-2 focus:ring-primary/50 focus:border-primary focus:outline-none;
            }
            .radio-custom {
                @apply h-4 w-4 text-primary focus:ring-primary border-gray-300;
            }
            .btn-hover {
                @apply hover:shadow-lg hover:-translate-y-0.5 transition-all duration-300;
            }
            .input-error {
                @apply border-danger focus:ring-danger/50;
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen flex items-center justify-center p-4 font-inter">
    <div class="w-full max-w-3xl bg-white rounded-2xl shadow-xl overflow-hidden">
        <!-- 顶部导航栏 -->
        <header class="bg-primary text-white px-6 py-4 flex justify-between items-center">
            <div class="flex items-center space-x-2">
                <i class="fa-solid fa-book-accounting text-xl"></i>
                <h1 class="text-xl font-bold">账务管理系统</h1>
            </div>
            <div class="flex items-center space-x-4">
                <a href="content.jsp" class="flex items-center space-x-1 text-white hover:text-gray-200 transition-colors">
                    <i class="fa-solid fa-arrow-left"></i>
                    <span>返回</span>
                </a>
                <button id="logoutBtn" class="flex items-center space-x-1 text-white hover:text-gray-200 transition-colors">
                    <i class="fa-solid fa-sign-out-alt"></i>
                    <span>退出</span>
                </button>
            </div>
        </header>
        
        <!-- 主内容区 -->
        <main class="p-6 md:p-8">
            <div class="mb-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-2">添加账务记录</h2>
                <p class="text-gray-600">请填写以下信息完成账务记录添加</p>
            </div>
            
            <form id="recordForm" action="AddRecordServlet" method="post" class="space-y-6">
                <input type="hidden" name="action" value="addRecord">
                
                <!-- 日期和金额 -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-2">
                        <label for="date" class="block text-sm font-medium text-gray-700">
                            <i class="fa-solid fa-calendar-days mr-1"></i>日期
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-gray-500">
                                <i class="fa-solid fa-calendar"></i>
                            </span>
                            <input type="text" id="date" name="date" placeholder="YYYY.MM.DD" 
                                class="pl-10 w-full rounded-lg border-gray-300 shadow-sm form-focus py-3 px-4 border">
                        </div>
                        <p id="dateError" class="text-danger text-sm hidden">请输入有效的日期</p>
                    </div>
                    
                    <div class="space-y-2">
                        <label for="amount" class="block text-sm font-medium text-gray-700">
                            <i class="fa-solid fa-coins mr-1"></i>金额
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-gray-500">
                                <i class="fa-solid fa-cny"></i>
                            </span>
                            <input type="text" id="amount" name="amount" placeholder="0.00" 
                                class="pl-10 w-full rounded-lg border-gray-300 shadow-sm form-focus py-3 px-4 border">
                        </div>
                        <p id="amountError" class="text-danger text-sm hidden">请输入有效的金额</p>
                    </div>
                </div>
                
                <!-- 类型选择 -->
                <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">
                        <i class="fa-solid fa-tag mr-1"></i>类型
                    </label>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-3 p-4 bg-gray-50 rounded-lg">
                        <div class="flex items-center space-x-2">
                            <input type="radio" id="type_income" name="type" value="income" class="radio-custom" checked>
                            <label for="type_income" class="text-sm text-gray-700 flex items-center">
                                <i class="fa-solid fa-arrow-down text-success mr-1"></i>收入
                            </label>
                        </div>
                        <div class="flex items-center space-x-2">
                            <input type="radio" id="type_expense" name="type" value="expense" class="radio-custom">
                            <label for="type_expense" class="text-sm text-gray-700 flex items-center">
                                <i class="fa-solid fa-arrow-up text-danger mr-1"></i>支出
                            </label>
                        </div>
                        <div class="flex items-center space-x-2">
                            <input type="radio" id="type_transfer" name="type" value="transfer" class="radio-custom">
                            <label for="type_transfer" class="text-sm text-gray-700 flex items-center">
                                <i class="fa-solid fa-exchange-alt text-primary mr-1"></i>转账
                            </label>
                        </div>
                        <div class="flex items-center space-x-2">
                            <input type="radio" id="type_brrowIn" name="type" value="brrowIn" class="radio-custom">
                            <label for="type_brrowIn" class="text-sm text-gray-700 flex items-center">
                                <i class="fa-solid fa-hand-holding-usd text-info mr-1"></i>借入
                            </label>
                        </div>
                        <div class="flex items-center space-x-2">
                            <input type="radio" id="type_brrowOut" name="type" value="brrowOut" class="radio-custom">
                            <label for="type_brrowOut" class="text-sm text-gray-700 flex items-center">
                                <i class="fa-solid fa-handshake text-warning mr-1"></i>借出
                            </label>
                        </div>
                        <div class="flex items-center space-x-2">
                            <input type="radio" id="type_return" name="type" value="return" class="radio-custom">
                            <label for="type_return" class="text-sm text-gray-700 flex items-center">
                                <i class="fa-solid fa-undo text-secondary mr-1"></i>还入
                            </label>
                        </div>
                        <div class="flex items-center space-x-2">
                            <input type="radio" id="type_handOut" name="type" value="hand out" class="radio-custom">
                            <label for="type_handOut" class="text-sm text-gray-700 flex items-center">
                                <i class="fa-solid fa-redo text-purple-500 mr-1"></i>还出
                            </label>
                        </div>
                    </div>
                    <p id="typeError" class="text-danger text-sm hidden">请选择记录类型</p>
                </div>
                
                <!-- 项目类别和备注 -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-2">
                        <label for="category" class="block text-sm font-medium text-gray-700">
                            <i class="fa-solid fa-folder-open mr-1"></i>项目类别
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-gray-500">
                                <i class="fa-solid fa-list-alt"></i>
                            </span>
                            <input type="text" id="category" name="category" placeholder="餐饮、购物等" 
                                class="pl-10 w-full rounded-lg border-gray-300 shadow-sm form-focus py-3 px-4 border">
                        </div>
                        <p id="categoryError" class="text-danger text-sm hidden">项目类别只能输入中文</p>
                    </div>
                    
                    <div class="space-y-2">
                        <label for="remark" class="block text-sm font-medium text-gray-700">
                            <i class="fa-solid fa-comment-dots mr-1"></i>备注
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-gray-500">
                                <i class="fa-solid fa-pencil-alt"></i>
                            </span>
                            <input type="text" id="remark" name="remark" placeholder="可选" 
                                class="pl-10 w-full rounded-lg border-gray-300 shadow-sm form-focus py-3 px-4 border">
                        </div>
                    </div>
                </div>
                
                <!-- 操作按钮 -->
                <div class="flex flex-col sm:flex-row gap-4 pt-4">
                    <button type="submit" 
                        class="flex-1 bg-primary hover:bg-primary/90 text-white font-medium py-3 px-4 rounded-lg btn-hover flex items-center justify-center space-x-2">
                        <i class="fa-solid fa-plus-circle"></i>
                        <span>添加记录</span>
                    </button>
                    <a href="content.jsp" 
                        class="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium py-3 px-4 rounded-lg btn-hover flex items-center justify-center space-x-2">
                        <i class="fa-solid fa-times-circle"></i>
                        <span>取消</span>
                    </a>
                </div>
            </form>
        </main>
        
        <!-- 页脚 -->
        <footer class="bg-gray-50 text-gray-600 text-sm px-6 py-3 border-t border-gray-200">
            <div class="flex flex-col md:flex-row justify-between items-center">
                <div>© 2025 账务管理系统</div>
            </div>
        </footer>
    </div>
    
    <script>
        // 表单验证
        document.getElementById('recordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            let isValid = true;
            
            // 重置所有错误提示
            document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
            document.querySelectorAll('.text-danger').forEach(el => el.classList.add('hidden'));
            
            // 验证日期
            const date = document.getElementById('date').value;
            if (!date) {
                document.getElementById('date').classList.add('input-error');
                document.getElementById('dateError').classList.remove('hidden');
                isValid = false;
            }
            
            // 验证金额
            const amount = document.getElementById('amount').value;
            if (!amount || isNaN(parseFloat(amount))) {
                document.getElementById('amount').classList.add('input-error');
                document.getElementById('amountError').classList.remove('hidden');
                isValid = false;
            }
            
            // 验证类型
            const type = document.querySelector('input[name="type"]:checked');
            if (!type) {
                document.getElementById('typeError').classList.remove('hidden');
                isValid = false;
            }
            
            // 验证项目类别
            const category = document.getElementById('category').value;
            const chinesePattern = /^[\u4e00-\u9fa5]+$/;
            if (category &&!chinesePattern.test(category)) {
                document.getElementById('category').classList.add('input-error');
                document.getElementById('categoryError').classList.remove('hidden');
                isValid = false;
            }
            
            // 如果验证通过，提交表单
            if (isValid) {
                this.submit();
            }
        });
        
        // 退出按钮处理
        document.getElementById('logoutBtn').addEventListener('click', function() {
            if (confirm('确定要退出账号吗？')) {
                window.location.href = 'LogoutServlet';
            }
        });
        
        // 美化日期输入
        const dateInput = document.getElementById('date');
        dateInput.addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^0-9.]/g, '');
            let parts = value.split('.');
            
            if (parts.length > 3) {
                parts = parts.slice(0, 3);
            }
            
            for (let i = 0; i < parts.length; i++) {
                if (i === 0 && parts[i].length > 4) {
                    parts[i] = parts[i].slice(0, 4);
                } else if ((i === 1 || i === 2) && parts[i].length > 2) {
                    parts[i] = parts[i].slice(0, 2);
                }
            }
            
            e.target.value = parts.join('.');
        });
    </script>
</body>
</html>