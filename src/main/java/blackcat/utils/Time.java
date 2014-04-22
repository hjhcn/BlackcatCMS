/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.time.DateFormatUtils;

public class Time {
	public Time() {
	}

	public static int getTimeStamp() {
		long longTime = System.currentTimeMillis();
		return (int) (longTime / 1000);
	}

	public static String getTimeStampString() {
		String dateline = System.currentTimeMillis() + "";
		return dateline.substring(0, 10);
	}

	public static int getTimeStamp(String pattern) {
		Date date = new Date();
		SimpleDateFormat dateformat = new SimpleDateFormat(pattern);
		String sDateSuffix = dateformat.format(date);
		try {
			date = dateformat.parse(sDateSuffix);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return (int) (date.getTime() / 1000);
	}

	public static int getTimeStamp(int dateline, String pattern) {
		Date date = new Date();
		SimpleDateFormat dateformat = new SimpleDateFormat(pattern);
		String sDateSuffix = dateformat.format((long) dateline * 1000);
		try {
			date = dateformat.parse(sDateSuffix);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return (int) (date.getTime() / 1000);
	}

	public static int getTodayTimeStamp() {
		return Time.getTimeStamp("yyyy-MM-dd");
	}

	public static int getTodayTimeStamp(int dateline) {
		return Time.getTimeStamp(dateline, "yyyy-MM-dd");
	}

	public static int getMonthTimeStamp() {
		return Time.getTimeStamp("yyyy-MM-01");
	}

	public static int getMonthTimeStamp(int dateline) {
		return Time.getTimeStamp(dateline, "yyyy-MM-01");
	}

	public static String formatTimeStamp(int timestamp, String pattern) {
		return DateFormatUtils.format((long) timestamp * 1000, pattern);
	}

	public static String formatTimeStamp(long timestamp, String pattern) {
		return DateFormatUtils.format(timestamp, pattern);
	}

	public static String formatCurrentTime(String pattern) {
		return DateFormatUtils.format(System.currentTimeMillis(), pattern);
	}

	public static String timeToStr(int timestamp) {
		int time = getTimeStamp() - timestamp;
		if (time < 60) {
			return time + "秒前";
		} else if (time >= 60 && time < 3600) {
			return time / 60 + "分钟前";
		} else if (time >= 3600 && time < (3600 * 24)) {
			return time / 3600 + "小时前";
		} else if (time > (3600 * 24) && time < (3600 * 24 * 365)) {
			return time / (3600 * 24) + "天前";
		} else
			return time / (3600 * 24 * 365) + "年前";
	}

	public String timeToCountdown(int timestamp) {
		int time = getTimeStamp() - timestamp;
		if (time < 60) {
			return time + "秒前";
		} else if (time >= 60 && time < 3600) {
			return time / 60 + "分钟前";
		} else if (time >= 3600 && time < (3600 * 24)) {
			return time / 3600 + "小时前";
		} else if (time > (3600 * 24) && time < (3600 * 24 * 365)) {
			return time / (3600 * 24) + "天前";
		} else
			return time / (3600 * 24 * 365) + "年前";
	}

	public String timeFormat(int timestamp, String pattern) {
		return DateFormatUtils.format((long) timestamp * 1000, pattern);
	}

	public static boolean checkDate(String date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		sdf.setLenient(false);
		try {
			sdf.parse(date);
		} catch (Exception ex) {
			return false;
		}
		return true;
	}

	public static void main(String[] args) {
		System.out.println(Time.getTodayTimeStamp());
		System.out.println(Time.getTodayTimeStamp(1367542400));
		System.out
				.println(formatTimeStamp(1367510400, "yyyy-MM-dd HH::mm::ss"));

	}
}
