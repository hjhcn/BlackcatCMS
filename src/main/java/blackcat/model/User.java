/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

import java.util.UUID;

import org.apache.struts2.json.annotations.JSON;

/**
 * @hibernate.class
 * @author lhl
 */
public class User {
	/**
	 * 注意uid不是id
	 * 
	 * @hibernate.id generator-class="native"
	 */
	private int uid;

	/**
	 * 邮箱
	 * 
	 * @hibernate.property
	 */
	private String email;

	/**
	 * 密码
	 * 
	 * @hibernate.property
	 */
	private String password;

	/**
	 * 用户真实名称
	 * 
	 * @hibernate.property
	 */
	private String username;

	/**
	 * 用户手机号码
	 * 
	 * @hibernate.property
	 */
	private String mobilePhone;

	/**
	 * 新浪微博令牌
	 * 
	 * @hibernate.property
	 */
	private String accessToken;

	/**
	 * 新浪微博令牌密钥
	 * 
	 * @hibernate.property
	 */
	private String accessTokenSecret;

	/**
	 * 用户类型 是注册用户还是管理员用户
	 * 
	 * @hibernate.property
	 */
	private int userType;

	/**
	 * 用户注册类型 1：邮箱 2：微博 3：手机号码
	 * 
	 * @hibernate.property
	 */
	private int regType;

	/**
	 * 账号验证位标记 从低位起（这里没有第0位），第1位标记邮箱，第2位标记微博，第3位标记手机 0：未验证 1：验证通过
	 * 
	 * @hibernate.property
	 */
	private int verification;

	/**
	 * 邮箱激活码
	 * 
	 * @hibernate.property
	 */
	private String emailActivateCode;

	/**
	 * 手机激活码
	 * 
	 * @hibernate.property
	 */
	private String mobilePhoneActivateCode;

	/**
	 * 注册时间
	 * 
	 * @hibernate.property
	 */
	private int regTime;

	/**
	 * 注册IP
	 * 
	 * @hibernate.property
	 */
	private String regIp;

	/**
	 * 上次登录时间
	 * 
	 * @hibernate.property
	 */
	private int lastTime;

	/**
	 * 上次登录IP
	 * 
	 * @hibernate.property
	 */
	private String lastIp;

	/**
	 * 用户积分
	 * 
	 * @hibernate.property
	 */
	private int credit;

	/**
	 * 用户余额
	 * 
	 * @hibernate.property
	 */
	private int money;

	/**
	 * 用户新消息个数
	 * 
	 * @hibernate.property
	 */
	private int newpm;

	/**
	 * 用户头像最后上传图，并非最終頭像
	 * 
	 * @hibernate.property
	 */
	private String avatar;

	/**
	 * 用户token，用于api登陆，cookie保存
	 */
	private String token;

	/**
	 * web登陆cookie
	 */
	private String cookie;

	private String oneKeyRegPswd;

	public int getUid() {
		return uid;
	}

	public void setUid(int uid) {
		this.uid = uid;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@JSON(serialize = false)
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public int getUserType() {
		return userType;
	}

	public void setUserType(int userType) {
		this.userType = userType;
	}

	public int getRegTime() {
		return regTime;
	}

	public void setRegTime(int regTime) {
		this.regTime = regTime;
	}

	public String getRegIp() {
		return regIp;
	}

	public void setRegIp(String regIp) {
		this.regIp = regIp;
	}

	public int getLastTime() {
		return lastTime;
	}

	public void setLastTime(int lastTime) {
		this.lastTime = lastTime;
	}

	public String getLastIp() {
		return lastIp;
	}

	public void setLastIp(String lastIp) {
		this.lastIp = lastIp;
	}

	public int getCredit() {
		return credit;
	}

	public void setCredit(int credit) {
		this.credit = credit;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public void setAccessTokenSecret(String accessTokenSecret) {
		this.accessTokenSecret = accessTokenSecret;
	}

	@JSON(serialize = false)
	public String getAccessTokenSecret() {
		return accessTokenSecret;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}

	@JSON(serialize = false)
	public String getAccessToken() {
		return accessToken;
	}

	public void setRegType(int regType) {
		this.regType = regType;
	}

	public int getRegType() {
		return regType;
	}

	public void setVerification(int verification) {
		this.verification = verification;
	}

	public int getVerification() {
		return verification;
	}

	public void setEmailActivateCode(String emailActivateCode) {
		this.emailActivateCode = emailActivateCode;
	}

	@JSON(serialize = false)
	public String getEmailActivateCode() {
		return emailActivateCode;
	}

	@JSON(serialize = false)
	public void setMobilePhoneActivateCode(String mobilePhoneActivateCode) {
		this.mobilePhoneActivateCode = mobilePhoneActivateCode;
	}

	@JSON(serialize = false)
	public String getMobilePhoneActivateCode() {
		return mobilePhoneActivateCode;
	}

	public int getNewpm() {
		return newpm;
	}

	public void setNewpm(int newpm) {
		this.newpm = newpm;
	}

	public void setMoney(int money) {
		this.money = money;
	}

	public int getMoney() {
		return money;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public boolean isWeiboBind() {
		return (this.verification & 2) > 0;
	}

	/**
	 * 生成token
	 * 
	 * @return token
	 */
	public String generateToken() {
		UUID uuid = UUID.randomUUID();
		token = uuid.toString();
		token = token.replaceAll("-", "");
		return token;
	}

	@JSON(serialize = false)
	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	/**
	 * 生成cookie
	 * 
	 * @return cookie
	 */
	public String generateCookie() {
		UUID uuid = UUID.randomUUID();
		cookie = uuid.toString();
		cookie = cookie.replaceAll("-", "");
		return cookie;
	}

	@JSON(serialize = false)
	public String getCookie() {
		return cookie;
	}

	public void setCookie(String cookie) {
		this.cookie = cookie;
	}

	public String getOneKeyRegPswd() {
		return oneKeyRegPswd;
	}

	public void setOneKeyRegPswd(String oneKeyRegPswd) {
		this.oneKeyRegPswd = oneKeyRegPswd;
	}
}
