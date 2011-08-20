<%@ page import="java.util.Map"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.TreeMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Collection"%>
<%@ page import="com.marklabs.web.controllers.Constants" %>
<%@ page import="java.util.List" %>

<%@ page import="com.marklabs.researchProject.ResearchProject" %>
<%@ page import="com.marklabs.brands.Brand" %>
<%@ page language="java" %>
<%@ include file = "imports.jsp" %>

<%
	String todo = (String) request.getAttribute("todo");
	ResearchProject[] availableResearchProjs = (ResearchProject[]) request.getAttribute("availableResearchProjs");
	Brand selectedBrandToEdit = (Brand) request.getAttribute("selectedBrandToEdit");
	List<Brand> addedBrands =  (List<Brand>)request.getAttribute("addedBrands");
	
%>

<!DOCTYPE html>
<html lang="en">
<head>
	<title>Add/Edit Brands</title>
	<meta charset="utf-8">
	
	
<script type="text/javascript">
	
	Array.prototype.contains = function (element) {
		for (var i = 0; i < this.length; i++) {
			if (this[i] == element) {
				return true;
			}
		}
		return false;
	}
	
	var addedBrandsJSArray = new Array();
	<% if (addedBrands != null) {
		for (int i = 0; i< addedBrands.size(); i++) {%>
			addedBrandsJSArray[<%=i%>] = "<%=addedBrands.get(i).getBrandName().substring(1).toLowerCase()%>";	
		<%}
	}%>
	
	function addBrand(){
		var thisForm = document.addEditBrand;
		if (thisForm.brandName.value != null && !("" == thisForm.brandName.value)) {
			if (!(addedBrandsJSArray.contains(thisForm.brandName.value.toLowerCase()))) {
	        	window.opener.addNewBrandFromPopUp(thisForm.brandName.value, thisForm.selectBaseProject.value); 
	    		window.close();
    		}
    		else {
    			alert("No brands with duplicate names can be added.");
    		}
        } else {
        	alert("Please enter name of product.");
        }
    }

	function updateBrand() {
		var thisForm = document.addEditBrand;
		var selectedBrandId = 0;
		<% if (selectedBrandToEdit != null) { %>
			selectedBrandId = <%=selectedBrandToEdit.getId()%>;
		<%} %>
		window.opener.updateBrandFromPopUp(selectedBrandId, thisForm.brandName.value, thisForm.selectBaseProject.value);
		window.close();
	}

	function closeWindow() {
		window.close();
	}
	
	function setParentListBox() {
		var arrayOfcheckedAttendee = new Array();
    	var j = 0;
		if (searchORX.checkedAttendee != null){
			for (var i = 0;i < searchORX.checkedAttendee.length;i++){
				if (searchORX.checkedAttendee[i].checked == true){
					arrayOfcheckedAttendee.push(searchORX.checkedAttendee[i].value);
				}
			}
			if(searchORX.checkedAttendee.length == null){
				arrayOfcheckedAttendee.push(searchORX.checkedAttendee.value);
			}
		}
		window.opener.addORXName(arrayOfcheckedAttendee);
	}
</script>	
</head>

<body>
<form name="addEditBrand" method="post" class="block-content form" id="simple-list-form">
						<h1>Add/Edit Brands</h1>
<input type="hidden" name="parentFormName" value=""/>
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">

    <td>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="">
        <tr>
          <td align="left" valign="top" class="back-white">
          <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td width="190" valign="top" class="text-blue-01-bold">Name of the brand<font size="2" color="red">*</font></td>
            </tr>
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td width="190" valign="top">
<%
String teamName = null;
String co = null;
teamName = (String)request.getSession().getAttribute(Constants.TEAM_NAME);
co = teamName.substring(0,1);
%>
              	<% if (todo.equalsIgnoreCase("editBrand")) { %>
			<input name="brandName" type="text"  maxlength="50" value="<%=(selectedBrandToEdit.getBrandName())%>" 
              	disabled class="past"> <%} else { %>
			<%=co%><input name="brandName" type="text" maxlength="3"/>
			<%} %>
              	</td>
			</tr>
			<tr> <td colspan="2"> &nbsp; </td> </tr>
			<tr>
              <td width="10" height="20">&nbsp;</td>
              <td width="190" valign="top" class="text-blue-01-bold">Base R&D Project</td>
            </tr>
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="100">
              <select name="selectBaseProject">
              <%if (availableResearchProjs != null && availableResearchProjs.length > 0) { 
              		for (ResearchProject researchProj : availableResearchProjs) {%>
						<option value=<%=researchProj.getId() %> 
							<% if ((todo.equalsIgnoreCase("editBrand")) && researchProj.getProjectName().
									equalsIgnoreCase(selectedBrandToEdit.getResearchProject().getProjectName())) { %> selected="selected" <%} %>>
										<%=researchProj.getProjectName() %> </option>	              	
              	<%	}
            	 } %>  
                </select>
              </td>
            </tr>           
    	    <tr>
        	     <td class="back-white" colspan="4">&nbsp;</td>
	        </tr>
            <tr>
			  <td width="10" height="20">&nbsp;</td>
              <td width="20" valign="top"><input name="Submit332" type="button"  
              <% if (todo.equalsIgnoreCase("addBrand")) { %>
              	style="border:0;background : url(images/buttons/add-int.gif);width:73px; height:22px;" 
              	class="button-01" onClick="javascript:addBrand()"
              	<%} else { %>
              	style="border:0;background : url(images/buttons/update.gif);width:74px; height:22px;" 
              	class="button-01" onClick="javascript:updateBrand()"
              	<%} %>
              	/></td>
              <td width="20" valign="top"><input name="Submit332" type="button"  
              	style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:22px;" 
              	class="button-01" onClick="javascript:window.close()"/></td>
            </tr>

          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
    
       
</table> </td></tr></table>
</form>

				


</body>
</html>
