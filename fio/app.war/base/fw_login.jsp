<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<script type="text/javascript">

if (window.parent != null) {

	if (window.parent.frames[0] != null) {

		if (window.parent.frames[0].name == "console") {
			window.parent.frames[0].location ="<%= request.getContextPath() %>/base/fw_login_form.jsp";
		} else {
			window.parent.parent.frames[0].location ="<%= request.getContextPath() %>/base/fw_login_form.jsp";
		}
	}
	location.href="<%= request.getContextPath() %>/base/fw_login_form.jsp";
} else {
	location.href="<%= request.getContextPath() %>/base/fw_login_form.jsp";
}

</script>
