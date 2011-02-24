package com.marklabs.web.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.marklabs.brandAdvertisement.BrandAdvertisement;
import com.marklabs.brandAdvertisement.IBrandAdvertisementService;
import com.marklabs.brands.Brand;
import com.marklabs.brands.IBrandService;
import com.marklabs.perceptualObj.IPerceptualObjService;
import com.marklabs.perceptualObj.MDSDimension;
import com.marklabs.perceptualObj.PerceptualObj;
import com.marklabs.perceptualObj.PerceptualObjectiveScales;
import com.marklabs.perceptualObj.SemanticScale;
import com.marklabs.teams.ITeamService;
import com.marklabs.teams.Team;

public class BrandAdvController extends MultiActionController{

	IBrandService brandService;
	IBrandAdvertisementService brandAdvertisementService;
	IPerceptualObjService perceptualObjService;
	ITeamService teamService;
	
	
	
	public ITeamService getTeamService() {
		return teamService;
	}

	public void setTeamService(ITeamService teamService) {
		this.teamService = teamService;
	}

	public IPerceptualObjService getPerceptualObjService() {
		return perceptualObjService;
	}

	public void setPerceptualObjService(IPerceptualObjService perceptualObjService) {
		this.perceptualObjService = perceptualObjService;
	}

	/**
	 * @return the brandAdvertisementService
	 */
	public IBrandAdvertisementService getBrandAdvertisementService() {
		return brandAdvertisementService;
	}

	/**
	 * @param brandAdvertisementService the brandAdvertisementService to set
	 */
	public void setBrandAdvertisementService(
			IBrandAdvertisementService brandAdvertisementService) {
		this.brandAdvertisementService = brandAdvertisementService;
	}

	/**
	 * @return the brandService
	 */
	public IBrandService getBrandService() {
		return brandService;
	}

	/**
	 * @param brandService the brandService to set
	 */
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}


	/**
	 * Default method of this controller. Will be invoked, when no action is passed.
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView index (HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("brandAdvHome");
		
		Team loggedInTeam = (Team)request.getSession().getAttribute(Constants.TEAM_OBJECT);
		int currPeriod = (Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD); 
		List<Brand> resultBrands = brandService.getAllBrandsForTeamCurrentPeriod(loggedInTeam, currPeriod);
		
		mav.addObject("existingBrands", resultBrands);
		
		if (request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV) == null && 
				resultBrands.size() > 0) {
			Brand thisBrand = resultBrands.get(0);
			// This is BrandAdv for the Brand in current period
			BrandAdvertisement thisPeriodBrandAdv = brandAdvertisementService.getBrandAdvOnBrand(thisBrand);
			PerceptualObj thisPeriodBrandPerceptualObj = perceptualObjService.getPerceptualObjInputForBrand(thisBrand);
			
			// Now getting the Brand with the same name in the previous period. And then will get its Adv
			Brand previousPeriodBrand = 
				brandService.getBrandOnNameAndPeriod(thisBrand.getBrandName(), (currPeriod - 1) ); 
			
			BrandAdvertisement previousPeriodBrandAdv = 
				brandAdvertisementService.getBrandAdvOnBrand(previousPeriodBrand);
			
			request.getSession().setAttribute(Constants.SELECTED_BRAND_ADV, resultBrands.get(0));
			request.getSession().setAttribute(Constants.PREVIOUSPERIOD_BRANDADV, previousPeriodBrandAdv);
			request.getSession().setAttribute(Constants.THISPERIOD_BRANDADV, thisPeriodBrandAdv);
			request.getSession().setAttribute(Constants.BRAND_PERCEPTUALOBJECTIVE, thisPeriodBrandPerceptualObj);
			
		}
		
		if (request.getParameter("selectedBrandId") != null) {
			long selectedBrandId = Long.parseLong(request.getParameter("selectedBrandId"));
			
			Brand thisBrand = brandService.getBrandonId(selectedBrandId);
			
			// This is BrandAdv for the Brand in current period
			BrandAdvertisement thisPeriodBrandAdv = brandAdvertisementService.getBrandAdvOnBrand(thisBrand);
			PerceptualObj thisPeriodBrandPerceptualObj = perceptualObjService.getPerceptualObjInputForBrand(thisBrand);
			
			// Now getting the Brand with the same name in the previous period. And then will get its Adv
			Brand previousPeriodBrand = 
				brandService.getBrandOnNameAndPeriod(thisBrand.getBrandName(), (currPeriod - 1) ); 
			
			BrandAdvertisement previousPeriodBrandAdv = 
				brandAdvertisementService.getBrandAdvOnBrand(previousPeriodBrand);
			
			request.getSession().removeAttribute(Constants.SELECTED_BRAND_ADV);
			request.getSession().removeAttribute(Constants.PREVIOUSPERIOD_BRANDADV);
			request.getSession().removeAttribute(Constants.THISPERIOD_BRANDADV);
			request.getSession().getAttribute(Constants.BRAND_PERCEPTUALOBJECTIVE);
			
			request.getSession().setAttribute(Constants.SELECTED_BRAND_ADV, thisBrand);
			request.getSession().setAttribute(Constants.PREVIOUSPERIOD_BRANDADV, previousPeriodBrandAdv);
			request.getSession().setAttribute(Constants.THISPERIOD_BRANDADV, thisPeriodBrandAdv);
			request.getSession().setAttribute(Constants.BRAND_PERCEPTUALOBJECTIVE, thisPeriodBrandPerceptualObj);
			
		}
		
		
		return mav;
	}
	
	public ModelAndView loadBrandAdvFrame (HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("brandAdvFrame");
		return mav;
	}
	
	public ModelAndView saveThisPeriodBrandAdv(HttpServletRequest request, HttpServletResponse response) {
		
		Team loggedInTeam = (Team)request.getSession().getAttribute(Constants.TEAM_OBJECT);
		long teamCurrentBudget = (Long)request.getSession().getAttribute(Constants.CURRENT_BUDGET);
		
		
		long advMediaBudget = Long.parseLong(request.getParameter("advMediaBudget"));
		long advResearchBudget = Long.parseLong(request.getParameter("advResearchBudget"));
		
		int blueblood_targetSeg = Integer.parseInt(request.getParameter("bluebloods_targetSeg"));
		int raffles_targetSeg = Integer.parseInt(request.getParameter("raffles_targetSeg"));
		int wannabes_targetSeg = Integer.parseInt(request.getParameter("wannabes_targetSeg"));
		int strugglers_targetSeg = Integer.parseInt(request.getParameter("strugglers_targetSeg"));
		int deprived_targetSeg = Integer.parseInt(request.getParameter("deprived_targetSeg"));
		
		int print_medium = Integer.parseInt(request.getParameter("print_medium"));
		int television_medium = Integer.parseInt(request.getParameter("television_medium"));
		int radio_medium = Integer.parseInt(request.getParameter("radio_medium"));
		int internet_medium = Integer.parseInt(request.getParameter("internet_medium"));
		
		// Processing Perceptual Objective
		String perceptualObjSelected = request.getParameter("perceptualObj");
		
		String semanticScaleDim1 = request.getParameter("semanticScaleDim1");
		String semanticScaleDim2 = request.getParameter("semanticScaleDim2");
		String semanticScaleDim1Obj = request.getParameter("semanticScaleDim1Obj");
		String semanticScaleDim2Obj = request.getParameter("semanticScaleDim2Obj");
		
		String mdsDimen1 = request.getParameter("mdsDimen1");
		String mdsDimen2 = request.getParameter("mdsDimen2");
		String mdsDimen1Obj = request.getParameter("mdsDimen1Obj");
		String mdsDimen2Obj = request.getParameter("mdsDimen2Obj");
		
		
		
		if (request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV) != null ) {
			
			BrandAdvertisement thisPeriodBrandAdv = 
				brandAdvertisementService.getBrandAdvOnBrand((Brand)request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV));
			
			
			// Tracking the old media budget and research budget for period budget tracking purposes
			long oldAdvMediaBudget = 0, oldAdvResearchBudget = 0;
			if (thisPeriodBrandAdv != null) {
				oldAdvMediaBudget = thisPeriodBrandAdv.getAdvMediabudget();
				oldAdvResearchBudget = thisPeriodBrandAdv.getAdvResearchBudget();
			}
			
			
			thisPeriodBrandAdv.setAdvMediabudget(advMediaBudget);
			thisPeriodBrandAdv.setAdvResearchBudget(advResearchBudget);
			
			thisPeriodBrandAdv.setSegBlueBloods(blueblood_targetSeg);
			thisPeriodBrandAdv.setSegRaffles(raffles_targetSeg);
			thisPeriodBrandAdv.setSegWannabees(wannabes_targetSeg);
			thisPeriodBrandAdv.setSegStrugglers(strugglers_targetSeg);
			thisPeriodBrandAdv.setSegDeprived(deprived_targetSeg);
			
			thisPeriodBrandAdv.setMediumPrint(print_medium);
			thisPeriodBrandAdv.setMediumInternet(internet_medium);
			thisPeriodBrandAdv.setMediumRadio(radio_medium);
			thisPeriodBrandAdv.setMediumTelevision(television_medium);
			
			// updating the Brand Advertisement expenditures, only if the budget is positive
			long updatedBudget = teamCurrentBudget - (advMediaBudget - oldAdvMediaBudget) - (advResearchBudget - oldAdvResearchBudget);
			if (updatedBudget > 0) {
			
				brandAdvertisementService.updateBrandAdvertisement(thisPeriodBrandAdv);
				
				PerceptualObj thisPeriodBrandPerceptualObj = null;
				
				if (perceptualObjSelected.equalsIgnoreCase("semanticScales")) {
					
					if (((semanticScaleDim1 != null && !(semanticScaleDim1.equalsIgnoreCase("")) &&
							semanticScaleDim1Obj != null && !(semanticScaleDim1Obj.equalsIgnoreCase(""))) || 
							(semanticScaleDim2 != null && !(semanticScaleDim2.equalsIgnoreCase("")) &&
									semanticScaleDim2Obj != null && !(semanticScaleDim2Obj.equalsIgnoreCase("")))) 
							&& (Brand)request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV) != null) {
					
						thisPeriodBrandPerceptualObj = addPerceptualObj((Brand)request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV), 
								semanticScaleDim1, semanticScaleDim1Obj, semanticScaleDim2, semanticScaleDim2Obj, 
								PerceptualObjectiveScales.SEMANTIC_SCALE.getPerceptualObjScale()); 
					}
				}
				else if (perceptualObjSelected.equalsIgnoreCase("mdsDimension")) {
					
					if (((mdsDimen1 != null && !(mdsDimen1.equalsIgnoreCase("")) &&
							mdsDimen1Obj != null && !(mdsDimen1Obj.equalsIgnoreCase(""))) || 
							(mdsDimen2 != null && !(mdsDimen2.equalsIgnoreCase("")) &&
									mdsDimen2Obj != null && !(mdsDimen2Obj.equalsIgnoreCase("")))) 
							&& (Brand)request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV) != null) {
					
						thisPeriodBrandPerceptualObj = addPerceptualObj((Brand)request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV), 
								mdsDimen1, mdsDimen1Obj,mdsDimen2, mdsDimen2Obj, 
								PerceptualObjectiveScales.MDS_DIMENSION.getPerceptualObjScale()); 
					}
				}
				else if (perceptualObjSelected.equalsIgnoreCase("noObjective")) {
					if ((Brand)request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV) != null) {
							deleteExisitingPerceptualObjective((Brand)request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV));
							
							// Now add a new entry for No Objective Sematic Scale
							PerceptualObj noObjPerceptualObj = new PerceptualObj();
							noObjPerceptualObj.setBrand((Brand)request.getSession().getAttribute(Constants.SELECTED_BRAND_ADV));
							noObjPerceptualObj.setScale(PerceptualObjectiveScales.NO_OBJECTIVE.getPerceptualObjScale());
							noObjPerceptualObj.setDimension1("-");
							noObjPerceptualObj.setObjective1(0);
							noObjPerceptualObj.setDimension2("-");
							noObjPerceptualObj.setObjective1(0);
							perceptualObjService.savePerceptualObj(noObjPerceptualObj);
					}
				}
				
				request.getSession().removeAttribute(Constants.THISPERIOD_BRANDADV);
				request.getSession().setAttribute(Constants.THISPERIOD_BRANDADV, thisPeriodBrandAdv);
				
				request.getSession().removeAttribute(Constants.BRAND_PERCEPTUALOBJECTIVE);
				request.getSession().setAttribute(Constants.BRAND_PERCEPTUALOBJECTIVE, thisPeriodBrandPerceptualObj);
				
				// Updating budget
				request.getSession().removeAttribute(Constants.CURRENT_BUDGET);
				request.getSession().setAttribute(Constants.CURRENT_BUDGET, updatedBudget);
							
				loggedInTeam.setTeamCurrentPeriodBudget(updatedBudget);
				teamService.updateTeam(loggedInTeam);
			}	
			
		}
		try {
			response.sendRedirect("brandAdvertisement.htm");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return null;
	}

	private void deleteExisitingPerceptualObjective(Brand thisBrand) {
		// checking if an entry for this brand exists in Perceptual Objective table
		PerceptualObj savedBrandPerceptualObj = perceptualObjService.getPerceptualObjInputForBrand(thisBrand);
		
		if (savedBrandPerceptualObj != null) { 
			perceptualObjService.deletePerceptualObj(savedBrandPerceptualObj);
		}
		
	}
	
	private PerceptualObj addPerceptualObj(Brand thisBrand,
			String perceptualObjScaleDim1, String perceptualObjScaleDim1Obj,String perceptualObjScaleDim2, 
			String perceptualObjScaleDim2Obj, String perceptualObjScale) {

		PerceptualObj thisBrandPerceptualObj = new PerceptualObj();
		
		// checking if an entry for this brand exists in Perceptual Objective table
		PerceptualObj savedBrandPerceptualObj = perceptualObjService.getPerceptualObjInputForBrand(thisBrand);
		
		if (savedBrandPerceptualObj != null) { 
			perceptualObjService.deletePerceptualObj(savedBrandPerceptualObj);
		}
		thisBrandPerceptualObj.setBrand(thisBrand);
		thisBrandPerceptualObj.setScale(perceptualObjScale);
		
		
		if (perceptualObjScaleDim1.equalsIgnoreCase(SemanticScale.DESIGN.getSemanticScale())) { 
			thisBrandPerceptualObj.setDimension1(SemanticScale.DESIGN.getSemanticScale());
		}
		else if (perceptualObjScaleDim1.equalsIgnoreCase(SemanticScale.FRAGRANCE.getSemanticScale())) {
			thisBrandPerceptualObj.setDimension1(SemanticScale.FRAGRANCE.getSemanticScale());
		}
		else if (perceptualObjScaleDim1.equalsIgnoreCase(SemanticScale.PACKAGING.getSemanticScale())) { 
			thisBrandPerceptualObj.setDimension1(SemanticScale.PACKAGING.getSemanticScale());
		}
		else if (perceptualObjScaleDim1.equalsIgnoreCase(SemanticScale.PERSISTENCE.getSemanticScale())) {
			thisBrandPerceptualObj.setDimension1(SemanticScale.PERSISTENCE.getSemanticScale());
		}
		else if (perceptualObjScaleDim1.equalsIgnoreCase(SemanticScale.SAFETY.getSemanticScale())) {
			thisBrandPerceptualObj.setDimension1(SemanticScale.SAFETY.getSemanticScale());
		}
		else if (perceptualObjScaleDim1.equalsIgnoreCase(SemanticScale.PRICE.getSemanticScale())) {
			thisBrandPerceptualObj.setDimension1(SemanticScale.PRICE.getSemanticScale());
		}
		else if (perceptualObjScaleDim1.equalsIgnoreCase(MDSDimension.APPEAL.getMDSDimension())) {
			thisBrandPerceptualObj.setDimension1(MDSDimension.APPEAL.getMDSDimension());
		}
		else if (perceptualObjScaleDim1.equalsIgnoreCase(MDSDimension.ECONOMY.getMDSDimension())) {
			thisBrandPerceptualObj.setDimension1(MDSDimension.ECONOMY.getMDSDimension());
		}
		else if (perceptualObjScaleDim1.equalsIgnoreCase(MDSDimension.QUALITY.getMDSDimension())) {
			thisBrandPerceptualObj.setDimension1(MDSDimension.QUALITY.getMDSDimension());
		}
		
		if (perceptualObjScaleDim1Obj != null) {
			double dimensionObj = Double.parseDouble(perceptualObjScaleDim1Obj); 
			thisBrandPerceptualObj.setObjective1(dimensionObj);
		}
		
		if (perceptualObjScaleDim2.equalsIgnoreCase(SemanticScale.DESIGN.getSemanticScale())) { 
			thisBrandPerceptualObj.setDimension2(SemanticScale.DESIGN.getSemanticScale());
		}
		else if (perceptualObjScaleDim2.equalsIgnoreCase(SemanticScale.FRAGRANCE.getSemanticScale())) {
			thisBrandPerceptualObj.setDimension2(SemanticScale.FRAGRANCE.getSemanticScale());
		}
		else if (perceptualObjScaleDim2.equalsIgnoreCase(SemanticScale.PACKAGING.getSemanticScale())) { 
			thisBrandPerceptualObj.setDimension2(SemanticScale.PACKAGING.getSemanticScale());
		}
		else if (perceptualObjScaleDim2.equalsIgnoreCase(SemanticScale.PERSISTENCE.getSemanticScale())) {
			thisBrandPerceptualObj.setDimension2(SemanticScale.PERSISTENCE.getSemanticScale());
		}
		else if (perceptualObjScaleDim2.equalsIgnoreCase(SemanticScale.SAFETY.getSemanticScale())) {
			thisBrandPerceptualObj.setDimension2(SemanticScale.SAFETY.getSemanticScale());
		}
		else if (perceptualObjScaleDim2.equalsIgnoreCase(SemanticScale.PRICE.getSemanticScale())) {
			thisBrandPerceptualObj.setDimension2(SemanticScale.PRICE.getSemanticScale());
		}
		else if (perceptualObjScaleDim2.equalsIgnoreCase(MDSDimension.APPEAL.getMDSDimension())) {
			thisBrandPerceptualObj.setDimension2(MDSDimension.APPEAL.getMDSDimension());
		}
		else if (perceptualObjScaleDim2.equalsIgnoreCase(MDSDimension.ECONOMY.getMDSDimension())) {
			thisBrandPerceptualObj.setDimension2(MDSDimension.ECONOMY.getMDSDimension());
		}
		else if (perceptualObjScaleDim2.equalsIgnoreCase(MDSDimension.QUALITY.getMDSDimension())) {
			thisBrandPerceptualObj.setDimension2(MDSDimension.QUALITY.getMDSDimension());
		}
		
		if (perceptualObjScaleDim2Obj != null) {
			double dimensionObj = Double.parseDouble(perceptualObjScaleDim2Obj); 
			thisBrandPerceptualObj.setObjective2(dimensionObj);
		}

		perceptualObjService.savePerceptualObj(thisBrandPerceptualObj);
		
		return thisBrandPerceptualObj;
	}
	
	
	
}
