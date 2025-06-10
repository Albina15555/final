<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Dao.AccountRecordDao,java.util.List,java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>账务记录查询结果</title>
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

      .button-group {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
        }

      .button-group a {
            text-decoration: none;
            color: white;
            background-color: #007BFF;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
            font-size: 16px;
        }

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
        <h2>账务记录查询结果</h2>

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
                    // 获取查询方式参数
                    String queryOption = request.getParameter("queryOption");
                    AccountRecordDao accountRecordDao = new AccountRecordDao();
                    List<AccountRecordDao.AccountRecord> recordList = null;
                    try {
                        if ("byTime".equals(queryOption)) {
                            // 按时间查询
                            String time = request.getParameter("time");
                            recordList = accountRecordDao.queryByTime(time);
                        } else if ("byTimeRange".equals(queryOption)) {
                            // 按时间区间查询
                            String startTime = request.getParameter("startTime");
                            String endTime = request.getParameter("endTime");
                            recordList = accountRecordDao.queryByTimeRange(startTime, endTime);
                        } else if ("byType".equals(queryOption)) {
                            // 按记录类型查询
                            String[] recordTypeArray = request.getParameterValues("recordType");
                            recordList = accountRecordDao.queryByType(recordTypeArray);
                        } else if ("byProject".equals(queryOption)) {
                            // 按项目查询
                            String project = request.getParameter("project");
                            recordList = accountRecordDao.queryByProject(project);
                        } else if ("all".equals(queryOption)) {
                            // 查询所有记录
                            recordList = accountRecordDao.queryAll();
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    if (recordList!= null &&!recordList.isEmpty()) {
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
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7">没有查询到符合条件的账务记录</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <div class="button-group">
            <!--  a href="function3reasult.jsp"查看所有记录--><!--/a-->
            <a href="content.jsp">点击返回主页面</a>
        </div>

        <form action="LogoutServlet" method="post"> <!-- 这里假设退出功能对应的Servlet为LogoutServlet，你可根据实际情况调整 -->
            <input type="hidden" name="action" value="logout"> <!-- 添加一个隐藏字段用于标识是退出操作 -->
            <input type="submit" value="退出账号" id="logoutBtn">
        </form>
    </div>
</body>
</html>