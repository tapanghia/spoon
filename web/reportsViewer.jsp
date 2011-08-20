<%@ page import="net.sf.jasperreports.engine.*"%>
<%@ page import="net.sf.jasperreports.engine.util.*"%>
<%@ page import="net.sf.jasperreports.engine.export.*"%>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.marklabs.web.ActionKeys"%>
<%@ page language="java"%>
<jsp:directive.page import="net.sf.jasperreports.charts.JRPiePlot" />
<jsp:directive.page import="net.sf.jasperreports.charts.JRPie3DPlot" />
<jsp:directive.page import="net.sf.jasperreports.engine.JRChartPlot" />
<jsp:directive.page	import="net.sf.jasperreports.charts.xml.JRPiePlotFactory" />
<%@ include file="imports.jsp"%>


<%
	boolean reportOnly = Boolean.valueOf(
			request.getParameter("reportOnly")).booleanValue();
	JasperPrint jasperPrint = (JasperPrint) session
			.getAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE);
	
	int pageIndex = 0;
	int lastPageIndex = 0;
	String message = "";
	StringBuffer sbuffer = new StringBuffer();
	if (jasperPrint != null && jasperPrint.getPages() != null) {
		lastPageIndex = jasperPrint.getPages().size() - 1;

		String pageStr = request.getParameter("page");
		try {
			pageIndex = Integer.parseInt(pageStr);
		} catch (Exception e) {
		}
	
		if (pageIndex < 0) {
			pageIndex = 0;
		}
	
		if (pageIndex > lastPageIndex) {
			pageIndex = lastPageIndex;
		}
	
		JRExporter exporter = null;

		exporter = new JRHtmlExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STRING_BUFFER,	sbuffer);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI,
				"imageServlet?abc=" + System.currentTimeMillis()
						+ "&image=");
		exporter.setParameter(JRExporterParameter.PAGE_INDEX, new Integer(pageIndex));
		exporter.setParameter(JRHtmlExporterParameter.HTML_HEADER, "");
		exporter.setParameter(JRHtmlExporterParameter.BETWEEN_PAGES_HTML,"");
		exporter.setParameter(JRHtmlExporterParameter.HTML_FOOTER, "");
	
		if (pageIndex >= 0) {
			exporter.exportReport();
		} 
		else {
			//message = "No Data Available for Selected Report";
			message = "This report has not been purchased for the current period.";
		}	
	}else{
		//message = "No Data Available for Selected Report";
		message = "This report has not been purchased for the current period.";
	}
%>


<html>
<script type="text/javascript">
function ExportToXls(){
	
	document.reportViewerForm.action = "<%=CONTEXTPATH%>/reportsViewer.htm?action=<%=ActionKeys.EXPORT_XLS%>";
	document.reportViewerForm.submit();
}
function ExportToPdf(){
	
	document.reportViewerForm.action = "<%=CONTEXTPATH%>/reportsViewer.htm?action=<%=ActionKeys.EXPORT_PDF%>";
	document.reportViewerForm.submit();
	
	
}

</script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
<style type="text/css">
a {
	
}
</style>
</head>
<body text="#000000" link="#000000" alink="#000000" vlink="#000000">
<div class="contentmiddle" style="width: 100%"">
<div class="contentmiddle" style="width: 100%"">
<div class="contentmiddle" style="width: 100%"">
<div class="contentmiddle" style="width: 100%"">
<form name="reportViewerForm" method="post">
<table width="100%" cellpadding="0" cellspacing="0" border="0"
	class="back-white">

	<tr>
		<td colspan="3">
		<hr size="1" color="#000000">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<%
					if (pageIndex > 0) {
				%>
				<td><a href="reportsViewer.jsp?page=0"><img
					src="images/first.GIF" border="0"></a></td>
				<td><a href="reportsViewer.jsp?page=<%=pageIndex - 1%>"><img
					src="images/previous.GIF" border="0"></a></td>
				<%
					} else {
				%>
				<td><img src="images/first_grey.GIF" border="0"></td>
				<td><img src="images/previous_grey.GIF" border="0"></td>
				<%
					}

						if (pageIndex < lastPageIndex) {
				%>
				<td><a href="reportsViewer.jsp?page=<%=pageIndex + 1%>"><img
					src="images/next.GIF" border="0"></a></td>
				<td><a href="reportsViewer.jsp?page=<%=lastPageIndex%>"><img
					src="images/last.GIF" border="0"></a></td>
				<%
					} else {
				%>
				<td><img src="images/next_grey.GIF" border="0"></td>
				<td><img src="images/last_grey.GIF" border="0"></td>
				<%
					}
				%>
				<td width="20%"><span class="text-blue-01-bold">&nbsp;&nbsp;&nbsp;&nbsp;Page
				<%=pageIndex + 1%> of <%=lastPageIndex + 1%></span></td>
				<td width="0.5%">&nbsp;&nbsp;<img src="images/xls_icon.gif" width="17"
					height="17" border="0" style="cursor: pointer; width: 17px;"
					onclick="javascript:ExportToXls();"></td>
				<td width="69.5%">&nbsp;&nbsp;<img src="images/pdf_icon.gif" border="0" style="cursor: pointer;"
					onclick="javascript:ExportToPdf();"></td>
				
			</tr>
		</table>
		<hr size="1" color="#000000">
		</td>
		</td>
		<td width="50%">&nbsp;</td>
	</tr>
	<tr>
		<%
			if (!"".equals(message)) {
		%>
		<td width="50%">&nbsp;</td>
		<td align="center"><font face="verdana" size="2" color="red">
		<b><%=message%></b> </font></td>

		<%
			}
		%>
	</tr>
	<tr>
		<td width="50%">&nbsp;</td>
		<td align="center"><%=sbuffer.toString()%></td>
		<td width="50%">&nbsp;</td>
	</tr>
</table>
</form>
</div>

</body>
</html>
