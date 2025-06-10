<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>账务记录查询</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#007BFF',
                        secondary: '#6C757D',
                        success: '#28A745',
                        danger: '#DC3545',
                        warning: '#FFC107',
                        info: '#17A2B8',
                        light: '#F8F9FA',
                        dark: '#343A40',
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
                @apply focus:ring-2 focus:ring-primary/50 focus:border-primary transition-all duration-200;
            }
            .card-shadow {
                @apply shadow-md hover:shadow-lg transition-shadow duration-300;
            }
            .btn-hover {
                @apply hover:shadow-md hover:-translate-y-0.5 transition-all duration-300;
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen flex flex-col">
    <!-- 顶部导航栏 -->
    <header class="w-full bg-white shadow-md fixed top-0 z-10">
        <div class="container mx-auto px-4 py-3 flex justify-between items-center">
            <div class="flex items-center">
                <i class="fa-solid fa-book text-primary text-2xl mr-2"></i>
                <h1 class="text-xl font-bold text-gray-800">账务管理系统</h1>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-gray-600 hidden md:inline-block">
                    <i class="fa-solid fa-user-circle mr-1"></i> 用户
                </span>
                <form action="LogoutServlet" method="post" class="inline">
                    <button type="submit" class="text-red-500 hover:text-red-700 transition-colors">
                        <i class="fa-solid fa-sign-out-alt"></i>
                    </button>
                </form>
            </div>
        </div>
    </header>

    <!-- 主内容区 -->
    <main class="flex-grow w-full max-w-4xl mx-auto px-4 pt-24 pb-12">
        <div class="text-center mb-8">
            <h2 class="text-[clamp(1.5rem,3vw,2.5rem)] font-bold text-gray-800 mb-2">账务记录查询</h2>
            <p class="text-gray-600">选择查询条件并提交</p>
        </div>

        <!-- 查询表单卡片 -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden mb-8 transform hover:shadow-xl transition-all duration-300">
            <div class="bg-primary text-white p-4">
                <h3 class="text-lg font-semibold flex items-center">
                    <i class="fa-solid fa-search mr-2"></i> 查询条件
                </h3>
            </div>
            
            <form action="QueryRecordServlet" method="post" class="p-6 space-y-6">
                <!-- 查询方式选择 -->
                <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">查询方式</label>
                    <select id="queryOption" name="queryOption" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none form-input-focus">
                        <option value="all">查看所有记录</option>
                        <option value="byTime">按时间查询</option>
                        <option value="byTimeRange">按时间区间查询</option>
                        <option value="byType">按记录类型查询</option>
                        <option value="byProject">按项目查询</option>
                    </select>
                </div>

                <!-- 按时间查询 -->
                <div id="timeDiv" style="display:none;" class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">时间</label>
                    <div class="relative">
                        <input type="text" id="time" name="time" placeholder="YYYY.MM.DD" 
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none form-input-focus">
                        <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                            <i class="fa-solid fa-calendar text-gray-400"></i>
                        </div>
                    </div>
                    <p id="timeError" class="text-danger text-sm hidden">日期格式不正确，请按照YYYY.MM.DD格式输入</p>
                </div>

                <!-- 按时间区间查询 -->
                <div id="timeRangeDiv" style="display:none;" class="space-y-4">
                    <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-700">开始时间</label>
                        <div class="relative">
                            <input type="text" id="startTime" name="startTime" placeholder="YYYY.MM.DD" 
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none form-input-focus">
                            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                                <i class="fa-solid fa-calendar text-gray-400"></i>
                            </div>
                        </div>
                        <p id="startTimeError" class="text-danger text-sm hidden">日期格式不正确，请按照YYYY.MM.DD格式输入</p>
                    </div>
                    
                    <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-700">结束时间</label>
                        <div class="relative">
                            <input type="text" id="endTime" name="endTime" placeholder="YYYY.MM.DD" 
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none form-input-focus">
                            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                                <i class="fa-solid fa-calendar text-gray-400"></i>
                            </div>
                        </div>
                        <p id="endTimeError" class="text-danger text-sm hidden">日期格式不正确，请按照YYYY.MM.DD格式输入</p>
                    </div>
                </div>

                <!-- 按记录类型查询 -->
                <div id="typeDiv" style="display:none;" class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">记录类型（可多选）</label>
                    <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
                        <label class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                            <input type="checkbox" name="recordType" value="支出" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                            <span class="ml-2 text-sm text-gray-700">支出</span>
                        </label>
                        <label class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                            <input type="checkbox" name="recordType" value="收入" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                            <span class="ml-2 text-sm text-gray-700">收入</span>
                        </label>
                        <label class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                            <input type="checkbox" name="recordType" value="转账" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                            <span class="ml-2 text-sm text-gray-700">转账</span>
                        </label>
                        <label class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                            <input type="checkbox" name="recordType" value="借出" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                            <span class="ml-2 text-sm text-gray-700">借出</span>
                        </label>
                        <label class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                            <input type="checkbox" name="recordType" value="借入" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                            <span class="ml-2 text-sm text-gray-700">借入</span>
                        </label>
                        <label class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                            <input type="checkbox" name="recordType" value="还入" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                            <span class="ml-2 text-sm text-gray-700">还入</span>
                        </label>
                        <label class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                            <input type="checkbox" name="recordType" value="还出" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                            <span class="ml-2 text-sm text-gray-700">还出</span>
                        </label>
                    </div>
                    <p id="typeError" class="text-danger text-sm hidden">请至少选择一种记录类型</p>
                </div>

                <!-- 按项目查询 -->
                <div id="projectDiv" style="display:none;" class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">项目名称</label>
                    <div class="relative">
                        <input type="text" id="project" name="project" placeholder="请输入项目名称" 
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none form-input-focus">
                        <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                            <i class="fa-solid fa-building text-gray-400"></i>
                        </div>
                    </div>
                </div>

                <!-- 按钮区域 -->
                <div class="flex flex-col sm:flex-row gap-4 pt-4">
                    <button type="submit" class="btn-hover bg-primary hover:bg-primary/90 text-white font-medium py-3 px-6 rounded-lg shadow flex items-center justify-center">
                        <i class="fa-solid fa-search mr-2"></i> 查询记录
                    </button>
                    <a href="content.jsp" class="btn-hover bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium py-3 px-6 rounded-lg shadow flex items-center justify-center">
                        <i class="fa-solid fa-arrow-left mr-2"></i> 返回主页面
                    </a>
                </div>
            </form>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="w-full bg-white py-4 border-t border-gray-200">
        <div class="container mx-auto px-4 text-center text-gray-500 text-sm">
            <p>© 2025 账务管理系统 | 版权所有</p>
        </div>
    </footer>

    <script>
        // 根据选择的查询方式，显示或隐藏对应的输入框区域
        document.getElementById('queryOption').addEventListener('change', function() {
            var selectedOption = this.value;
            var timeDiv = document.getElementById('timeDiv');
            var timeRangeDiv = document.getElementById('timeRangeDiv');
            var typeDiv = document.getElementById('typeDiv');
            var projectDiv = document.getElementById('projectDiv');
            
            // 隐藏所有条件框
            timeDiv.style.display = 'none';
            timeRangeDiv.style.display = 'none';
            typeDiv.style.display = 'none';
            projectDiv.style.display = 'none';
            
            // 重置所有错误提示
            document.getElementById('timeError').classList.add('hidden');
            document.getElementById('startTimeError').classList.add('hidden');
            document.getElementById('endTimeError').classList.add('hidden');
            document.getElementById('typeError').classList.add('hidden');
            
            // 显示对应条件框
            if (selectedOption === 'byTime') {
                timeDiv.style.display = 'block';
            } else if (selectedOption === 'byTimeRange') {
                timeRangeDiv.style.display = 'block';
            } else if (selectedOption === 'byType') {
                typeDiv.style.display = 'block';
            } else if (selectedOption === 'byProject') {
                projectDiv.style.display = 'block';
            }
        });

        // 表单验证函数
        function validateForm() {
            var queryOption = document.getElementById('queryOption').value;
            var isValid = true;
            
            // 重置所有错误提示
            document.getElementById('timeError').classList.add('hidden');
            document.getElementById('startTimeError').classList.add('hidden');
            document.getElementById('endTimeError').classList.add('hidden');
            document.getElementById('typeError').classList.add('hidden');
            
            if (queryOption === "byTime") {
                var time = document.getElementById('time').value;
                if (!validateDateFormat(time)) {
                    document.getElementById('timeError').classList.remove('hidden');
                    isValid = false;
                }
            } else if (queryOption === "byTimeRange") {
                var startTime = document.getElementById('startTime').value;
                var endTime = document.getElementById('endTime').value;
                
                if (!validateDateFormat(startTime)) {
                    document.getElementById('startTimeError').classList.remove('hidden');
                    isValid = false;
                }
                
                if (!validateDateFormat(endTime)) {
                    document.getElementById('endTimeError').classList.remove('hidden');
                    isValid = false;
                }
                
                // 检查开始时间是否小于结束时间
                if (isValid && startTime && endTime) {
                    var start = new Date(startTime.replace(/\./g, '-'));
                    var end = new Date(endTime.replace(/\./g, '-'));
                    if (start > end) {
                        document.getElementById('startTimeError').textContent = "开始时间不能大于结束时间";
                        document.getElementById('startTimeError').classList.remove('hidden');
                        isValid = false;
                    }
                }
            } else if (queryOption === "byType") {
                var checkboxes = document.querySelectorAll('input[name="recordType"]:checked');
                if (checkboxes.length === 0) {
                    document.getElementById('typeError').classList.remove('hidden');
                    isValid = false;
                }
            }
            
            // 如果验证失败，滚动到第一个错误字段
            if (!isValid) {
                var firstError = document.querySelector('.text-danger:not(.hidden)');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
            
            return isValid;
        }

        // 日期格式验证函数
        function validateDateFormat(dateStr) {
            // 检查是否为空
            if (!dateStr) return false;
            
            // 检查格式是否为YYYY.MM.DD
            var reg = /^\d{4}\.\d{2}\.\d{2}$/;
            if (!reg.test(dateStr)) return false;
            
            // 检查日期是否有效
            var parts = dateStr.split('.');
            var year = parseInt(parts[0], 10);
            var month = parseInt(parts[1], 10);
            var day = parseInt(parts[2], 10);
            
            // 检查月份范围
            if (month < 1 || month > 12) return false;
            
            // 检查每月天数
            var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
            
            // 闰年处理
            if ((year % 4 === 0 && year % 100 !== 0) || year % 400 === 0) {
                daysInMonth[1] = 29;
            }
            
            return day > 0 && day <= daysInMonth[month - 1];
        }

        // 为所有输入框添加焦点和失焦事件
        document.querySelectorAll('input, select').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('ring-2', 'ring-primary/30', 'rounded-lg');
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('ring-2', 'ring-primary/30', 'rounded-lg');
            });
        });
    </script>
</body>
</html>