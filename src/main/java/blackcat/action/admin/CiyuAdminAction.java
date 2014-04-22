/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.action.admin;

import blackcat.SystemConstants.AUTHORITY;
import blackcat.SystemConstants.EXT_TYPE;
import blackcat.SystemConstants.OPERATE;
import blackcat.annotation.AdminAuthority;
import blackcat.model.Admin;
import blackcat.model.Ciyu;
import blackcat.model.page.PageView;
import blackcat.service.CiyuService;

public class CiyuAdminAction extends BaseAdminAction {

	private static final long serialVersionUID = -4163982429170402027L;
	private CiyuService ciyuService;
	private String ci;
	private PageView<Ciyu> ciyus;
	private Ciyu ciyu;
	private OPERATE operate;
	private String fileListStr;
	private String ids;
	private String statuses;
	private EXT_TYPE ext;

	@AdminAuthority(authority = AUTHORITY.SUPER)
	public String backupPassed() {
		ciyuService.backupPassed();
		return SUCCESS;
	}

	@AdminAuthority(authority = AUTHORITY.SUPER)
	public String batchGenThumb() {
		count = ciyuService.batchGenThumb();
		return SUCCESS;
	}

	public String ciyu() {
		ciyu = ciyuService.get(id);
		return SUCCESS;
	}

	public String list() {
		Admin findAdmin = admin;
		if (admin.getAuthority() != AUTHORITY.EDIT)
			findAdmin = null;
		ciyus = ciyuService.findScrollData(ci, findAdmin, statuses, page, rows, order, sort);
		return SUCCESS;
	}

	@AdminAuthority(authority = AUTHORITY.SUPER)
	public String batchSave() {
		feedback = ciyuService.batchSave(fileListStr, admin, ext);
		return SUCCESS;
	}

	@AdminAuthority(authority = AUTHORITY.SUPER)
	public String uploadOrEdit() {
		feedback = ciyuService.operate(ciyu, operate, admin);
		return SUCCESS;
	}

	@AdminAuthority(authority = AUTHORITY.SUPER)
	public String operate() {
		setCount(ciyuService.operate(ids, operate));
		return SUCCESS;
	}

	public void setCiyuService(CiyuService ciyuService) {
		this.ciyuService = ciyuService;
	}

	public String getCi() {
		return ci;
	}

	public void setCi(String ci) {
		this.ci = ci;
	}

	public PageView<Ciyu> getCiyus() {
		return ciyus;
	}

	public void setCiyus(PageView<Ciyu> ciyus) {
		this.ciyus = ciyus;
	}

	public Ciyu getCiyu() {
		return ciyu;
	}

	public void setCiyu(Ciyu ciyu) {
		this.ciyu = ciyu;
	}

	public String getFileListStr() {
		return fileListStr;
	}

	public void setFileListStr(String fileListStr) {
		this.fileListStr = fileListStr;
	}

	public OPERATE getOperate() {
		return operate;
	}

	public void setOperate(OPERATE operate) {
		this.operate = operate;
	}

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public String getStatuses() {
		return statuses;
	}

	public void setStatuses(String statuses) {
		this.statuses = statuses;
	}

	public EXT_TYPE getExt() {
		return ext;
	}

	public void setExt(EXT_TYPE ext) {
		this.ext = ext;
	}
}
