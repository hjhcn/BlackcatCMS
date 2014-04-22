/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.interceptor;

import blackcat.SystemConstants;
import blackcat.annotation.UserAuthority;
import blackcat.model.User;
import blackcat.rules.FeedbackRule;
import blackcat.rules.UserRule;
import blackcat.utils.Http;
import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import net.sf.json.JSONObject;
import org.apache.struts2.ServletActionContext;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;

public class ApiInterceptor extends AbstractInterceptor {

	private static final long serialVersionUID = 1L;

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {

		Object action = invocation.getAction(); // 获得action
		String methodName = invocation.getProxy().getMethod(); // 通过action代理获得方法名
		Method method = action.getClass().getMethod(methodName);
		boolean needLogin;
		UserAuthority auth = method.getAnnotation(UserAuthority.class);
		if (auth != null) {
			needLogin = auth.needLogin();
			if (needLogin) {
				HttpServletRequest request = ServletActionContext.getRequest();
                String queryString=request.getQueryString();
				String url = "http://localhost:8080/api/json/user_userDetail_user";
				String reponseData = Http.getRemoteData(url, queryString,
						"application/x-www-form-urlencoded", "GET");
				JSONObject json = JSONObject.fromObject(reponseData);
				int feedback = json.getInt("feedback");
				if (feedback == SystemConstants.FEEDBACK.SUCCESS) {
					JSONObject userJson = json.getJSONObject("user");
					User user = new User();
					user.setUid(userJson.getInt("uid"));
					user.setUsername(userJson.getString("username"));
					if (action instanceof UserRule) {
						UserRule userRule = (UserRule) action;
						userRule.setUser(user);
					}
				} else {
					if (action instanceof FeedbackRule) {
						FeedbackRule feedbackRule = (FeedbackRule) action;
						feedbackRule.setFeedback(SystemConstants.FEEDBACK.USER_TOKEN_ERROR);
					}
					return Action.ERROR;
				}
			}
		}
		return invocation.invoke();
	}
}
