/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service.impl;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import blackcat.SystemConstants;
import blackcat.dao.AdminDao;
import blackcat.model.Admin;
import blackcat.model.AdminStatistic;
import blackcat.model.CiyuStatistic;
import blackcat.model.HanziStatistic;
import blackcat.model.LoginAdmin;
import blackcat.model.page.PageView;
import blackcat.model.page.QueryResult;
import blackcat.service.AdminService;
import blackcat.service.CiyuService;
import blackcat.service.HanziService;
import blackcat.utils.MD5;
import blackcat.utils.Time;

public class AdminServiceImpl implements AdminService {
	private AdminDao adminDao;
	private HanziService hanziService;
	private CiyuService ciyuService;

	public void setHanziService(HanziService hanziService) {
		this.hanziService = hanziService;
	}

	public void setCiyuService(CiyuService ciyuService) {
		this.ciyuService = ciyuService;
	}

	public void setAdminDao(AdminDao adminDao) {
		this.adminDao = adminDao;
	}

	public Admin getAdminById(int id) {
		return adminDao.get(id);
	}

	public LoginAdmin login(String username, String password, String ip) {
		List<Admin> admins = adminDao.findByProperty("username", username);
		LoginAdmin loginAdmin = new LoginAdmin();
		int feedback = SystemConstants.FEEDBACK.SUCCESS;
		MD5 md5 = new MD5();
		if (admins.size() > 0) {
			Admin admin = admins.get(0);
			if (!md5.getMD5ofStr(password).equals(admin.getPassword()))
				feedback = SystemConstants.FEEDBACK.ADMIN_LOGIN_PASW_ERROR;
			else {
				admin.setLastTime(Time.getTimeStamp());
				admin.setLastIp(ip);
				adminDao.saveOrUpdate(admin);
			}
			loginAdmin.setAdmin(admin);
		} else
			feedback = SystemConstants.FEEDBACK.ADMIN_USERNAME_NOTEXSIT;
		loginAdmin.setFeedback(feedback);
		return loginAdmin;
	}

	public PageView<Admin> findScrollData(String search, int page, int rows, String order,
			String sort) {
		ArrayList<String> whereClause = new ArrayList<String>();
		if (search != null && !"".equals(search)) {
			whereClause.add("title like '%" + search + "%'");
		}
		PageView<Admin> admins = new PageView<Admin>(page, rows);
		LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
		orderbyClause.put(sort, order);
		admins.setQueryResult(adminDao.findScrollData(page, rows, whereClause, orderbyClause));
		return admins;
	}

	public int changePassword(int id, String OldPassword, String newPassword) {
		if (!checkPassword(newPassword))
			return SystemConstants.FEEDBACK.ADMIN_NEW_PASW_ERROR;
		Admin admin = adminDao.get(id);
		if (admin == null)
			return SystemConstants.FEEDBACK.ADMIN_UID_NOTEXSIT;
		if (!admin.getPassword().equals(new MD5().getMD5ofStr(OldPassword)))
			return SystemConstants.FEEDBACK.ADMIN_LOGIN_PASW_ERROR;
		else {
			admin.setPassword(new MD5().getMD5ofStr(newPassword));
			adminDao.saveOrUpdate(admin);
			return SystemConstants.FEEDBACK.SUCCESS;
		}
	}

	public boolean checkPassword(String password) {
		if (password != null && password.length() >= 6 && password.length() <= 16)
			return true;
		else
			return false;
	}

	@Override
	public AdminStatistic statistic(int id) {
		AdminStatistic as = new AdminStatistic();
		as.setHs(hanziService.statistic(id));
		as.setCs(ciyuService.statistic(id));
		return as;
	}

	public PageView<AdminStatistic> statistic() {
		List<AdminStatistic> asList = new ArrayList<AdminStatistic>();
		Map<Integer, HanziStatistic> hsMap = hanziService.statistic();
		Map<Integer, CiyuStatistic> csMap = ciyuService.statistic();

		for (Map.Entry<Integer, HanziStatistic> entry : hsMap.entrySet()) {
			AdminStatistic as = new AdminStatistic();
			int aid = entry.getKey();
			Admin admin = adminDao.get(aid);
			if (admin != null) {
				as.setAdmin(admin);
				as.setHs(entry.getValue());
				as.setCs(csMap.get(aid));
				csMap.remove(aid);
				asList.add(as);
			}
		}

		for (Map.Entry<Integer, CiyuStatistic> entry : csMap.entrySet()) {
			AdminStatistic as = new AdminStatistic();
			int aid = entry.getKey();
			Admin admin = adminDao.get(aid);
			if (admin != null) {
				as.setAdmin(admin);
				as.setCs(entry.getValue());
				as.setHs(hsMap.get(aid));
				asList.add(as);
			}
		}

		QueryResult<AdminStatistic> asQR = new QueryResult<AdminStatistic>();
		asQR.setResultlist(asList);
		asQR.setTotalrecord(asList.size());
		PageView<AdminStatistic> asView = new PageView<AdminStatistic>(1, asList.size());
		asView.setQueryResult(asQR);

		return asView;
	}

}
