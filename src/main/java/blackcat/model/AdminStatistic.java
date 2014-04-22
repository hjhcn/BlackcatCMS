/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

public class AdminStatistic {
	private Admin admin;
	private HanziStatistic hs;
	private CiyuStatistic cs;

	public HanziStatistic getHs() {
		return hs;
	}

	public void setHs(HanziStatistic hs) {
		this.hs = hs;
	}

	public CiyuStatistic getCs() {
		return cs;
	}

	public void setCs(CiyuStatistic cs) {
		this.cs = cs;
	}

	public Admin getAdmin() {
		return admin;
	}

	public void setAdmin(Admin admin) {
		this.admin = admin;
	}

}
