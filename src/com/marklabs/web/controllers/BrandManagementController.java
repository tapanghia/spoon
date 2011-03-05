package com.marklabs.web.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.marklabs.brandAdvertisement.BrandAdvertisement;
import com.marklabs.brandAdvertisement.IBrandAdvertisementService;
import com.marklabs.brandSpecifications.BrandSpecs;
import com.marklabs.brandSpecifications.IBrandSpecsService;
import com.marklabs.brands.Brand;
import com.marklabs.brands.IBrandService;
import com.marklabs.distributionCoverage.IMarginOfferedService;
import com.marklabs.distributionCoverage.ISalesForceService;
import com.marklabs.distributionCoverage.MarginOffered;
import com.marklabs.distributionCoverage.SalesForce;
import com.marklabs.perceptualObj.IPerceptualObjService;
import com.marklabs.perceptualObj.PerceptualObj;
import com.marklabs.perceptualObj.PerceptualObjectiveScales;
import com.marklabs.researchProject.IResearchProjectService;
import com.marklabs.researchProject.ResearchProject;
import com.marklabs.teams.Team;

public class BrandManagementController extends MultiActionController{

	IBrandService brandService;
	IResearchProjectService researchProjectService;
	IBrandSpecsService brandSpecsService;
	IBrandAdvertisementService brandAdvertisementService;
	ISalesForceService salesForceService;
	IMarginOfferedService marginOfferedService;
	IPerceptualObjService perceptualObjService;
	
	
	public IPerceptualObjService getPerceptualObjService() {
		return perceptualObjService;
	}
	public void setPerceptualObjService(IPerceptualObjService perceptualObjService) {
		this.perceptualObjService = perceptualObjService;
	}
	public IBrandAdvertisementService getBrandAdvertisementService() {
		return brandAdvertisementService;
	}
	public void setBrandAdvertisementService(
			IBrandAdvertisementService brandAdvertisementService) {
		this.brandAdvertisementService = brandAdvertisementService;
	}
	public ISalesForceService getSalesForceService() {
		return salesForceService;
	}
	public void setSalesForceService(ISalesForceService salesForceService) {
		this.salesForceService = salesForceService;
	}
	public IMarginOfferedService getMarginOfferedService() {
		return marginOfferedService;
	}
	public void setMarginOfferedService(IMarginOfferedService marginOfferedService) {
		this.marginOfferedService = marginOfferedService;
	}
	public IBrandSpecsService getBrandSpecsService() {
		return brandSpecsService;
	}
	public void setBrandSpecsService(IBrandSpecsService brandSpecsService) {
		this.brandSpecsService = brandSpecsService;
	}
	public IBrandService getBrandService() {
		return brandService;
	}
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}

	public IResearchProjectService getResearchProjectService() {
		return researchProjectService;
	}
	public void setResearchProjectService(
			IResearchProjectService researchProjectService) {
		this.researchProjectService = researchProjectService;
	}
	/**
	 * Default method of thie this controller. Whenever the user clicks on the Tab, the control passes to this 
	 * 		action.
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("brandManagementHome");
		Team loggedInTeam = (Team)request.getSession().getAttribute(Constants.TEAM_OBJECT);
		int currPeriod = (Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD); 
		List<Brand> resultBrands = brandService.getAllBrandsForTeamCurrentPeriod(loggedInTeam, currPeriod);
		
		mav.addObject("toDisplayBrands", resultBrands);
		return mav;
	}
	
//TODO: marked for removal.
//	public ModelAndView displayBrands (HttpServletRequest request, HttpServletResponse response) {
//		ModelAndView mav = new ModelAndView("displayBrands");
//		Team loggedInTeam = (Team)request.getSession().getAttribute(Constants.TEAM_OBJECT);
//		int currPeriod = (Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD); 
//		List<Brand> resultBrands = brandService.getAllBrandsForTeamCurrentPeriod(loggedInTeam, currPeriod);
//		
//		mav.addObject("toDisplayBrands", resultBrands);
//		return mav;
//	}

	public ModelAndView addNewBrand(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("addEditBrandsPopUp");
		Team loggedInTeam = (Team)request.getSession().getAttribute(Constants.TEAM_OBJECT);
		int currentPeriod = ((Integer) request.getSession().getAttribute(Constants.CURRENT_PERIOD)).intValue();
		ResearchProject[] researchProjs = researchProjectService.getCompletedResearchProjectsForTeam(loggedInTeam.getId(), currentPeriod);
				
		mav.addObject("availableResearchProjs", researchProjs);
		mav.addObject("todo", "addBrand");
		return mav;
	}
	
	public ModelAndView editBrand(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("addEditBrandsPopUp");
		
		String selectedBrandToEdit = request.getParameter("selectedBrandId");
		Brand selectedBrand = brandService.getBrandonId(Long.parseLong(selectedBrandToEdit));
		int currentPeriod = ((Integer) request.getSession().getAttribute(Constants.CURRENT_PERIOD)).intValue();
		Team loggedInTeam = (Team)request.getSession().getAttribute(Constants.TEAM_OBJECT);
		ResearchProject[] researchProjs = researchProjectService.getCompletedResearchProjectsForTeam(loggedInTeam.getId(), currentPeriod);
		
		mav.addObject("selectedBrandToEdit", selectedBrand);
		mav.addObject("availableResearchProjs", researchProjs);
		mav.addObject("todo", "editBrand");
		return mav;
	}
	
	public ModelAndView saveOrUpdateBrand (HttpServletRequest request, HttpServletResponse response) {
		String brandInf = (String) request.getParameter("hiddenSelectedBrand");
		String projInf = (String) request.getParameter("hiddenSelectedProject");
		String todo = (String) request.getParameter("todo");
		HttpSession session = request.getSession();
		int currentPeriod =  (Integer)request.getSession().getAttribute(Constants.CURRENT_PERIOD);
		long teamId = Long.parseLong((String)request.getSession().getAttribute(Constants.TEAM_ID));
		Team team = (Team) request.getSession().getAttribute(Constants.TEAM_OBJECT);
		
		if (todo != null && !("".equals(todo)) && "addBrand".equalsIgnoreCase(todo)) {
			if (brandInf != null && !("".equals(brandInf) && projInf != null && !("".equals(projInf)))) {
				long projId = Long.parseLong(projInf);
				ResearchProject baseProject = researchProjectService.getResearcProjectByID(projId);
				if (baseProject != null) {
					brandInf = (team.getTeamName()).substring(0, 1) + brandInf;
					Brand newBrand = new Brand();
					newBrand.setBrandName(brandInf.toUpperCase());
					newBrand.setResearchProject(baseProject);
					newBrand.setDeleteFlag(DeleteFlag.DELETEFLAG_NO.getDeletFlag());
					newBrand.setPeriod((Integer)(session.getAttribute(Constants.CURRENT_PERIOD)));
					newBrand.setStatus(BrandStatus.NEW.getBrandStatus());
					
					brandService.saveBrand(newBrand);
					
					
					// Now adding a new dummy BrandSpecs Entry while saving the new Brand
					addBrandSpecsForNewBrandAdded(newBrand);
									
					//Now adding new dummy BrandAdvertisement Entry while saving the new Brand
					addBrandAdvForNewBrandAdded(newBrand);
					
					// No dummy values will be added to Perceptual Objective hence 'No Objective' radiobutton will be selected by default
					
					// Adding dummy SalesForce entry for the new brand added
					addBrandSalesForceForNewBrandAdded(newBrand);
					
					//Adding dummy Margin Offered entry for new Brand added
					addBrandMarginOfferedForNewBrandAdded(newBrand);
					
					// Adding dummy perceptual Objective entry for New Brand
					addBrandPerceptualObjectiveForNewBrandAdded(newBrand);
					
				}
			}
		}
		
		if (todo != null && !("".equals(todo)) && "updateBrand".equalsIgnoreCase(todo)) {
			if (brandInf != null && !("".equals(brandInf) && projInf != null && !("".equals(projInf)))) {
				long brandId = Long.parseLong(brandInf);
				long projId = Long.parseLong(projInf);
				ResearchProject baseProject = researchProjectService.getResearcProjectByID(projId);
				if (baseProject != null) {
					Brand toEditBrand = brandService.getBrandonId(brandId);
					ResearchProject previousResearchProj = toEditBrand.getResearchProject();
					toEditBrand.setResearchProject(baseProject);
					
					// checking if this base project is cost improved
					boolean isCostImproved = false;
					
					if ((previousResearchProj.getDesign() == baseProject.getDesign()) && (previousResearchProj.getFragrance() == baseProject.getFragrance()) 
							&& (previousResearchProj.getPersistence() == baseProject.getPersistence()) && 
							(previousResearchProj.getPackaging() == baseProject.getPackaging()) && (previousResearchProj.getSafety() == baseProject.getSafety()) 
							&& previousResearchProj.getRequestedBaseCost() <= baseProject.getRequestedBaseCost()) 
						isCostImproved = true;
					
					
					/*ResearchProject[] teamResearchProjects = researchProjectService.getResearchProjectsForTeamCurrentPeriod(team);
					for (ResearchProject researchProj : teamResearchProjects) {
						if (researchProj.getId() != baseProject.getId()) {
							if ((researchProj.getDesign() == baseProject.getDesign()) && (researchProj.getFragrance() == baseProject.getFragrance()) 
									&& (researchProj.getPersistence() == baseProject.getPersistence()) && 
									(researchProj.getPackaging() == baseProject.getPackaging()) && (researchProj.getSafety() == baseProject.getSafety()) 
									&& researchProj.getRequestedBaseCost() <= baseProject.getRequestedBaseCost()) 
								isCostImproved = true;
						}
					}*/
					
					// Now fetching the previous period brand research project
					// Also i will have to record the previous status of the of the brand. Based on this the Brand Specs will be updated. 
					
					boolean isPreviousBrandStatusMaintained = false;
					boolean isPreviousBrandStatusModified = false;
					boolean isPreviousBrandStatusCostImproved = false;
					
					
					Brand previousPeriodBrand = brandService.getBrandOnNameAndPeriod(toEditBrand.getBrandName(), (currentPeriod - 1));
					if (previousPeriodBrand != null) {
						ResearchProject previousPeriodRP = previousPeriodBrand.getResearchProject();
						if (previousPeriodRP.getProjectName().equalsIgnoreCase(baseProject.getProjectName())) {
							if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.MAINTAINED.getBrandStatus()))
									isPreviousBrandStatusMaintained = true;
							else if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.MODIFIED.getBrandStatus()))		
									isPreviousBrandStatusModified = true;
							else if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.COST_IMPROVEMENT.getBrandStatus()))
									isPreviousBrandStatusCostImproved = true;
									
							toEditBrand.setStatus(BrandStatus.MAINTAINED.getBrandStatus());
						}
						else if (isCostImproved) {
							// for brand status cost improvement
							if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.MAINTAINED.getBrandStatus()))
								isPreviousBrandStatusMaintained = true;
							else if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.MODIFIED.getBrandStatus()))		
								isPreviousBrandStatusModified = true;
							else if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.COST_IMPROVEMENT.getBrandStatus()))
								isPreviousBrandStatusCostImproved = true;
							
							toEditBrand.setStatus(BrandStatus.COST_IMPROVEMENT.getBrandStatus());
							
						}
						else {
							if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.MAINTAINED.getBrandStatus()))
								isPreviousBrandStatusMaintained = true;
							else if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.MODIFIED.getBrandStatus()))		
								isPreviousBrandStatusModified = true;
							else if (toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.COST_IMPROVEMENT.getBrandStatus()))
								isPreviousBrandStatusCostImproved = true;
							
							toEditBrand.setStatus(BrandStatus.MODIFIED.getBrandStatus());
						}
					}
					else {
						toEditBrand.setStatus(BrandStatus.NEW.getBrandStatus());
					}
					brandService.saveOrUpdateBrand(toEditBrand);
					
					//also have to update Brand Production and Pricing -- 
					//	Production & Pricing - Trading Co. value should become equal to current inventory when the base project is 
					//		changed for any brand and current inventory should become 0
					
					BrandSpecs updatedBrandSpecs = brandSpecsService.getBrandSpecsOnBrand(toEditBrand);
					long toEditBrandCurrentInventory = updatedBrandSpecs.getCurrentInventory();
					long toEditBrandInventorySold = updatedBrandSpecs.getInventorySold();
					
					if (previousPeriodBrand != null) {
						//ResearchProject previousPeriodRP = previousPeriodBrand.getResearchProject();
						
						if (isPreviousBrandStatusMaintained && ((toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.MODIFIED.getBrandStatus())) || 
								(toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.COST_IMPROVEMENT.getBrandStatus())))) {
							updatedBrandSpecs.setInventorySold(toEditBrandCurrentInventory);
							updatedBrandSpecs.setCurrentInventory(toEditBrandInventorySold);
						}
						else if ((isPreviousBrandStatusCostImproved || isPreviousBrandStatusModified) && 
									(toEditBrand.getStatus().equalsIgnoreCase(BrandStatus.MAINTAINED.getBrandStatus()))) {
							updatedBrandSpecs.setInventorySold(toEditBrandCurrentInventory);
							updatedBrandSpecs.setCurrentInventory(toEditBrandInventorySold);
						}
						
						brandSpecsService.updateBrandSpecs(updatedBrandSpecs);
						
					}
						
				}
			}
			
		}
		
		try {
			response.sendRedirect("brandManagement.htm");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	
	
	private void addBrandPerceptualObjectiveForNewBrandAdded(Brand newBrand) {
		PerceptualObj newBrandPerceptualObj = new PerceptualObj();
		newBrandPerceptualObj.setBrand(newBrand);
		newBrandPerceptualObj.setScale(PerceptualObjectiveScales.NO_OBJECTIVE.getPerceptualObjScale());
		newBrandPerceptualObj.setDimension1("-");
		newBrandPerceptualObj.setObjective1(0);
		newBrandPerceptualObj.setDimension2("-");
		newBrandPerceptualObj.setObjective2(0);
		
		perceptualObjService.savePerceptualObj(newBrandPerceptualObj);
	}

	private void addBrandSpecsForNewBrandAdded(Brand newBrand) {
		BrandSpecs newBrandSpecs = new BrandSpecs();
		newBrandSpecs.setBrand(newBrand);
		newBrandSpecs.setCurrentInventory(0);
		newBrandSpecs.setInventorySold(0);
		newBrandSpecs.setProductionLevel(0);
		newBrandSpecs.setRetailPrice(0);
		brandSpecsService.saveBrandSpecs(newBrandSpecs);
	
	}
	
	private void addBrandAdvForNewBrandAdded(Brand newBrand) {
		BrandAdvertisement newBrandAdv = new BrandAdvertisement();
		newBrandAdv.setBrand(newBrand);
		
		newBrandAdv.setAdvMediabudget(0);
		newBrandAdv.setAdvResearchBudget(0);
		
		newBrandAdv.setSegBlueBloods(0);
		newBrandAdv.setSegRaffles(0);
		newBrandAdv.setSegWannabees(0);
		newBrandAdv.setSegStrugglers(0);
		newBrandAdv.setSegDeprived(0);
		
		newBrandAdv.setMediumInternet(0);
		newBrandAdv.setMediumPrint(0);
		newBrandAdv.setMediumRadio(0);
		newBrandAdv.setMediumTelevision(0);
		
		brandAdvertisementService.saveBrandAdvertisement(newBrandAdv);
	}
	
	private void addBrandSalesForceForNewBrandAdded(Brand newBrand) {
		SalesForce newBrandSF = new SalesForce();
		newBrandSF.setBrand(newBrand);
		
		newBrandSF.setSupermarket_sf(0);
		newBrandSF.setKiranaStore_sf(0);
		newBrandSF.setGeneralStore_sf(0);
		
		salesForceService.saveSalesForce(newBrandSF);
		
	}
	
	private void addBrandMarginOfferedForNewBrandAdded(Brand newBrand) {
		MarginOffered newBrandMO = new MarginOffered();
		newBrandMO.setBrand(newBrand);
		newBrandMO.setSupermarket_mo(0);
		newBrandMO.setGeneralStore_mo(0);
		newBrandMO.setKiranaStore_mo(0);
		
		marginOfferedService.saveMarginOffered(newBrandMO);
		
	}
	
	
	public ModelAndView deleteBrandConfirmed(HttpServletRequest request, HttpServletResponse response) {
		if (request.getParameter("brandToDelete") != null) {
			long brandToDeleteId = Long.parseLong(request.getParameter("brandToDelete"));
			Brand brandToDelete = brandService.getBrandonId(brandToDeleteId);
			
			// here will have to delete this Brand and all the information accross th system for this Brand 
			//like the Production/Pricing and Adv expenses needs to be deleted
			deleteBrandSpecsForDeletedBrand(brandToDelete);
			deleteBrandAdvForDeletedBrand(brandToDelete);
			deleteBrandSalesForceForDeletedBrand(brandToDelete);
			deleteBrandMarginOfferedForDeletedBrand(brandToDelete);
			deleteBrandPerceptualObjective(brandToDelete);
			
			
			brandService.deleteBrandCascade(brandToDelete);
			
			
			// Now removing the session variables that are used to highlight tabs
			request.getSession().removeAttribute(Constants.SELECTED_BRAND);
			request.getSession().removeAttribute(Constants.SELECTED_BRAND_ADV);
			
			try {
				response.sendRedirect("brandManagement.htm");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	
		return null; 
	}
	
	private void deleteBrandSpecsForDeletedBrand(Brand deletedBrand) {
		BrandSpecs toDeleteBrandSpecs = brandSpecsService.getBrandSpecsOnBrand(deletedBrand);
		if (toDeleteBrandSpecs != null) 
			brandSpecsService.deleteBrandSpecs(toDeleteBrandSpecs);
	
	}
	
	private void deleteBrandAdvForDeletedBrand(Brand deletedBrand) {
		BrandAdvertisement toDeleteBrandAdv = brandAdvertisementService.getBrandAdvOnBrand(deletedBrand);
		if (toDeleteBrandAdv != null)
			brandAdvertisementService.deleteBrandAdvertisement(toDeleteBrandAdv);
	}
	
	private void deleteBrandSalesForceForDeletedBrand(Brand deletedBrand) {
		SalesForce toDeleteBrandSF = salesForceService.getSalesForceForBrand(deletedBrand);
		if (toDeleteBrandSF != null)
			salesForceService.deleteSalesForce(toDeleteBrandSF);
		
	}
	
	private void deleteBrandMarginOfferedForDeletedBrand(Brand deletedBrand) {
		MarginOffered newBrandMO = marginOfferedService.getMarginOfferedForBrand(deletedBrand);
		if (newBrandMO != null)
			marginOfferedService.deleteMarginOffered(newBrandMO);
	}
	
	private void deleteBrandPerceptualObjective(Brand toDeleteBrand) {
		PerceptualObj toDeleteBrandPerceptualObj = perceptualObjService.getPerceptualObjInputForBrand(toDeleteBrand);
		if (toDeleteBrandPerceptualObj != null) 
			perceptualObjService.deletePerceptualObj(toDeleteBrandPerceptualObj);
	}
	
	
}
 