/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import blackcat.SystemConstants.AUTHORITY;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface AdminAuthority {
	int authority() default AUTHORITY.VIEW;
}
