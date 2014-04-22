/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service;

import blackcat.model.Admin;
import blackcat.model.AdminStatistic;
import blackcat.model.LoginAdmin;
import blackcat.model.page.PageView;

public interface AdminService {
	public LoginAdmin login(String username, String password, String ip);

	public Admin getAdminById(int id);

	public PageView<Admin> findScrollData(String search, int page, int rows, String order,
                                          String sort);

	public int changePassword(int id, String OldPassword, String newPassword);

	public AdminStatistic statistic(int id);
	public PageView<AdminStatistic> statistic();
}
