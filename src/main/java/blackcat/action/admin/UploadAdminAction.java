/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.action.admin;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import blackcat.SystemConstants;
import blackcat.SystemConstants.AUTHORITY;
import blackcat.SystemConstants.EXT_TYPE;
import blackcat.annotation.AdminAuthority;
import blackcat.model.Admin;
import blackcat.model.UploadFile;
import blackcat.model.page.PageView;
import blackcat.rules.UploadFileRule;
import blackcat.service.UploadFileService;

public class UploadAdminAction extends BaseAdminAction implements UploadFileRule {

	private static final long serialVersionUID = 2352624521621547644L;
	private File file;
	private String fileFileName;
	private String fileContentType;

	private UploadFileService uploadFileService;
	private PageView<UploadFile> uploadFiles;
	private String statuses;
	private EXT_TYPE ext;
	private String search;
	private UploadFile uploadFile;
	private List<String> ftpFileNames;

	@AdminAuthority(authority = AUTHORITY.EDIT)
	public String uploadFile() {
		uploadFile = uploadFileService.uploadFile(file, fileFileName, fileContentType,
				admin.getId(), EXT_TYPE.ALL);
		feedback = uploadFile.getId();
		return SUCCESS;
	}

	public String list() {
		Admin findAdmin = admin;
		if (admin.getAuthority() != AUTHORITY.EDIT)
			findAdmin = null;
		uploadFiles = uploadFileService.list(findAdmin, statuses, search,
				tsRange.getStartTimeStamp(), tsRange.getEndTimeStamp(), page, rows, order, sort,
				ext);
		return SUCCESS;
	}

	@AdminAuthority(authority = AUTHORITY.EDIT)
	public String importFromFtp() {
		feedback = uploadFileService.importFromFtp(admin, ftpFileNames);
		return SUCCESS;
	}

	@AdminAuthority(authority = AUTHORITY.EDIT)
	public String listFtpFile() {
		File ftpFile = new File(SystemConstants.UPLOAD_FOLDER_TEMP + admin.getUsername() + "/");
		ftpFileNames = new ArrayList<String>();
		if (ftpFile.exists()) {
			for (File file : ftpFile.listFiles()) {
				if (file.isFile()) {
					ftpFileNames.add(file.getName());
				}
			}
		}
		return SUCCESS;
	}

	public String delete() {

		return SUCCESS;
	}

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public String getFileFileName() {
		return fileFileName;
	}

	public void setFileFileName(String fileFileName) {
		this.fileFileName = fileFileName;
	}

	public String getFileContentType() {
		return fileContentType;
	}

	public void setFileContentType(String fileContentType) {
		this.fileContentType = fileContentType;
	}

	public void setUploadFileService(UploadFileService uploadFileService) {
		this.uploadFileService = uploadFileService;
	}

	public void setUploadFiles(PageView<UploadFile> uploadFiles) {
		this.uploadFiles = uploadFiles;
	}

	public PageView<UploadFile> getUploadFiles() {
		return uploadFiles;
	}

	public UploadFileService getUploadFileService() {
		return uploadFileService;
	}

	public void setStatuses(String statuses) {
		this.statuses = statuses;
	}

	public String getStatuses() {
		return statuses;
	}

	public void setExt(EXT_TYPE ext) {
		this.ext = ext;
	}

	public EXT_TYPE getExt() {
		return ext;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public String getSearch() {
		return search;
	}

	public UploadFile getUploadFile() {
		return uploadFile;
	}

	public void setUploadFile(UploadFile uploadFile) {
		this.uploadFile = uploadFile;
	}

	public List<String> getFtpFileNames() {
		return ftpFileNames;
	}

	public void setFtpFileNames(List<String> ftpFileNames) {
		this.ftpFileNames = ftpFileNames;
	}

}
