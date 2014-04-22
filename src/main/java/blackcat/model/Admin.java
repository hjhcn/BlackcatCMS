/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

import blackcat.SystemConstants.AUTHORITY;

public class Admin implements java.io.Serializable {
	private static final long serialVersionUID = -927454814798101360L;
	private int id;
	private String username;
	private String password;
	private int disabled;
	private int role;
	private int lastTime;
	private String lastIp;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public int getDisabled() {
		return disabled;
	}

	public void setDisabled(int disabled) {
		this.disabled = disabled;
	}

	public int getAuthority() {
		return role;
	}

	public int getRole() {
		return role;
	}

	public void setRole(int role) {
		this.role = role;
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

	public boolean getIsSuper() {
		return this.getAuthority() == AUTHORITY.SUPER;
	}

	public boolean getIsEditable() {
		return this.getAuthority() <= AUTHORITY.EDIT;
	}
}
