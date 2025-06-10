<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Dao.AccountRecordDao,java.util.List,java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>更新后的所有账务记录展示</title>
    <style>
        /* 整体页面背景色及字体设置 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        /* 结果容器样式，使其更居中且有合适的宽度、内边距和外观效果 */
     .container {
            width: 80%;
            max-width: 800px;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th {
            background-color: #007BFF;
            color: white;
            padding: 12px;
            text-align: left;
            font-size: 16px;
        }

        table td {
            border: 1px solid #ccc;
            padding: 12px;
            font-size: 14px;
        }

        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        /* 提示信息样式，用于显示查不到结果等提示内容，使其更突出 */
     .no-result-message {
            text-align: center;
            color: #888;
            font-size: 16px;
            margin-top: 20px;
        }

        /* 按钮组样式，用于对操作按钮进行布局管理 */
     .button-group {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
        }

        /* 按钮样式，统一设置外观及交互效果 */
     .button-group a {
            text-decoration: none;
            color: white;
            background-color: #007BFF;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
            font-size: 16px;
        }

        /* 按钮悬停效果 */
     .button-group a:hover {
            background-color: #0056b3;
        }

        form#logoutForm {
            margin-top: 20px;
        }

        input[type="submit"]#logoutBtn {
            background-color: #FF5733; /* 与查询按钮颜色区分开，使用了不同颜色表示退出操作 */
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            display: block;
            margin: 0 auto;
        }

        input[type="submit"]#logoutBtn:hover {
            background-color: #E84322;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>所有账务记录</h2>

        <!-- 用于展示账务记录的表格 -->
        <table>
            <thead>
                <tr>
                    <th>记录ID</th>
                    <th>用户ID</th>
                    <th>日期</th>
                    <th>类型</th>
                    <th>金额</th>
                    <th>类别</th>
                    <th>备注</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // 从请求属性中获取查询到的账务记录列表
                    List<Dao.AccountRecordDao.AccountRecord> recordList = (List<Dao.AccountRecordDao.AccountRecord>) request.getAttribute("recordList");
                    if (recordList!= null &&!recordList.isEmpty()) {
                        for (Dao.AccountRecordDao.AccountRecord record : recordList) {
                %>
                <tr>
                    <td><%= record.getRecordId() %></td>
                    <td><%= record.getUserId() %></td>
                    <td><%= record.getDate() %></td>
                    <td><%= record.getType() %></td>
                    <td><%= record.getAmount() %></td>
                    <td><%= record.getCategory() %></td>
                    <td><%= record.getRemark() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7">
                        <p class="no-result-message">很抱歉，暂时未查询到账务记录数据，请检查查询条件或稍后重试。</p>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <!-- 操作按钮组，包含返回等功能按钮 -->
        <div class="button-group">
            <a href="function4.jsp">返回编辑页面</a>
            <a href="content.jsp">点击返回主页面</a>
            <form action="LogoutServlet" method="post"> <!-- 假设退出功能对应的Servlet为LogoutServlet，可按需调整 -->
                <input type="hidden" name="action" value="logout"> <!-- 添加隐藏字段标识退出操作 -->
                <input type="submit" value="退出账号" id="logoutBtn">
            </form>
        </div>
    </div>
</body>
</html>