/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model.page;

import java.util.List;

public class QueryResult<T> {
	private List<T> resultlist;
	private long totalrecord;

	public List<T> getResultlist() {
		return resultlist;
	}

	public void setResultlist(List<T> resultlist) {
		this.resultlist = resultlist;
	}

	public long getTotalrecord() {
		return totalrecord;
	}

	public void setTotalrecord(long totalrecord) {
		this.totalrecord = totalrecord;
	}
}