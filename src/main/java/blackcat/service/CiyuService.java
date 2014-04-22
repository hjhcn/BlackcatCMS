/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service;

import java.util.Map;

import blackcat.SystemConstants.EXT_TYPE;
import blackcat.SystemConstants.OPERATE;
import blackcat.model.Admin;
import blackcat.model.Ciyu;
import blackcat.model.CiyuStatistic;
import blackcat.model.page.PageView;

public interface CiyuService {
	public int operate(Ciyu ciyuUpload, OPERATE operate, Admin admin);

	public int operate(String ids, OPERATE operate);

	public PageView<Ciyu> findScrollData(String ci, Admin admin, String statuses, int page,
                                         int rows, String order, String sort);

	public Ciyu get(int id);

	public int batchSave(String fileListStr, Admin admin, EXT_TYPE ext);

	public CiyuStatistic statistic(int aid);

	public Map<Integer, CiyuStatistic> statistic();

	public int batchGenThumb();

	public void backupPassed();
}
