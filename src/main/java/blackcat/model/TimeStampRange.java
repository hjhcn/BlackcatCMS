/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

import blackcat.SystemConstants;
import blackcat.utils.Time;

public class TimeStampRange implements java.io.Serializable {
	private static final long serialVersionUID = -3197894090253287627L;
	private int startTimeStamp;
	private int endTimeStamp;

	public TimeStampRange() {
		this.startTimeStamp = SystemConstants.OPENING_TIMESTAMP;
		this.endTimeStamp = Time.getTimeStamp();
	}

	public TimeStampRange(int startTimeStamp, int endTimeStamp) {
		this.startTimeStamp = endTimeStamp;
		this.endTimeStamp = endTimeStamp;
	}

	public int getStartTimeStamp() {
		return startTimeStamp;
	}

	public void setStartTimeStamp(int startTimeStamp) {
		this.startTimeStamp = startTimeStamp;
	}

	public int getEndTimeStamp() {
		return endTimeStamp;
	}

	public void setEndTimeStamp(int endTimeStamp) {
		this.endTimeStamp = endTimeStamp;
	}

	public boolean isValid() {
		if (startTimeStamp > 0 && endTimeStamp > 0 && startTimeStamp < endTimeStamp) {
			return true;
		} else
			return false;
	}
}
