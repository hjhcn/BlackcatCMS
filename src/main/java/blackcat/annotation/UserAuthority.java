/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.annotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface UserAuthority {
	boolean needLogin();

	int verification() default 0;
}