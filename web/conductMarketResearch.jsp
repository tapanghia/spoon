<%@ include file="header.jsp" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.marklabs.brands.Brand"%>
<%@page import="com.marklabs.web.controllers.Constants"%>
<%@page import="com.marklabs.web.controllers.DeleteFlag"%>
<%@page import="com.marklabs.marketResearchStudies.ReportTeamPurchaseMap"%>
<%
	List<ReportTeamPurchaseMap> reportTeamPurchaseList = 
		(List<ReportTeamPurchaseMap>)request.getAttribute(Constants.REPORT_TEAM_PURCHASE_MAP_LISTING);
%>
<script type="text/javascript">
$(document).ready(function(){
  $("input.save").click(function(){
    var marketResearchIframeForm = document.marketResearchForm;
    var thisForm = document.marketResearchForm;
    thisForm.action = "<%=CONTEXTPATH%>/intelligenceTeam.htm?do=conductMarketResearch";
    
    var selectedReportIds = ''; 
    var unSelectedReportIds = '';
    if (marketResearchIframeForm.isReportSelected.length != undefined) {
	    for (var i =0; i< marketResearchIframeForm.isReportSelected.length; i++) {
	      if (marketResearchIframeForm.isReportSelected[i].checked) {
	        selectedReportIds = selectedReportIds + marketResearchIframeForm.isReportSelected[i].value + ',';
	      } else {
	        unSelectedReportIds = unSelectedReportIds + marketResearchIframeForm.isReportSelected[i].value + ',';
	      }
	    }
    }
    else {
    	// Checkbox length is undefined, means the number of checkboxes in this page is only 1
    	if (marketResearchIframeForm.isReportSelected.checked) {
    		selectedReportIds = selectedReportIds + marketResearchIframeForm.isReportSelected.value + ',';
    	} else {
    		unSelectedReportIds = unSelectedReportIds + marketResearchIframeForm.isReportSelected.value + ',';
    	}
     }
 
    thisForm.checkedReportIds.value = selectedReportIds;
    thisForm.unCheckedReportIds.value = unSelectedReportIds;
    thisForm.submit();
  });
  $("input.cancel").click(function(){
  	var thisForm = document.marketResearchForm;
  	thisForm.action = "<%=CONTEXTPATH%>/intelligenceTeam.htm";
    thisForm.submit();
  });

var sum = 0;
var inp = document.getElementsByName("isReportSelected");
for (var i = 0; i < inp.length; i++)
{
if (inp[i].checked) { sum  += parseFloat(inp[i].alt); }
}

$( "#totcost" ).val(sum);


$("#isReportSelected").live("change", function(){
var sum = 0;
var inp = document.getElementsByName("isReportSelected");
for (var i = 0; i < inp.length; i++)
{
if (inp[i].checked) { sum  += parseFloat(inp[i].alt); }
}

$( "#totcost" ).val(sum);

});
});
</script>

<!-- Content -->
	<article class="container_12">
		
		<section class="grid_3">
			<div class="block-border"><div class="block-content">
				<h1>Reports</h1>				
				<ul class="collapsible-list with-bg">
					<li>
						<b class="toggle"></b>
						<span>Company Performance</span>
						<ul class="with-icon icon-report">
							<li><a href="reports.htm?reportName=TeamResult">Team Performance</a></li>
							<li><a href="reports.htm?reportName=BrandResult">Brand Performance</a></li>
							<li><a href="reports.htm?reportName=StockMarketReport">Stock market</a></li>
							<li><a href="reports.htm?reportName=RnDReport">R&D Report</a></li>
						</ul>
					</li>
					<li>
						<b class="toggle"></b>
						<span>Intelligence Reports</span>
						<ul class="with-icon icon-report">
							<li><a href="reports.htm?reportName=Benchmarking">Benchmarking</a></li>
							<li><a href="reports.htm?reportName=BrandCharacteristicReport">Brand Characteristics</a></li>
							<li><a href="reports.htm?reportName=BrandAwarenessReport">Brand Awareness</a></li>
							<li><a href="reports.htm?reportName=BrandPurchaseIntentionReport">Brand Purchase Intention</a></li>
							<li><a href="reports.htm?reportName=MarketShareReport">Market Share</a></li>
							<li><a href="reports.htm?reportName=SemanticScaleReport">Semantic Scale</a></li>
							<li><a href="reports.htm?reportName=MultiDimensionalScaleReport">Multi Dimensional Scale</a></li>
							<li><a href="reports.htm?reportName=GrowthMatrixReport">Growth Matrix</a></li>
							<li><a href="reports.htm?reportName=DemandForecastReport">Demand Forecast</a></li>
							<li><a href="reports.htm?reportName=CompetitiveAdvExpenseReport">Competitive Advertising Expense</a></li>
							<li><a href="reports.htm?reportName=ShoppingHabitsReport">Shopping Habits</a></li>
							<li><a href="reports.htm?reportName=DistributionCoverageReport">Distribution Coverage</a></li>
							<li><a href="reports.htm?reportName=DistributionMarketShareReport">Distribution Market Share</a></li>
							<li><a href="reports.htm?reportName=CompetitiveSalesForceReport">Competitive Sales Force</a></li>
							<li><a href="reports.htm?reportName=CompetitiveMarginReport">Competitive Margin</a></li>
							<li><a href="reports.htm?reportName=ExpertAdviceReport">Expert Advice</a></li>
						</ul>
					</li>
				</ul>
				
			</div></div>

		</section>

		
		<section class="grid_9">
			<div class="block-border"><form class="block-content form" name="marketResearchForm" id="marketResearchForm" method="post">
				<h1>Market Research Studies</h1>
    <input type="hidden" name="checkedReportIds" id="checkedReportIds"/>
    <input type="hidden" name="unCheckedReportIds" id="unCheckedReportIds"/>
<table class="table" cellspacing="0" width="100%">
 
    <thead>
        <tr>
            <th scope="col" width="5%">&nbsp;</th>
            <th scope="col" width="50%">Study Titles</th>
            <th scope="col" width="20%">Cost</th>
            <th scope="col" width="25%">Buy</th>
        </tr>
    </thead>
		
    <tfoot>
        <tr>
            <td colspan="4"><input type="button" class="button save" value="Save"/>
    <input type="button" class="button cancel" value="Cancel"/></td>
        </tr>
    </tfoot>
    <tbody>
			<% int count = 0;
				 if (reportTeamPurchaseList != null && reportTeamPurchaseList.size() > 0) {
            Iterator<ReportTeamPurchaseMap> reportTeamPurchaseListItr = reportTeamPurchaseList.iterator();
            while (reportTeamPurchaseListItr.hasNext()) {
							ReportTeamPurchaseMap reportTeamPurchaseMap = (ReportTeamPurchaseMap) reportTeamPurchaseListItr.next();
					%>
		  <tr align="left" valign="middle">
        <td>
        	<img src="<%=COMMONIMAGES%>/icons/fugue/chart.png">
        </td>
        <td> 
        	<%=reportTeamPurchaseMap.getReport().getReportName()%>
      	</td>
        <td> 
         	<%=reportTeamPurchaseMap.getReport().getReportCost()%>
				</td>
		    <td>
		    	 <input type="checkbox" name="isReportSelected" id="isReportSelected" 
		    	 	value="<%=reportTeamPurchaseMap.getReport().getId()%>"
			    	 <% if ((reportTeamPurchaseMap.getAccessFlag()).equalsIgnoreCase(DeleteFlag.DELETEFLAG_YES.getDeletFlag())) {%>
			    	 checked="checked" <%}%> alt="<%=reportTeamPurchaseMap.getReport().getReportCost()%>">
	    	</td>
			</tr>
			<% count++; 
			  } 
			} else { %>
			<tr class="error">
	  			<td>No Reports Exist. Please contact the administrator.</td>
	    </tr>
		 <% } %>
<tr>
<td colspan="3">Total Cost</td> 
<td><input type="text" name="totcost" id="totcost" size="" readonly class="past"></td>
</tr>

    </tbody>
	</table>
    </form></div>
		</section>
		
		<div class="clear"></div>
		
	</article>
<%@ include file="footer.jsp" %>