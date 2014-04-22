/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.action;

import java.util.HashMap;
import java.util.Map;

import blackcat.SystemConstants;
import blackcat.model.Ciyu;
import blackcat.model.Hanzi;
import blackcat.model.page.PageView;
import blackcat.service.CiyuService;
import blackcat.service.HanziService;

public class HanziAction extends BaseAction {

	private static final long serialVersionUID = 3803528812353674046L;
	private String zi;
	private Hanzi hanzi;
	private HanziService hanziService;
	private CiyuService ciyuService;
	private int rows = 50;
	private String sort = "bihuashu";
	private String order = "asc";
	private static PageView<Hanzi> hanzis;
	private static Map<String, Hanzi> hanziMap;
	private PageView<Ciyu> ciyus;

	private void initData(String zi) {
		if (hanzis == null) {
			page = 1;
			rows = 10000;
			hanzis = hanziService.findScrollData(null, zi, "4", 1, page, rows, order, sort);
			hanziMap = new HashMap<String, Hanzi>();
			for (Hanzi hanzi : hanzis.getRows()) {
				hanziMap.put(hanzi.getZi(), hanzi);
			}

		}
	}

	public String list() {
		initData(zi);
		return SUCCESS;
	}

	public String hanzi() {
		initData("");
		if (hanzis != null) {
			hanzi = hanziMap.get(zi);
			if (hanzi != null) {
				feedback = SystemConstants.FEEDBACK.HANZI_LIMITED;
			} else {

			}
		} else {
			feedback = SystemConstants.FEEDBACK.UNKNOW_ERROR;
		}
		return SUCCESS;
	}

	public String ciyu() {
		sort = "id";
		ciyus = ciyuService.findScrollData(zi, null, "2", page, rows, order, sort);
		return SUCCESS;
	}

	public PageView<Hanzi> getHanzis() {
		return hanzis;
	}

	public String getZi() {
		return zi;
	}

	public void setZi(String zi) {
		this.zi = zi;
	}

	public Hanzi getHanzi() {
		return hanzi;
	}

	public void setHanzi(Hanzi hanzi) {
		this.hanzi = hanzi;
	}

	public HanziService getHanziService() {
		return hanziService;
	}

	public void setHanziService(HanziService hanziService) {
		this.hanziService = hanziService;
	}

	public PageView<Ciyu> getCiyus() {
		return ciyus;
	}

	public void setCiyuService(CiyuService ciyuService) {
		this.ciyuService = ciyuService;
	}

}
