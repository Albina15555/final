<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="Dao.AccountRecordDao,java.util.List,java.sql.SQLException" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>账务记录管理</title>
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
            justify-content: center;
            min-height: 100vh;
        }

        /* 表格样式 */
        table {
            width: 80%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th, table td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }

        /* 按钮样式 */
        button {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 8px 12px;
            font-size: 14px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 5px;
        }

        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>

<body>
    <h2>账务记录管理</h2>

    <table>
        <thead>
            <tr>
                <th>记录ID</th>
                <th>用户ID</th>
                <th>日期</th>
                <th>类型</th>
                <th>金额</th>
                <th>项目类别</th>
                <th>备注</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <%
                AccountRecordDao dao = new AccountRecordDao();
                try {
                    List<AccountRecordDao.AccountRecord> recordList = dao.queryAll();
                    for (AccountRecordDao.AccountRecord record : recordList) {
            %>
            <tr>
                <td><%= record.getRecordId() %></td>
                <td><%= record.getUserId() %></td>
                <td><%= record.getDate() %></td>
                <td><%= record.getType() %></td>
                <td><%= record.getAmount() %></td>
                <td><%= record.getCategory() %></td>
                <td><%= record.getRemark() %></td>
                <td>
                    <button onclick="doDelete('<%= record.getRecordId() %>')">删除</button>
                </td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='8'>数据库查询出现错误</td></tr>");
                }
            %>
        </tbody>
    </table>

    <script>
        function doDelete(recordId) {
            if (confirm('确定要删除记录ID为 ' + recordId + ' 的记录吗？')) {
                // 创建一个隐藏的表单，用于提交删除记录的请求
                var form = document.createElement('form');
                form.style.display = 'none';
                form.method = 'POST';
                form.action = 'DeleteRecordServlet';
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'recordId';
                input.value = recordId;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();

                // 处理服务器端返回结果（假设服务器端返回success表示成功，其他表示失败）
                form.addEventListener('load', function () {
                    var response = form.responseText;
                    if (response === "success") {
                        // 删除成功，提示用户重新进入页面查看最新数据，并在用户点击确定后跳转到content.jsp页面
                        var isConfirmed = window.confirm('记录已成功删除，请重新进入页面以获取最新数据。');
                        if (isConfirmed) {
                            window.location.href = 'content.jsp';
                        }
                    } else {
                        // 删除失败，弹出提示框告知用户
                        alert('删除记录失败，请稍后重试');
                    }
                });
            }
        }
    </script>
</body>
    <a href="content.jsp">点击返回主页面</a>
    <form action="LogoutServlet" method="post"> 
        <input type="hidden" name="action" value="logout"> <!-- 添加一个隐藏字段用于标识是退出操作 -->
        <input type="submit" value="退出账号" style="display:block;margin:10px auto;padding:10px 20px;font-size:16px;">
    </form>
</html>