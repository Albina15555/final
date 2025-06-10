<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="filter.PermissionChecker" %>
<%
    String functionKey = request.getParameter("functionKey");
    boolean hasPermission = PermissionChecker.hasPermission(session, functionKey);
    out.print(hasPermission);
%>