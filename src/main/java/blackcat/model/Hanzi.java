/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

import blackcat.rules.VersionResRule;

import java.util.Set;

public class Hanzi implements java.io.Serializable,VersionResRule {

	private static final long serialVersionUID = 1004611578539083462L;
	private Integer id;
	private String zi;
	private String pinyin;
	private String pinyinyindiao;
	private Integer bihuashu;
	private String bushou;
	private String info;
    private Integer version;

    private Integer level;
	private String contour;
	private String locus;
	private Short status;
	private String cnAudioPath;
	private UploadFile cnAudio;
	private Short selected;
    private Short cijuStatus;

	private Admin admin;

    private Set<Zuciju> zucijus;

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getZi() {
		return this.zi;
	}

	public void setZi(String zi) {
		this.zi = zi;
	}

	public String getPinyin() {
		return this.pinyin;
	}

	public void setPinyin(String pinyin) {
		this.pinyin = pinyin;
	}

	public String getPinyinyindiao() {
		return this.pinyinyindiao;
	}

	public void setPinyinyindiao(String pinyinyindiao) {
		this.pinyinyindiao = pinyinyindiao;
	}

	public Integer getBihuashu() {
		return this.bihuashu;
	}

	public void setBihuashu(Integer bihuashu) {
		this.bihuashu = bihuashu;
	}

	public String getBushou() {
		return this.bushou;
	}

	public void setBushou(String bushou) {
		this.bushou = bushou;
	}

	public String getInfo() {
		return this.info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public Integer getLevel() {
		return this.level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public String getContour() {
		return this.contour;
	}

	public void setContour(String contour) {
		this.contour = contour;
	}

	public String getLocus() {
		return this.locus;
	}

	public void setLocus(String locus) {
		this.locus = locus;
	}

	public String getCnAudioPath() {
		return this.cnAudioPath;
	}

	public void setCnAudioPath(String cnAudioPath) {
		this.cnAudioPath = cnAudioPath;
	}

	public Short getStatus() {
		return status;
	}

	public void setStatus(Short status) {
		this.status = status;
	}

	public UploadFile getCnAudio() {
		return cnAudio;
	}

	public void setCnAudio(UploadFile cnAudio) {
		this.cnAudio = cnAudio;
	}

	public Admin getAdmin() {
		return admin;
	}

	public void setAdmin(Admin admin) {
		this.admin = admin;
	}

	public Short getSelected() {
		return selected;
	}

	public void setSelected(Short selected) {
		this.selected = selected;
	}

    @Override
    public int getVersion() {
        return version;
    }

    public  void setVersion(int version){
        this.version=version;
    }

    public Set<Zuciju> getZucijus() {
        return zucijus;
    }

    public void setZucijus(Set<Zuciju> zucijus) {
        this.zucijus = zucijus;
    }

    public Short getCijuStatus() {
        return cijuStatus;
    }

    public void setCijuStatus(Short cijuStatus) {
        this.cijuStatus = cijuStatus;
    }
}