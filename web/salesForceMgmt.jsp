<%@ include file="header.jsp" %>
<%@page import="java.lang.Double"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.marklabs.brands.Brand"%>
<%@page import="com.marklabs.web.controllers.Constants"%>
<%@page import="com.marklabs.distributionCoverage.AverageMarginOffered"%>
<%@page import="com.marklabs.distributionCoverage.MarginOffered"%>
<%@page import="com.marklabs.distributionCoverage.SalesForce"%>
<%@page import="com.marklabs.distributionCoverage.SalesForcePercentage"%>
<% 
	AverageMarginOffered averMarginOffered = (AverageMarginOffered) request.getAttribute(Constants.AVERAGE_MARGIN_OFFERED);
	Map<Brand, MarginOffered> marginOfferedForBrands = (Map<Brand, MarginOffered>) request.getAttribute(Constants.MARGIN_OFFERED_FOR_BRANDS);
	Map<Brand, SalesForce> salesForceForBrands = (Map<Brand, SalesForce>) request.getAttribute(Constants.SALESFORCE_FOR_BRANDS);
		
	boolean brandExists = false;
	List<Brand> resultBrands =  (List<Brand>)request.getAttribute(Constants.TO_DISPLAY_BRANDS);
	if (resultBrands != null && resultBrands.size() > 0) {
		brandExists = true;
	}	
	
	// New code
	
	int currentPeriod = ((Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD));
	Map<Brand, SalesForce> salesForceForPreviousPeriodBrandsMap = 
		(Map<Brand, SalesForce>) request.getAttribute(Constants.PREVIOUS_PERIOD_BRAND_SALES_FORCE_MAP);
	List<Brand> previousPeriodBrands = (List<Brand>)request.getAttribute(Constants.PREVIOUS_PERIOD_BRANDS_FOR_SALES_FORCE);
	
	boolean previousPeriodBrandExists = false;
	if (previousPeriodBrands != null && previousPeriodBrands.size() > 0) {
		previousPeriodBrandExists = true;
	}
	
%>

<script type="text/javascript">
$(document).ready(function(){
  $("input.cancel").click(function(){
  	var thisForm = document.salesForceForm;
  	thisForm.action = "<%=CONTEXTPATH%>/salesTeam.htm";
    thisForm.submit();
  });
  $("input.save").click(function(){
    var salesForceIframeForm = document.salesForceForm; 
    var brandMarginOfferedInputData = '';
    var brandSalesEffortInputData = '';
    var count = 0;
    var textInputArray = salesForceIframeForm.getElementsByTagName("input");
    
    for (var i=0; i<textInputArray.length; i++) {
      if (textInputArray[i].type == 'text') {
      
        // Margin Offered for Brands in Super Markets
        if ((textInputArray[i].name).indexOf("SuperMarket_MarginOffered_") != -1) {
          var temp = (textInputArray[i].name).lastIndexOf("_"); 
          var brandId = (textInputArray[i].name).substring(temp+1, (textInputArray[i].name).length);
          brandMarginOfferedInputData = 
          brandMarginOfferedInputData + brandId + '_' + 'SuperMarketMarginOffered' + '_' + textInputArray[i].value + ';;';  
        }
          
        // Margin Offered for Brands in General Stores
        if ((textInputArray[i].name).indexOf("GeneralStore_MarginOffered_") != -1) {
          var temp = (textInputArray[i].name).lastIndexOf("_");
          var brandId = (textInputArray[i].name).substring(temp+1, (textInputArray[i].name).length);
        
          brandMarginOfferedInputData = 
          brandMarginOfferedInputData + brandId + '_' + 'GeneralStoreMarginOffered' + '_' + textInputArray[i].value + ';;';
        }
          
        // Margin Offered for Brands in Kirana Stores
        if ((textInputArray[i].name).indexOf("KiranaStore_MarginOffered_") != -1) {
          var temp = (textInputArray[i].name).lastIndexOf("_");
          var brandId = (textInputArray[i].name).substring(temp+1, (textInputArray[i].name).length);
          brandMarginOfferedInputData = 
          brandMarginOfferedInputData + brandId + '_' + 'KiranaStoreMarginOffered' + '_' + textInputArray[i].value + ';;';  
        }
          
        //Sales Force for Brands in Super Market
        if ((textInputArray[i].name).indexOf("SuperMarket_SalesForce_") != -1) {
          var temp = (textInputArray[i].name).lastIndexOf("_"); 
          var brandId = (textInputArray[i].name).substring(temp+1, (textInputArray[i].name).length);
          var superMarketSalesForceValue = textInputArray[i].value;
          brandSalesEffortInputData = 
	          brandSalesEffortInputData + brandId + '_' + 'SuperMarketSalesForce' + '_' + superMarketSalesForceValue + ';;';  
        }
        
        // Sales Force for Brands in General Stores
        if ((textInputArray[i].name).indexOf("GeneralStore_SalesForce_") != -1) {
          var temp = (textInputArray[i].name).lastIndexOf("_");
          var brandId = (textInputArray[i].name).substring(temp+1, (textInputArray[i].name).length);
          var genStoreSalesForceValue = textInputArray[i].value;
          brandSalesEffortInputData = 
            brandSalesEffortInputData + brandId + '_' + 'GeneralStoreSalesForce' + '_' + genStoreSalesForceValue + ';;';
        }
        
        // Sales Force for Brands in Kirana Stores
        if ((textInputArray[i].name).indexOf("KiranaStore_SalesForce_") != -1) {
          var temp = (textInputArray[i].name).lastIndexOf("_");
          var brandId = (textInputArray[i].name).substring(temp+1, (textInputArray[i].name).length);
          var kiranaStoreSalesForceValue = textInputArray[i].value;
          brandSalesEffortInputData = 
	          brandSalesEffortInputData + brandId + '_' + 'KiranaStoreSalesForce' + '_' + kiranaStoreSalesForceValue + ';;';
        }
      }
    }
      
    var thisForm = document.salesForceForm;
    thisForm.brandMarginOfferedInputData.value = brandMarginOfferedInputData.substring(0, brandMarginOfferedInputData.length - 2);
    thisForm.brandSalesEffortInputData.value = brandSalesEffortInputData.substring(0, brandSalesEffortInputData.length - 2);
    thisForm.todo.value = 'saveSalesMgmtData';
      
    thisForm.action = "<%=CONTEXTPATH%>/salesTeam.htm?do=getSalesForceMgmt";

	//lets do some validation.

	    thisForm.submit();
  });

$("input.generate").click(function(){
var a = 0;
var b = 0;
var c = 0;
var d = 0;
var costTotal = 0;
var totalSuperMarketSF = 0;
var totalGeneralStoreSF = 0;
var totalKiranaStoreSF = 0;

<%
Iterator<Brand> itr3 = resultBrands.iterator();
			      while(itr3.hasNext()){
					  Brand thisBrand = itr3.next(); 
					  SalesForce salesForcePerct = salesForceForBrands.get(thisBrand);
			 %>
	a = $("#SuperMarket_SalesForce_<%=thisBrand.getId() %>").val();
	b = $("#GeneralStore_SalesForce_<%=thisBrand.getId() %>").val();
	c = $("#KiranaStore_SalesForce_<%=thisBrand.getId() %>").val();

	var temp = 1.9999994;
	alert(Math.round(temp));
	alert(parseInt(a)+parseInt(b)+parseInt(c));
	alert(1+0.05*<%=((Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD))%>);
	alert(20000*(1+0.05*<%=((Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD))%>));
	alert((parseInt(a)+parseInt(b)+parseInt(c))*20000*(1+0.05*<%=((Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD))%>));

	d = Math.round(parseFloat((parseInt(a)+parseInt(b)+parseInt(c))*20000*(1+0.05*<%=((Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD))%>)));
	alert(d);
	$("#costSalesForce_<%=thisBrand.getId() %>").val(d);

	costTotal = costTotal + parseInt(d);
	totalSuperMarketSF = totalSuperMarketSF + parseInt(a);
	totalGeneralStoreSF = totalGeneralStoreSF + parseInt(b)
	totalKiranaStoreSF = totalKiranaStoreSF + parseInt(c);
	
 <% } %>

	$("#superMarketTotal").val(totalSuperMarketSF);
	$("#genStoreTotal").val(totalGeneralStoreSF);
	$("#kirStoreTotal").val(totalKiranaStoreSF);
	$("#costTotal").val(costTotal);


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
	
$("#salesForceForm").validate({
		rules: {
<%
Iterator<Map.Entry<Brand, MarginOffered>> brandMarginItr2 = marginOfferedForBrands.entrySet().iterator();
            		while (brandMarginItr2.hasNext()) {
						Map.Entry<Brand, MarginOffered> entry = (Map.Entry<Brand,MarginOffered>) brandMarginItr2.next();
						
						Brand thisBrand = entry.getKey();
						MarginOffered thisBrandMarginOffered = entry.getValue();
%>			
				SuperMarket_MarginOffered_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
				range: [0, 100]
    			},
				GeneralStore_MarginOffered_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
				range: [0, 100]
    			},
				KiranaStore_MarginOffered_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
				range: [0, 100]
    			},
<% }
				Iterator<Brand> itr2 = resultBrands.iterator();
			      while(itr2.hasNext()){
					  Brand thisBrand = itr2.next(); 
%>
				SuperMarket_SalesForce_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
    			},
				GeneralStore_SalesForce_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
    			},
				KiranaStore_SalesForce_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
    			},    			
<% }%>

				costTotal: {
      			number: true
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
			<div class="block-border"><form class="block-content form" name="salesForceForm" id="salesForceForm" method="post">
				<h1>Sales Force Management & Margin Offered</h1>
    <input type="hidden" name="brandMarginOfferedInputData" id="brandMarginOfferedInputData"/>
    <input type="hidden" name="brandSalesEffortInputData" id = "brandSalesEffortInputData"/>
    <input type="hidden" name="todo" id="todo"/>

					<fieldset>
					<legend>Margin Offered</legend>				
					<div class="columns">
        				<div class="colx5-left">
					<span class="label"></span>
					</div>
					<div class="colx5-center1">
						<span class="label">Super Markets</span>	
					</div>
					<div class="colx5-center2">
						<span class="label">General Stores</span>
					</div>
					<div class="colx5-center3">
						<span class="label">Kirana Stores</span>
					</div>
					<div class="colx5-right">
						<span class="label"></span>
					</div>
					</div>

					<div class="columns">
        				<div class="colx5-left">
					<span class="label">Average Margin Offered (%)</span>
					</div>
					<div class="colx5-center1">
						<span class="label"></span><input type="text" maxlength="3" name="aveMarginOffered_sm" id="aveMarginOffered_sm" disabled value="<%= ((averMarginOffered != null)?averMarginOffered.getSupermarket_amo():"")%>" size="10" class="past">	
					</div>
					<div class="colx5-center2">
						<span class="label"></span><input type="text" maxlength="3" name="aveMarginOffered_gs" id="aveMarginOffered_gs" disabled value = "<%= ((averMarginOffered != null)?averMarginOffered.getGeneralStore_amo():"")%>" size="10" class="past"> 

					</div>
					<div class="colx5-center3">
						<span class="label"></span><input type="text" maxlength="3" name="aveMarginOffered_ks" id="aveMarginOffered_ks" disabled value = "<%= ((averMarginOffered != null)?averMarginOffered.getKiranaStore_amo():"")%>" size="10" class="past">

					</div>
					<div class="colx5-right">
						<span class="label"></span>
					</div>
					</div>
<%
				  if(brandExists){
				  	 Iterator<Brand> itr = resultBrands.iterator();
			      	 while(itr.hasNext()){
					 	Brand thisBrand = itr.next();
					 	MarginOffered thisBrandMarginOffered = marginOfferedForBrands.get(thisBrand);
					 
						%>
					<div class="columns">
					<div class="colx5-left">
					<span class="label">Margin Offered for <b><%=thisBrand.getBrandName() %> (%)</b></span>
					</div>
					<div class="colx5-center1">
						<span class="label"></span>
						<input type="text" maxlength="3" name="SuperMarket_MarginOffered_<%=thisBrand.getId() %>" 
							id="SuperMarket_MarginOffered_<%=thisBrand.getId() %>" 
							value = "<%= ((thisBrandMarginOffered != null)?thisBrandMarginOffered.getSupermarket_mo():"")%>" size="10">
					</div>
					<div class="colx5-center2">
						<span class="label"></span>
						<input type="text" maxlength="3" name="GeneralStore_MarginOffered_<%=thisBrand.getId() %>" 
							id="GeneralStore_MarginOffered_<%=thisBrand.getId() %>" 
							value = "<%= ((thisBrandMarginOffered != null)?thisBrandMarginOffered.getGeneralStore_mo():"")%>" size="10"> 

					</div>
					<div class="colx5-center3">
						<span class="label"></span>
						<input type="text" maxlength="3" name="KiranaStore_MarginOffered_<%=thisBrand.getId() %>" 
							id="KiranaStore_MarginOffered_<%=thisBrand.getId() %>" 
							value = "<%= ((thisBrandMarginOffered != null)?thisBrandMarginOffered.getKiranaStore_mo():"")%>" size="10"> 

					</div>
					<div class="colx5-right">
						<span class="label"></span>
					</div>
					</div>
				<% 					}
				} else { 
				%>
No Brands Exist
	 <% } %>
</fieldset>
<fieldset>
					<legend>Sales Force Management</legend>				
					<div class="columns">
	        			<div class="colx5-left">
							<span class="label"></span>
						</div>
						<div class="colx5-center1">
							<span class="label">Super Markets</span>	
						</div>
						<div class="colx5-center2">
							<span class="label">General Stores</span>
						</div>
						<div class="colx5-center3">
							<span class="label">Kirana Stores</span>
						</div>
						<div class="colx5-right">
							<span class="label">Sales Force Costs</span>
						</div>
					</div>

					<%
					if (currentPeriod > 0 && previousPeriodBrandExists) {
						//	Header for displaying Previous period brand Sales Force
					%>	
						<div class="columns">
		        			<div class="colx5-left">
								<span class="label">Period <%= (currentPeriod -1) %></span>
							</div>
							<div class="colx5-center1">
							</div>
							<div class="colx5-center2">
							</div>
							<div class="colx5-center3">
							</div>
							<div class="colx5-right">
							</div>
						</div>
			 		<% 	
						Iterator<Brand> itr = previousPeriodBrands.iterator();
						while(itr.hasNext()){
							Brand previousPeriodBrand = itr.next(); 
							SalesForce salesForcePreviousPeriod = salesForceForPreviousPeriodBrandsMap.get(previousPeriodBrand);
							
							long totalSalesForceForThisBrand = 
								new Double(((salesForcePreviousPeriod != null)?salesForcePreviousPeriod.getSupermarket_sf():0) +
								((salesForcePreviousPeriod != null)?salesForcePreviousPeriod.getGeneralStore_sf():0) +
								((salesForcePreviousPeriod != null)?salesForcePreviousPeriod.getKiranaStore_sf():0)).longValue();
					%>
							<div class="columns">
								<div class="colx5-left">
								<span class="label">Sales Force for <b><%=previousPeriodBrand.getBrandName() %></b></span>
								</div>
								<div class="colx5-center1">
									<span class="label"></span>
									<input type="text" maxlength="3" disabled class="past"
										name="SuperMarket_SalesForce_PreviousPeriod_<%=previousPeriodBrand.getId() %>" 
										id="SuperMarket_SalesForce_PreviousPeriod_<%=previousPeriodBrand.getId() %>" 
										value = "<%= ((salesForcePreviousPeriod != null)?new Double(salesForcePreviousPeriod.getSupermarket_sf()).longValue():"")%>" size="10"> 
								</div>
								<div class="colx5-center2">
									<span class="label"></span>
									<input type="text" maxlength="3" disabled class="past"
										name="GeneralStore_SalesForce_PreviousPeriod_<%=previousPeriodBrand.getId() %>" 
										id="GeneralStore_SalesForce_PreviousPeriod_<%=previousPeriodBrand.getId() %>" 
										value = "<%= ((salesForcePreviousPeriod != null)?new Double(salesForcePreviousPeriod.getGeneralStore_sf()).longValue():"")%>" size="10">  
			
								</div>
								<div class="colx5-center3">
									<span class="label"></span>
									<input type="text" maxlength="3" disabled class="past"
										name="KiranaStore_SalesForce_PreviousPeriod_<%=previousPeriodBrand.getId() %>" 
										id="KiranaStore_SalesForce_PreviousPeriod_<%=previousPeriodBrand.getId() %>" 
										value = "<%= ((salesForcePreviousPeriod != null)?new Double(salesForcePreviousPeriod.getKiranaStore_sf()).longValue():"")%>" size="10">  
			
								</div>
								<div class="colx5-right">
									<span class="label"></span>
									<input type="text" maxlength="3" disabled class="past" 
										name="costSalesForce_PreviousPeriod_<%=previousPeriodBrand.getId() %>" 
										id="costSalesForce_PreviousPeriod_<%=previousPeriodBrand.getId() %>" 
										value = <%=  (totalSalesForceForThisBrand)*20000*(1+0.05* (((Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD)) - 1))%> 
										disabled class="past" size="10"/>
								</div>
							</div>
					<%									
						}
					}	

				  if(brandExists){
					  
					%>  
				<div class="columns">
	        			<div class="colx5-left">
							<span class="label">Period <%= currentPeriod %></span>
						</div>
						<div class="colx5-center1">
						</div>
						<div class="colx5-center2">
						</div>
						<div class="colx5-center3">
						</div>
						<div class="colx5-right">
							<span class="label"></span>
							<input type="button" class="button generate" value="Generate">
						</div>
					</div>	  
					  
			<%	  
            Iterator<Brand> itr = resultBrands.iterator();
			      while(itr.hasNext()){
					  Brand thisBrand = itr.next(); 
					  SalesForce salesForceThisPeriodBrand = salesForceForBrands.get(thisBrand);
			 %>
					<div class="columns">
					<div class="colx5-left">
					<span class="label">Sales Force for <b><%=thisBrand.getBrandName() %></b></span>
					</div>
					<div class="colx5-center1">
						<span class="label"></span>
						<input type="text" maxlength="3" name="SuperMarket_SalesForce_<%=thisBrand.getId() %>" 
							id="SuperMarket_SalesForce_<%=thisBrand.getId() %>" 
							value = "<%= ((salesForceThisPeriodBrand != null)?new Double(salesForceThisPeriodBrand.getSupermarket_sf()).longValue():"")%>" size="10"> 
					</div>
					<div class="colx5-center2">
						<span class="label"></span>
						<input type="text" maxlength="3" name="GeneralStore_SalesForce_<%=thisBrand.getId() %>" 
							id="GeneralStore_SalesForce_<%=thisBrand.getId() %>" 
							value = "<%= ((salesForceThisPeriodBrand != null)?new Double(salesForceThisPeriodBrand.getGeneralStore_sf()).longValue():"")%>" size="10">  

					</div>
					<div class="colx5-center3">
						<span class="label"></span>
						<input type="text" maxlength="3" name="KiranaStore_SalesForce_<%=thisBrand.getId() %>" 
							id="KiranaStore_SalesForce_<%=thisBrand.getId() %>" 
							value = "<%= ((salesForceThisPeriodBrand != null)?new Double(salesForceThisPeriodBrand.getKiranaStore_sf()).longValue():"")%>" size="10">  
					</div>
					<div class="colx5-right">
						<span class="label"></span>
						<input type="text" maxlength="3" class="past" name="costSalesForce_<%=thisBrand.getId() %>" 
							id="costSalesForce_<%=thisBrand.getId() %>" disabled size="10"/>
					</div>
					</div>
			<% }
			} else { %>
		 No Brands Exist.
   			<% } %>

<div class="columns">
        				<div class="colx5-left">
					<span class="label">Total Sales Force</span>
					</div>
					<div class="colx5-center1">
						<span class="label"></span>
						<input type="text" maxlength="3" name="superMarketTotal" id="superMarketTotal" size="10" disabled class="past">
					</div>
					<div class="colx5-center2">
						<span class="label"></span>
						<input type="text" maxlength="3" name="genStoreTotal" id="genStoreTotal" size="10" disabled class="past">
					</div>
					<div class="colx5-center3">
						<span class="label"></span>
						<input type="text" maxlength="3" name="kirStoreTotal" id="kirStoreTotal" size="10" disabled class="past">
					</div>
					<div class="colx5-right">
						<span class="label"></span>
						<input type="text" maxlength="3" size="10" name="costTotal" id="costTotal" disabled class="past">
					</div>
					</div>
				</fieldset>
<div calss="columns">
	<input type="button" class="button save" value="Save">
  	<input type="button" class="button cancel" value="Cancel">
</div>				
			</div>										
		</div>
			</form></div>
		</section>

			<div class="clear"></div>
		
	</article>

<%@ include file="footer.jsp" %>