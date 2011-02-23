package com.marklabs.researchProject;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.marklabs.teams.Team;

/**
 * @date 04/25/2010
 * @author Tapan
 *
 */
public class ResearchProjectService extends HibernateDaoSupport implements IResearchProjectService {
	
	public ResearchProject[] getAllResearchProjectsForTeam(long teamId) {
		String query = "from ResearchProject where teamId = "+teamId;
		List result = getHibernateTemplate().find(query);
		if (result != null && result.size() > 0)
			return (ResearchProject[])result.toArray(new ResearchProject[result.size()]);
        return null;
	}
	
	public void saveResearchProject(ResearchProject researchProject) {
		getHibernateTemplate().save(researchProject);
	}

	public ResearchProject[] getResearchProjectsForTeamCurrentPeriod(Team team) {
		String query = "from ResearchProject where teamId = "+team.getId() +" and " +
				"currentPeriod = "+team.getCurrentTeamPeriod();
		List result = getHibernateTemplate().find(query);
		if (result != null && result.size() > 0)
			return (ResearchProject[])result.toArray(new ResearchProject[result.size()]);
        return null;
	}

	public ResearchProject[] getResearchProjForTeamByProjFinishPeriod(long teamId, int projFinishPeriod) {
		String query = "from ResearchProject where teamId = "+teamId +" and " +
				"projectFinishPeriod = "+projFinishPeriod;
		List result = getHibernateTemplate().find(query);
		if (result != null && result.size() > 0)
			return (ResearchProject[])result.toArray(new ResearchProject[result.size()]);
        return null;
	}
	
	@Override
	public ResearchProject[] getCompletedResearchProjectsForTeam(long teamId, int currentPeriod) {
		String query = "from ResearchProject where teamId = "+teamId +" and " +
			"projectFinishPeriod <= "+currentPeriod + " and currentPeriod = "+currentPeriod;
		List<ResearchProject> result = getHibernateTemplate().find(query);
		if (result != null && result.size() > 0)
			return (ResearchProject[])result.toArray(new ResearchProject[result.size()]);
		return null;
	}

	public ResearchProject[] getResearchProjForTeamPreviousPeriod(long teamId, int currentPeriod) {
		String query = "from ResearchProject where teamId = "+teamId +" and " +
				"currentPeriod = "+(currentPeriod-1);
		List result = getHibernateTemplate().find(query);
		if (result != null && result.size() > 0)
			return (ResearchProject[])result.toArray(new ResearchProject[result.size()]);
        return null;
	}

	
	public ResearchProject getResearcProjectByID(long researchProjectId) {
		String queryString = "from ResearchProject where id = "+ researchProjectId;
		List result = getHibernateTemplate().find(queryString);
		
		if (result != null && result.size() > 0)
			return (ResearchProject) result.get(0);
		
		return null;
	}
	
	public void deleteResearchProject(ResearchProject toDeleteResearchProject) {
		getHibernateTemplate().delete(toDeleteResearchProject);
	}
	
	public void updateResearchProject(ResearchProject toUpdateResearchProject) {
		getHibernateTemplate().update(toUpdateResearchProject);
	}

	
}