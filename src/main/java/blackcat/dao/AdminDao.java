/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.dao;

import blackcat.model.Admin;

public interface AdminDao extends BaseDao<Admin> {
	public Admin getByUsername(String username);

	public Admin getByUid(int uid);
}
