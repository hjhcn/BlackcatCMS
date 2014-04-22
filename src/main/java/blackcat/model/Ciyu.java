/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

import blackcat.rules.VersionResRule;
import org.apache.struts2.json.annotations.JSON;

import blackcat.utils.FileUtils;


public class Ciyu implements java.io.Serializable,VersionResRule{

	private static final long serialVersionUID = 5259429930217756375L;
	private Integer id;
	private String ci;
	private String pinyin;
	private String pinyinyindiao;
	private String english;
	private Short status;
	private Integer updateTime;
	private Short thumbStatus;

	private Admin admin;

	private String iconPath;
	private String enAudioPath;
	private String cnAudioPath;
	private UploadFile icon;
	private UploadFile cnAudio;
	private UploadFile enAudio;

    private Integer version;

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getCi() {
		return this.ci;
	}

	public void setCi(String ci) {
		this.ci = ci;
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

	public String getIconPath() {
		return iconPath;
	}

	public void setIconPath(String iconPath) {
		this.iconPath = iconPath;
	}

	@JSON(serialize = false)
	public UploadFile getIcon() {
		return icon;
	}

	public void setIcon(UploadFile icon) {
		this.icon = icon;
	}

	@JSON(serialize = false)
	public UploadFile getCnAudio() {
		return cnAudio;
	}

	public void setCnAudio(UploadFile cnAudio) {
		this.cnAudio = cnAudio;
	}

	@JSON(serialize = false)
	public UploadFile getEnAudio() {
		return enAudio;
	}

	public void setEnAudio(UploadFile enAudio) {
		this.enAudio = enAudio;
	}

	public String getEnglish() {
		return this.english;
	}

	public void setEnglish(String english) {
		this.english = english;
	}

	public String getEnAudioPath() {
		return this.enAudioPath;
	}

	public void setEnAudioPath(String enAudioPath) {
		this.enAudioPath = enAudioPath;
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

	public Admin getAdmin() {
		return admin;
	}

	public void setAdmin(Admin admin) {
		this.admin = admin;
	}

	public Integer getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Integer updateTime) {
		this.updateTime = updateTime;
	}

	public Short getThumbStatus() {
		return thumbStatus;
	}

	public void setThumbStatus(Short thumbStatus) {
		this.thumbStatus = thumbStatus;
	}

	public String getThumbPath() {
		return pathToThumb(this.iconPath);
	}

	public static String pathToThumb(String path) {
		return FileUtils.getPre(path) + ".thumb.jpg";
	}

    @Override
    public int getVersion() {
        return version;
    }

    public  void setVersion(int version){
        this.version=version;
    }


}