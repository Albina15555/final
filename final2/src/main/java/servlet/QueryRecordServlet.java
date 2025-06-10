package servlet;

import Dao.AccountRecordDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

//@WebServlet("/QueryRecordServlet")
public class QueryRecordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取前端传来的查询方式参数
        String queryOption = request.getParameter("queryOption");
        AccountRecordDao accountRecordDao = new AccountRecordDao();
        // 根据不同查询方式调用对应数据库查询方法，并将结果存入请求属性中，以便转发到展示页面展示
		if ("byTime".equals(queryOption)) {
		    // 按时间查询
		    String time = request.getParameter("time");
		    List<AccountRecordDao.AccountRecord> recordList = accountRecordDao.queryByTime(time);
		    request.setAttribute("recordList", recordList);
		} else if ("byTimeRange".equals(queryOption)) {
		    // 按时间区间查询
		    String startTime = request.getParameter("startTime");
		    String endTime = request.getParameter("endTime");
		    List<AccountRecordDao.AccountRecord> recordList = accountRecordDao.queryByTimeRange(startTime, endTime);
		    request.setAttribute("recordList", recordList);
		} else if ("byType".equals(queryOption)) {
		    // 按记录类型查询
		    String[] recordTypeArray = request.getParameterValues("recordType");
		    List<AccountRecordDao.AccountRecord> recordList = accountRecordDao.queryByType(recordTypeArray);
		    request.setAttribute("recordList", recordList);
		} else if ("byProject".equals(queryOption)) {
		    // 按项目查询
		    String project = request.getParameter("project");
		    List<AccountRecordDao.AccountRecord> recordList = accountRecordDao.queryByProject(project);
		    request.setAttribute("recordList", recordList);
		}if ("all".equals(queryOption)) {
		    // 查询所有记录
		    List<AccountRecordDao.AccountRecord> recordList;
		    try {
		        recordList = accountRecordDao.queryAll();
		        request.setAttribute("recordList", recordList);
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		}
		
		// 将请求转发到查询结果展示页面（function2result1.jsp）
		request.getRequestDispatcher("function2result1.jsp").forward(request, response);
    }}