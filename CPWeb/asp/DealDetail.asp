<%@ Language=VBScript %>
<%
	'Startup
	dim WebApp
	dim ForecastFacade 
	dim CurrencyType 
	
	set WebApp = CreateObject("tvmwebclient.WebApplication")
	set ForecastFacade = CreateObject("ctvmlending.forecasterfacade")
	
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
%>
<html>
<head>
<meta NAME="WebAppStarted" Content="<% =Application("WebAppStarted")%>">
<meta NAME="PageDateTime" Content="<% =now %>">
<meta NAME="DEALID" Content="<% =Request("DealId") %>">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<style>
<!-- #Include File="style.css" -->
</style>
<title>Deal Description Sheet</title>
</head>
<body>

<%
	dim DealId
	
	DealId = Request("DealId")
	
	If IsEmpty(DealId) then
		Response.Write "No deal id supplied. Please go back and try again."
		Response.End 
	end if	

	dim mRs
	set mRs = CreateObject("ADODB.Recordset")	
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_DealDetails @DealId=" & Dealid)
	
	dim CustomerId
	dim ObligorId
	dim DealStructureId
	dim CustomerHeading 
	CustomerId = mRs("CustomerId")
	ObligorId = mRs("ObligorId")
	DealStructureId = mRs("DealStructureId")
%>

<table width="100%" Class="PageHeader">
<td>Deal Detail Sheet</td>
<td Align="Right">
<a HREF="default.asp">New Search 
<img ALIGN="absmiddle" ALT="New Search" SRC="images/new.gif" border="0" WIDTH="12" HEIGHT="14"></a>
</td>
</table>
<br>

<%	CustomerHeading = "Customer Details" %>
<!-- #Include File="CustomerInclude.asp"-->
<br>

<%	if cstr(CustomerId) <> cstr(ObligorId) then 
		CustomerId = ObligorId
		CustomerHeading = "Obligor Details" %>
%&gt;
<!-- #Include File="CustomerInclude.asp"-->
<br>

<%	end if %>

<!-- #Include File="DealStructureInclude.asp" -->
<br>

<%	
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_DealDetails @DealId=" & Dealid)	
%>
<!-- General Deal Details -->
<table class="StandardTable" width="90%" align="center">
<tr id="Header"><td ColSpan="2">Deal Details</td></tr>

<%	if mRs("InputDate") <> #30 dec 1899# then %>
<tr><td id="Bold" nowrap>Input Employee:</td><td><% =mRs("InputEmployee") %></td></tr>
<tr><td id="Bold" nowrap>Input Date:</td><td><% =WebApp.Format(mRs("InputDate"),"dd Mmm yyyy") %></td></tr>
<tr><td Colspan="2"><hr width="90%" size="1" class="StandardTable"></td></tr>
<%	end if %>
<tr><td id="Bold" nowrap>Deal Number:</td><td><% =mRs("DealNumberCP") %></td></tr>
<tr><td id="Bold" nowrap>Legal Entity:</td><td><%  =mRs("LegalEntity") %></td></tr>
<tr><td id="Bold" nowrap>Product:</td><td><% =mRs("Product") %></td></tr>
<tr><td id="Bold" nowrap>Product Variation:</td><td><%  =mRs("ProductVariation") %></td></tr>
<tr><td id="Bold" nowrap>Currency:</td><td><%  =mRs("Currency") %></td></tr>
<tr><td id="Bold" nowrap>Business Day Adjustment:</td><td><%  =mRs("BDayConvention") %></td></tr>
<tr><td id="Bold" nowrap>Calendars:</td><td><%  =mRs("Calendars") %></td></tr>
<tr><td id="Bold" nowrap>Description:</td><td><%  =mRs("DealDescription") %></td></tr>

</table>
<%	mRs.Close %>
<br>

<!-- Level Data -->

<table class="StandardTable" width="90%" align="center">
<tr id="Header"><td ColSpan="2">Deal Level Data and Answers</td></tr>
<%	
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetLevelData " & DealId)
	do until mRs.EOF 
%>
<tr><td id="Bold" nowrap><% =mRs("Type") %></td><td><% =mRs("Value") %></td></tr>
<% mRs.MoveNext 
   loop
   mRs.Close 
%>
<!-- Answers -->
<%   
   set mrs = WebApp.GetRecordset("exec Rabo_WWW_GetAnswers " & DealId)
   do until mRs.EOF 
%>
<tr><td id="Bold" nowrap><% =mRs("Question") %></td><td><% =mRs("Answer") %></td></tr>
<% mRs.MoveNext 
   loop
   mRs.Close 
%>
</table>
<br>

<table Width="90%" align="center">
<td valign="top" width="50%">
<!-- Positions -->
<%
	set CurrencyType = ForecastFacade.GetCurrencyType(dealid)
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetPositions " & DealId)
%>
<table Width="95%" Align="left" Class="StandardTable">
<tr id="Header"><td Colspan="20">Balances</td></tr>
<%	do until mRs.EOF %>	
<tr><td id="Bold" nowrap><% =mRs("PositionTypeDescription") %></td><td align="right"><% =CurrencyType.Format(mRs("PositionValue")) %></td></tr>
<%	mRs.MoveNext 
	loop
	mRs.Close 
%>
</table>
</td>
<td valign="top" align="right">
<!-- Dates -->
<%
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetDates " & DealId)
%>
<table Width="95%" Align="right" Class="StandardTable">
<tr id="Header"><td Colspan="20">Dates</td></tr>
<%	do until mRs.EOF %>	
<tr><td id="Bold" nowrap><% =mRs("Description") %></td><td align="right"><% =WebApp.format(mRs("EffectiveDate"),"d Mmm yyyy") %></td></tr>
<%	mRs.MoveNext 
	loop
	mRs.Close 
%>
</table>
</td>
</table>
<br>

<!-- Schedules -->
<%
	dim NextDate 
	dim NextAmount
	dim IsFee
	
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetCurrentRate " & DealId)
	if not mRs.EOF then 	
		NextDate = ForecastFacade.GetScheduleNextDate("Interest",DealId)
		
		if NextDate = #30 dec 1899# then
			'We haven't found interest schedule, there might be fee compounding schedule 
			NextDate = ForecastFacade.GetScheduleNextDate("Accruing Fee Pay/Compound",DealId)
			IsFee = True
		else
			IsFee = False
		end if
		
		NextAmount = ForecastFacade.GetNextTransaction(mRs("TransactionType"),DealId,cdate(NextDate))	
%>
<table class="StandardTable" width="90%" align="center">
<tr id="Header"><td Colspan="20">Interest</td></tr>
<tr><td id="Bold" nowrap>Interest Rate:</td><td><% =mRs("Percentage") %>%</td></tr>
<tr><td id="Bold" nowrap>Interest Treatment:</td><td><% =mRs("TransactionType") %></td></tr>
<%	if NextDate <> #30 dec 1899# then
		if IsFee then  %>

			<tr><td id="Bold" nowrap>Next Fee Date:</td><td><% =WebApp.Format(NextDate,"dd Mmm yyyy") %></td></tr>
			<tr><td id="Bold" nowrap>Next Fee Amount:</td><td><% =CurrencyType.Format(ccur(NextAmount)) %></td></tr>

<%		Else %>

			<tr><td id="Bold" nowrap>Next Interest Date:</td><td><% =WebApp.Format(NextDate,"dd Mmm yyyy") %></td></tr>
			<tr><td id="Bold" nowrap>Next Interest Amount:</td><td><% =CurrencyType.Format(ccur(NextAmount)) %></td></tr>
<%		end if 
	End if %>
<tr><td id="Bold" nowrap>Rate Basis:</td><td><% =mRs("Divisor") %></td></tr>
</table>
<br>
<%	end if
	mRs.Close %>


<table Width="90%" border="0" background="Transparent" align="center">
	<td valign="top" width="50%">
	<table Border="0" Width="100%">
	<tr>
		<td>
		<!-- Rate History -->
		<%
			set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetRateHistory " & DealId )
			dim count		
			count = 0
		%>
		<table Class="StandardTable" Width="95%" Align="Left">
		<tr Id="Header"><td Colspan="20">Rate History</td></tr>
		<tr id="ColHeader"><td>Start Date</td><td>End Date</td><td align="right">Rate</td></tr>
		<%	
			do until mRs.EOF 
			count = count + 1 
		%>
		<tr <% if count mod 2 = 0 then Response.Write "id=EvenRow" else Response.Write "id=OddRow"%>>
			<td><% 
					if IsNull(mRs("StartDate")) then
						Response.Write "None"
					else 
						Response.Write WebApp.Format(mRs("StartDate"),"dd Mmm yyyy") 
					end if
			%></td>
			<td><% 
					if IsNull(mRs("EndDate")) then 
						Response.Write "None"
					else
						Response.Write  WebApp.Format(mRs("EndDate"),"dd Mmm yyyy") 
					end if
			%></td>
			<td align="right"><% =mRs("Percentage") %>%</td>
		</tr>
		<%	mRs.MoveNext 
			loop
			mRs.Close  
		%>
		</table>
		</td>
	</tr>
	<tr>
		<td valign="top" align="Left">
		<!-- Drawdowns/Initial Deal Amounts -->
		<%
			set mRs = WebApp.GetRecordset("Rabo_WWW_GetDrawDownItems " & DealId)
			count = 0  
		%>	
		<br>
		<table Class="StandardTable" Width="95%" Align="Left">
		<tr id="Header"><td Colspan="20">Initial Deal Amounts</td></tr>
		<tr id="ColHeader"><td>Description</td><td align="Right">Amount</td></tr>
		<%
			do until mRs.EOF 
			count = count + 1
		%>
		<tr <% if count mod 2 = 0 then Response.Write "id=EvenRow" else Response.Write "id=OddRow"%>>
			<td><% =mRs("Description") %></td>
			<td align="right"><% =CurrencyType.Format(ccur(mRs("Amount"))) %></td>
		</tr>
		<%	
			mRs.MoveNext 
			loop 
			mRs.Close 
		%>
		</table>
		</td>
	</tr>
	</table>
	
	</td>
		
	<td valign="top" Rowspan="20">
	<!-- Instalments -->
	<%
		set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetInstalments " & DealId)	
		count = 0
	%>
	<table Class="StandardTable" Width="95%" Align="Right">
	<tr id="Header"><td Colspan="20">Redemption Scheme</td></tr>
	<tr id="ColHeader"><td>Date</td><td align="Right">Amount</td></tr>
	<%	
		do until mRs.EOF 
		count = count + 1
	%>
	<tr <% if count mod 2 = 0 then Response.Write "id=EvenRow" else Response.Write "id=OddRow"%>>
		<td><% =WebApp.Format(mRs("EffectiveDate"),"dd Mmm yyyy") %></td>
		<td align="right"><% =CurrencyType.Format(mRs("Amount")) %></td>
	</tr>
	<%	
		mRs.MoveNext 
		loop
		mRs.Close 
	%>

	</table>
	</td>
</table>

<!-- #Include File="footer.asp" -->
</body>
</html>

<%
	'Cleanup
	on error resume next
	mRs.Close 
	set mRs = nothing
	set WebApp = nothing
	set ForecastFacade = nothing
	set CurrencyType = nothing
%>

