/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.orm;

import java.sql.Types;

import org.hibernate.Hibernate;
import org.hibernate.dialect.MySQL5Dialect;

public class MySQLServerDialect extends MySQL5Dialect {
	public MySQLServerDialect() {
		super();
//		registerHibernateType(Types.DECIMAL, Hibernate.BIG_DECIMAL.getName());
//		registerHibernateType(-1, Hibernate.STRING.getName());
	}
}
