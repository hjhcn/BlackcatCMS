/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

import java.io.File;

import org.apache.struts2.json.annotations.JSON;

import blackcat.SystemConstants;
import blackcat.utils.Time;

public class UploadFile implements java.io.Serializable {

	private static final long serialVersionUID = 8332332177086816801L;
	private Integer id;
	private String fileUrl;
	private Integer fileSize;
	private String description;
	private Integer dateline;
	private Short status;
	private String fileType;

	private Admin admin;

	private File file;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getFileUrl() {
		return fileUrl;
	}

	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}

	public Integer getFileSize() {
		return fileSize;
	}

	public void setFileSize(Integer fileSize) {
		this.fileSize = fileSize;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setDateline(Integer dateline) {
		this.dateline = dateline;
	}

	public Integer getDateline() {
		return dateline;
	}

	public void setStatus(Short status) {
		this.status = status;
	}

	/**
	 * 0 上传至临时目录 <br>
	 * 1 已使用 <br>
	 */
	public Short getStatus() {
		return status;
	}

	public String getCreateTimeFormat() {
		return Time.formatTimeStamp(dateline, "yyyy-MM-dd HH:mm:ss");
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getFileType() {
		return fileType;
	}

	/**
	 * @return 文件web地址，通过状态自动判断目录
	 */
	public String getWebUrl() {
		String forder = "/";
		switch (this.status) {
		case -1:
		case 0:
			forder += SystemConstants.PATH + "uploadfileTemp/";
			break;
		default:
			forder += SystemConstants.PATH + "uploadfile/";
			break;
		}
		return forder + this.getFileUrl();
	}

	/**
	 * @return 文件最终保存后，web地址
	 */
	public String getFinalWebUrl() {
		return "/" + SystemConstants.PATH + "uploadfile/" + this.getFileUrl();
	}

	@JSON(serialize = false)
	public String getTempPath() {
		return SystemConstants.UPLOAD_FOLDER_TEMP + this.getFileUrl();
	}

	/**
	 * 
	 * @return 文件最终绝对存储路径，并不一定是真实路径因为有可能文件还在临时目录中，还未转存)
	 */
	@JSON(serialize = false)
	public String getFilePath() {
		return this.getUploadFolder() + this.getFileUrl();
	}

	@JSON(serialize = false)
	public String getUploadFolder() {
		return SystemConstants.UPLOAD_FOLDER;
	}

	@JSON(serialize = false)
	public File getFile() {
		if (null == file) {
			file = new File(this.getUploadFolder() + this.getFileUrl());
		}
		return file;
	}

	public Admin getAdmin() {
		return admin;
	}

	public void setAdmin(Admin admin) {
		this.admin = admin;
	}

}