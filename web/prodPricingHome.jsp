<%@ include file="header.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.marklabs.brands.Brand"%>
<%@ page import="com.marklabs.web.controllers.Constants" %>
<%@ page import="com.marklabs.brandSpecifications.BrandSpecs" %>
<% 
  int currentPeriod = ((Integer) request.getSession().getAttribute(Constants.CURRENT_PERIOD)).intValue();
  int previousPeriod = currentPeriod - 1;
  
  BrandSpecs previousPeriodBrandSpecs = (BrandSpecs) request.getSession().getAttribute(Constants.PREVIOUSPERIOD_BRANDSPECS);
  BrandSpecs thisPeriodBrandSpecs = (BrandSpecs) request.getSession().getAttribute(Constants.THISPERIOD_BRANDSPECS);
  
  boolean doesBrandsExist = false;
  List<Brand> existingBrands = (List<Brand>) request.getAttribute(Constants.EXISTING_BRANDS); 

  if (existingBrands != null && existingBrands.size() > 0)
    doesBrandsExist = true;
  
  Brand selectedBrand = 
    (Brand) request.getSession().getAttribute(Constants.SELECTED_BRAND);
%>

<script type="text/javascript">
$(document).ready(function(){
  $("#prodPricingForm").submit(function(){
    return true;
  });
  $("#prodPricingForm input.cancel").click(function(){
    window.location = "<%=CONTEXTPATH%>/marketingTeam.htm";
  });
});
</script>
<script type="text/javascript"> 
$.validator.setDefaults({
	highlight: function(input) {
		$(input).addClass("error");
	},
	unhighlight: function(input) {
		$(input).removeClass("error");
	}
});

$(document).ready(function() {
	
$("#prodPricingForm").validate({
		rules: {
			ppBaseRnd: "required",
			tpBaseRnd: "required",
			ppProdLevel: {
				required: true,
				number: true
			},
			thisPeriodBrandProdLevel: {
				required: true,
				number: true,
				range: [0, 10000000]
			},
			ppInventorySold: {
				required: true,
				number: true
			},
			tpInventorySold: {
				required: true,
				number: true
			},
			ppPrice: {
				required: true,
				number: true
			},
			thisPeriodBrandRetailPrice: {
				required: true,
				number: true,
				range: [1, 700]
			}
		}
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
			<div class="block-border"><form class="block-content form" name="prodPricingForm" id="prodPricingForm" method="post" action="productionPricing.htm?do=saveThisPeriodBrandSpecs">
				<h1>Brand Production & Pricing</h1>
				
				<div class="columns">
					<div>	
							
							<ul class="tabs js-tabs same-height">
<% 
		if (doesBrandsExist) {
			Iterator<Brand> itr = existingBrands.iterator();
			while (itr.hasNext()) {
				Brand thisBrand = (Brand)itr.next();
			%>	
				<li <% if (selectedBrand != null && 
						selectedBrand.getId() == thisBrand.getId()) { 
						%>
						class="current" <%}%>> 	
						<a href="productionPricing.htm?selectedBrandId=<%=thisBrand.getId()%>"> 
					<span><%= thisBrand.getBrandName() %></span></a></li>					
			<%	
			}
		}
		%>
							</ul>
							
							<div class="tabs-content">
								
								<div id="tab-product1">

					<fieldset>
					<legend>Product Specifications</legend>					
					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Product Specifications</span>
					</div>
					<div class="colx3-center">
						<span class="label">Period <%=previousPeriod %></span>	
					</div>
					<div class="colx3-right">
						<span class="label">Period <%=currentPeriod %></span>
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Base R&D Project</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span><p><span class="relative">	
<input type="text" name="ppBaseRnd" id="ppBaseRnd" disabled value = "<%= ((previousPeriodBrandSpecs != null)?previousPeriodBrandSpecs.getBrand().getResearchProject().getProjectName():"")%>" class="past"><span class="check-past"></span></span></p>
					</div>
					<div class="colx3-right">
						<span class="label"></span>
<input type="text" name="tpBaseRnd" id="tpBaseRnd" disabled value = "<%= ((thisPeriodBrandSpecs != null)?thisPeriodBrandSpecs.getBrand().getResearchProject().getProjectName():"")%>" class="past">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Brand Production Level</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span><p><span class="relative">	
<input type="text" name="ppProdLevel" id="ppProdLevel" disabled value = "<%= ((previousPeriodBrandSpecs != null)?previousPeriodBrandSpecs.getProductionLevel():"")%>" class="past"><span class="check-past"></span></span></p>
					</div>
					<div class="colx3-right">
						<span class="label"></span>
<input type="text" name="thisPeriodBrandProdLevel" id="tpProdLevel" value = "<%= ((thisPeriodBrandSpecs != null)?thisPeriodBrandSpecs.getProductionLevel():"")%>" />
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Inventory sold to trading co.</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span><p><span class="relative">	
<input type="text" name="ppInventorySold" id="ppInventorySold" disabled value = "<%= ((previousPeriodBrandSpecs != null)?previousPeriodBrandSpecs.getInventorySold():"")%>" class="past"><span class="check-past"></span></span></p>
					</div>
					<div class="colx3-right">
						<span class="label"></span>
<input type="text" name="tpInventorySold" id="tpInventorySold" disabled value = "<%= ((thisPeriodBrandSpecs != null)?thisPeriodBrandSpecs.getInventorySold():"")%>" class="past">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Current Inventory</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span><p><span class="relative">	
<input type="text" name="ppInventory" id="ppInventory" disabled value = "<%= ((previousPeriodBrandSpecs != null)?previousPeriodBrandSpecs.getCurrentInventory():"")%>" class="past"><span class="check-past"></span></span></p>
					</div>
					<div class="colx3-right">
						<span class="label"></span>
<input type="text" name="tpInventory" id="tpInventory" disabled value = "<%= ((thisPeriodBrandSpecs != null)?thisPeriodBrandSpecs.getCurrentInventory():"")%>" class="past">
					</div>
					</div>
					
				</fieldset>

				<fieldset>
					<legend>Pricing</legend>					
					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Pricing</span>
					</div>
					<div class="colx3-center">
						<span class="label">Period <%=previousPeriod %></span>	
					</div>
					<div class="colx3-right">
						<span class="label">Period <%=currentPeriod %></span>
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Recommended Retail Price</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span><p><span class="relative">	
<input type="text" name="ppPrice" id="ppPrice" disabled value = "<%= ((previousPeriodBrandSpecs != null)?previousPeriodBrandSpecs.getRetailPrice():"")%>" class="past"><span class="check-past"></span></span></p>
					</div>
					<div class="colx3-right">
						<span class="label"></span>
<input type="text" name="thisPeriodBrandRetailPrice" id="tpPrice" value = "<%= ((thisPeriodBrandSpecs != null)?thisPeriodBrandSpecs.getRetailPrice():"")%>" />
					</div>
					</div>
					
				</fieldset>
					<div class="columns">
						<button type="submit" class="red" name="submit">Save</button>
					</div>	

								
								</div>										
							</div>
					
					</div>
				</div>
				
			</form></div>
		</section>

			<div class="clear"></div>
		
	</article>


<%@ include file="footer.jsp" %>