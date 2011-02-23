<%@include file="header.jsp" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Iterator" %>
<%@page import="com.marklabs.brands.Brand" %>
<%@page import="com.marklabs.web.controllers.Constants" %>
<%@page import="com.marklabs.brandAdvertisement.BrandAdvertisement" %>
<%@page import="com.marklabs.perceptualObj.PerceptualObj" %>
<%@page import="com.marklabs.perceptualObj.PerceptualObjectiveScales" %>
<%@page import="com.marklabs.perceptualObj.SemanticScale" %>
<%@page import="com.marklabs.perceptualObj.MDSDimension" %>

<% 
  int currentPeriod = ((Integer) request.getSession().getAttribute(Constants.CURRENT_PERIOD)).intValue();
  int previousPeriod = currentPeriod - 1;
  
  BrandAdvertisement previousPeriodBrandAdv = (BrandAdvertisement) request.getSession().getAttribute(Constants.PREVIOUSPERIOD_BRANDADV);
  BrandAdvertisement thisPeriodBrandAdv = (BrandAdvertisement) request.getSession().getAttribute(Constants.THISPERIOD_BRANDADV);

  boolean doesBrandsExist = false;
  List<Brand> existingBrands = (List<Brand>) request.getAttribute("existingBrands");  

  if (existingBrands != null && existingBrands.size() > 0) {
    doesBrandsExist = true;
  }
  Brand selectedBrand = (Brand) request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV);
  
  PerceptualObj thisBrandPerceptualObj = (PerceptualObj)request.getSession().getAttribute(Constants.BRAND_PERCEPTUALOBJECTIVE);
 
%>
<style>
	#bluebloods, #raffles, #wannabes, #deprived, #strugglers, #print, #television, #radio, #internet {
		float: left;
		clear: left;
		width: 200px;
	}
	#bluebloods .ui-slider-range { background: #729fcf; }
	#bluebloods .ui-slider-handle { border-color: #729fcf; }
	#raffles .ui-slider-range { background: #729fcf; }
	#raffles .ui-slider-handle { border-color: #729fcf; }
	#wannabes .ui-slider-range { background: #729fcf; }
	#wannabes .ui-slider-handle { border-color: #729fcf; }
	#deprived .ui-slider-range { background: #729fcf; }
	#deprived .ui-slider-handle { border-color: #729fcf; }
	#strugglers .ui-slider-range { background: #729fcf; }
	#strugglers .ui-slider-handle { border-color: #729fcf; }
	#print .ui-slider-range { background: #729fcf; }
	#print .ui-slider-handle { border-color: #729fcf; }
	#television .ui-slider-range { background: #729fcf; }
	#television .ui-slider-handle { border-color: #729fcf; }
	#radio .ui-slider-range { background: #729fcf; }
	#radio .ui-slider-handle { border-color: #729fcf; }
	#internet .ui-slider-range { background: #729fcf; }
	#internet .ui-slider-handle { border-color: #729fcf; }
</style>
<script type="text/javascript"> 
$.validator.setDefaults({
	highlight: function(input) {
		$(input).addClass("error");
	},
	unhighlight: function(input) {
		$(input).removeClass("error");
	}
});

$.validator.methods.equal = function(value, element, param) {
	return value == param;
};

$(document).ready(function() {

$("#brandAdvHomeForm").validate({
		rules: {
			advMediaBudget: {
				required: true,
				number: true
			},
			advResearchBudget: {
				required: true,
				number: true
			},
			bluebloods_targetSeg: {
				required: true,
				number: true,
				range: [0,100]
			},
			raffles_targetSeg: {
				required: true,
				number: true,
				range: [0,100]
			},
			wannabes_targetSeg: {
				required: true,
				number: true,
				range: [0,100]
			},
			deprived_targetSeg: {
				required: true,
				number: true,
				range: [0,100]
			},
			strugglers_targetSeg: {
				required: true,
				number: true,
				range: [0,100]
			},
			print_medium: {
				required: true,
				number: true,
				range: [0,100]
			},
			television_medium: {
				required: true,
				number: true,
				range: [0,100]
			},
			radio_medium: {
				required: true,
				number: true,
				range: [0,100]
			},
			internet_medium: {
				required: true,
				number: true,
				range: [0,100]
			},
			targetSegTotal: {
				required: true,
				number: true,
				equal: 100
			},
			targetMedTotal: {
				required: true,
				number: true,
				equal: 100
			},
			semanticScaleDim1Obj: {
				required: function() {
				          return $('#perceptualObj_1:checked').length >0;
					    },
     				number: true,
				range: [1, 7]
			},
			semanticScaleDim2Obj: {
				required: function() {
					    return $('#perceptualObj_1:checked').length >0;
					    },
				number: true,
				range: [1, 7]
			},
			mdsDimen1Obj: {
				required: function() {
					    return $('#perceptualObj_2:checked').length >0;
					    },
				number: true,
				range: [0, 20]
			},
			mdsDimen2Obj: {
				required: function() {
					    return $('#perceptualObj_2:checked').length >0;
					    },
				number: true,
				range: [0, 20]
			}
		},
		messages: {
			targetSegTotal: "Target Segment total should add up to 100%",
			targetMedTotal: "Medium Selection total should add up to 100%"
			}	
	});

});

</script>
<script>
	$(function() {
		$( "#bluebloods").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegBlueBloods():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var p = $( "#amount5" ).val();
				var q = $( "#amount4" ).val();
				var r = $( "#amount3" ).val();
				var s = $( "#amount2" ).val();
				var sum3 = parseFloat(p) + parseFloat(q) + parseFloat(r) + parseFloat(s) + ui.value;
				$( "#amount" ).val( "" + ui.value );
				$( "#targetSegTotal" ).val( sum3 );
			}
		});
		$( "#amount" ).val( "" + $( "#bluebloods" ).slider( "value" ) );	
	});
	$(function() {
		$( "#raffles").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegRaffles():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var p = $( "#amount5" ).val();
				var q = $( "#amount4" ).val();
				var r = $( "#amount3" ).val();
				var s = $( "#amount" ).val();
				var sum3 = parseFloat(p) + parseFloat(q) + parseFloat(r) + parseFloat(s) + ui.value;
				$( "#amount2" ).val( "" + ui.value );
				$( "#targetSegTotal" ).val( sum3 );
			}
		});
		$( "#amount2" ).val( "" + $( "#raffles" ).slider( "value" ) );
	});
	$(function() {
		$( "#wannabes").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegWannabees():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var p = $( "#amount5" ).val();
				var q = $( "#amount4" ).val();
				var r = $( "#amount2" ).val();
				var s = $( "#amount" ).val();
				var sum3 = parseFloat(p) + parseFloat(q) + parseFloat(r) + parseFloat(s) + ui.value;
				$( "#amount3" ).val( "" + ui.value );
				$( "#targetSegTotal" ).val( sum3 );
			}
		});
		$( "#amount3" ).val( "" + $( "#wannabes" ).slider( "value" ) );
	});
	$(function() {
		$( "#deprived").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegDeprived():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var p = $( "#amount5" ).val();
				var q = $( "#amount3" ).val();
				var r = $( "#amount2" ).val();
				var s = $( "#amount" ).val();
				var sum3 = parseFloat(p) + parseFloat(q) + parseFloat(r) + parseFloat(s) + ui.value;
				$( "#amount4" ).val( "" + ui.value );
				$( "#targetSegTotal" ).val( sum3 );
			}
		});
		$( "#amount4" ).val( "" + $( "#deprived" ).slider( "value" ) );
	});
	$(function() {
		$( "#strugglers").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegStrugglers():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var p = $( "#amount4" ).val();
				var q = $( "#amount3" ).val();
				var r = $( "#amount2" ).val();
				var s = $( "#amount" ).val();
				var sum3 = parseFloat(p) + parseFloat(q) + parseFloat(r) + parseFloat(s) + ui.value;
				$( "#amount5" ).val( "" + ui.value );
				$( "#targetSegTotal" ).val( sum3 );
			}
		});
		$( "#amount5" ).val( "" + $( "#strugglers" ).slider( "value" ) );
	});
	$(function() {
		$( "#print").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getMediumPrint():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var b = $( "#amount9" ).val();
				var c = $( "#amount7" ).val();
				var d = $( "#amount8" ).val();
				var sum1 = parseFloat(b) + parseFloat(c) + parseFloat(d) + ui.value;
				$( "#amount6" ).val( "" + ui.value );
				$( "#targetMedTotal" ).val( sum1 );
			}
		});
		$( "#amount6" ).val( "" + $( "#print" ).slider( "value" ) );
	});
	$(function() {
		$( "#television").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getMediumTelevision():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var b = $( "#amount9" ).val();
				var c = $( "#amount8" ).val();
				var d = $( "#amount6" ).val();
				var sum1 = parseFloat(b) + parseFloat(c) + parseFloat(d) + ui.value;
				$( "#amount7" ).val( "" + ui.value );
				$( "#targetMedTotal" ).val( sum1 );

			}
		});
		$( "#amount7" ).val( "" + $( "#television" ).slider( "value" ) );
	});
	$(function() {
		$( "#radio").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getMediumRadio():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var b = $( "#amount9" ).val();
				var c = $( "#amount7" ).val();
				var d = $( "#amount6" ).val();
				var sum1 = parseFloat(b) + parseFloat(c) + parseFloat(d) + ui.value;
				$( "#amount8" ).val( "" + ui.value );
				$( "#targetMedTotal" ).val( sum1 );
			}
		});
		$( "#amount8" ).val( "" + $( "#radio" ).slider( "value" ) );
	});
	$(function() {
		$( "#internet").slider({
			range: "min",
			value: <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getMediumInternet():"")%>,
			min: 0,
			max: 100,
			slide: function( event, ui ) {
				var b = $( "#amount8" ).val();
				var c = $( "#amount7" ).val();
				var d = $( "#amount6" ).val();
				var sum1 = parseFloat(b) + parseFloat(c) + parseFloat(d) + ui.value;
				$( "#amount9" ).val( "" + ui.value );
				$( "#targetMedTotal" ).val( sum1 );
				
			}
		});
		$( "#amount9" ).val( "" + $( "#internet" ).slider( "value" ) );
	});


function SetSliderValue(sliderId, textBoxControl) {
		var amount = textBoxControl.value;
		var minimum = $(sliderId).slider("min")
		var maximum = $(sliderId).slider("max")
		
		if (amount > minimum || amount < maximum){
			$(sliderId).slider('option', 'value', amount);
		}		
	}

</script>
<script type="text/javascript">
  $(document).ready(function(){
  	$("input.cancel").click(function(){
      window.location = "<%=CONTEXTPATH%>/marketingTeam.htm";
  	});

	var a = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegBlueBloods():"")%>;
	var b = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegRaffles():"")%>;
	var c = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegWannabees():"")%>;
	var d = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegDeprived():"")%>;
	var e = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getSegStrugglers():"")%>;
      var totval = a + b + c + d + e;
	$("input.targetSegTotal").val(totval);

	var f = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getMediumPrint():"")%>;
	var g = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getMediumRadio():"")%>;
	var h = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getMediumInternet():"")%>;
	var i = <%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getMediumTelevision():"")%>;
	var totval2 = f + g + h + i;
	$("input.targetMedTotal").val(totval2);

    $("#brandAdvHomeForm").submit(function() {
    
    	//var thisForm = document.brandAdvHomeForm;
    	//var perceptualObjRadioSelectedIndex = thisForm.perceptualObj.selectedIndex;
    	//alert(perceptualObjRadioSelectedIndex);
  		return true;
    });
    $("input.tarSegFld").live("change", function(){ 
      var sum = 0;
      var inp = $("input.tarSegFld");
      
      for ( i = 0; i < inp.length; i++)
        sum = sum + parseInt($(inp[i]).val());
      $("input.targetSegTotal").val(sum);
    });
    $("input.tarMedFld").live("change", function(){ 
      var sum = 0;
      var inp = $("input.tarMedFld");
      
      for ( i = 0; i < inp.length; i++)
        sum = sum + parseInt($(inp[i]).val());
      $("input.targetMedTotal").val(sum);
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
			<div class="block-border"><form class="block-content form" id="brandAdvHomeForm" name="brandAdvHomeForm" method="post" action="brandAdvertisement.htm?do=saveThisPeriodBrandAdv">
				<h1>Brand Advertising</h1>
				
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
						<a href="brandAdvertisement.htm?selectedBrandId=<%=thisBrand.getId()%>"> 
					<span><%= thisBrand.getBrandName() %></span></a></li>					
			<%	
			}
		}
		%>
							</ul>
		
<div class="tabs-content">							
<div id="tab-product1">
<fieldset>
<legend>Brand Advertising</legend>					
					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Brand Advertising</span>
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
					<strong>Advertising Media Budget</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span><p><span class="relative">	
<input type="text" name="ppAdvMBudget" id="ppAdvMBudget" disabled value = "<%= ((previousPeriodBrandAdv != null)?previousPeriodBrandAdv.getAdvMediabudget():"")%>" class="past"><span class="check-past"></span></span></p></div>
					<div class="colx3-right">
						<span class="label"></span>
<input type="text" name="advMediaBudget" id="tpAdvMBudget" value = "<%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getAdvMediabudget():"")%>" />				</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Advertising Research Budget</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span><p><span class="relative">	
<input type="text" name="ppAdvRBudget" id="ppAdvRBudget" disabled value = "<%= ((previousPeriodBrandAdv != null)?previousPeriodBrandAdv.getAdvResearchBudget():"")%>" class="past"><span class="check-past"></span></span></p></div>
					<div class="colx3-right">
						<span class="label"></span>
<input type="text" name="advResearchBudget" id="tpAdvRBudget" value = "<%= ((thisPeriodBrandAdv != null)?thisPeriodBrandAdv.getAdvResearchBudget():"")%>" /></div></div>
</fieldset>

<fieldset>
<legend>Targeted Segments (%)</legend>					
					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Bluebloods</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="bluebloods"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount" name="bluebloods_targetSeg" class="tarSegFld bbSegTotal" onKeyUp="SetSliderValue('#bluebloods', this)">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Raffles</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="raffles"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount2" name="raffles_targetSeg" class="tarSegFld rafflesSegTotal" onKeyUp="SetSliderValue('#raffles', this)">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Wannabes</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="wannabes"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount3" name="wannabes_targetSeg" class="tarSegFld wannabesSegTotal" onKeyUp="SetSliderValue('#wannabes', this)">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Strugglers</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="strugglers"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount5" name="strugglers_targetSeg" class="tarSegFld strSegTotal" onKeyUp="SetSliderValue('#strugglers', this)">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Deprived</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="deprived"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount4" name="deprived_targetSeg" class="tarSegFld depSegTotal" onKeyUp="SetSliderValue('#deprived', this)">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Total</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="targetSegTotal" class="targetSegTotal" name="targetSegTotal" readonly>
					</div>
					</div>
					</fieldset>
<fieldset>
<legend>Medium Selection (%)</legend>					
					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Print</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="print"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount6" name="print_medium" onKeyUp="SetSliderValue('#print', this)" class="tarMedFld printMedTotal">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Television</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="television"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount7" name="television_medium" onKeyUp="SetSliderValue('#television', this)" class="tarMedFld TVMedTotal">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Radio</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="radio"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount8" name="radio_medium" onKeyUp="SetSliderValue('#radio', this)" class="tarMedFld radioMedTotal">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Internet</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span><div id="internet"></div>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="amount9" name="internet_medium" onKeyUp="SetSliderValue('#internet', this)" class="tarMedFld intMedTotal">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label">Total</span>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
					</div>
					<div class="colx3-right">
						<span class="label"></span><input type="text" id="targetMedTotal" class="targetMedTotal" name="targetMedTotal" readonly>
					</div>
					</div>

					</fieldset>
					<fieldset>
					<div class="columns">
        				<div class="colx5-left">
					<span class="label">Perceptual Objectives</span>
					</div>
					<div class="colx5-center1">
						<span class="label">Dimension 1</span>	
					</div>
					<div class="colx5-center2">
						<span class="label">Objective</span>
					</div>
					<div class="colx5-center3">
						<span class="label">Dimension 2</span>	
					</div>
					<div class="colx5-right">
						<span class="label">Objective</span>
					</div>
					</div>

					<div class="columns">
        				<div class="colx5-left">
					<span class="label"></span><input type="radio" name="perceptualObj" value="semanticScales" id ="perceptualObj_1" <% if (thisBrandPerceptualObj != null && thisBrandPerceptualObj.getScale().equalsIgnoreCase(PerceptualObjectiveScales.SEMANTIC_SCALE.getPerceptualObjScale())) {%> checked="true" <%}%>/>Semantic Scales</div>
					<div class="colx5-center1">
						<span class="label"></span>
<select name="semanticScaleDim1" id="semanticScaleDim1">
              <option id="-1" value="-1">--</option>
              <option id="1" value="design" 
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(SemanticScale.DESIGN.getSemanticScale())) {
	          %> selected
	          <%}%>> Design </option>
              <option id="1" value="fragrance"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(SemanticScale.FRAGRANCE.getSemanticScale())) {
	          %> selected
	          <%}%>>Fragrance</option>
              <option id="1" value="persistence"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(SemanticScale.PERSISTENCE.getSemanticScale())) {
	          %> selected
	          <%}%>>Persistence</option>
              <option id="1" value="packaging" 
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(SemanticScale.PACKAGING.getSemanticScale())) {
	          %> selected
	          <%}%>>Packaging</option>
              <option id="1" value="safety"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(SemanticScale.SAFETY.getSemanticScale())) {
	          %> selected
	          <%}%>>Safety</option>
 		  <option id="1" value="price"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(SemanticScale.PRICE.getSemanticScale())) {
	          %> selected
	          <%}%>>Price</option>

            </select>	
					</div>
					<div class="colx5-center2">
						<span class="label"></span><input type="text" name="semanticScaleDim1Obj" id="semanticScaleDim1Obj" value = "<%= ((thisBrandPerceptualObj != null && thisBrandPerceptualObj.getScale().equalsIgnoreCase(PerceptualObjectiveScales.SEMANTIC_SCALE.getPerceptualObjScale()))?thisBrandPerceptualObj.getObjective1():"")%>" size="10"/>
					</div>
					<div class="colx5-center3">
						<span class="label"></span><select name="semanticScaleDim2" id="semanticScaleDim2">
              <option id="-1" value="-1">--</option>
              <option id="1" value="design" 
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(SemanticScale.DESIGN.getSemanticScale())) {
	          %> selected
	          <%}%>> Design </option>
              <option id="1" value="fragrance"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(SemanticScale.FRAGRANCE.getSemanticScale())) {
	          %> selected
	          <%}%>>Fragrance</option>
              <option id="1" value="persistence"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(SemanticScale.PERSISTENCE.getSemanticScale())) {
	          %> selected
	          <%}%>>Persistence</option>
              <option id="1" value="packaging" 
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(SemanticScale.PACKAGING.getSemanticScale())) {
	          %> selected
	          <%}%>>Packaging</option>
              <option id="1" value="safety"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(SemanticScale.SAFETY.getSemanticScale())) {
	          %> selected
	          <%}%>>Safety</option>
	          <option id="1" value="price"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(SemanticScale.PRICE.getSemanticScale())) {
	          %> selected
	          <%}%>>Price</option>
            </select>	
					</div>
					<div class="colx5-right">
						<span class="label"></span><input type="text"  name="semanticScaleDim2Obj" id="semanticScaleDim2Obj" value = "<%= ((thisBrandPerceptualObj != null && thisBrandPerceptualObj.getScale().equalsIgnoreCase(PerceptualObjectiveScales.SEMANTIC_SCALE.getPerceptualObjScale()))?thisBrandPerceptualObj.getObjective2():"")%>" size="10"/>
					</div>
					</div>

	<div class="columns">
        				<div class="colx5-left">
					<span class="label"></span><input type="radio" name="perceptualObj" value="mdsDimension" id="perceptualObj_2" <% if (thisBrandPerceptualObj != null && thisBrandPerceptualObj.getScale().equalsIgnoreCase(PerceptualObjectiveScales.MDS_DIMENSION.getPerceptualObjScale())) {%> checked="true" <%}%>/>MDS Dimensions</div>
					<div class="colx5-center1">
						<span class="label"></span>
<select name="mdsDimen1" id="mdsDimen1">
              <option id="-1" value="-1">--</option>
              <option id="-1" value="Economy"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(MDSDimension.ECONOMY.getMDSDimension())) {
	          %> selected
	          <%}%>>Economy</option>
              <option id="-1" value="Quality"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(MDSDimension.QUALITY.getMDSDimension())) {
	          %> selected
	          <%}%>>Quality</option>
              <option id="-1" value="Appeal"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension1().equalsIgnoreCase(MDSDimension.APPEAL.getMDSDimension())) {
	          %> selected
	          <%}%>>Appeal</option>
            </select>
		</div>
					<div class="colx5-center2">
						<span class="label"></span><input type="text" name="mdsDimen1Obj" id="mdsDimen1Obj" value = "<%= ((thisBrandPerceptualObj != null && thisBrandPerceptualObj.getScale().equalsIgnoreCase(PerceptualObjectiveScales.MDS_DIMENSION.getPerceptualObjScale()))?thisBrandPerceptualObj.getObjective1():"")%>" size="10"/></div>
					<div class="colx5-center3">
						<span class="label"></span<select name="mdsDimen2" id="mdsDimen2">
              <option id="-1" value="-1">--</option>
              <option id="-1" value="Economy"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(MDSDimension.ECONOMY.getMDSDimension())) {
	          %> selected
	          <%}%>>Economy</option>
              <option id="-1" value="Quality"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(MDSDimension.QUALITY.getMDSDimension())) {
	          %> selected
	          <%}%>>Quality</option>
              <option id="-1" value="Appeal"
              <% if (thisBrandPerceptualObj != null && 
          		thisBrandPerceptualObj.getDimension2().equalsIgnoreCase(MDSDimension.APPEAL.getMDSDimension())) {
	          %> selected
	          <%}%>>Appeal</option>
            </select>
		</div>
					<div class="colx5-right">
						<span class="label"></span><input type="text" name="mdsDimen2Obj" id="mdsDimen2Obj" value = "<%= ((thisBrandPerceptualObj != null && thisBrandPerceptualObj.getScale().equalsIgnoreCase(PerceptualObjectiveScales.MDS_DIMENSION.getPerceptualObjScale()))?thisBrandPerceptualObj.getObjective2():"")%>" size="10"/>
					</div>
					</div>

<div class="columns">
        				<div class="colx5-left">
					<span class="label"></span><input type="radio" name="perceptualObj" value="noObjective" id="perceptualObj" 
          <% if (thisBrandPerceptualObj != null) {
          	if (thisBrandPerceptualObj.getScale().equalsIgnoreCase(PerceptualObjectiveScales.NO_OBJECTIVE.getPerceptualObjScale())) {
          		%> checked="true"
          <%}
          } else {
          %> checked="true"
          <%} %> />No Objective
					</div>
					<div class="colx5-center1">
						<span class="label"></span>	
					</div>
					<div class="colx5-center2">
						<span class="label"></span>
					</div>
					<div class="colx5-center3">
						<span class="label"></span>	
					</div>
					<div class="colx5-right">
						<span class="label"></span>
					</div>
					</div>



					</fieldset>
					<div class="columns">
						<button type="submit" class="button save">Save</button>
						<button type="submit" class="button cancel">Cancel</button>
					</div>
	</form>
</div>

<%@ include file="footer.jsp" %>