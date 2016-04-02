
<html  data-ng-app="creditPlusApp" >
<head>
    <link href="style.css" rel="stylesheet" />
    <base href="/" target="_blank">
<title>Customer Detail</title>
</head>
<body data-ng-cloak >


    <table Class="PageHeader">
        <tr>
            <td>Customer Detail Sheet</td>
            <td>
                <a HREF="default.asp">New Search 
                <img  ALT="New Search" SRC="images/new.gif" border="0" WIDTH="12" HEIGHT="14"></a>
            </td>
        </tr>
    </table>
<br>

<!--"CustomerInclude.asp" -->
    <table class='StandardTable' data-ng-controller="customerController" >
        <TR class='Header'><TD ColSpan=20>Customer Details</TD></TR>
        <TR><TD>Customer Number:</TD><TD><A HREF="CustomerDetail.asp?CustomerId={{Customer.id}}">{{Customer.customerNumber}}</A></TD></TR>
        <TR><TD>Customer Name:</TD><TD>{{Customer.customerName}}</TD></TR>
        <TR><TD Colspan=20></TD></TR>
    </table>

<br>


<table Class="StandardTable">
<tr id="Header"><td Colspan="20">Deal Summary</td></tr>
<tr id="ColHeader"><td>Deal Number</td><td>Product</td><td>Product Variation</td><td>Deal Structure</td><td >Principal/Notional</td></tr>



</table>
<br>



<!--"footer.asp" -->
</body>
</html>

<script src="/Scripts/angular.js"></script>
<script src="/Scripts/angular-resource.js"></script>
<script src="/Scripts/app/app.module.js"></script>
<script src="/Scripts/app/customer.service.js"></script>
<script src="/Scripts/app/customer.controller.js"></script>

