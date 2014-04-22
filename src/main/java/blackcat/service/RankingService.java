/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service;

import blackcat.model.Ranking;
import blackcat.model.page.PageView;

public interface RankingService {
	public Ranking getRankingById(int uid);

	public int update(Ranking ranking);

	public PageView<Ranking> findScrollData(int page, int rows, String order, String sort);

}
