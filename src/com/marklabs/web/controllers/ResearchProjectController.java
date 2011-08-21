package com.marklabs.web.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.marklabs.researchProject.IResearchProjectMetadataService;
import com.marklabs.researchProject.IResearchProjectService;
import com.marklabs.researchProject.ResearchProject;
import com.marklabs.researchProject.ResearchProjectMetadata;
import com.marklabs.teams.ITeamService;
import com.marklabs.teams.Team;
import com.marklabs.utils.view.JsonView;

/**
 * @date 04/25/2010
 * @author Tapan
 *
 */
public class ResearchProjectController extends MultiActionController {
	
	IResearchProjectService researchProjectService;
	IResearchProjectMetadataService researchProjectMetadataService;
	ITeamService teamService;
	
	
	public ITeamService getTeamService() {
		return teamService;
	}

	public void setTeamService(ITeamService teamService) {
		this.teamService = teamService;
	}

	/**
	 * @return the researchProjectMetadataService
	 */
	public IResearchProjectMetadataService getResearchProjectMetadataService() {
		return researchProjectMetadataService;
	}

	/**
	 * @param researchProjectMetadataService the researchProjectMetadataService to set
	 */
	public void setResearchProjectMetadataService(
			IResearchProjectMetadataService researchProjectMetadataService) {
		this.researchProjectMetadataService = researchProjectMetadataService;
	}

	/**
	 * @return the researchProjectService
	 */
	public IResearchProjectService getResearchProjectService() {
		return researchProjectService;
	}

	/**
	 * @param researchProjectService the researchProjectService to set
	 */
	public void setResearchProjectService(
			IResearchProjectService researchProjectService) {
		this.researchProjectService = researchProjectService;
	}

	/**
	 * Being Used
	 * @param request
	 * @param response
	 * @return mav object, to display the list of all the research projects for the Team on the User Interface
	 * 
	 */

	public ModelAndView getResearchProjectsForTeam(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("editAddResearchProject");
		
		long loggedInTeamId = Long.parseLong((String)request.getSession().getAttribute(Constants.TEAM_ID));
		int currentPeriod = ((Integer) request.getSession().getAttribute(Constants.CURRENT_PERIOD)).intValue();
		ResearchProject[] researchProjArray = 
			researchProjectService.getResearchProjForTeamByProjFinishPeriod(loggedInTeamId, currentPeriod+1);
		
		mav.addObject(Constants.EXISTING_RESEARCH_PROJECTS, researchProjArray);
		
		if (request.getSession().getAttribute(Constants.SELECTED_RESEARCH_PROJECT) == null && 
				researchProjArray != null && researchProjArray.length > 0)
			request.getSession().setAttribute(Constants.SELECTED_RESEARCH_PROJECT, researchProjArray[0]);
		
		if (request.getParameter("selectedProjectId") != null) {
			
			long selectedResearchProjId = Long.parseLong(request.getParameter("selectedProjectId"));
			ResearchProject selectedResearchProj = 
				researchProjectService.getResearcProjectByID(selectedResearchProjId);
			request.getSession().removeAttribute(Constants.SELECTED_RESEARCH_PROJECT);
			request.getSession().setAttribute(Constants.SELECTED_RESEARCH_PROJECT, selectedResearchProj);
		}
		
		if (researchProjArray == null || researchProjArray.length == 0) {
			try {
			response.sendRedirect("researchProject.htm?do=addResearchProject");
			} catch (IOException e) {
				
			}
		}
		return mav;
	}
	
	/**
	 * Being Used
	 * Default method, If the action is not passed, when the control is passed to this controller, 
	 * 		this method, will be invoked. 
	 * @param request
	 * @param response
	 * @return
	 */
	
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		session.setAttribute("CURRENT_LINK",Constants.RESEARCH_PROJECT_LINK);
		ModelAndView mav = new ModelAndView("researchProjectHome");
		return mav;
	}

	/**
	 * Being Used
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView addResearchProject(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("addResearchProject");
		
		HttpSession session = request.getSession();
		long teamId = Long.parseLong((String)session.getAttribute(Constants.TEAM_ID));
		int currentPeriod = ((Integer) session.getAttribute(Constants.CURRENT_PERIOD)).intValue();
		ResearchProject []previousPeriodProj = 
			researchProjectService.getCompletedResearchProjectsForTeam(teamId, currentPeriod);
		
		ResearchProject []allResearchProjForTeam = researchProjectService.getAllResearchProjectsForTeam(teamId);
		
		mav.addObject(Constants.PREVIOUS_PERIOD_RESEARCH_PROJECTS, previousPeriodProj);
		mav.addObject(Constants.ALL_RESEARCH_PROJECTS_FOR_TEAM, allResearchProjForTeam);	
		return mav;
	}
	
	/**
	 * Being Used
	 * Function to get the selected Base Project Specifications
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView getResearchProjectSpecs(HttpServletRequest request, HttpServletResponse response) {
		long researchProjId = 0;
		ResearchProject thisResearchProject = new ResearchProject();
		Map<String, Integer> map = new HashMap<String, Integer>();
		
		if (request.getParameter("selectedBaseProjectID") != null)
			researchProjId = Long.parseLong(request.getParameter("selectedBaseProjectID"));
		
		if (researchProjId != -1 ) {
			thisResearchProject = researchProjectService.getResearcProjectByID(researchProjId);   
		
			map.put("design", thisResearchProject.getDesign());
	   	 	map.put("fragrance", thisResearchProject.getFragrance());
	   	 	map.put("persistence", thisResearchProject.getPersistence());
	   	 	map.put("packaging", thisResearchProject.getPackaging());
	   	 	map.put("safety", thisResearchProject.getSafety());
		}
		else {
			
	   	 	map.put("design", 0);
	   	 	map.put("fragrance", 0);
	   	 	map.put("persistence", 0);
	   	 	map.put("packaging", 0);
	   	 	map.put("safety", 0);
		}
	
   	 	return new ModelAndView(new JsonView(), map);
	}
	
	/**
	 * Being Used
	 * Function used to calculate the minimum Base Cost. This will return a JSON View Object containing the
	 * 		minimum Base Cost for the Input specifications, requested Base Cost = minimum Base Cost and
	 * 		Required Budget at minimum base cost.
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView calculateMinBaseCost(HttpServletRequest request, HttpServletResponse response) {
		int designValue = Integer.parseInt(request.getParameter("designValue"));
		int fragranceValue = Integer.parseInt(request.getParameter("fragranceValue"));
		int persistenceValue = Integer.parseInt(request.getParameter("persistenceValue"));
		int packagingValue = Integer.parseInt(request.getParameter("packagingValue"));
		int safetyValue = Integer.parseInt(request.getParameter("safetyValue"));
		
		ResearchProjectMetadata projMetadata = new ResearchProjectMetadata();
    	projMetadata.setDesign(designValue);
    	projMetadata.setFragrance(fragranceValue);
    	projMetadata.setPersistence(persistenceValue);
    	projMetadata.setPackaging(packagingValue);
    	projMetadata.setSafety(safetyValue);
    	
    	long minBaseCost = researchProjectMetadataService.getMinimumBaseCost(projMetadata); 
    	long requiredBudgetAtMinBaseCost = 
    		researchProjectMetadataService.getRequiredBudgetAtMinBaseCost(minBaseCost);
    	
    	Map<String, Long> map = new HashMap<String, Long>();
    	 map.put("minBaseCost", minBaseCost);
    	 map.put("budgetRequired", requiredBudgetAtMinBaseCost);
    	 
    	 return new ModelAndView(new JsonView(), map);
     	
	}
	
	/**
	 * Being Used
	 * Function to calculate the Required Budget on the Requested Base Cost for the Research Project
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView calculateReqBudgetOnReqBaseCost(HttpServletRequest request, HttpServletResponse response) {
		
		long minBaseCost = Long.parseLong(request.getParameter("minBaseCost"));
		long requestedBaseCost = Long.parseLong(request.getParameter("requestedBaseCost"));
		long budgetRequiredAtMinBaseCost = Long.parseLong(request.getParameter("budgetRequiredAtMinBaseCost"));
		
		long budgetRequired = researchProjectMetadataService.getRequiredBudgetAtReqBaseCost(requestedBaseCost, 
				minBaseCost, budgetRequiredAtMinBaseCost);
		
		Map<String, Long> map = new HashMap<String, Long>();
	   	map.put("budgetRequired", budgetRequired);
	
	   	return new ModelAndView(new JsonView(), map);
	}
	
	/**
	 * Being Used
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView addResearchProjectSpecs(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		long teamId = Long.parseLong((String)session.getAttribute(Constants.TEAM_ID));
		int currentPeriod = ((Integer) session.getAttribute(Constants.CURRENT_PERIOD)).intValue();
		ResearchProject []previousPeriodProj = 
			researchProjectService.getResearchProjForTeamPreviousPeriod(teamId, currentPeriod);
		
		ModelAndView mav = new ModelAndView("addProjectSpecifications");
		mav.addObject(Constants.PREVIOUS_PERIOD_RESEARCH_PROJECTS, previousPeriodProj);
		return mav;
	}
	
	public ModelAndView saveResearchProject(HttpServletRequest request, HttpServletResponse response) {
	
		long teamCurrentBudget = (Long)request.getSession().getAttribute(Constants.CURRENT_BUDGET);
				
		ResearchProject researchProject = new ResearchProject();
		String projectName = request.getParameter("projectName");
		
		int designValue = Integer.parseInt(request.getParameter("design"));
		int fragranceValue = Integer.parseInt(request.getParameter("fragrance"));
		int persistenceValue = Integer.parseInt(request.getParameter("persistence"));
		int packagingValue = Integer.parseInt(request.getParameter("packaging"));
		int safetyValue = Integer.parseInt(request.getParameter("safety"));
		
		long minBaseCost = Long.parseLong(request.getParameter("minBaseCost"));
		long requestedBaseCost = Long.parseLong(request.getParameter("requestedBaseCost"));
		
		long requiredBudgetAtMinBaseCost = 
    		researchProjectMetadataService.getRequiredBudgetAtMinBaseCost(minBaseCost);
		
		long budgetRequiredAtReqBaseCost = researchProjectMetadataService.getRequiredBudgetAtReqBaseCost(requestedBaseCost, 
				minBaseCost, requiredBudgetAtMinBaseCost);
		
		Team loggedInTeam = (Team)request.getSession().getAttribute(Constants.TEAM_OBJECT);
		int currentPeriod = ((Integer) request.getSession().getAttribute(Constants.CURRENT_PERIOD)).intValue();
		projectName = (loggedInTeam.getTeamName()).substring(0, 1) + "R" + projectName;
		
		
		researchProject.setProjectName(projectName.toUpperCase());
		researchProject.setDesign(designValue);
		researchProject.setFragrance(fragranceValue);
		researchProject.setPersistence(persistenceValue);
		researchProject.setPackaging(packagingValue);
		researchProject.setSafety(safetyValue);
		
		researchProject.setMinimumBaseCost(minBaseCost);
		researchProject.setRequestedBaseCost(requestedBaseCost);
		researchProject.setRequiredBudgetAtMinBC(requiredBudgetAtMinBaseCost);
		researchProject.setRequiredBudgetAtReqBC(budgetRequiredAtReqBaseCost);
		researchProject.setAllocatedBudget(budgetRequiredAtReqBaseCost);
		
		researchProject.setTeam(loggedInTeam);
		researchProject.setCurrentPeriod(currentPeriod);
		researchProject.setProjectFinishPeriod(currentPeriod + 1);
		
		researchProject.setBudgetDeficit(0);
		researchProject.setIsAvailable("Y");
		
		// Save the Research Proj only if, the budget is not negative
		long updatedBudget = teamCurrentBudget - budgetRequiredAtReqBaseCost;
		if (updatedBudget > 0) {
			researchProjectService.saveResearchProject(researchProject);
			
			//Removing the existing selected research proj from session and adding the newly created project
			request.getSession().removeAttribute(Constants.SELECTED_RESEARCH_PROJECT);
			request.getSession().setAttribute(Constants.SELECTED_RESEARCH_PROJECT, researchProject);
			
			//Updating the team budget in session and team table
			
			request.getSession().removeAttribute(Constants.CURRENT_BUDGET);
			request.getSession().setAttribute(Constants.CURRENT_BUDGET, updatedBudget);
			
			
			loggedInTeam.setTeamCurrentPeriodBudget(updatedBudget);
			teamService.updateTeam(loggedInTeam);
		}
		try {
			response.sendRedirect("researchProject.htm?do=addResearchProject");
		} catch (IOException e) {
			// TODO Auto-generated catch block
		}
//		ModelAndView mav = new ModelAndView("editAddResearchProject");
		return null;
	}
	
	/**
	 * Being Used
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView editResearchProjectSpecs(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("editProjectSpecifications");
		return mav;
	}
	
	/**
	 * Being Used
	 * Function to edit/update the research Projects
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView updateResearchProject(HttpServletRequest request, HttpServletResponse response) {
		
		Team loggedInTeam = (Team)request.getSession().getAttribute(Constants.TEAM_OBJECT);
		long teamCurrentBudget = (Long)request.getSession().getAttribute(Constants.CURRENT_BUDGET);
				
		String updatedResearchProjectIdString = request.getParameter("updatedResearchProjectId");
		if (updatedResearchProjectIdString != null) {
			long updatedResearchProjectId = Long.parseLong(updatedResearchProjectIdString);
		
			ResearchProject updatedResearchProj = 
				researchProjectService.getResearcProjectByID(updatedResearchProjectId);
			
			// Tracking the old required budget at requested base cost of budget deduction purposes
			long oldReqBudgetAtReqBaseCost = 0;
			if (updatedResearchProj != null) 
				oldReqBudgetAtReqBaseCost = updatedResearchProj.getRequiredBudgetAtReqBC();
			
			int designValue = Integer.parseInt(request.getParameter("design"));
			int fragranceValue = Integer.parseInt(request.getParameter("fragrance"));
			int persistenceValue = Integer.parseInt(request.getParameter("persistence"));
			int packagingValue = Integer.parseInt(request.getParameter("packaging"));
			int safetyValue = Integer.parseInt(request.getParameter("safety"));
			
			long minBaseCost = Long.parseLong(request.getParameter("minBaseCost"));
			long requestedBaseCost = Long.parseLong(request.getParameter("requestedBaseCost"));
			
			long requiredBudgetAtMinBaseCost = 
	    		researchProjectMetadataService.getRequiredBudgetAtMinBaseCost(minBaseCost);
			
			long budgetRequiredAtReqBaseCost = researchProjectMetadataService.getRequiredBudgetAtReqBaseCost(requestedBaseCost, 
					minBaseCost, requiredBudgetAtMinBaseCost);
			
			updatedResearchProj.setDesign(designValue);
			updatedResearchProj.setFragrance(fragranceValue);
			updatedResearchProj.setPersistence(persistenceValue);
			updatedResearchProj.setPackaging(packagingValue);
			updatedResearchProj.setSafety(safetyValue);
			
			updatedResearchProj.setMinimumBaseCost(minBaseCost);
			updatedResearchProj.setRequestedBaseCost(requestedBaseCost);
			updatedResearchProj.setRequiredBudgetAtMinBC(requiredBudgetAtMinBaseCost);
			updatedResearchProj.setRequiredBudgetAtReqBC(budgetRequiredAtReqBaseCost);
			updatedResearchProj.setAllocatedBudget(budgetRequiredAtReqBaseCost);
		
			// Need not update the research project if the budget is negative
			long updatedBudget = teamCurrentBudget - (budgetRequiredAtReqBaseCost - oldReqBudgetAtReqBaseCost);
			
			if (updatedBudget > 0) {
				researchProjectService.updateResearchProject(updatedResearchProj);
				
				//Now removing the old Research Object from Session and putting the updated one
				request.getSession().removeAttribute(Constants.SELECTED_RESEARCH_PROJECT);
				request.getSession().setAttribute(Constants.SELECTED_RESEARCH_PROJECT, updatedResearchProj);
				
				
				
				request.getSession().removeAttribute(Constants.CURRENT_BUDGET);
				request.getSession().setAttribute(Constants.CURRENT_BUDGET, updatedBudget);
							
				loggedInTeam.setTeamCurrentPeriodBudget(updatedBudget);
				teamService.updateTeam(loggedInTeam);
			}
			
		}
				
		long loggedInTeamId = Long.parseLong((String)request.getSession().getAttribute(Constants.TEAM_ID));
		int currentPeriod = ((Integer) request.getSession().getAttribute(Constants.CURRENT_PERIOD)).intValue();
		ResearchProject[] researchProjArray = 
			researchProjectService.getResearchProjForTeamByProjFinishPeriod(loggedInTeamId, currentPeriod+1);
		
		ModelAndView mav = new ModelAndView("editAddResearchProject");
		mav.addObject(Constants.EXISTING_RESEARCH_PROJECTS, researchProjArray);
		
		return mav;
	}
	
	public ModelAndView deleteResearchProject (HttpServletRequest request, HttpServletResponse response) {
		String deletedResearchProjectIdString = request.getParameter("deletedResearchProjectId");
		if (deletedResearchProjectIdString != null) {
			long deletedResearchProjectId = Long.parseLong(deletedResearchProjectIdString);
		
			ResearchProject toDeleteResearchProj = 
				researchProjectService.getResearcProjectByID(deletedResearchProjectId);
			researchProjectService.deleteResearchProject(toDeleteResearchProj);
			
			//Removing the deleted Project from Session
			request.getSession().removeAttribute(Constants.SELECTED_RESEARCH_PROJECT);
		}
		
		long loggedInTeamId = Long.parseLong((String)request.getSession().getAttribute(Constants.TEAM_ID));
		int currentPeriod = ((Integer) request.getSession().getAttribute(Constants.CURRENT_PERIOD)).intValue();
		ResearchProject[] researchProjArray = 
			researchProjectService.getResearchProjForTeamByProjFinishPeriod(loggedInTeamId, currentPeriod+1);
		
		try {
			if (researchProjArray == null || researchProjArray.length == 0) {
				response.sendRedirect("researchProject.htm?do=addResearchProject");
			} else {
					response.sendRedirect("researchProject.htm?do=getResearchProjectsForTeam");
			}
		} catch (IOException e) {
			
		}
		return null;
	}
}