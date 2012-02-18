<%@ include file="header.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.marklabs.brands.Brand"%>
<%
  List<Brand> resultBrands =  (List<Brand>)request.getAttribute("toDisplayBrands");
%>

<script type="text/javascript">
$(document).ready(function(){
  $("input.save").click(function(){
  	var numOfBrands = <%=resultBrands.size()%>;
  	
  	if (numOfBrands < 3) {
	    var winParam = window.open('brandManagement.htm?do=addNewBrand','searchBrand',
	      'width=400,height=250,top=50,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
	    if (winParam != "")
	      winParam.focus ();
    }  
    else {
    	alert("No new brand can be created as you have already created 3 brands. ");
    }
  });
  $("input.edit").click(function(){
    var selectedBrandId;
    var isBrandChecked = false;
    var brandDisplayIframeForm = document.getElementById( "brandManagementForm" );
    //alert(brandDisplayIframeForm.selectBrand.length);
    for (var i =0; i< brandDisplayIframeForm.selectBrand.length; i++) {
      if (brandDisplayIframeForm.selectBrand[i].checked) {
        isBrandChecked = true;
        selectedBrandId = brandDisplayIframeForm.selectBrand[i].value;
      }
    }
    if (!(isBrandChecked)) {
      alert("Please select a brand to edit.");
    } else {
      var winParam = window.open('brandManagement.htm?do=editBrand&selectedBrandId='+ selectedBrandId,'searchBrand',
      'width=400,height=250,top=50,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
      if (winParam != "")
      winParam.focus ();
    }
  });
  $("input.delete").click(function(){
    var confirmMessage = "Deleting a brand, will delete all the data (Production and Pricing, Advertisement etc..) for this brand accross the application.";
    var isBrandChecked = false;
    var selectedBrandId;
    
    var brandDisplayIframeForm = document.getElementById( "brandManagementForm" );
    for (var i =0; i< brandDisplayIframeForm.selectBrand.length; i++) {
      if (brandDisplayIframeForm.selectBrand[i].checked) {
        isBrandChecked = true;
        selectedBrandId = brandDisplayIframeForm.selectBrand[i].value;
      }
    }
    if (isBrandChecked && window.confirm(confirmMessage)) {
        var thisForm = document.brandManagementForm;
        thisForm.brandToDelete.value = selectedBrandId;
        thisForm.action = "<%=CONTEXTPATH%>/brandManagement.htm?do=deleteBrandConfirmed";
        thisForm.submit();
    } else {
      alert("Please select a brand to delete.");
    }
  });
  $("input.cancel").click(function(){
    window.location = "<%=CONTEXTPATH%>/marketingTeam.htm";
  });
});

function addNewBrandFromPopUp(selectedBrandName, selectedResearchProjId) {
	var thisForm = document.brandManagementForm;
	thisForm.hiddenSelectedBrand.value = selectedBrandName;
	thisForm.hiddenSelectedProject.value = selectedResearchProjId;
	thisForm.todo.value = 'addBrand';
	
	thisForm.action = "<%=CONTEXTPATH%>/brandManagement.htm?do=saveOrUpdateBrand";
	thisForm.submit();
}

function updateBrandFromPopUp(selectedBrandId, selectedBrandName, selectedResearchProjId) {
	var thisForm = document.brandManagementForm;
	thisForm.hiddenSelectedBrand.value = selectedBrandId;
	thisForm.hiddenSelectedProject.value = selectedResearchProjId;
	thisForm.todo.value = 'updateBrand';
	
	thisForm.action = "<%=CONTEXTPATH%>/brandManagement.htm?do=saveOrUpdateBrand";
	thisForm.submit();
}
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
							<li><a href="reports.htm?reportName=DecisionSummary">Decision Summary</a></li>
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
							<li><a href="reports.htm?reportName=ShoppingHabitsReport">Shopping Habits</a></li>
							<li><a href="reports.htm?reportName=DistributionCoverageReport">Distribution Coverage</a></li>
							<li><a href="reports.htm?reportName=DistributionMarketShareReport">Distribution Market Share</a></li>
							<li><a href="reports.htm?reportName=InventoryManagement">Inventory Management</a></li>
							<li><a href="reports.htm?reportName=CompetitiveAdvExpenseReport">Competitive Advertising Expense</a></li>
							<li><a href="reports.htm?reportName=CompetitiveSalesForceReport">Competitive Sales Force</a></li>
							<li><a href="reports.htm?reportName=CompetitiveMarginReport">Competitive Margin</a></li>
							<li><a href="reports.htm?reportName=ExpertAdviceReport">Expert Advice</a></li>
						</ul>
					</li>
				</ul>
				
			</div></div>

		</section>

		
		<section class="grid_9">
			<div class="block-border"><form class="block-content form" name="brandManagementForm" id="brandManagementForm" method="post">
				<h1>Brand Portfolio</h1>
    <input type="hidden" name="hiddenSelectedBrand" id="hiddenSelectedBrand"/>
    <input type="hidden" name="hiddenSelectedProject" id="hiddenSelectedProject"/>
    <input type="hidden" name="todo" id="todo">
    <input type="hidden" name="brandToDelete" id="brandToDelete">

<!-- Add the class 'table' -->
<table class="table" cellspacing="0" width="100%">
 
    <thead>
        <tr>
             
            <th scope="col">Marketed Brand</th>
            <th scope="col">Status</th>
            <th scope="col">R&D Project</th>
            <th scope="col" class="table-actions">Actions</th>
        </tr>
    </thead>
 
    <tfoot>
        <tr>
            <td colspan="4"><input type="button" class="button save" value="Add Product"/>
    <input type="button" class="button edit" value="Edit Product"/>
    <input type="button" class="button delete" value="Delete Product"/>
    <input type="button" class="button cancel" value="Cancel"/></td>
        </tr>
    </tfoot>
     
    <tbody>
       <% for (Brand thisBrand : resultBrands) { %>
       <tr>
        <td><%= thisBrand.getBrandName() %></td>
        <td><%= thisBrand.getStatus() %></td>
        <td><%= thisBrand.getResearchProject().getProjectName() %></td>
        <td class="table-actions"><input type="radio" value="<%=thisBrand.getId()%>" name="selectBrand" id="<%=thisBrand.getId() %>"></td>
      </tr>
      <% } %>
    </tbody>
 
</table>

</form></div>
		</section>
		
		<div class="clear"></div>
		
	</article>
<%@ include file="footer.jsp" %>