/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service;

import blackcat.SystemConstants.OPERATE;
import blackcat.model.Admin;
import blackcat.model.Hanzi;
import blackcat.model.HanziStatistic;
import blackcat.model.Zuciju;
import blackcat.model.page.PageView;

import java.util.Map;
import java.util.List;

public interface HanziService {
	public PageView<Hanzi> findScrollData(Admin admin, String zi, String statuses,
                                          int selected, int page, int rows, String order, String sort);

	public Hanzi get(int id);

	public Hanzi get(String zi);

    public Hanzi getDetail(int id);

	public int updateContourLocus(Hanzi hanzi);

	public int operate(String ids, OPERATE operate);

    public HanziStatistic statistic(int aid);

    public Map<Integer, HanziStatistic> statistic();

    public int batchSaveAudio(String fileListStr, Admin admin);

    public void backupPassed();

    public int updateZuciju(Zuciju zuciju);

    public int updataZuciju(int hid,List<Zuciju> zucijuList);
}
