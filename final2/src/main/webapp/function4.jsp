<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="Dao.AccountRecordDao,java.util.List,java.sql.SQLException" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>账务记录编辑页面</title>
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

        /* 编辑弹窗样式（模态框） */
        #editModal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }

        #editModalContent {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 400px;
        }

        #editModalContent label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
            color: #555;
        }

        #editModalContent input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        #editModalContent button {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        #editModalContent button:hover {
            background-color: #0056b3;
        }

        #editModalClose {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        #editModalClose:hover,
        #editModalClose:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>

<body>
    <h2>账务记录编辑与管理</h2>

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
                    <button onclick="showEditForm('<%= record.getRecordId() %>')">编辑</button>
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

    <!-- 编辑弹窗 -->
    <div id="editModal">
        <div id="editModalContent">
            <span id="editModalClose">&times;</span>
            <h3>编辑账务记录</h3>
            <label for="editRecordId">记录ID：</label>
            <input type="text" id="editRecordId" readonly>
            <label for="editDate">日期：</label>
            <input type="text" id="editDate" name="date">
            <label for="editType">类型：</label>
            <input type="text" id="editType" name="type">
            <label for="editAmount">金额：</label>
            <input type="text" id="editAmount" name="amount">
            <label for="editCategory">项目类别：</label>
            <input type="text" id="editCategory" name="category">
            <label for="editRemark">备注：</label>
            <input type="text" id="editRemark" name="remark">
            <button onclick="saveEdit()">保存修改</button>
        </div>
    </div>

    <script>
        function showEditForm(recordId) {
            // 显示编辑弹窗
            document.getElementById('editModal').style.display = 'block';
            // 获取对应记录的详细信息（此处使用隐藏表单提交方式，假设服务器端返回对应记录信息填充到表单中）
            var form = document.createElement('form');
            form.style.display = 'none';
            form.method = 'GET';
            form.action = 'GetRecordDetailServlet';
            var recordIdInput = document.createElement('input');
            recordIdInput.type = 'hidden';
            recordIdInput.name = 'recordId';
            recordIdInput.value = recordId;
            form.appendChild(recordIdInput);
            document.body.appendChild(form);
            form.submit();

            // 处理服务器端返回结果（假设服务器端返回的表单数据中包含对应记录信息，这里通过表单元素获取）
            form.addEventListener('load', function () {
                var recordIdElement = document.getElementById('recordId');
                var dateElement = document.getElementById('date');
                var typeElement = document.getElementById('type');
                var amountElement = document.getElementById('amount');
                var categoryElement = document.getElementById('category');
                var remarkElement = document.getElementById('remark');

                if (recordIdElement && dateElement && typeElement && amountElement && categoryElement && remarkElement) {
                    document.getElementById('editRecordId').value = recordIdElement.value;
                    document.getElementById('editDate').value = dateElement.value;
                    document.getElementById('editType').value = typeElement.value;
                    document.getElementById('editAmount').value = amountElement.value;
                    document.getElementById('editCategory').value = categoryElement.value;
                    document.getElementById('editRemark').value = remarkElement.value;
                } else {
                    alert('获取记录详情失败，请稍后重试');
                    document.getElementById('editModal').style.display = 'none';
                }
            });
        }

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

        function saveEdit() {
            var recordId = document.getElementById('editRecordId').value;
            var date = document.getElementById('editDate').value;
            var type = document.getElementById('editType').value;
            var amount = document.getElementById('editAmount').value;
            var category = document.getElementById('editCategory').value;
            var remark = document.getElementById('editRemark').value;
            if (!date ||!type ||!amount ||!category ||!remark) {
                alert('请填写完整的记录信息');
                return;
            }

            // 创建一个隐藏的表单，用于提交编辑后的记录数据
            var form = document.createElement('form');
            form.style.display = 'none';
            form.method = 'POST';
            form.action = 'EditRecordServlet';

            var recordIdInput = document.createElement('input');
            recordIdInput.type = 'hidden';
            recordIdInput.name = 'recordId';
            recordIdInput.value = recordId;

            var dateInput = document.createElement('input');
            dateInput.type = 'hidden';
            dateInput.name = 'date';
            dateInput.value = date;

            var typeInput = document.createElement('input');
            typeInput.type = 'hidden';
            typeInput.name = 'type';
            typeInput.value = type;

            var amountInput = document.createElement('input');
            amountInput.type = 'hidden';
            amountInput.name = 'amount';
            amountInput.value = amount;

            var categoryInput = document.createElement('input');
            categoryInput.type = 'hidden';
            categoryInput.name = 'category';
            categoryInput.value = category;

            var remarkInput = document.createElement('input');
            remarkInput.type = 'hidden';
            remarkInput.name = 'remark';
            remarkInput.value = remark;

            form.appendChild(recordIdInput);
            form.appendChild(dateInput);
            form.appendChild(typeInput);
            form.appendChild(amountInput);
            form.appendChild(categoryInput);
            form.appendChild(remarkInput);

            document.body.appendChild(form);
            form.submit();

            // 处理服务器端返回结果（假设服务器端返回success表示成功，其他表示失败）
            form.addEventListener('load', function () {
                var response = form.responseText;
                if (response === "success") {
                    // 编辑成功，提示用户重新进入页面查看最新数据，并在用户点击确定后跳转到function4.jsp页面
                    var isConfirmed = window.confirm('记录已成功修改，请重新进入页面以获取最新数据。');
                    if (isConfirmed) {
                        window.location.href = 'function4.jsp';
                    }
                } else {
                    // 编辑失败，弹出提示框告知用户
                    alert('编辑记录失败，请稍后重试');
                }
            });

            // 隐藏编辑弹窗
            document.getElementById('editModal').style.display = 'none';
        }

        // 为弹窗的关闭按钮添加点击事件，用于隐藏弹窗
        document.getElementById('editModalClose').addEventListener('click', function () {
            document.getElementById('editModal').style.display = 'none';
        });
    </script>
</body>
<a href="content.jsp">点击返回主页面</a>
    <form action="LogoutServlet" method="post"> 
        <input type="hidden" name="action" value="logout"> <!-- 添加一个隐藏字段用于标识是退出操作 -->
        <input type="submit" value="退出账号" style="display:block;margin:10px auto;padding:10px 20px;font-size:16px;">
    </form>
</html>