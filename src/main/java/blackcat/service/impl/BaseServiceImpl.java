/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service.impl;

import java.util.LinkedHashMap;

import blackcat.dao.BaseDao;
import blackcat.model.page.PageView;
import blackcat.service.BaseService;

public class BaseServiceImpl<T> implements BaseService<T> {
	public BaseDao<T> baseDao;

	@Override
	public T get(int id) {
		return baseDao.get(id);
	}

	@Override
	public PageView<T> findScrollData(int page, int rows, String order, String sort) {
		PageView<T> datas = new PageView<T>(page, rows);
		LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
		orderbyClause.put(sort, order);
		datas.setQueryResult(baseDao.findScrollData(page, rows, orderbyClause));
		return datas;
	}

	@Override
	public boolean delete(int id) {
		baseDao.delete(id);
		return true;
	}

	@Override
	public boolean saveOrUpdate(T obj) {
		baseDao.saveOrUpdate(obj);
		return true;
	}

	public void setBaseDao(BaseDao<T> baseDao) {
		this.baseDao = baseDao;
	}

}
