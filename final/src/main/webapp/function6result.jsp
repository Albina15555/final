<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Dao.AccountRecordDao,java.util.List,java.sql.SQLException" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>账务统计结果</title>
    <style>
        /* 全局样式 */
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

        /* 标题样式 */
        h2 {
            font-size: 32px;
            font-weight: bold;
            color: #333;
            margin-bottom: 30px;
        }

        h3 {
            font-size: 24px;
            font-weight: normal;
            color: #555;
            margin-bottom: 15px;
        }

        /* 容器通用样式 */
      .container {
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
            width: 80%;
            margin-bottom: 30px;
        }

        /* 表格样式 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        table th {
            background-color: #007BFF;
            color: white;
            padding: 15px;
            text-align: center;
            font-weight: bold;
        }

        table td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: center;
        }

        /* 按钮样式 */
        button {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 12px 25px;
            font-size: 18px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 15px;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* 按钮组容器样式 */
      .button-group {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }
    </style>
</head>

<body>
    <h2>账务统计结果</h2>

    <!-- 统计方式展示区域 -->
    <div class="container">
        <h3>统计方式：
            <%= request.getAttribute("statisticsType")!= null? request.getAttribute("statisticsType") : "未选择" %>
        </h3>
    </div>

    <!-- 总账统计结果展示区域 -->
    <div class="container">
        <%
            if ("总账".equals(request.getAttribute("statisticsType"))) {
        %>
        <h3>总账金额总和：
            <%= String.format("%.2f", request.getAttribute("generalLedgerTotal")!= null? (double) request.getAttribute("generalLedgerTotal") : 0.0) %>
        </h3>
        <%
            }
        %>
    </div>

    <!-- 分类账统计结果展示区域 -->
    <div class="container">
        <%
            if ("分类账".equals(request.getAttribute("statisticsType"))) {
        %>
        <h3>分类账统计结果（按选择的项目类型）：</h3>
        <table>
            <thead>
                <tr>
                    <th>项目类别</th>
                    <th>金额总和</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<AccountRecordDao.CategoryTotal> categoryLedgerTotals = (List<AccountRecordDao.CategoryTotal>) request.getAttribute("categoryLedgerTotals");
                    if (categoryLedgerTotals!= null &&!categoryLedgerTotals.isEmpty()) {
                        for (AccountRecordDao.CategoryTotal categoryTotal : categoryLedgerTotals) {
                %>
                <tr>
                    <td><%= categoryTotal.getCategory() %></td>
                    <td><%= String.format("%.2f", categoryTotal.getTotalAmount()) %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="2">当前所选条件下暂无分类账统计数据，请重新选择项目类型进行统计。</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
            }
        %>
    </div>

    <!-- 操作按钮组区域 -->
    <div class="button-group">
        <button onclick="window.location.href='function6.jsp'">返回重新统计</button>
        <a href="content.jsp"><button>点击返回主页面</button></a>
        <form action="LogoutServlet" method="post">
            <input type="hidden" name="action" value="logout">
            <!-- 添加隐藏字段标识退出操作 -->
            <input type="submit" value="退出账号" id="logoutBtn">
        </form>
    </div>
</body>

</html>