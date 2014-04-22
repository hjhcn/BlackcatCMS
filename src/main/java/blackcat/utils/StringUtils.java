/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.utils;

import java.util.regex.Pattern;

public class StringUtils {
	public static boolean isAllHanzi(String ci) {
		String regEx = "^[\u4e00-\u9fa5]{0,}$";
		return Pattern.matches(regEx, ci);
	}
}
