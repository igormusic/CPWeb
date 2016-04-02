<%@ Language=VBScript %>
<%
	'Startup
	dim WebApp
	set WebApp = CreateObject("tvmwebclient.WebApplication")
	
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
%>
<html>
<head>
<meta NAME="WebAppStarted" Content="<% =Application("WebAppStarted") %>">
<meta NAME="PageDateTime" Content="<% =now() %>">
<meta NAME="DEALSTRUCTUREID" Content="<% =Request("DealStructureId") %>">
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<style>
<!-- #Include File="style.css" -->
</style>
<title>Deal Structure Sheet</title>
</head>
<body>

<%
	dim DealStructureId
	dim mRs
	
	DealStructureId = Request("DealStructureId")
	
	If IsEmpty(DealStructureId) then
		'DealStructureId = "800010202133771"
		Response.Write "No Deal Structure id supplied. Please go back and try again."
		Response.End 
	end if
	
	set mRs = CreateObject("ADODB.Recordset")
%>

<table width="100%" Class="PageHeader">
<td>Deal Structure Detail Sheet</td>
<td Align="Right">
<a HREF="default.asp">New Search 
<img ALIGN="absmiddle" ALT="New Search" SRC="images/new.gif" border="0" WIDTH="12" HEIGHT="14"></a>
</td>
</table>
<br>

<!-- #Include File="DealStructureInclude.asp" -->
<br>

<%	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetDealStructuresDeals " & DealStructureId)
	dim count
	if not mRs.EOF then %>
<table Class="StandardTable" Align="Center" Width="90%">
<tr id="Header"><td Colspan="20">Deal Summary</td></tr>
<tr id="ColHeader"><td>Customer</td><td align="center">Deal Number</td><td>Product</td><td>Product Variation</td></tr>
<%	count = 0
	do until mRs.EOF 
	count = count + 1
%>
<tr <% if count mod 2 = 0 then Response.Write "id=EvenRow" else Response.Write "id=OddRow"%>>
	<td><a HREF="CustomerDetail.asp?CustomerId=<% =mRs("CustomerID") %>"><% =mRs("CustomerName") %> (<% =mRs("CustomerNumber") %>)</a></td>
	<td align="center"><a HREF="DealDetail.asp?DealId=<% =mRs("DealId") %>"><% =mRs("DealNumber") %></a></td>
	<td><% =mRs("Product") %></td>
	<td><% =mRs("Variation") %></td>
</tr>	
<%
	mRs.MoveNext 
	loop
	mRs.Close 
%>
</table>
<%	end if %>

<!-- #Include File="footer.asp" -->
</body>
</html>

<%
	'Cleanup
	on error resume next
	mRs.Close 	
	set WebApp = nothing
	set mRs = noting
%>
