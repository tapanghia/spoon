<%@ include file="header.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="com.marklabs.web.controllers.Constants"%>

<%
	List<String> reportParametersList = (List<String>)session.getAttribute(Constants.REPORT_PARAMETER_LIST);
	long teamId = Long.parseLong((String)session.getAttribute(Constants.TEAM_ID));
	int currentPeriod = (Integer)session.getAttribute(Constants.CURRENT_PERIOD);
	String reportName = request.getParameter("reportName");
	String teamName = (String)session.getAttribute(Constants.TEAM_NAME);
%>

<script type="text/javascript">
function runReport() {
	var elements = document.getElementById('rndReportForm').elements;
	var parameterList='?';
	if(elements!=null && elements.length>0){
		for(var i = 0; i < elements.length; i++){
				if(elements[i].name =='period'){
			    var selectedLOV = document.getElementById(elements[i].name);
			    var parameterName = elements[i].name;
					if (parameterList == '?')
						parameterList = parameterList + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
					else
				    	parameterList = parameterList + "&" + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
				}
				if(elements[i].name =='teamName'){
			    var selectedInputText = document.getElementById(elements[i].name);
			    var parameterName = elements[i].name;
					if (parameterList == '?')
						parameterList = parameterList + parameterName + "=" + selectedInputText.value;
					else
				    	parameterList = parameterList + "&" + parameterName + "=" + selectedInputText.value;
				}
				if(elements[i].name =='mdsMapX'){
			    var selectedLOV = document.getElementById(elements[i].name);
			    var parameterName = elements[i].name;
					if (parameterList == '?')
						parameterList = parameterList + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
					else
				    	parameterList = parameterList + "&" + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
				}
				if(elements[i].name =='mdsMapY'){
			    var selectedLOV = document.getElementById(elements[i].name);
			    var parameterName = elements[i].name;
					if (parameterList == '?')
						parameterList = parameterList + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
					else
				    	parameterList = parameterList + "&" + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
				}
				if(elements[i].name =='semanticMapX'){
			    var selectedLOV = document.getElementById(elements[i].name);
			    var parameterName = elements[i].name;
					if (parameterList == '?')
						parameterList = parameterList + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
					else
				    	parameterList = parameterList + "&" + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
				}
				if(elements[i].name =='semanticMapY'){
			    var selectedLOV = document.getElementById(elements[i].name);
			    var parameterName = elements[i].name;
					if (parameterList == '?')
						parameterList = parameterList + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
					else
				    	parameterList = parameterList + "&" + parameterName + "=" + selectedLOV.options[selectedLOV.selectedIndex].id;
				}
		}
	}
	document.getElementById("reportsFrame").src="reportsViewer.htm" +parameterList+ "&reportName=<%=reportName%>&URLVer=" + new Date().getTime();
}
</script>

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
			<div class="block-border"><div class="block-content">
				<h1>View Report</h1>

  <form class="editform report" id="rndReportForm" name="rndReportForm" method="post">
		<div class="report">
			<% if (reportParametersList != null && reportParametersList.size() > 0) { %>
					<%if(reportParametersList.contains("period")){ %>
					<label>Period:</label>
					<select id="period" name="period">
						<% for (int i = (currentPeriod - 1); i >= 0; i-- ){%>
							<option id="<%=i %>" value="<%=i %>" <%if (i == currentPeriod) { %>selected="selected" <%} %>><%=i %></option>
						<%}%>
					</select>
					<%}%>
					<%if(reportParametersList.contains("teamName")){ %>
					<!--label>Team:</label-->
					<input type="hidden" name="teamName" id="teamName" value="<%=teamName%>">
					<%}%>
					<%if(reportParametersList.contains("mdsMapX")){ %>
					<label>MDS X-Axis:</label>
					<select id="mdsMapX" name="mdsMapX">
						<option id="economy" value="economy" selected="selected">Economy</option>
						<option id="quality" value="quality">Quality</option>
						<option id="appeal" value="appeal">Appeal</option>
					</select>
					<%}%>
					<%if(reportParametersList.contains("mdsMapY")){ %>
					<label>MDS Y-Axis</label>
					<select id="mdsMapY" name="mdsMapY">
						<option id="economy" value="economy" >Economy</option>
						<option id="quality" value="quality" selected="selected">Quality</option>
						<option id="appeal" value="appeal">Appeal</option>
					</select>
					<%}%>
					<%if(reportParametersList.contains("semanticMapX")){ %>
					<label>Semantic X-Axis:</label>
					<select id="semanticMapX" name="semanticMapX">
						<option id="design" value="design" selected="selected">Design</option>
						<option id="fragrance" value="fragrance" >Fragrance</option>
						<option id="persistence" value="persistence">Persistence</option>
						<option id="packaging" value="packaging" >Packaging</option>
						<option id="safety" value="safety">Safety</option>
						<option id="price" value="price">Price</option>
					</select>
					<%}%>
					<%if(reportParametersList.contains("semanticMapY")){ %>
					<label>Semantic Y-Axis</label>
					<select id="semanticMapY" name="semanticMapY">
						<option id="design" value="design">Design</option>
						<option id="fragrance" value="fragrance" selected="selected">Fragrance</option>
						<option id="persistence" value="persistence">Persistence</option>
						<option id="packaging" value="packaging" >Packaging</option>
						<option id="safety" value="safety">Safety</option>
						<option id="price" value="price">Price</option>
					</select>
					<%}%>
					<input type="button" class="button generate" value="Generate" onClick="runReport()" /></td>
			<%} else {%> 
  			<div>Please choose a report from the Report Menu.</div>
			<%}%>
			<iframe id="reportsFrame" src='blank.html'
				name="reportsFrame" height="950" width="100%" frameborder="0" scrolling="auto" 
				style="background-color:#fcfcf8;"></iframe>
		</div>
  </form>
</div></div></section>
<div class="clear"></div>
		
	</article>
	
	<!-- End content -->

<%@ include file="footer.jsp" %>