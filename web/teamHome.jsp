<%@ include file="header.jsp" %>
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
			<div class="block-border"><div class="block-content">
				<h1>Team Home</h1>
						<span style="color:#0083C3">Hi&nbsp;<i>Team,</i>&nbsp;&nbsp;Welcome to MarkLabs.</span><br><br>
						<p style="text-align: justify;"><span style="color:#0083C3"><i>MarkLabs</span></i> is an emerging economy growing at breath-neck pace. 
						The whole world has its eyes on this country and all the big brands are
						eyeing a share of this lucrative pie. <span style="color:#0083C3"><i>Competition</i></span>, therefore, is as 
						intense as you can imagine.</p>
						<p style="text-align: justify;">Your team has been entrusted with the task of managing the brands 
						for the company <span style="color:#0083C3"><i><%=((request.getSession().getAttribute(Constants.TEAM_NAME)!= null)? (request.getSession().getAttribute(Constants.TEAM_NAME)):"NA") %></span></i>. It is going to be a 
						complex task involving in depth understanding of your products, 
						customer preferences and strategic moves of competing companies.</p>
						<p style="text-align: justify;">The company has been organized into different departments that you 
						must visit to take the relevant decisions. The inputs that you take are 
						specific to <span style="color:#0083C3"><i>4</i> key departments i.e. Research and Development, Marketing,
						Sales and Market Intelligence</span>. The <span style="color:#0083C3">Board Room</span> is the most sophisticated room of the firm where your decisions
				   		shall be evaluated and scrutinized. The tab <span style="color:#0083C3">Basic Description </span>gives 
						you a detailed analysis of the region, their consumers, distribution 
						channels, etc.</p>
						<p style="text-align: justify;">The very first step in marketing your products is to <span style="color:#0083C3"><i>know your target 
						segment</i></span>. You need to choose segment or segments you want to cater to 
						from among the five segments explained under the tab Basic Description.
						Once the segments are chosen, you must <span style="color:#0083C3"><i>develop appropriate products</i></span> for 
						each of the segments using the help of R&D Department. 
						<br><br>Secondly, you 
						need to <span style="color:#0083C3"><i>use proper communication channel mix</i></span> and effective advertisement
						budget on the segment/segments you have targeted using the help of the
						Marketing Department. 
						<br><br>The third step is to <span style="color:#0083C3"><i>create an effective 
						distribution channel</i></span> for your product using the help of the Sales
						Department. The Intelligence Department will help you by providing
						<span style="color:#0083C3"><i>market research</i></span> reports, which you need to analyze and take effective
						measures accordingly. You shall be <span style="color:#0083C3"><i>reviewed on a quarterly basis </i></span>and 
						your input decisions shall be evaluated in the boardroom where meetings
						take place once in every quarter when the financial reports of the
						company are disclosed. </p>
						<p style="text-align: justify;">To get you started, instructions for all the 
						departments are presented to you on this page under different tabs on 
						the top of the page. </p>
						<span style="color:#0083C3"><i>All the very best for an exciting time ahead&nbsp;!!!</i></span>
						</div></div></section>
<div class="clear"></div>
		
	</article>
	
	<!-- End content -->

<%@ include file="footer.jsp" %>