
<!-- SESSION 정보 객체 -->
<input type="hidden" id="sessionUserId"     name="sessionUserId"    value="<%= session.getAttribute("SESSION_USER_ID") %>" />      <!-- 사용자 ID -->
<input type="hidden" id="sessionUserName"   name="sessionUserName"  value="<%= session.getAttribute("SESSION_USER_NAME") %>" />    <!-- 사용자명 -->
<input type="hidden" id="sessionUserType"   name="sessionUserType"  value="<%= session.getAttribute("SESSION_USER_TYPE") %>" />    <!-- 사용자구분 -->
<input type="hidden" id="sessionUserClass"  name="sessionUserClass" value="<%= session.getAttribute("SESSION_USER_CLASS") %>" />   <!-- 사용자분류 -->
<input type="hidden" id="sessionTelNo"      name="sessionTelNo"     value="<%= session.getAttribute("SESSION_TEL_NO") %>" />       <!-- 전화번호 -->
<input type="hidden" id="sessionEmail"      name="sessionEmail"     value="<%= session.getAttribute("SESSION_EMAIL") %>" />        <!-- 사용자 Email -->
<input type="hidden" id="sessionSiteCode"   name="sessionSiteCode"  value="<%= session.getAttribute("SESSION_SITE_CODE") %>" />    <!-- 사이트코드 -->
