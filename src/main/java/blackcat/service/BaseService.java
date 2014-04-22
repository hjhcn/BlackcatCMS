/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service;

import blackcat.model.page.PageView;

public interface BaseService<T> {
	public T get(int id);

	public PageView<T> findScrollData(int page, int rows, String order, String sort);

	public boolean delete(int id);

	public boolean saveOrUpdate(T obj);

}
