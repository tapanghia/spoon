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
	
	Map<Brand, SalesForcePercentage> brandSalesForcePercentageMap = 
		(Map<Brand, SalesForcePercentage>)request.getAttribute(Constants.BRAND_SALESFORCE_PERCENTAGE_MAP); 

	long totalSuperMarketSalesForce = (Long) request.getAttribute(Constants.TOTAL_SUPERMARKET_SALESFORCE);
	long totalGenStoreSalesForce = (Long) request.getAttribute(Constants.TOTAL_GENSTORE_SALESFORCE);
	long totalKiranaStoreSalesForce = (Long) request.getAttribute(Constants.TOTAL_KIRANASTORESALESFORCE);
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
          var superMarketTotalSalesForce = salesForceIframeForm.SuperMarket_TotalSalesForce.value;
          var superMarketSalesForceValue = (textInputArray[i].value/100) * superMarketTotalSalesForce;
          brandSalesEffortInputData = 
          brandSalesEffortInputData + brandId + '_' + 'SuperMarketSalesForce' + '_' + superMarketSalesForceValue + ';;';  
        }
        
        // Sales Force for Brands in General Stores
        if ((textInputArray[i].name).indexOf("GeneralStore_SalesForce_") != -1) {
          var temp = (textInputArray[i].name).lastIndexOf("_");
          var brandId = (textInputArray[i].name).substring(temp+1, (textInputArray[i].name).length);
          var generalStoreTotalSalesForce = salesForceIframeForm.GeneralStore_TotalSalesForce.value;
        
          var genStoreSalesForceValue = (textInputArray[i].value/100) * generalStoreTotalSalesForce;
  
          brandSalesEffortInputData = 
            brandSalesEffortInputData + brandId + '_' + 'GeneralStoreSalesForce' + '_' + genStoreSalesForceValue + ';;';
        }
        
        // Sales Force for Brands in Kirana Stores
        if ((textInputArray[i].name).indexOf("KiranaStore_SalesForce_") != -1) {
          var temp = (textInputArray[i].name).lastIndexOf("_");
          var brandId = (textInputArray[i].name).substring(temp+1, (textInputArray[i].name).length);
          var kiranaStoreTotalSalesForce = salesForceIframeForm.KiranaStore_TotalSalesForce.value;
          var kiranaStoreSalesForceValue = (textInputArray[i].value/100) * kiranaStoreTotalSalesForce;
    
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

var sum1 = 0;
var sum2 = 0;
var sum3 = 0;
var sum4 = 0;
var a = 0;
var b = 0;
var c = 0;
var d = 0;


<%
Iterator<Brand> itr3 = resultBrands.iterator();
			      while(itr3.hasNext()){
					  Brand thisBrand = itr3.next(); 
					  SalesForcePercentage salesForcePerct = brandSalesForcePercentageMap.get(thisBrand);
			 %>

	a = $("#SuperMarket_SalesForce_<%=thisBrand.getId() %>").val();
	b = $("#GeneralStore_SalesForce_<%=thisBrand.getId() %>").val();
	c = $("#KiranaStore_SalesForce_<%=thisBrand.getId() %>").val();

	var e = $("#SuperMarket_TotalSalesForce").val();
	var f = $("#GeneralStore_TotalSalesForce").val();
	var g = $("#KiranaStore_TotalSalesForce").val();

	d = ((parseFloat(a) / 100)*parseInt(e)+(parseFloat(b) / 100)*parseInt(f)+(parseFloat(c) / 100)*parseInt(g))*20000*(1+0.05*<%=request.getSession().getAttribute(Constants.CURRENT_PERIOD)%>);


      sum1 = sum1 + parseFloat(a);
      sum2 = sum2 + parseFloat(b);
      sum3 = sum3 + parseFloat(c);
      sum4 = sum4 + parseFloat(d);

	$("#costSalesForce_<%=thisBrand.getId() %>").val(d);

<% } %>
	$("#superMarketTotal").val(sum1);
	$("#genStoreTotal").val(sum2);
	$("#kirStoreTotal").val(sum3);
	$("#costTotal").val(sum4);


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
					  SalesForcePercentage salesForcePerct = brandSalesForcePercentageMap.get(thisBrand);
%>
				SuperMarket_SalesForce_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
				range: [0, 100]
    			},
				GeneralStore_SalesForce_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
				range: [0, 100]
    			},
				KiranaStore_SalesForce_<%=thisBrand.getId() %>: {
      			required: true,
      			number: true,
				range: [0, 100]
    			},
<% } %>

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
							<li><a href="reports.htm?reportName=CompetitiveAdvExpenseReport">Competitive Advertising Expense</a></li>
							<li><a href="reports.htm?reportName=ShoppingHabitsReport">Shopping Habits</a></li>
							<li><a href="reports.htm?reportName=DistributionCoverageReport">Distribution Coverage</a></li>
							<li><a href="reports.htm?reportName=DistributionMarketShareReport">Distribution Market Share</a></li>
							<li><a href="reports.htm?reportName=CompetitiveSalesForceReport">Competitive Sales Force</a></li>
							<li><a href="reports.htm?reportName=CompetitiveMarginReport">Competitive Margin</a></li>
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
						<span class="label"></span><input type="text" maxlength="3" name="SuperMarket_MarginOffered_<%=thisBrand.getId() %>" id="SuperMarket_MarginOffered_<%=thisBrand.getId() %>" value = "<%= ((thisBrandMarginOffered != null)?thisBrandMarginOffered.getSupermarket_mo():"")%>" size="10">
					</div>
					<div class="colx5-center2">
						<span class="label"></span><input type="text" maxlength="3" name="GeneralStore_MarginOffered_<%=thisBrand.getId() %>" id="GeneralStore_MarginOffered_<%=thisBrand.getId() %>" value = "<%= ((thisBrandMarginOffered != null)?thisBrandMarginOffered.getGeneralStore_mo():"")%>" size="10"> 

					</div>
					<div class="colx5-center3">
						<span class="label"></span><input type="text" maxlength="3" name="KiranaStore_MarginOffered_<%=thisBrand.getId() %>" id="KiranaStore_MarginOffered_<%=thisBrand.getId() %>" value = "<%= ((thisBrandMarginOffered != null)?thisBrandMarginOffered.getKiranaStore_mo():"")%>" size="10"> 

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

<div class="columns">
        				<div class="colx5-left">
					<span class="label">Number of Sales People</span>
					</div>
					<div class="colx5-center1">
						<span class="label"></span><input type="text" maxlength="3" name="SuperMarket_TotalSalesForce" id="SuperMarket_TotalSalesForce" value="<%=totalSuperMarketSalesForce%>" size="10"/>	
					</div>
					<div class="colx5-center2">
						<span class="label"></span><input type="text" maxlength="3" name="GeneralStore_TotalSalesForce" id="GeneralStore_TotalSalesForce" value="<%=totalGenStoreSalesForce%>" size="10"/> 

					</div>
					<div class="colx5-center3">
						<span class="label"></span><input type="text" maxlength="3" name="KiranaStore_TotalSalesForce" id="KiranaStore_TotalSalesForce" value="<%=totalKiranaStoreSalesForce%>" size="10"/></div>
					<div class="colx5-right">
						<span class="label"></span><input type="button" class="button generate" value="Generate" onClick="javascript:saveSalesForceInput();">
					</div>
					</div>
<% 
				  if(brandExists){
            Iterator<Brand> itr = resultBrands.iterator();
			      while(itr.hasNext()){
					  Brand thisBrand = itr.next(); 
					  SalesForcePercentage salesForcePerct = brandSalesForcePercentageMap.get(thisBrand);
			 %>
<div class="columns">
<div class="colx5-left">
					<span class="label">% of Effort <b><%=thisBrand.getBrandName() %></b></span>
					</div>
					<div class="colx5-center1">
						<span class="label"></span><input type="text" maxlength="3" name="SuperMarket_SalesForce_<%=thisBrand.getId() %>" id="SuperMarket_SalesForce_<%=thisBrand.getId() %>" value = "<%= ((salesForcePerct != null)?salesForcePerct.getSuperMarketPercentage():"")%>" size="10"> 
					</div>
					<div class="colx5-center2">
						<span class="label"></span><input type="text" maxlength="3" name="GeneralStore_SalesForce_<%=thisBrand.getId() %>" id="GeneralStore_SalesForce_<%=thisBrand.getId() %>" value = "<%= ((salesForcePerct != null)?salesForcePerct.getGenStorePercentage():"")%>" size="10">  

					</div>
					<div class="colx5-center3">
						<span class="label"></span><input type="text" maxlength="3" name="KiranaStore_SalesForce_<%=thisBrand.getId() %>" id="KiranaStore_SalesForce_<%=thisBrand.getId() %>" value = "<%= ((salesForcePerct != null)?salesForcePerct.getKiranaStorePercentage():"")%>" size="10">  

					</div>
					<div class="colx5-right">
						<span class="label"></span><input type="text" maxlength="3" class="past" name="costSalesForce_<%=thisBrand.getId() %>" id="costSalesForce_<%=thisBrand.getId() %>" disabled size="10"/>
					</div>
					</div>
			<% }
			} else { %>
		 No Brands Exist.
   			<% } %>

<div class="columns">
        				<div class="colx5-left">
					<span class="label">Total</span>
					</div>
					<div class="colx5-center1">
						<span class="label"></span><input type="text" maxlength="3" name="superMarketTotal" id="superMarketTotal" size="10" disabled class="past">
					</div>
					<div class="colx5-center2">
						<span class="label"></span><input type="text" maxlength="3" name="genStoreTotal" id="genStoreTotal" size="10" disabled class="past">
					</div>
					<div class="colx5-center3">
						<span class="label"></span><input type="text" maxlength="3" name="kirStoreTotal" id="kirStoreTotal" size="10" disabled class="past"></div>
					<div class="colx5-right">
						<span class="label"></span><input type="text" maxlength="3" size="10" name="costTotal" id="costTotal" disabled class="past">
					</div>
					</div>
				</fieldset>
<div calss="columns">
	<input type="button" class="button save" value="Save" onClick="javascript:saveSalesForceInput();">
  	<input type="button" class="button cancel" value="Cancel" onClick="javascript:cancelSalesForceInput();">
</div>				
			</div>										
		</div>
			</form></div>
		</section>

			<div class="clear"></div>
		
	</article>

<%@ include file="footer.jsp" %>