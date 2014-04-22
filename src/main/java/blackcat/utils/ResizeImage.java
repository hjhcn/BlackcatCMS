/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.utils;

import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.io.File;
import java.io.IOException;
import java.io.FileOutputStream;
import java.util.Map;

public class ResizeImage {

	/**
	 * @param im
	 *            原始图像
	 * @param resizeTimes
	 *            缩放倍数
	 * @return 返回处理后的图像
	 */
	public static BufferedImage resizeImage(BufferedImage im, float resizeTimes) {
		if (im == null)
			return null;
		/* 原始图像的宽度和高度 */
		int width = im.getWidth();
		int height = im.getHeight();

		/* 调整后的图片的宽度和高度 */
		int toWidth = (int) (Float.parseFloat(String.valueOf(width)) * resizeTimes);
		int toHeight = (int) (Float.parseFloat(String.valueOf(height)) * resizeTimes);

		/* 新生成结果图片 */
		BufferedImage result = new BufferedImage(toWidth, toHeight, BufferedImage.TYPE_INT_RGB);

		result.getGraphics().drawImage(
				im.getScaledInstance(toWidth, toHeight, java.awt.Image.SCALE_SMOOTH), 0, 0, null);
		return result;
	}

	/**
	 * @param path
	 *            要转化的图像的文件夹,就是存放图像的文件夹路径
	 * @param type
	 *            图片的后缀名组成的数组
	 * @return
	 */
	public static List<BufferedImage> getImageList(String path, String[] type) throws IOException {
		Map<String, Boolean> map = new HashMap<String, Boolean>();
		for (String s : type) {
			map.put(s, true);
		}
		List<BufferedImage> result = new ArrayList<BufferedImage>();
		File[] fileList = new File(path).listFiles();
		for (File f : fileList) {
			if (f.length() == 0)
				continue;
			if (map.get(FileUtils.getExt(f.getName())) == null)
				continue;
			result.add(ImageIO.read(f));
		}
		return result;
	}

	/**
	 * 把BufferedImage存盘
	 */
	public static boolean writeToDisk(BufferedImage im, String path, String fileName) {
		File f = new File(path + fileName);
		String fileType = FileUtils.getExt(fileName);
		if (fileType == null)
			return false;
		try {
			ImageIO.write(im, fileType, f);
			im.flush();
			return true;
		} catch (IOException e) {
			return false;
		}
	}

	/**
	 * 把BufferedImage转JPEG编码后存盘
	 */
	public static boolean writeHighQuality(BufferedImage im, String fileFullPath) {
		try {
			/* 输出到文件流 */
			FileOutputStream newimage = new FileOutputStream(fileFullPath);
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(newimage);
			JPEGEncodeParam jep = JPEGCodec.getDefaultJPEGEncodeParam(im);
			/* 压缩质量 */
			jep.setQuality(1f, true);
			encoder.encode(im, jep);
			/* 近JPEG编码 */
			newimage.close();
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 缩放图片后存盘
	 * 
	 * @param srcPath
	 *            原图路径
	 * @param thumbPath
	 *            缩略图路径
	 * @param ratio
	 *            缩放比例
	 * @return 是否成功
	 */
	public static boolean generateAndSaveThumbImage(String srcPath, float ratio) {
		try {
			String thumbPath = FileUtils.getPre(srcPath) + ".thumb.jpg";
			BufferedImage img;
			img = ImageIO.read(new File(srcPath));
			writeHighQuality(resizeImage(img, ratio), thumbPath);
			return true;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}

}
