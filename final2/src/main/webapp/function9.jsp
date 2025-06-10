<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Dao.AccountRecordDao.AccountRecord,java.util.List"%>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>账务记录选项排序</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        form {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            width: 400px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        select {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        input[type="submit"] {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>

<body>
    <h2>账务记录选项排序</h2>
    <form action="SortAccountRecordServlet" method="post">
        <label for="sortField">请选择要排序的字段：</label>
        <select id="sortField" name="sortField">
            <option value="user_id">用户ID</option>
            <option value="date">日期</option>
            <option value="type">类型</option>
            <option value="amount">金额</option>
            <option value="category">项目类别</option>
        </select>
        <label for="sortOrder">请选择排序顺序：</label>
        <select id="sortOrder" name="sortOrder">
            <option value="asc">升序</option>
            <option value="desc">降序</option>
        </select>
        <input type="submit" value="提交排序">
    </form>
    </form>
</body>
<a href="content.jsp">点击返回主页面</a>
    <form action="LogoutServlet" method="post"> 
        <input type="hidden" name="action" value="logout"> <!-- 添加一个隐藏字段用于标识是退出操作 -->
        <input type="submit" value="退出账号" style="display:block;margin:10px auto;padding:10px 20px;font-size:16px;">
    </form>
</html>