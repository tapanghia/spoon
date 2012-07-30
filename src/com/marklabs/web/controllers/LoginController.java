package com.marklabs.web.controllers;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.marklabs.teams.ITeamService;
import com.marklabs.teams.Team;
import com.marklabs.user.IUserService;
import com.marklabs.user.User;
import com.marklabs.utils.IGlobalConstantsService;


/**
 * @date 02/25/2010
 * @author Tapan
 *
 */
public class LoginController extends MultiActionController {
	private static Logger logger = Logger.getLogger(LoginController.class);
   
	ITeamService teamService;
	IUserService userService;
	IGlobalConstantsService globalConstantsService;
	

	/**
	 * @return the globalConstantsService
	 */
	public IGlobalConstantsService getGlobalConstantsService() {
		return globalConstantsService;
	}

	/**
	 * @param globalConstantsService the globalConstantsService to set
	 */
	public void setGlobalConstantsService(
			IGlobalConstantsService globalConstantsService) {
		this.globalConstantsService = globalConstantsService;
	}

	/**
	 * @return the teamService
	 */
	public ITeamService getTeamService() {
		return teamService;
	}

	/**
	 * @param teamService the teamService to set
	 */
	public void setTeamService(ITeamService teamService) {
		this.teamService = teamService;
	}
	
	/**
	 * @return the userService
	 */
	public IUserService getUserService() {
		return userService;
	}

	/**
	 * @param userService the userService to set
	 */
	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	/**
	 * This function is called, when the a team logs into the application. 
	 * 		Here, if the team is authenticated, the control passes to the team's dashboard, else, 
	 * 		the user is directed back to the login page. 
	 * @param req
	 * @param res
	 * @return mav object
	 * @throws IOException 
	 */
	public ModelAndView authenticateTeam(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String teamUserName = request.getParameter("userName");
		String teamPassword = request.getParameter("userPassword");
		boolean isTeamAuthenticated = false;
		HttpSession session = request.getSession();
		
		if (null == teamUserName || null == teamPassword || ("".equalsIgnoreCase(teamUserName)) ||
				("".equalsIgnoreCase(teamPassword))) {
					ModelAndView mav = new ModelAndView("newLogin");
					mav.addObject("credentialsInvalidMessage", Constants.LOGIN_UNSUCCESSFUL);
					return mav;
		}
		else {
			
			// checking for admin user
			if (teamUserName.equalsIgnoreCase(Constants.ADMIN_USERNAME) &&
					teamPassword.equalsIgnoreCase(Constants.ADMIN_USERNAME)) {
				Team team = createAdminTeam();
				
				session.setAttribute(Constants.TEAM_ID, team.getId()+"");
				session.setAttribute(Constants.TEAM_NAME, team.getTeamName());
				session.setAttribute(Constants.TEAM_USERNAME, team.getTeamUserName());
				session.setAttribute(Constants.CURRENT_PERIOD, new Integer(team.getCurrentTeamPeriod()));
				session.setAttribute(Constants.CURRENT_BUDGET, team.getTeamCurrentPeriodBudget());
				session.setAttribute(Constants.TEAM_OBJECT, team);
				
				// session attributes for admin 
				session.setAttribute(Constants.IS_ADMIN_USER_LOGGED_IN, new Boolean(true));
				
				
				Team[] allTeams = teamService.getAllTeams();
				if (allTeams == null || allTeams.length <= 0) {
					ModelAndView mav = new ModelAndView("newLogin");
					mav.addObject("credentialsInvalidMessage", Constants.NO_TEAM_DETAILS_FOUND);
					return mav;
				}
				
				String[] teamNameArray = new String[allTeams.length];
				int teamCounter = 0;
				int maxPeriod = 0;
				for (Team teamObject : allTeams) {
					teamNameArray[teamCounter++] = teamObject.getTeamName();
					if (teamObject.getCurrentTeamPeriod() > maxPeriod)
						maxPeriod = teamObject.getCurrentTeamPeriod();
				}
				session.setAttribute(Constants.CURRENT_PERIOD, maxPeriod);
				session.setAttribute(Constants.TEAM_NAME_ARRAY, teamNameArray);
				
				response.sendRedirect("teamHome.htm");
				return null;

			}
			// for all other users
			else {
				//validating the credentials provided as input by the user.
				isTeamAuthenticated = teamService.isTeamAuthenticated(teamUserName, teamPassword);
				if (!(isTeamAuthenticated)){
					ModelAndView mav = new ModelAndView("newLogin");
					mav.addObject("credentialsInvalidMessage", Constants.LOGIN_UNSUCCESSFUL);
					return mav;
				}
				else {
					//Populating the session with the Team Details
					Team team = teamService.getTeamDetails(teamUserName, teamPassword);
					session.setAttribute(Constants.TEAM_ID, team.getId()+"");
					session.setAttribute(Constants.TEAM_NAME, team.getTeamName());
					session.setAttribute(Constants.TEAM_USERNAME, team.getTeamUserName());
					session.setAttribute(Constants.CURRENT_PERIOD, new Integer(team.getCurrentTeamPeriod()));
					session.setAttribute(Constants.CURRENT_BUDGET, team.getTeamCurrentPeriodBudget());
					session.setAttribute(Constants.TEAM_OBJECT, team);
					response.sendRedirect("teamHome.htm");
					
					//return new ModelAndView("dashBoard");
					return null;
				}
			}
		}
	}
	
	
	private Team createAdminTeam() {
		Team adminTeam = new Team();
		adminTeam.setId(0);
		adminTeam.setCurrentTeamPeriod(0);
		adminTeam.setTeamCurrentPeriodBudget(0);
		adminTeam.setTeamName(Constants.ADMIN_USERNAME);
		adminTeam.setTeamPassword(Constants.ADMIN_USERNAME);
		adminTeam.setTeamUserName(Constants.ADMIN_USERNAME);
		return adminTeam;
	}
	
	/**
	 * This function is called, when the team log outs from the application.
	 * @param request
	 * @param response
	 * @return mav object
	 */
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("newLogin");
        request.getSession().invalidate();
        return mav;
	}
	
	
	/**
	 * This is the default method, which will be invoked, if no parameter is passed to this controller.
	 * @param req
	 * @param res
	 * @return null
	 */
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {
		return null;
		
	}
	
	/**
	 * This method is responsible for authenticating the admin user, and redirecting to the admin Interface.
	 * @param request
	 * @param response
	 * @return admin interface
	 */
	public ModelAndView authenticateAdminUser(HttpServletRequest request, HttpServletResponse response) {
		
		String adminUserName = request.getParameter("adminUserName");
		String adminPassword = request.getParameter("adminPassword");
		boolean isUserAuthenticated = false;
		HttpSession session = request.getSession();
		
		if (null == adminUserName || null == adminPassword || ("".equalsIgnoreCase(adminUserName)) ||
				("".equalsIgnoreCase(adminPassword))) {
					ModelAndView mav = new ModelAndView("adminLogin");
					mav.addObject("credentialsInvalidMessage", Constants.LOGIN_UNSUCCESSFUL);
					return mav;
		}
		else {
			//validating the credentials provided as input by the user.
			isUserAuthenticated = userService.isUserAuthenticated(adminUserName, adminPassword);
			if (!(isUserAuthenticated)){
				ModelAndView mav = new ModelAndView("login");
				mav.addObject("credentialsInvalidMessage", Constants.LOGIN_UNSUCCESSFUL);
				return mav;
			}
			else {
				//Populating the session with the Team Details
				ModelAndView mav = new ModelAndView("adminDashBoard");
				User user = userService.getUserDetails(adminUserName, adminPassword);
				Team[] teams = teamService.getAllTeams();
				if (teams != null && teams.length > 0) {
					mav.addObject("existingTeamsArray", teams);
					mav.addObject("configureTeams", "no");
					session.setAttribute("teams", teams);
				}	
				else {
					mav.addObject("configureTeams", "yes");
				}
				session.setAttribute(Constants.USER_ID, user.getUserId()+"");
				session.setAttribute(Constants.USERNAME, user.getUserName());
				session.setAttribute(Constants.USER_TYPE, user.getUserTypeId()+"");
				session.setAttribute("CURRENT_PERIOD", globalConstantsService.getValueByName("CURRENT_PERIOD"));
				return mav;
			}
		}
	}
	
}