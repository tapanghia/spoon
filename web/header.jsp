<%@ include file="commons.jspf"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.TreeMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Collection"%>
<%@ page import="com.marklabs.web.controllers.Constants" %>
<% 
  String currentLink = null;
  if (null !=  session.getAttribute("CURRENT_LINK")){
    currentLink = (String)session.getAttribute("CURRENT_LINK");
    currentLink = currentLink.toLowerCase();
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>

	<title>MarkLabs: Marketing Simulation by Biziga Labs</title>
	<meta charset="utf-8">
	
	<!-- Global stylesheets -->
	<link href="css/reset.css" rel="stylesheet" type="text/css">
	<link href="css/common.css" rel="stylesheet" type="text/css">
	<link href="css/form.css" rel="stylesheet" type="text/css">
	<link href="css/standard.css" rel="stylesheet" type="text/css">
	
	<!-- Comment/uncomment one of these files to toggle between fixed and fluid layout -->
	<!--<link href="css/960.gs.css" rel="stylesheet" type="text/css">-->
	<link href="css/960.gs.fluid.css" rel="stylesheet" type="text/css">
	
	<!-- Custom styles -->
	<link href="css/simple-lists.css" rel="stylesheet" type="text/css">
	<link href="css/block-lists.css" rel="stylesheet" type="text/css">
	<link href="css/table.css" rel="stylesheet" type="text/css">
	<link href="css/jquery-ui-1.8.7.custom.css" rel="stylesheet" type="text/css">
	
	<!-- Favicon -->
	<link rel="shortcut icon" type="image/x-icon" href="images/favicon.ico">
	
	<!-- Generic libs -->
	<script type="text/javascript" src="js/html5.js"></script>				<!-- this has to be loaded before anything else -->
	<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
	
	<!-- Template libs -->
	<script type="text/javascript" src="js/jquery.accessibleList.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript" src="js/standard.js"></script>
	<!--[if lte IE 8]><script type="text/javascript" src="js/standard.ie.js"></script><![endif]-->
	<script type="text/javascript" src="js/jquery.tip.js"></script>
	<script type="text/javascript" src="js/jquery.hashchange.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	
	<!-- Custom styles lib -->
	<script type="text/javascript" src="js/list.js"></script>
		
</head>

<body>
<!-- The template uses conditional comments to add wrappers div for ie8 and ie7 - just add .ie or .ie7 prefix to your css selectors when needed -->
<!--[if lt IE 9]><div class="ie"><![endif]-->
<!--[if lt IE 8]><div class="ie7"><![endif]-->
	
	<!-- Header -->
	
	<!-- Server status -->
	<header><div class="container_12">
<div class="server-info2"><a href="login.htm?do=logout" class="button red" title="Logout">Logout</a> </div>
<div class="server-info"><img src="images/logo1.jpg"></div>

		
	</div></header>
	<!-- End server status -->

	<!-- Main nav -->
	<nav id="main-nav">
		
		<ul class="container_12">
			<li class="home <%= (currentLink.equalsIgnoreCase("home"))?"current":"" %>"><a href="teamHome.htm" title="Home">Home</a>
				<ul>
					<li><a href="teamHome.htm" title="Dashboard">Dashboard</a></li>
					<li><a href="#" title="Help">Help</a></li>
				</ul>
			</li>
			<li class="write <%= (currentLink.equalsIgnoreCase("researchproject"))?"current":"" %>"><a href="researchProject.htm" title="R&D Team">R&DTeam</a>
				<ul>
					<li><a href="researchProject.htm" title="R&D Team Home">R&D Team Home</a></li>
					<li><a href="reports.htm?reportName=RnDReport" title="View R&D Reports">View R&D Reports</a></li>
					<li><a href="researchProject.htm?do=addResearchProject" title="Add Research Project">Add Research Project</a></li>
					<li><a href="researchProject.htm?do=getResearchProjectsForTeam" title="View/Edit Research Projects">View/Edit Research Projects</a></li>
				</ul>
			</li>
			<li class="comments <%= (currentLink.equalsIgnoreCase("marketing"))?"current":"" %>"><a href="marketingTeam.htm" title="Marketing Team">MarketingTeam</a>
				<ul>
					<li><a href="marketingTeam.htm" title="MarketingTeam">Marketing Team</a></li>
					<li><a href="brandManagement.htm" title="Brand Management">Brand Management</a></li>
					<li><a href="productionPricing.htm" title="Production & Pricing">Production & Pricing</a></li>
					<li><a href="brandAdvertisement.htm" title="Advertisement">Advertisement</a></li>
				</ul>
			</li>
			<li class="medias <%= (currentLink.equalsIgnoreCase("sales"))?"current":"" %>"><a href="salesTeam.htm" title="Sales Team">SalesTeam</a>
				<ul>
					<li><a href="salesTeam.htm" title="Sales Team">Sales Team</a></li>
					<li><a href="salesTeam.htm?do=getSalesForceMgmt" title="Sales Force Management">Sales Force Management</a></li>
				</ul>
			</li>
			<li class="users <%= (currentLink.equalsIgnoreCase("intelligence"))?"current":"" %>"><a href="intelligenceTeam.htm" title="Intelligence Team">IntelligenceTeam</a>
				<ul>
					<li><a href="intelligenceTeam.htm" title="Intelligence Team">Intelligence Team</a></li>
					<li><a href="intelligenceTeam.htm?do=displayMarketResearch" title="Conduct Market Research">Conduct Market Research</a></li>
				</ul>
			</li>
			<li class="stats <%= (currentLink.equalsIgnoreCase("boardroom"))?"current":"" %>"><a href="boardRoom.htm" title="Board Room">BoardRoom</a>
				<ul>
					<li><a href="boardRoom.htm" title="Board Room">Board Room</a></li>
					<li><a href="reports.htm?reportName=StockMarketReport" title="Market News">Market News</a></li>
					<!-- li><a href="#" title="Proposed Marketing Plan">Proposed Marketing Plan</a></li-->
				</ul>
			</li>
		</ul>
	</nav>
	<!-- End main nav -->

	<!-- Sub nav -->
	<div id="sub-nav"><div class="container_12">
		
	</div></div>
	<!-- End sub nav -->
	
	<div id="header-shadow"></div>
	<!-- End header -->
	
	<!-- Always visible control bar -->
	<div id="control-bar" class="grey-bg clearfix"><div class="container_12">
	
		<div class="float-left">
			<button type="button" onclick="javascript:window.open('basicDescription.jsp?', 'resizable=no, toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no');">Basic Description</button>
		</div>
		
		<div class="float-right"> 
			<button type="button" class="red"><%= ((request.getSession().getAttribute(Constants.CURRENT_PERIOD)!= null)? ("Period " + (Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD)):"")%></button> 
			<button type="button" class="red"><%= ((request.getSession().getAttribute(Constants.CURRENT_BUDGET)!= null)? ("Budget: " + request.getSession().getAttribute(Constants.CURRENT_BUDGET)):"")%></button> 
		</div>
			
	</div></div>
	<!-- End control bar -->
