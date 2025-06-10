<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>统计方式选择</title>
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
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        /* 表单容器样式 */
        form {
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 400px;
            box-sizing: border-box;
        }

        /* 标签样式 */
        label {
            display: block;
            margin-bottom: 15px;
            font-weight: bold;
            color: #555;
            font-size: 18px;
        }

        /* 单选按钮样式 */
        input[type="radio"] {
            margin-right: 12px;
            transform: scale(1.2);
        }

        /* 文本输入框样式 */
        input[type="text"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 25px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
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
            width: 100%;
            box-sizing: border-box;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* 分类账输入框样式 */
      .category-input {
            display: none;
            margin-top: 10px;
        }

        /* 当选择分类账的单选框被选中时，显示对应的输入框 */
        input[type="radio"][value="categoryLedger"]:checked ~.category-input {
            display: block;
        }

        /* 链接样式 */
        a {
            display: block;
            text-align: center;
            text-decoration: none;
            color: #007BFF;
            margin-top: 20px;
            font-size: 16px;
        }

        /* 退出账号按钮所在表单样式 */
        form:last-child {
            margin-top: 20px;
        }
    </style>
</head>

<body>
    <h2>请选择统计方式及相关选项</h2>

    <form action="CountServlet" method="get">
        <label>
            <input type="radio" name="statisticsType" value="generalLedger" checked> 总账
        </label>
        <br>
        <label>
            <input type="radio" name="statisticsType" value="categoryLedger"> 分类账
            <input type="text" id="categoryInput" name="selectedCategories" placeholder="请输入分类账项目类型，多个类型用逗号隔开" class="category-input">
        </label>
        <br>
        <button type="submit">开始统计</button>
    </form>
    <a href="content.jsp">点击返回主页面</a>
    <form action="LogoutServlet" method="post">
        <input type="hidden" name="action" value="logout">
        <input type="submit" value="退出账号">
    </form>
</body>

</html>