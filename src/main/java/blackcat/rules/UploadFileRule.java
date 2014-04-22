/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.rules;

import java.io.File;

import blackcat.service.UploadFileService;

public interface UploadFileRule {
	public void setFile(File file);

	public void setFileFileName(String fileFileName);

	public void setFileContentType(String fileContentType);

	public void setUploadFileService(UploadFileService uploadFileService);
}
