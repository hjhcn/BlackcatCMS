/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.action.admin;

import blackcat.action.BaseAction;
import blackcat.model.Admin;
import blackcat.rules.AdminSessionRule;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;

public class BaseAdminAction extends BaseAction implements SessionAware, ServletRequestAware,
		ServletResponseAware, AdminSessionRule {

	private static final long serialVersionUID = 2157561654358344088L;
	public Map<String, Object> session;
	public HttpServletResponse response;
	public HttpServletRequest request;
	public Admin admin;
	public int count;

	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
	}

	public void setServletResponse(HttpServletResponse response) {
		this.response = response;
	}

	public void setAdminSession(Admin admin) {
		this.admin = admin;
	}

	public final String execute() {
		return SUCCESS;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

}
