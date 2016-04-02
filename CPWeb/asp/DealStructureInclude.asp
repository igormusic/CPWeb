
<%
'Need to have:
'	mRs as ADODB.Recordset
'	DealStructureId as String
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_DealStructureDetails " & DealStructureId)
%>
<TABLE Class=StandardTable Width=90% Align=Center>
<TR id=Header><TD Colspan=20>Deal Structure Details</TD></TR>
<TR><TD id=Bold>Number:</TD><TD><A HREF="DealStructureDetail.asp?DealStructureId=<% =mRs("Id") %>"><% =mRs("StructureNumber") %></A></TD></TR>
<TR><TD id=Bold>Name:</TD><TD><% =mRs("Description") %></TD></TR>
<TR><TD id=Bold>Type:</TD><TD><% =mRs("DealStructureType") %></TD></TR>
<TR><TD Colspan=20><HR width=90% size=1 class=StandardTable></TD></TR>
<%	mRs.Close 
	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetLevelData " & DealStructureId)
	do until mRs.EOF %>
<TR><TD id=Bold><% =mRs("Type") %></TD><TD><% =mRs("Value") %></TD></TR>
<%	mRs.MoveNext 
	loop
	mRs.Close 

	set mRs = WebApp.GetRecordset("exec Rabo_WWW_GetAnswers " & DealStructureId)
	do until mRs.EOF %>
<TR><TD id=Bold><% =mRs("Question") %></TD><TD><% =mRs("Answer") %></TD></TR>
<%	mRs.MoveNext 
	loop
	mRs.Close 
%>
</TABLE>