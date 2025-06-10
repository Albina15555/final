<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="Dao.AccountRecordDao.AccountRecord,java.util.List"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>账务记录排序结果展示</title>
    <style>
        /* 全局样式，设置页面基础字体、背景等 */
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

        /* 标题样式类，统一设置标题的外观 */
       .page-title {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        /* 表格容器样式类，设置表格的整体外观、阴影、内边距等 */
       .table-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-top: 20px;
        }

        /* 表格样式，设置表格的基本样式，如边框合并等 */
        table {
            border-collapse: collapse;
            width: 800px;
        }

        /* 表头单元格样式 */
        th {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
            background-color: #f2f2f2; /* 给表头添加一个浅灰色背景，增强区分度 */
        }

        /* 表格数据单元格样式 */
        td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }
    </style>
</head>

<body>
    <h2 class="page-title">账务记录排序结果</h2>
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>用户ID</th>
                    <th>日期</th>
                    <th>类型</th>
                    <th>金额</th>
                    <th>项目类别</th>
                    <th>备注</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Object sortedRecordsObj = request.getAttribute("sortedRecords");
                    if (sortedRecordsObj instanceof List) {
                        List<AccountRecord> sortedRecords = (List<AccountRecord>) sortedRecordsObj;
                        if (!sortedRecords.isEmpty()) {
                            for (AccountRecord record : sortedRecords) {
                %>
                <tr>
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
                    <td colspan="6">暂无排序结果数据，请返回重新选择。</td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6">获取到的数据类型不符合预期，请联系管理员。</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
<a href="content.jsp">点击返回主页面</a>
        <input type="hidden" name="action" value="logout"> <!-- 添加一个隐藏字段用于标识是退出操作 -->
        <input type="submit" value="退出账号" style="display:block;margin:10px auto;padding:10px 20px;font-size:16px;">
    </form>
</html>