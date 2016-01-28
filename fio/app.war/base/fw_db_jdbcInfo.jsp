<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>
<%@page import="com.cni.fw.ff.common.SystemInfo"%>

<%@page import="java.util.Iterator"%>
<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/daf.js"></script>

<%
	MTO dbInfo = output.getMTO("DB_PRODUCT");
	MTO jdbcInfo = output.getMTO("JDBC_DRIVER");
	MTO transactionInfo = output.getMTO("TRANSACTION_ISOLATION_SUPPORT");
%>

<b>&nbsp;* DB 정보</u></b>
<table width="500" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td bgcolor="EAF3F8" align=left width=35%>DB Name</td>
		<td bgcolor="FFFFFF" align=left><%= dbInfo.get("NAME") %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>DB Version</td>
		<td bgcolor="FFFFFF" align=left><%= dbInfo.get("VERSION") %></td>
	</tr>
</table>
<br>

<hr>
<b>&nbsp;* JDBC 정보</u></b>
<table width="500" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td bgcolor="EAF3F8" align=left width=35%>JDBC Name</td>
		<td bgcolor="FFFFFF" align=left><%= jdbcInfo.get("NAME") %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>JDBC Version</td>
		<td bgcolor="FFFFFF" align=left><%= jdbcInfo.get("VERSION") %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>JDBC URL</td>
		<td bgcolor="FFFFFF" align=left><%= jdbcInfo.get("URL") %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>JDBC User</td>
		<td bgcolor="FFFFFF" align=left><%= jdbcInfo.get("USER") %></td>
	</tr>
</table>
<br>

<hr>
<b>&nbsp;* Transaction Isolation 지원 정보</u></b>
<table width="500" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td bgcolor="EAF3F8" align=left width=35%>TRANSACTION_NONE</td>
		<td bgcolor="FFFFFF" align=center><% if (BooleanMaker.make(transactionInfo.get("TRANSACTION_NONE"))) { %>지원<% } %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>TRANSACTION_READ_UNCOMMITTED</td>
		<td bgcolor="FFFFFF" align=center><% if (BooleanMaker.make(transactionInfo.get("TRANSACTION_READ_UNCOMMITTED"))) { %>지원<% } %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>TRANSACTION_READ_COMMITTED</td>
		<td bgcolor="FFFFFF" align=center><% if (BooleanMaker.make(transactionInfo.get("TRANSACTION_READ_COMMITTED"))) { %>지원<% } %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>TRANSACTION_REPEATABLE_READ</td>
		<td bgcolor="FFFFFF" align=center><% if (BooleanMaker.make(transactionInfo.get("TRANSACTION_REPEATABLE_READ"))) { %>지원<% } %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>TRANSACTION_SERIALIZABLE</td>
		<td bgcolor="FFFFFF" align=center><% if (BooleanMaker.make(transactionInfo.get("TRANSACTION_SERIALIZABLE"))) { %>지원<% } %></td>
	</tr>
</table>
<br>
<hr>
