<%@ Language=VBScript %>
<%
	'Startup
	dim WebApp
	dim ForecastFacade
	dim CurrencyType
	set WebApp = CreateObject("tvmwebclient.WebApplication")
	set ForecastFacade = CreateObject("ctvmlending.ForecasterFacade")
%>
<html>
<head>
<meta NAME="WebAppStarted" Content="<% =Application("WebAppStarted")%>">
<meta NAME="PageDateTime" Content="<% =now %>">
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<style>
<!-- #Include File="style.css" -->
</style>
</head>
<body>

<table width="100%" Class="PageHeader">
<td>Rabo Enquiry System</td>
<td Align="Right">
<a HREF="default.asp">New Search 
<img ALIGN="absmiddle" ALT="New Search" SRC="images/new.gif" border="0" WIDTH="12" HEIGHT="14"></a>
</td>
</table>
<br>

<form name="SearchForm" method="post" action="SearchResults.asp">
<table Class="StandardTable" Align="Center" width="90%">
<tr id="Header">Search Criteria</tr>
<tr>
	<td><strong>Search For:</strong><br>
		<input type="radio" id="SearchFor" name="SearchFor" value="Customer" CHECKED>Customer<br>
		<input type="radio" id="SearchFor" name="SearchFor" value="Deal">Deal<br>
		<input type="radio" id="SearchFor" name="SearchFor" Value="DealStructure">Deal Structure</td>
</tr>	
<tr>
	<td Colspan="20">Search String: <input type="text" id="SearchString" name="SearchString" size="30"></td>
</tr>
<tr>
	<td><input type="submit" value="Search" id="submit" name="submit"></td>
</tr>
</table>
</form>
<br>

<%
	dim mRs
	dim DealNo
	dim OldDealNo
	dim Count
	
	set mRs = CreateObject("ADODB.Recordset")
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetTasks")
	if not mRs.EOF then
		Count = 0
		OldDealNo = cstr(mRs("DealId"))
%>
<table Class="StandardTable" Align="Center" Width="90%">
<tr id="Header"><td Colspan="20">Tasks for the next 14 days</td></tr>
<tr id="ColHeader"><td>Customer</td><td align="center">Deal</td><td>Product</td><td>Product Variation</td><td>Description</td><td>Effective Date</td><td>Next Fixing Date</td><td align="right">Amount</td><td align="right">Principal Outstanding</td></tr>
<%	do until mRs.EOF 
		set CurrencyType = ForecastFacade.GetCurrencyType(mRs("DealId"))
		Count = Count + 1
		DealNo = cstr(mRs("DealId"))
		
		if OldDealNo <> DealNo then 
%>
<tr>
	<td ColSpan="20"><hr width="90%" size="1" class="StandardTable"></td>
</tr>
<%		
		OldDealNo = DealNo
		end if 
%>


<tr <% if count mod 2 = 0 then Response.Write "id=EvenRow" else Response.Write "id=OddRow"%>>
	<td><a HREF="CustomerDetail.asp?CustomerId=<% =mRs("CustomerId") %>"><% =mRs("CustomerName") %> (<% =mRs("CustomerNumber") %>)</a></td>
	<td align="center"><a HREF="DealDetail.asp?DealId=<% =mRs("DealId") %>"><% =cint(mRs("DealNumber")) %></a></td>
	<td><% =mRs("ProductName") %></td>
	<td><% =mRs("ProductVariationName") %></td>
	<td><% =mRs("TaskEventDescription") %></td>
	<td><% =WebApp.Format(mRs("TaskEffectiveDate"),"dd mmm yyyy") %></td>
	<td><% =WebApp.Format(mRs("TaskNextFixingDate"),"dd mmm yyyy") %></td>
	<td align="right"><% =CurrencyType.Format(ccur(mRs("TaskEventAmount"))) %></td>
	<td align="right"><% =CurrencyType.Format(ccur(mRs("TaskPrincipalOutstanding"))) %></td>
	
</tr>
<%	mRs.MoveNext 
	loop 
	mRs.Close 
%>
</table>
<%	end if %>
<script LANGUAGE="javascript">
<!--
	document.SearchForm.SearchString.focus();
//-->
</script>

<!-- #Include File="footer.asp" -->
</body>
</html>

<%
	'Cleanup
	on error resume next
	set WebApp = nothing
	set ForecastFacade = nothing
	set CurrencyType = nothing
	mRs.Close 
	set mRs = nothing 
%>
