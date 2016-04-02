<%@ Language=VBScript %>
<%
	'Startup
	dim WebApp
	dim ForecastFacade
	dim CurrencyType
	
	set WebApp = CreateObject("tvmwebclient.WebApplication")
	set ForecastFacade = CreateObject("ctvmlending.ForecasterFacade")
	
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1	
%>
<html>
<head>
<meta NAME="WebAppStarted" Content="<% =Application("WebAppStarted")%>">
<meta NAME="PageDateTime" Content="<% =now %>">
<meta NAME="CUSTOMERID" Content="<% =Request("CustomerId") %>">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<style>
<!-- #Include File="style.css" -->
</style>
<title>Customer Detail</title>
</head>
<body>
<%
	dim CustomerId
	dim CustomerHeading
	dim mRs
	
	CustomerId = Request("CustomerId")
	CustomerHeading = "Customer Details"
	
	If IsEmpty(CustomerId) then
		Response.Write "No Customer id supplied. Please go back and try again."
		Response.End 
	end if
	
	set mRs = CreateObject("ADODB.Recordset")
%>

<table width="100%" Class="PageHeader">
<td>Customer Detail Sheet</td>
<td Align="Right">
<a HREF="default.asp">New Search 
<img ALIGN="absmiddle" ALT="New Search" SRC="images/new.gif" border="0" WIDTH="12" HEIGHT="14"></a>
</td>
</table>
<br>

<!-- #include file="CustomerInclude.asp" -->
<br>

<%
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetCustomersDeals " & CustomerId)
	if not mRs.EOF then 
	dim count 
	count=0
%>
<table Class="StandardTable" width="90%" Align="Center">
<tr id="Header"><td Colspan="20">Deal Summary</td></tr>
<tr id="ColHeader"><td align="Center">Deal Number</td><td>Product</td><td>Product Variation</td><td>Deal Structure</td><td align="Right">Principal/Notional</td></tr>
<%	
	do until mRs.EOF 
		count = count + 1
		set CurrencyType = ForecastFacade.GetCurrencyType(mRs("Id"))
%>
<tr <% if count mod 2 = 0 then Response.Write "id=EvenRow" else Response.Write "id=OddRow"%>>
	<td align="Center"><a HREF="DealDetail.asp?DealId=<% =mRs("Id") %>"><% =mRs("DealNumber") %></a></td>
	<td><% =mRs("Product") %></td>
	<td><% =mRs("Variation") %></td>
	<td><a HREF="DealStructureDetail.asp?DealStructureId=<% =mRs("DealStructureID") %>"><% =mRs("DealStructure") %> (<% =mRs("StructureNumber") %>)</a></td>
	<td align="Right"><% =CurrencyType.Format(ccur(mRs("PositionValue"))) %></td>	
</tr>

<%
	mRs.MoveNext 
	loop
	mRs.Close 
%>
</table>
<br>
<%	end if %>


<!-- #Include File="footer.asp" -->
</body>
</html>

<%
	'Cleanup
	on error resume next 
	mRs.Close 
	set WebApp = nothing
	set mRs = nothing
%>
