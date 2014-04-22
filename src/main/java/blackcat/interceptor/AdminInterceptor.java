/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.interceptor;

import java.lang.reflect.Method;

import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import blackcat.SystemConstants;
import blackcat.annotation.AdminAuthority;
import blackcat.model.Admin;
import blackcat.rules.AdminSessionRule;
import blackcat.rules.FeedbackRule;

import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

public class AdminInterceptor extends AbstractInterceptor {

	private static final long serialVersionUID = 77362167764460002L;

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {
		String methodName = invocation.getProxy().getMethod();
		Method currentMethod = invocation.getAction().getClass().getMethod(methodName);
		HttpSession session = ServletActionContext.getRequest().getSession();
		Admin admin = (Admin) session.getAttribute(SystemConstants.ADMIN_SESSION);
		Object action = invocation.getAction();
		int feedback = SystemConstants.FEEDBACK.SUCCESS;
		if (null != admin) {
			action = invocation.getAction();
			if (action instanceof AdminSessionRule) {
				if (currentMethod.isAnnotationPresent(AdminAuthority.class)) {
					AdminAuthority authority = currentMethod.getAnnotation(AdminAuthority.class);
					int auth = authority.authority();
					if (admin.getAuthority() > auth) {
						feedback = SystemConstants.FEEDBACK.ADMIN_AUTH_ERROR;
					}
				}
			}
		} else
			feedback = SystemConstants.FEEDBACK.ADMIN_UNLOGIN_ERROR;

		if (feedback == SystemConstants.FEEDBACK.SUCCESS) {
			AdminSessionRule adminSessionRule = (AdminSessionRule) action;
			adminSessionRule.setAdminSession(admin);
			return invocation.invoke();
		} else {
			if (action instanceof FeedbackRule) {
				FeedbackRule feedbackRule = (FeedbackRule) action;
				feedbackRule.setFeedback(feedback);
			}
			return Action.ERROR;
		}

	}

}
