/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.dao.impl;

import blackcat.dao.AdminDao;
import blackcat.model.Admin;

import java.util.List;

public class AdminDaoImpl extends BaseDaoImpl<Admin> implements AdminDao {
	@SuppressWarnings("unchecked")
	public Admin getByUsername(String username) {
		List<Admin> admins = this.getHibernateTemplate().find("from Admin where username=?",
				username);
		if (admins.size() > 0)
			return admins.get(0);
		else
			return null;
	}

	public Admin getByUid(int uid) {
		List<Admin> admins = this.findByProperty("user.uid", uid);
		if (admins.size() > 0)
			return admins.get(0);
		else
			return null;
	}
}
