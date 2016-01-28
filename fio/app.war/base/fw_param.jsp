<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<style type="text/css">
.popupMenuButton {
	width: 55px;
	height: 30px;
	cursor: pointer;
	float: left;
}
</style>

<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/prototype.js"></script>
<script language="javascript">

	var totalParameter = 3;
	
	document.onkeypress = onKeyHandler;
	
	function onKeyHandler() {
		var code = window.event.keyCode;
		if (code == 13) {
			var form = document.urlForm;
			clickButton(form);
		}
	}
	
	function clickButton() {
		//var form = $('popupForm');
		//var input = form['name0'];
		console.log($F(input));
		for(var i = 0 ; i <= totalParameter ; i++) {	
			if((document.getElementById("value" + i).value).trim != "")
			{
				document.getElementById("value" + i).name = document.getElementById("name" + i).value;
			}
		}
		form.action = document.getElementById("urlStr").value;	
		form.submit();
		parent.closeParameterFrame();
	}
	
	function addParameter()
	{
		totalParameter++;
		var table = document.getElementById("parameterTable");
	    var row = document.createElement("TR");
	    var td1 = document.createElement("TD");
	    td1.innerHTML = "<input id='name" + totalParameter + "' type='text' size='12'/>";
	    var td2 = document.createElement("TD");
	    td2.innerHTML = "<input id='value" + totalParameter + "' type='text' size='22'/>";
	    row.appendChild(td1);
	    row.appendChild(td2);
	  	table.children(0).appendChild(row);
	}
	
	function removeParameter()
	{
		if(totalParameter >= 4)
		{
			var table = document.getElementById("parameterTable");
			table.deleteRow(totalParameter + 1);
			totalParameter--;
		}
	}
	
	function resetParameter()
	{
		for(var i = 0 ; i <= totalParameter ; i++)
		{	
			document.getElementById("value" + i).value = "";
			document.getElementById("name" + i).value = "";
		}
	}
</script>
</head>
<body>
	<center>
	<form id="popupForm" name="urlForm" target="right" action="#">
		<span id="url" style="font-size: 15px;"></span>
		<br />
		<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button01.jpg" onclick="clickButton();" />
		<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button02.jpg" onclick="addParameter();" />
		<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button03.jpg" onclick="removeParameter();" />
		<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button04.jpg" onclick="resetParameter();" />
		<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button05.jpg" onclick="parent.closeParameterFrame();" />
		
		<table id="parameterTable" bgcolor="EAF3F8" bordercolor="#dddddd">
			<tr bgcolor="B5D5E2" style="font-size: 15px;">
				<th align="center">
					Name
				</th>
				<th align="center">
					Value
				</th>
			</tr>
			<tr>
				<td>
					<input id="name0" type="text" size="12"/>
				</td>
				<td>
					<input id="value0" type="text" size="22"/>
				</td>
			</tr>	
			<tr>
				<td>
					<input id="name1" type="text" size="12"/>
				</td>
				<td>
					<input id="value1" type="text" size="22"/>
				</td>
			</tr>
			<tr>
				<td>
					<input id="name2" type="text" size="12"/>
				</td>
				<td>
					<input id="value2" type="text" size="22"/>
				</td>
			</tr>
			<tr>
				<td>
					<input id="name3" type="text" size="12"/>
				</td>
				<td>
					<input id="value3" type="text" size="22"/>
				</td>
			</tr>
		</table>
	</form>
	</center>
</body>
</html>