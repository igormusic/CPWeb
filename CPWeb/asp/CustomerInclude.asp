
<%
'Need to have:
'	mRs as ADODB.Recordset
'	CustomerHeading as string
'	CustomerId as string

	set mRs = WebApp.GetRecordset("exec Rabo_WWW_CustomerDetail " & CustomerId)
%>

<TABLE Class=StandardTable Width=90% align=center>
<TR id=Header><TD ColSpan=20><% =CustomerHeading %></TD></TR>
<TR><TD id=Bold nowrap>Customer Number:</TD><TD><A HREF="CustomerDetail.asp?CustomerId=<% =mRs("Id") %>"><% =mrs("CustomerNumber") %></A></TD></TR>
<TR><TD id=Bold nowrap>Customer Name:</TD><TD><% =mrs("CustomerName") %></TD></TR>
<TR><TD Colspan=20><HR width=90% size=1 class=StandardTable></TD></TR>
<%
	mRs.Close 
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetContacts " & CustomerId)
	do until mRs.EOF 
%>
<TR><TD id=Bold nowrap><% =mRs("Type") %></TD><TD><% =mRs("Value") %></TD></TR>
<%		mRs.MoveNext 
	loop 
	mRs.Close
	
	private function CreateAddress(aRs) 
		dim Tmp
		
		if trim(aRs("Addressline1")) <> "" then Tmp = Tmp & aRs("Addressline1")
		if trim(aRs("Addressline2")) <> "" then Tmp = Tmp & "<br>" & vbCrLf & aRs("Addressline2")
		if trim(aRs("Addressline3")) <> "" then Tmp = Tmp & "<br>" & vbCrLf & aRs("Addressline3")
		if trim(aRs("Addressline4")) <> "" then Tmp = Tmp & "<br>" & vbCrLf & aRs("Addressline4")
		if trim(aRs("PostCode_SA")) <> "" then Tmp = Tmp & "<br>" & vbCrLf & aRs("PostCode_SA")
		
		CreateAddress = Tmp
	end function 
	
	
	set mrs = WebApp.GetRecordset("exec Rabo_WWW_GetAddress " & CustomerId)	
	do until mRs.EOF 
%>
<TR><TD id=Bold valign=top nowrap><% =mRs("Description") %></TD><TD><% =CreateAddress(mRs) %></TD></TR>
<%	mRs.MoveNext 
	loop
	
	mRs.Close 
%>
<TR><TD ColSpan=20><HR width=90% size=1 class=StandardTable></TD></TR>
<%
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetLevelData " & CustomerId)
	do until mRs.EOF 
%>
<TR><TD id=Bold valign=top nowrap><% =mRs("Type") %></TD><TD><% =mRs("Value") %></TD></TR>
<%		mRs.MoveNext 
	loop 
	
	mRs.Close 

	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetAnswers " & CustomerId)
	do until mRs.EOF 
%>
<TR><TD id=Bold valign=top nowrap><% =mRs("Question") %></TD><TD><% =mRs("Answer") %></TD></TR>
<%	mRs.MoveNext 
	loop 
	mRs.Close 
%>
</TABLE>
