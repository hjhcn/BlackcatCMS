/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service;

import java.io.File;
import java.util.List;

import blackcat.SystemConstants.EXT_TYPE;
import blackcat.model.Admin;
import blackcat.model.UploadFile;
import blackcat.model.page.PageView;

public interface UploadFileService {
	public UploadFile get(int id);

	/**
	 * @param fileList
	 *            文件列表
	 * @param fileListFileName
	 *            文件列表原名
	 * @param fileListContentType
	 *            文件类型列表
	 * @param user
	 *            用户
	 * @param extType
	 *            接收类型
	 * @return 成功返回ufid，失败则返回0；
	 */
	public UploadFile uploadFile(File file, String fileFileName, String fileContentType, int aid,
                                 EXT_TYPE extType);

	public PageView<UploadFile> list(Admin admin, String statuses, String search,
                                     int startTimeStamp, int endTimeStamp, int page, int rows, String order, String sort,
                                     EXT_TYPE extType);

	public boolean saveOrUpdate(UploadFile uploadFile);

	public int setNotTmp(int id, short status);

	public boolean saveFile(UploadFile uploadFile);

	public int importFromFtp(Admin admin, final List<String> importFileNames);

}
