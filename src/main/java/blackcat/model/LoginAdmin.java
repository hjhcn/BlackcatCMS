/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

/**
 * 该类用于登陆时返回管理员信息
 */
public class LoginAdmin {
	private Admin admin;
	private int feedback;

	public Admin getAdmin() {
		return admin;
	}

	public void setAdmin(Admin admin) {
		this.admin = admin;
	}

	public int getFeedback() {
		return feedback;
	}

	public void setFeedback(int feedback) {
		this.feedback = feedback;
	}
}
