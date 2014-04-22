/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.dao.impl;

import blackcat.dao.BaseDao;
import blackcat.model.page.QueryResult;
import blackcat.utils.GenericsUtils;
import org.hibernate.Query;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@SuppressWarnings("unchecked")
public class BaseDaoImpl<T> extends HibernateDaoSupport implements BaseDao<T> {

	protected Class<T> entityClass = GenericsUtils.getSuperClassGenricType(this.getClass());

	public void delete(int id) {
		this.getHibernateTemplate().delete(this.get(id));
	}

	public void delete(T entity) {
		this.getHibernateTemplate().delete(entity);
	}

	public void update(T entity) {
		this.getHibernateTemplate().update(entity);
	}

	public void saveOrUpdate(T entity) {
		this.getHibernateTemplate().saveOrUpdate(entity);
	}

	public T get(int id) {
		return this.getHibernateTemplate().get(entityClass, id);
	}

	public void execute(String hql) {
		getSession().createQuery(hql).executeUpdate();
	}

	public List<T> findAll() {
		String queryString = "from " + entityClass.getSimpleName();
		return getHibernateTemplate().find(queryString);
	}

	public List<T> findTopData(int pageSize, List<String> whereClause, List<String> groupbyClause,
			LinkedHashMap<String, String> orderbyClause) {
		Query q = getSession().createQuery(
				"from " + entityClass.getSimpleName() + " entity " + buildWhereClause(whereClause)
						+ buildGroupByClause(groupbyClause) + buildOrderByClause(orderbyClause));
		q.setFirstResult(0).setMaxResults(pageSize);
		return q.list();
	}

	public List<T> findByProperty(String propertyName, Object value) {
		String queryString = "from " + entityClass.getSimpleName() + " entity where entity."
				+ propertyName + "= ?";
		return getHibernateTemplate().find(queryString, value);
	}

	public QueryResult<T> findScrollData(int pageNum, int pageSize) {
		return this.findScrollData(pageNum, pageSize, null, null);
	}

	public QueryResult<T> findScrollData(int start, int maxResults, List<String> whereClause) {
		return this.findScrollData(start, maxResults, whereClause, null);
	}

	public QueryResult<T> findScrollData(int pageNum, int pageSize,
			LinkedHashMap<String, String> orderbyClause) {
		return this.findScrollData(pageNum, pageSize, null, orderbyClause);
	}

	public QueryResult<T> findScrollData(int pageNum, int pageSize, List<String> whereClause,
			LinkedHashMap<String, String> orderbyClause) {
		int start = pageNum > 0 ? (pageNum - 1) * pageSize : 0;
		QueryResult<T> qr = new QueryResult<T>();
		Query q = getSession().createQuery(
				"select count(*) from " + entityClass.getSimpleName() + " entity "
						+ buildWhereClause(whereClause));
		int count = Integer.parseInt(q.uniqueResult() + "");
		if (start >= count)
			start = count - 1 - pageSize;
		q = getSession().createQuery(
				"from " + entityClass.getSimpleName() + " entity " + buildWhereClause(whereClause)
						+ buildOrderByClause(orderbyClause));
		q.setFirstResult(start).setMaxResults(pageSize);
		qr.setResultlist(q.list());
		qr.setTotalrecord(count);
		return qr;
	}

	/**
	 * 建立排序子句
	 */
	protected String buildOrderByClause(LinkedHashMap<String, String> orderbyClause) {
		StringBuilder orderby = new StringBuilder("");
		if (orderbyClause != null && orderbyClause.size() > 0) {
			orderby.append(" order by ");
			for (String prop : orderbyClause.keySet()) {
				orderby.append(" entity.").append(prop).append(" ").append(orderbyClause.get(prop))
						.append(",");
			}
			orderby.deleteCharAt(orderby.length() - 1);
		}
		return orderby.toString();
	}

	/**
	 * 根据过滤条件收集器建立where子句
	 */
	protected String buildWhereClause(List<String> whereClause) {
		StringBuilder where = new StringBuilder("");
		if (whereClause != null && whereClause.size() > 0) {
			where.append(" ").append("where ");
			for (String str : whereClause) {
				where.append(" (entity.").append(str).append(") and ");
				// 为实现‘或’
				// where.append(" entity.").append(str).append(" and ");
			}
			where.delete(where.lastIndexOf("and"), where.length() - 1);
		}
		return where.toString();
	}

	/**
	 * 根据过滤条件收集器建立group子句
	 */
	protected String buildGroupByClause(List<String> groupbyClause) {
		StringBuilder groupby = new StringBuilder("");
		if (groupbyClause != null && groupbyClause.size() > 0) {
			groupby.append(" ").append("group by ");
			for (String str : groupbyClause) {
				groupby.append("entity.").append(str).append(",");
			}
			groupby.deleteCharAt(groupby.length() - 1);
		}
		return groupby.toString();
	}

	public List<T> findAllData(List<String> whereClause, List<String> groupbyClause,
			LinkedHashMap<String, String> orderbyClause) {
		Query q = getSession().createQuery(
				"from " + entityClass.getSimpleName() + " entity " + buildWhereClause(whereClause)
						+ buildGroupByClause(groupbyClause) + buildOrderByClause(orderbyClause));
		return q.list();
	}

	public int getCount(List<String> whereClause) {
		String hql = "select count(*) from " + entityClass.getSimpleName() + " entity "
				+ buildWhereClause(whereClause);
		Query q = getSession().createQuery(hql);
		return Integer.parseInt(q.uniqueResult() + "");
	}

	public int operate(List<String> whereClause, String expression, String propertyName) {
		Query q = getSession().createQuery(
				"select " + expression + "(entity." + propertyName + ") from "
						+ entityClass.getSimpleName() + " entity " + buildWhereClause(whereClause));
		if (q.uniqueResult() == null)
			return 0;
		return Integer.parseInt(q.uniqueResult() + "");
	}

	public List<?> statistic(Map<String, String> expClause, List<String> whereClause,
			LinkedList<String> groupbyClause, LinkedHashMap<String, String> orderbyClause) {

		StringBuilder groupby = new StringBuilder("");
		if (groupbyClause != null && groupbyClause.size() > 0) {
			for (String str : groupbyClause) {
				groupby.append("entity.").append(str).append(",");
			}
			// 最后一个逗号用于和expSB合并
		}

		StringBuffer expSB = new StringBuffer("");
		for (Map.Entry<String, String> entry : expClause.entrySet()) {
			expSB.append(entry.getValue() + " as " + entry.getKey()).append(",");
		}
		expSB.deleteCharAt(expSB.length() - 1);

		Query q = getSession().createQuery(
				"select " + groupby + expSB + " from " + entityClass.getSimpleName() + " entity "
						+ buildWhereClause(whereClause) + buildGroupByClause(groupbyClause)
						+ buildOrderByClause(orderbyClause));
		return q.list();
	}
}
