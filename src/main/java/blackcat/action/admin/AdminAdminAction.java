/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.action.admin;

import blackcat.SystemConstants;
import blackcat.SystemConstants.AUTHORITY;
import blackcat.annotation.AdminAuthority;
import blackcat.model.Admin;
import blackcat.model.AdminStatistic;
import blackcat.model.LoginAdmin;
import blackcat.model.page.PageView;
import blackcat.service.AdminService;
import blackcat.utils.Ip;

import javax.servlet.http.HttpSession;

public class AdminAdminAction extends BaseAdminAction {
	private static final long serialVersionUID = 8595981534712690170L;

	private AdminService adminService;
	private String username;
	private String password;
	private PageView<Admin> admins;
	private String search;
	private String newPassword;
	private int aid;
	private AdminStatistic adminStatistic;
	private PageView<AdminStatistic> asView;

	@AdminAuthority(authority = AUTHORITY.SUPER)
	public String statisticAAdmin() {
		adminStatistic = adminService.statistic(aid);
		return SUCCESS;
	}

	@AdminAuthority(authority = AUTHORITY.SUPER)
	public String statistic() {
		asView = adminService.statistic();
		return SUCCESS;
	}

	public String login() {
		LoginAdmin loginAdmin = adminService.login(username, password, Ip.getIpAddr(request));
		feedback = loginAdmin.getFeedback();
		if (feedback == SystemConstants.FEEDBACK.SUCCESS) {
			session.put(SystemConstants.ADMIN_SESSION, loginAdmin.getAdmin());
			return SUCCESS;
		} else
			return LOGIN;
	}

	public String logout() {
		HttpSession session = request.getSession(false);
		if (session != null)
			session.removeAttribute(SystemConstants.ADMIN_SESSION);
		return SUCCESS;
	}

	public String password() {
		feedback = adminService.changePassword(admin.getId(), password, newPassword);
		return SUCCESS;
	}

	@AdminAuthority(authority = AUTHORITY.SUPER)
	public String list() {
		// 尚未优化
		admins = adminService.findScrollData(search, page, rows, order, sort);
		return SUCCESS;
	}

	public String getAdminByAid() {
		admin = adminService.getAdminById(aid);
		return SUCCESS;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setAdmin(Admin admin) {
		this.admin = admin;
	}

	public Admin getAdmin() {
		return admin;
	}

	public void setAdminService(AdminService adminService) {
		this.adminService = adminService;
	}

	public int getFeedback() {
		return feedback;
	}

	public void setAdmins(PageView<Admin> admins) {
		this.admins = admins;
	}

	public PageView<Admin> getAdmins() {
		return admins;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String setNewPassword() {
		return newPassword;
	}

	public int getAid() {
		return aid;
	}

	public void setAid(int aid) {
		this.aid = aid;
	}

	public AdminStatistic getAdminStatistic() {
		return adminStatistic;
	}

	public void setAdminStatistic(AdminStatistic adminStatistic) {
		this.adminStatistic = adminStatistic;
	}

	public PageView<AdminStatistic> getAsView() {
		return asView;
	}

	public void setAsView(PageView<AdminStatistic> asView) {
		this.asView = asView;
	}

}
