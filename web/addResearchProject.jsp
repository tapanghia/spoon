<%@ include file="header.jsp" %>
<%@ page import="com.marklabs.web.controllers.Constants"%>
<%@ page import="com.marklabs.researchProject.ResearchProject"%>
<%
  ResearchProject[] previousPeriodProj = (ResearchProject[]) request.getAttribute(Constants.PREVIOUS_PERIOD_RESEARCH_PROJECTS);
  ResearchProject[] allResearchProjForTeam = (ResearchProject[]) request.getAttribute(Constants.ALL_RESEARCH_PROJECTS_FOR_TEAM);
%>
<style>
	#design, #fragrance, #persistence, #packaging, #safety {
		float: left;
		clear: left;
		width: 200px;
	}
	#design .ui-slider-range { background: #729fcf; }
	#design .ui-slider-handle { border-color: #729fcf; }
	#fragrance .ui-slider-range { background: #729fcf; }
	#fragrance .ui-slider-handle { border-color: #729fcf; }
	#persistence .ui-slider-range { background: #729fcf; }
	#persistence .ui-slider-handle { border-color: #729fcf; }
	#packaging .ui-slider-range { background: #729fcf; }
	#packaging .ui-slider-handle { border-color: #729fcf; }
	#safety .ui-slider-range { background: #729fcf; }
	#safety .ui-slider-handle { border-color: #729fcf; }
</style>
<script type="text/javascript">

	var existingResearchProjJSArray = new Array();
	<% if (allResearchProjForTeam != null) {
		for (int i = 0; i< allResearchProjForTeam.length; i++) {%>
			existingResearchProjJSArray[<%=i%>] = "<%=allResearchProjForTeam[i].getProjectName().substring(2).toLowerCase()%>";	
		<%}
	}%>
	
	Array.prototype.contains = function (element) {
		for (var i = 0; i < this.length; i++) {
			if (this[i] == element) {
				return true;
			}
		}
		return false;
	}

$(function(){

  $("#addResearchProjForm").submit(function(){
  	if ($("#projectName").val() != null && !("" == $("#projectName").val())) {
		if ($.inArray($("#projectName").val().toLowerCase(), existingResearchProjJSArray) == -1) {
			return true;
		}
		else {
			alert("No research projects with duplicate names can be added.");
			return false;
		}
    } 
  });

  //todo to be cleaned up.
  $("input.cancel").click(function() {
    window.location = "<%=CONTEXTPATH%>/researchProject.htm";
  });

  //todo to be cleaned up.
  $('#generateMinBaseCost').click(function(event) {
    $.ajax({
       type: "POST",
       url: "researchProject.htm",
       data: "do=calculateMinBaseCost&designValue="+document.addResearchProjForm.design.value+"&fragranceValue="+document.addResearchProjForm.fragrance.value+"&persistenceValue="+document.addResearchProjForm.persistence.value+"&packagingValue="+document.addResearchProjForm.packaging.value+"&safetyValue="+document.addResearchProjForm.safety.value,
       dataType: 'json',  
       success: function(data){
         $("input[name='minBaseCost']").val(data.minBaseCost);
         $("input[name='requestedBaseCost']").val(data.minBaseCost);
         $("input[name='budgetRequired']").val(data.budgetRequired);
         $("input[name='budgetRequiredAtMinBaseCost']").val(data.budgetRequired);
       }
     });
  });

  //todo to be cleaned up.
  $('#generateBudgetReq').click(function(event) {
    $.ajax({
       type: "POST",
       url: "researchProject.htm",
       data: "do=calculateReqBudgetOnReqBaseCost&budgetRequiredAtMinBaseCost="+document.addResearchProjForm.budgetRequiredAtMinBaseCost.value+"&minBaseCost="+document.addResearchProjForm.minBaseCost.value+"&requestedBaseCost="+document.addResearchProjForm.requestedBaseCost.value,
       dataType: 'json',  
       success: function(data){
         $("input[name='budgetRequired']").val(data.budgetRequired);
       }
     });
  });
  
  $("select#previousPerProj").change(function(){
   	  $.ajax({
         type: "POST",
         url: "researchProject.htm",
         data: "do=getResearchProjectSpecs&selectedBaseProjectID="+document.addResearchProjForm.previousPerProj.options[document.addResearchProjForm.previousPerProj.selectedIndex].id,
         dataType: 'json',  
         success: function(data){
           $("input[name='design']").val(data.design);
           $("input[name='fragrance']").val(data.fragrance);
           $("input[name='persistence']").val(data.persistence);
           $("input[name='packaging']").val(data.packaging);
           $("input[name='safety']").val(data.safety);
	     $("#design").slider('option', 'value', data.design);
	     $("#fragrance").slider('option', 'value', data.fragrance);
	     $("#persistence").slider('option', 'value', data.persistence);
	     $("#packaging").slider('option', 'value', data.packaging);
	     $("#safety").slider('option', 'value', data.safety);
         }
       });
    });
  
    //todo to be cleaned up.
    $("#useCompletedProject").click(function(){
      if (document.getElementById('useCompletedProject').checked) {
          document.getElementById('previousPerProj').disabled = false;
      } else { 
          document.getElementById('previousPerProj').disabled = true;
      }
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
	
$("#addResearchProjForm").validate({
		rules: {
			projectName: {
				required: true,
				minlength: 3
			},
			previousPerProj: {
				required: "#useCompletedProject:checked"
			},
			design: {
      			required: true,
      			range: [1, 100]
    			},
			fragrance: {
      			required: true,
      			range: [1, 100]
    			},
			persistence: {
      			required: true,
      			range: [1, 100]
    			},
			packaging: {
      			required: true,
      			range: [1, 100]
    			},
			safety: {
      			required: true,
      			range: [1, 100]
    			},
			minBaseCost: {
      			required: true,
      			number: true
    			},
			requestedBaseCost: {
      			required: true,
      			number: true,
				min: function() {
				          return $('#minBaseCost').val();
					    },
				max: 700
    			},
			budgetRequired: {
      			required: true,
      			number: true
    			}
		}
	});

$('#addResearchProjForm')[0].reset();
document.getElementById('previousPerProj').disabled = true;

});

</script>

<script>
	$(function() {
		$( "#design").slider({
			range: "min",
			value: 50,
			min: 1,
			max: 100,
			slide: function( event, ui ) {
				$( "#amount" ).val( "" + ui.value );
				$( "#minBaseCost" ).val("");
				$( "#requestedBaseCost" ).val("");
				$( "#budgetRequired" ).val("");
			}
		});
		$( "#amount" ).val( "" + $( "#design" ).slider( "value" ) );
	});
	$(function() {
		$( "#fragrance").slider({
			range: "min",
			value: 50,
			min: 1,
			max: 100,
			slide: function( event, ui ) {
				$( "#amount2" ).val( "" + ui.value );
				$( "#minBaseCost" ).val("");
				$( "#requestedBaseCost" ).val("");
				$( "#budgetRequired" ).val("");
			}
		});
		$( "#amount2" ).val( "" + $( "#fragrance" ).slider( "value" ) );
	});
	$(function() {
		$( "#persistence").slider({
			range: "min",
			value: 50,
			min: 1,
			max: 100,
			slide: function( event, ui ) {
				$( "#amount3" ).val( "" + ui.value );
				$( "#minBaseCost" ).val("");
				$( "#requestedBaseCost" ).val("");
				$( "#budgetRequired" ).val("");
			}
		});
		$( "#amount3" ).val( "" + $( "#persistence" ).slider( "value" ) );
	});
	$(function() {
		$( "#packaging").slider({
			range: "min",
			value: 50,
			min: 1,
			max: 100,
			slide: function( event, ui ) {
				$( "#amount4" ).val( "" + ui.value );
				$( "#minBaseCost" ).val("");
				$( "#requestedBaseCost" ).val("");
				$( "#budgetRequired" ).val("");
			}
		});
		$( "#amount4" ).val( "" + $( "#packaging" ).slider( "value" ) );
	});
	$(function() {
		$( "#safety").slider({
			range: "min",
			value: 50,
			min: 1,
			max: 100,
			slide: function( event, ui ) {
				$( "#amount5" ).val( "" + ui.value );
				$( "#minBaseCost" ).val("");
				$( "#requestedBaseCost" ).val("");
				$( "#budgetRequired" ).val("");
			}
		});
		$( "#amount5" ).val( "" + $( "#safety" ).slider( "value" ) );
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
			<div class="block-border"><form class="block-content form" id="addResearchProjForm" name="addResearchProjForm" method="post" 
				action="researchProject.htm?do=saveResearchProject">
				<h1>New Project</h1>

<% if((Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD) == 1)
{
%>
<p class="message warning">Sorry. You cannot add a project in Period 1</p>
</div>
				</div>
				
			</form></div>
		</section>
		
		<div class="clear"></div>
		
	</article>
<%@ include file="footer.jsp" %>
<%
}
else
{
%>
				
				<div class="columns">

	<div>	
							
							<ul class="tabs js-tabs same-height">
								<li class="current"><a href="#tab-project1" title="Product 1">New Project</a></li>
							</ul>
							
							<div class="tabs-content">
								
								<div id="tab-project1">

					<fieldset>
					<legend>Project Spefications</legend>					
					<div class="columns">
        				<div class="colx2-left">
					<span class="label"></span>
					<strong>Project Name</strong>
					</div>
        				<div class="colx2-right">
					<span class="label"></span>
<%
String teamName = null;
String co = null;
teamName = (String)request.getSession().getAttribute(Constants.TEAM_NAME);
co = teamName.substring(0,1);
%>

	    				<strong><%=co%>R</strong><input type="text" name="projectName" id="projectName" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();">
					</div>
					</div>

					<div class="columns">
        				<div class="colx2-left">
					<span class="label"></span>
					<input type="checkbox" name="useCompletedProject" id="useCompletedProject">&nbsp;<strong>Use one of the completed projects displayed as a basis for the new Project.</strong>
					</div>
					<div class="colx2-right">
						<span class="label"></span>
						<select id="previousPerProj" name="previousPerProj" disabled>
          <option id="-1" value="">Please select a value.</option>
          <% 
            if (previousPeriodProj != null && previousPeriodProj.length > 0) {
              for (int i = 0; i < previousPeriodProj.length; i++) {
          %>
          <option id="<%=previousPeriodProj[i].getId()%>" value="<%=previousPeriodProj[i].getId()%>"><%=previousPeriodProj[i].getProjectName() %></option>
          <%    
            }
          }
          %>
        </select>
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Design (1-100)</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<div id="design"></div>
					</div>
					<div class="colx3-right">
						<span class="label"></span>	
						<input type="text" id="amount" name="design" onKeyUp="SetSliderValue('#design', this)" readonly class="past">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Fragrance (1-100)</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<div id="fragrance"></div>
					</div>
					<div class="colx3-right">
						<span class="label"></span>	
						<input type="text" id="amount2" name="fragrance" onKeyUp="SetSliderValue('#fragrance', this)" readonly class="past">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Persistence (1-100)</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<div id="persistence"></div>
					</div>
					<div class="colx3-right">
						<span class="label"></span>	
						<input type="text" id="amount3" name="persistence" onKeyUp="SetSliderValue('#persistence', this)" readonly class="past">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Packaging (1-100)</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<div id="packaging"></div>
					</div>
					<div class="colx3-right">
						<span class="label"></span>	
						<input type="text" id="amount4" name="packaging" onKeyUp="SetSliderValue('#packaging', this)" readonly class="past">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Safety (1-100)</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<div id="safety"></div>
					</div>
					<div class="colx3-right">
						<span class="label"></span>	
						<input type="text" id="amount5" name="safety" onKeyUp="SetSliderValue('#safety', this)" readonly class="past">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Minimum Base Cost</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<input type="text" id="minBaseCost" name="minBaseCost" class="past" readonly>
					</div>
					<div class="colx3-right">
						<span class="label"></span>
						<input name="generateMinBaseCost" id="generateMinBaseCost" type="button" class="button generate" value="Generate" />
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Requested Base Cost</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<input type="text" id="requestedBaseCost" name="requestedBaseCost">
					</div>
					<div class="colx3-right">
						<span class="label"></span>	
            <input name="generateBudgetReq" id="generateBudgetReq" type="button" class="button generate" value="Generate Budget Required"/>
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Budget Required</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<input type="text" id="budgetRequired" name="budgetRequired" readonly class="past">
					</div>
					<div class="colx3-right">
						<span class="label"></span>
					</div>
					</div>

					<div class="columns">
    <input type="hidden" name="budgetRequiredAtMinBaseCost" id="budgetRequiredAtMinBaseCost" readonly maxlength="10" /> 
						<button type="submit" class="red" name="submit">Add Project</button>
					</div>					
				</fieldset>
</div>										
	</div>
					
					</div>
				</div>
				
			</form></div>
		</section>
		
		<div class="clear"></div>
		
	</article>


<%@ include file="footer.jsp" %>
<%
}
%>