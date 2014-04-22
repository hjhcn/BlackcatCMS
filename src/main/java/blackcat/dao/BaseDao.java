/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.dao;

import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import blackcat.model.page.QueryResult;

public interface BaseDao<T> {
	public void delete(int id);

	public T get(int id);

	public void delete(T entity);

	public void update(T entity);

	public void saveOrUpdate(T entity);

	public void execute(String hql);

	public int getCount(List<String> whereClause);

	public int operate(List<String> whereClause, String expression, String propertyName);

	/**
	 * Return the query results as a <tt>List</tt>. If the query contains multiple results pre row,
	 * the results are returned in an instance of <tt>Object[]</tt>.
	 * 
	 */
	public List<?> statistic(Map<String, String> expClause, List<String> whereClause,
                             LinkedList<String> groupbyClause, LinkedHashMap<String, String> orderbyClause);

	public List<T> findAll();

	public List<T> findAllData(List<String> whereClause, List<String> groupbyClause,
                               LinkedHashMap<String, String> orderbyClause);

	public List<T> findTopData(int pageSize, List<String> whereClause, List<String> groupbyClause,
                               LinkedHashMap<String, String> orderbyClause);

	public List<T> findByProperty(String propertyName, Object value);

	public QueryResult<T> findScrollData(int pageNum, int pageSize);

	public QueryResult<T> findScrollData(int start, int maxResults, List<String> whereClause);

	public QueryResult<T> findScrollData(int pageNum, int pageSize,
                                         LinkedHashMap<String, String> orderbyClause);

	public QueryResult<T> findScrollData(int pageNum, int pageSize, List<String> whereClause,
                                         LinkedHashMap<String, String> orderbyClause);
}
