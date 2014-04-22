/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class FileUtils {
	public static boolean upload(String folder, String filename, File file) {
		FileOutputStream fos;
		try {
			File newFile = new File(folder);
			if (!newFile.exists()) {
				newFile.mkdirs();
			}

			fos = new FileOutputStream(folder + filename);
			FileInputStream fis = new FileInputStream(file);
			byte[] buffer = new byte[10240];
			int len = 0;
			while ((len = fis.read(buffer)) > 0) {
				fos.write(buffer, 0, len);
				fos.flush();
			}
			fis.close();
			fos.close();
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public static boolean movePath(String sourcePath, String targetPath) {
		if (copyPath(sourcePath, targetPath)) {
			deleteDir(new File(sourcePath));
			return true;
		}
		return false;
	}

	public static boolean copyPath(String sourcePath, String targetPath) {
		try {
			File file = new File(sourcePath);
			if (file.isFile())
				return copyFile(sourcePath, targetPath);
			else if (file.isDirectory()) {
				(new File(targetPath)).mkdirs(); // 如果文件夹不存在 则建立新文件夹
				File[] files = file.listFiles();
				for (File afile : files) {
					if (afile.isFile()) {
						copyFile(sourcePath + File.separator + afile.getName(), targetPath
								+ File.separator + afile.getName());
					} else {
						copyPath(sourcePath + File.separator + afile.getName(), targetPath
								+ File.separator + afile.getName());
					}
				}
			} else {
				System.out.println("路径：" + sourcePath + "。不存在！");
				return false;
			}
			return true;
		} catch (Exception e) {
			System.out.println("从" + sourcePath + "拷贝到" + targetPath + "异常！");
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 使用该方法需外层添加目录
	 */
	private static boolean copyFile(String sourcePath, String targetPath) {
		try {
			String targetDir = targetPath.substring(0, targetPath.lastIndexOf("/"));
			File file = new File(targetDir);
			if (!file.exists())
				file.mkdirs();
			FileInputStream fis = new FileInputStream(sourcePath);
			FileOutputStream fos = new FileOutputStream(targetPath);
			byte[] buffer = new byte[10240];
			int len = 0;
			while ((len = fis.read(buffer)) > 0) {
				fos.write(buffer, 0, len);
			}
			fos.flush();
			fos.close();
			fis.close();
		} catch (StringIndexOutOfBoundsException e) {
			e.printStackTrace();
			return false;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public static boolean deleteDir(File dir) {
		if (dir.isDirectory()) {
			String[] children = dir.list();
			for (int i = 0; i < children.length; i++) {
				boolean success = deleteDir(new File(dir, children[i]));
				if (!success) {
					return false;
				}
			}
		}
		return dir.delete();
	}

	public static boolean isFolderExist() {

		return true;
	}

	public static List<String> getRooFileList(String rootDir) {
		List<String> fileList = new ArrayList<String>();
		File dir = new File(rootDir);
		if (dir.isDirectory()) {
			String[] children = dir.list();
			for (String child : children) {
				File file = new File(dir, child);
				if (file.isFile()) {
					fileList.add(child);
				}
			}
		}
		return fileList;
	}

	public static String getFileFolderByNow() {
		String day = Time.formatCurrentTime("yyyyMMdd");
		String folder = day.substring(0, 4) + "/" + day.substring(4, 8) + "/";
		return folder;
	}

	public static String getExt(String fileString) {
		int lastDot = fileString.lastIndexOf(".");
		String fileExt = "";
		if (lastDot > 0) {
			fileExt = fileString.substring(lastDot + 1, fileString.length()).toLowerCase();
		}
		return fileExt;
	}

	public static String getPre(String fileString) {
		int lastDot = fileString.lastIndexOf(".");
		String fileExt = "";
		if (lastDot > 0) {
			fileExt = fileString.substring(0, lastDot);
		}
		return fileExt;
	}

	public static boolean isExtAccepted(String ext, String[] acceptedExts) {
		for (String acceptedExt : acceptedExts) {
			if (ext != null && acceptedExt != null && acceptedExt.equals(ext)) {
				return true;
			}
		}
		return false;
	}

	public static String acceptExt2SqlString(String[] acceptedExts) {
		String exts = "";
		int i = 0;
		for (String acceptedExt : acceptedExts) {
			if (i > 0)
				exts += ",";
			exts += "'" + acceptedExt + "'";
			i++;
		}
		return exts;
	}

	public static void main(String[] arg) {
		// String time = FileUtils.getFilenameByTime();
		// System.out.println(time);
		// System.out.println(FileUtils.getFileFolderByTime(time));

		// FileUtils.copyFile("F:/uploadfileTemp/dsfsdf.doc",
		// "E:/ins_uploadfile/2012111/dsfsdf.doc");
		// FileUtils.movePath("F:/test2", "F:/sfssdsfs/dsfsf/");

		FileUtils.copyFile("/Users/haojunhua/position.pos",
				"/Users/haojunhua/2013/0903/411911b5-4e1d-4831-a75e-9567d1e7acf8.thumb.jpg");
		
		File file = new File("/Users/haojunhua/test/test.pdf");
		if (file.isFile()) {
			System.out.println("file");
		} else if (file.isDirectory()) {
			System.out.println("isDirectory");
		} else {
			System.out.println("不存在");
		}
		
	}

}
