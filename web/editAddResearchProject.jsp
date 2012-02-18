<%@ include file="header.jsp" %>
<%@ page import="com.marklabs.web.controllers.Constants"%>
<%@ page import="com.marklabs.researchProject.ResearchProject"%>
<%
  boolean doesProjectExist = false;
  ResearchProject []existingResearchProjects = 
    (ResearchProject[])request.getAttribute(Constants.EXISTING_RESEARCH_PROJECTS);

  if (existingResearchProjects != null && existingResearchProjects.length > 0)
    doesProjectExist = true;
  
  ResearchProject selectedProject = 
    (ResearchProject) request.getSession().getAttribute(Constants.SELECTED_RESEARCH_PROJECT);
    
  ResearchProject thisResearchProject = 
    (ResearchProject) request.getSession().getAttribute(Constants.SELECTED_RESEARCH_PROJECT);
    
  long design = 0, fragrance = 0, persistence = 0, packaging = 0, safety = 0, minBaseCost = 0,
    reqBaseCost = 0, requiredBudgetAtMinBaseCost = 0, requiredBudgetAtReqBaseCost = 0;
    
  if(thisResearchProject != null) {
    design = thisResearchProject.getDesign();
    fragrance = thisResearchProject.getFragrance();
    persistence = thisResearchProject.getPersistence();
    packaging = thisResearchProject.getPackaging();
    safety = thisResearchProject.getSafety();
    minBaseCost = thisResearchProject.getMinimumBaseCost();
    reqBaseCost = thisResearchProject.getRequestedBaseCost();
    requiredBudgetAtMinBaseCost = thisResearchProject.getRequiredBudgetAtMinBC();
    requiredBudgetAtReqBaseCost = thisResearchProject.getRequiredBudgetAtReqBC();
  }
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
$(document).ready(function(){
  $("input.cancel").click(function(){
  	window.location = "<%=CONTEXTPATH%>/researchProject.htm";
  });
  
  $("input.delete").click(function(){
    var editProjIframeForm = document.getElementById( "editAddResearchProjForm" );
    var researchProjectId = editProjIframeForm.selectResearchProjId.value;
    editProjIframeForm.action = 
    	"<%=CONTEXTPATH%>/researchProject.htm?do=deleteResearchProject&deletedResearchProjectId="+researchProjectId;
    editProjIframeForm.submit();
  });
  
  $("input.update").click(function(){
    
    //todo to be cleaned up.
    var editProjIframeForm = document.getElementById( "editAddResearchProjForm" );
    var researchProjectId = editProjIframeForm.selectResearchProjId.value;
    editProjIframeForm.action = 
    	"<%=CONTEXTPATH%>/researchProject.htm?do=updateResearchProject&updatedResearchProjectId="+researchProjectId;
    
    //if valid submit the form.
      editProjIframeForm.submit();
  });
  
  $('#generateMinBaseCost').click(function(event) {
    $.ajax({
       type: "POST",
       url: "researchProject.htm",
       data: "do=calculateMinBaseCost&designValue="+document.editAddResearchProjForm.design.value+"&fragranceValue="+document.editAddResearchProjForm.fragrance.value+"&persistenceValue="+document.editAddResearchProjForm.persistence.value+"&packagingValue="+document.editAddResearchProjForm.packaging.value+"&safetyValue="+document.editAddResearchProjForm.safety.value,
       dataType: 'json',  
       success: function(data){
         $("input[name='minBaseCost']").val(data.minBaseCost);
         $("input[name='requestedBaseCost']").val(data.minBaseCost);
         $("input[name='budgetRequired']").val(data.budgetRequired);
         $("input[name='budgetRequiredAtMinBaseCost']").val(data.budgetRequired);
       }
     });
  });
  
  $('#generateBudgetReq').click(function(event) {
    $.ajax({
       type: "POST",
       url: "researchProject.htm",
       data: "do=calculateReqBudgetOnReqBaseCost&budgetRequiredAtMinBaseCost="+document.editAddResearchProjForm.budgetRequiredAtMinBaseCost.value+"&minBaseCost="+document.editAddResearchProjForm.minBaseCost.value+"&requestedBaseCost="+document.editAddResearchProjForm.requestedBaseCost.value,
       dataType: 'json',  
       success: function(data){
         $("input[name='budgetRequired']").val(data.budgetRequired);
       }
     });
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
      			number: true
    			},
			budgetRequired: {
      			required: true,
      			number: true
    			}
		}
	});

});

</script>

<script>
	$(function() {
		$( "#design").slider({
			range: "min",
			value: <%=design %>,
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
			value: <%=fragrance %>,
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
			value: <%=persistence %>,
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
			value: <%=packaging %>,
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
			value: <%=safety %>,
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
<div class="block-border"><form class="block-content form" name="editAddResearchProjForm" id="editAddResearchProjForm" method="post">
				<h1>Edit/Delete Project</h1>
				
				<div class="columns">
				<div>		
				<ul class="tabs js-tabs same-height">
			<% if (doesProjectExist) {
				for (int i = 0; i < existingResearchProjects.length; i++ ) {
			%>
				   <li <% if (selectedProject != null && selectedProject.getId() == existingResearchProjects[i].getId()) { %> class="current" <%}%>
						<a href="researchProject.htm?do=getResearchProjectsForTeam&selectedProjectId=<%=existingResearchProjects[i].getId()%>" title="<%= existingResearchProjects[i].getProjectName() %>"><span><%= existingResearchProjects[i].getProjectName() %></span></a>
				</li>
			<% }
			} %>
							</ul>

<div class="tabs-content">
								<div id="tab-project1">

<fieldset>
					<legend>Project Spefications</legend>					
					
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
						<input type="text" id="amount" name="design" value="<%=design %>" onKeyUp="SetSliderValue('#design', this)">
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
						<input type="text" id="amount2" name="fragrance" value="<%=fragrance %>" onKeyUp="SetSliderValue('#fragrance', this)">
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
						<input type="text" id="amount3" name="persistence" value="<%=persistence %>" onKeyUp="SetSliderValue('#persistence', this)">
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
						<input type="text" id="amount4" name="packaging" value="<%=packaging %>" onKeyUp="SetSliderValue('#packaging', this)">
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
						<input type="text" id="amount5" name="safety" value="<%=safety %>" onKeyUp="SetSliderValue('#safety', this)">
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Minimum Base Cost</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<input type="text" id="minBaseCost" name="minBaseCost" value="<%=minBaseCost %>">
					</div>
					<div class="colx3-right">
						<span class="label"></span><input name="generateMinBaseCost" id="generateMinBaseCost" type="button" class="button generate" value="Generate" />
					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Requested Base Cost</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<input type="text" id="requestedBaseCost" name="requestedBaseCost" value="<%=reqBaseCost %>">
					</div>
					<div class="colx3-right">
						<span class="label"></span><input name="generateBudgetReq" id="generateBudgetReq" type="button" class="button generate" value="Generate Budget Required"/>

					</div>
					</div>

					<div class="columns">
        				<div class="colx3-left">
					<span class="label"></span>
					<strong>Budget Required</strong>
					</div>
					<div class="colx3-center">
						<span class="label"></span>	
						<input type="text" id="budgetRequired" name="budgetRequired" value="<%=requiredBudgetAtMinBaseCost %>">
					</div>
					<div class="colx3-right">
						<span class="label"></span>	
					</div>
					</div>

					<div class="columns">
<input type="hidden" name="selectResearchProjId" id="selectResearchProjId" value="<%= (selectedProject != null ? selectedProject.getId() : "") %>">
<input type="hidden" name="budgetRequiredAtMinBaseCost" id="budgetRequiredAtMinBaseCost" readonly maxlength="10" value="<%=requiredBudgetAtMinBaseCost %>"/> 
	  					<input type="submit" class="button update" value="Update" onClick="javascript:updateResearchProject()"/>
	  					<input type="submit" class="button delete" value="Delete" onClick="javascript:deleteResearchProject()"/>
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