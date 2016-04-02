<%@ Language=VBScript %>
<%
	'Startup
	dim WebApp
	dim ForecastFacade 
	dim CurrencyType 
	
	set WebApp = CreateObject("tvmwebclient.WebApplication")
	set ForecastFacade = CreateObject("ctvmlending.forecasterfacade")
	
	'Response.CacheControl = "no-cache"
	'Response.AddHeader "Pragma", "no-cache"
	'Response.Expires = -1

	dim SearchString	
	SearchString = Request.Form("SearchString")
	
	if trim(SearchString) = "" or IsEmpty(SearchString) then 
		Response.Redirect "default.asp"
		Response.End 
	end if
	
	Private Function SqlString(S)
		SqlString = Replace(S,"'","''")
	End Function 
	
%>
<html>
<head>
<meta NAME="WebAppStarted" Content="<% =Application("WebAppStarted")%>">
<meta NAME="PageDateTime" Content="<% =now %>">
<meta NAME="SearchFor" Content="<% =Request.Form("SearchFor") %>">
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<style>
	<!-- #Include File="style.css" -->
</style>
</head>
<body>

<table width="100%" Class="PageHeader">
<td>Search Results Sheet</td>
<td Align="Right">
<a HREF="default.asp">New Search 
<img ALIGN="absmiddle" ALT="New Search" SRC="images/new.gif" border="0" WIDTH="12" HEIGHT="14"></a>
</td>
</table>
<br>

<% 
	dim SearchForCustomer
	dim SearchForDeal
	dim SearchForDealStructure
	dim mRs
	dim count
	
	set mRs = CreateObject("ADODB.Recordset")
	
	SearchForCustomer = false 
	SearchForDeal = false 
	SearchForDealStructure = false
	
	if Request.Form("SearchFor") = "Customer" then 
		SearchForCustomer = true 
	elseif Request.Form("SearchFor") = "Deal" then 
		SearchForDeal = true 		
	elseif Request.Form("SearchFor") = "DealStructure" then 
		SearchForDealStructure = true 
	end if
%>

<table Class="StandardTable" Align="Center" Width="90%">
<tr id="Header"><td Colspan="20">Search Results</td></tr>
<tr id="ColHeader"><%
	if SearchForCustomer then 
		set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetCustomers '" & (SearchString) & "'")
%><td>Customer Number</td><td>Customer Name</td><%
	elseif SearchForDeal then
		set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetDeals '" & SqlString(SearchString) & "'") 		
%><td>Customer</td><td>Deal Number</td><td>External Ref.</td><td>Product</td><td>Variation</td><td>Deal Structure</td><%		
	elseif SearchForDealStructure then
		set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetDealStructures '" & SqlString(SearchString) & "'") 
%><td>Deal Structure Number</td><td>Deal Structure Description</td><%		
	end if

	count = 0

	if mRs.EOF then 
%></tr>
<td>There were no results for '<% =SearchString%>'</td>		
</tr>
</table>
</body>
</html>
		
<%	Response.End 
	end if

	do until mRs.EOF 
		count = count +1
%>
<tr <% if count mod 2 = 0 then Response.Write "id=EvenRow" else Response.Write "id=OddRow"%>>
<%	if SearchForCustomer then %>
	<td><a HREF="CustomerDetail.asp?CustomerId=<% =mRs("Id") %>"><% =mRs("CustomerNumber") %></a></td>
	<td><% =mRs("CustomerName") %></td>
<%	end if %>
<%	if SearchForDeal then %>
	<td><a HREF="CustomerDetail.asp?CustomerId=<% =mRs("CustomerId") %>"><% =mRs("CustomerName") %> (<% =mRs("CustomerNumber") %>)</a></td>
	<td><a HREF="DealDetail.asp?DealId=<% =mRs("Id") %>"><% =mRs("DealNumber") %></a></td>	
	<td><% =mRs("ExternalRef") %></td>
	<td><% =mRs("Product") %></td>
	<td><% =mRs("Variation") %></td>
	<td><A HREF="DealStructureDetail.asp?DealStructureId=<% =mRs("DealStructureId")%>"><% =mRs("DealStructure") %> (<% =mRs("StructureNumber") %>)</A></td>
	
<%	end if %>
<%	if SearchForDealStructure then %>
	<td><a HREF="DealStructureDetail.asp?DealStructureId=<% =mRs("Id") %>"><% =mRs("StructureNumber") %></a></td>
	<td><% =mRs("Description") %></td>
<%	end if %>

</tr>
<%		mRs.MoveNext 
	loop	
	mRs.Close 
%>
</table>



<!-- #Include File="footer.asp" -->
</body>
</html>

<%
	'cleanup
	on error resume next 
	mRs.Close
	set WebApp = nothing 
	set mRs = nothing
%>

