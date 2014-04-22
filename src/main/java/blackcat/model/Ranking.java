/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

public class Ranking implements java.io.Serializable {
	private static final long serialVersionUID = -927454814798101360L;
	private int uid;
    private String username;
	private int zika;
	private int tuka;
	private int xunzhang;
	private int xingxing;
	private int updateTime;
	private String lastIp;

	public int getUid() {
		return uid;
	}

	public void setUid(int uid) {
		this.uid = uid;
	}

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getZika() {
		return zika;
	}

	public void setZika(int zika) {
		this.zika = zika;
	}

	public int getTuka() {
		return tuka;
	}

	public void setTuka(int tuka) {
		this.tuka = tuka;
	}

	public int getXunzhang() {
		return xunzhang;
	}

	public void setXunzhang(int xunzhang) {
		this.xunzhang = xunzhang;
	}

	public int getXingxing() {
		return xingxing;
	}

	public void setXingxing(int xingxing) {
		this.xingxing = xingxing;
	}

	public int getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(int updateTime) {
		this.updateTime = updateTime;
	}

	public String getLastIp() {
		return lastIp;
	}

	public void setLastIp(String lastIp) {
		this.lastIp = lastIp;
	}

}
