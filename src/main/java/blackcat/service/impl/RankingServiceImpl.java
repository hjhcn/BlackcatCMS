/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service.impl;

import blackcat.SystemConstants;
import blackcat.dao.RankingDao;
import blackcat.model.Ranking;
import blackcat.model.page.PageView;
import blackcat.service.RankingService;

import java.util.LinkedHashMap;

public class RankingServiceImpl implements RankingService {

	private RankingDao rankingDao;

	public void setRankingDao(RankingDao rankingDao) {
		this.rankingDao = rankingDao;
	}

	@Override
	public Ranking getRankingById(int uid) {
		return rankingDao.get(uid);
	}

	@Override
	public int update(Ranking ranking) {
		rankingDao.saveOrUpdate(ranking);
		return SystemConstants.FEEDBACK.SUCCESS;
	}

	@Override
	public PageView<Ranking> findScrollData(int page, int rows, String order, String sort) {
		PageView<Ranking> rankings = new PageView<Ranking>(page, rows);
		LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
		orderbyClause.put(sort, order);
		rankings.setQueryResult(rankingDao.findScrollData(page, rows, orderbyClause));
		return rankings;
	}

}
