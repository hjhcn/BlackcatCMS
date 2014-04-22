/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.action;

import blackcat.SystemConstants;
import blackcat.model.TimeStampRange;
import blackcat.rules.EasyUiDataGrid;
import blackcat.rules.FeedbackRule;

import com.opensymphony.xwork2.ActionSupport;

public class BaseAction extends ActionSupport implements FeedbackRule, EasyUiDataGrid {
	private static final long serialVersionUID = 4186341131437455986L;

	public int feedback = SystemConstants.FEEDBACK.SUCCESS;

	public int page = 1;
	public int rows = 10;
	public String sort = "id";
	public String order = "desc";
	public int id = 0;
	public TimeStampRange tsRange = new TimeStampRange();

	public int getFeedback() {
		return this.feedback;
	}

	public void setFeedback(int feedback) {
		this.feedback = feedback;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public void setTsRange(TimeStampRange tsRange) {
		this.tsRange = tsRange;
	}

	public TimeStampRange getTsRange() {
		return tsRange;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
}
