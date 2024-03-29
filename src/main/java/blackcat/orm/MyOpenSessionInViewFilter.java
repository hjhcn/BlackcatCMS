/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.orm;

import org.hibernate.FlushMode;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.orm.hibernate3.support.OpenSessionInViewFilter;

public class MyOpenSessionInViewFilter extends OpenSessionInViewFilter {
	@Override
	protected void closeSession(Session session, SessionFactory sessionFactory) {
		session.flush();
		session.getTransaction().commit();
		super.closeSession(session, sessionFactory);
	}

	@Override
	protected Session getSession(SessionFactory sessionFactory)
			throws DataAccessResourceFailureException {
		Session session = SessionFactoryUtils.getSession(sessionFactory, true);
		session.beginTransaction();
		FlushMode flushMode = getFlushMode();
		if (flushMode != null) {
			this.setFlushMode(FlushMode.AUTO);
		}
		return session;
	}
}
