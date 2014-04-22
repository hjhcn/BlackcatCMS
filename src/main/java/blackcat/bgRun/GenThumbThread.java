/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.bgRun;

import java.util.LinkedList;

import blackcat.SystemConstants.STATUS;
import blackcat.model.Ciyu;
import blackcat.model.GenThumbObject;
import blackcat.utils.ResizeImage;

public class GenThumbThread extends Thread {
	private static GenThumbThread instance = null;
	private static LinkedList<GenThumbObject> genThumbList = new LinkedList<GenThumbObject>();

	private GenThumbThread() {

	}

	public static synchronized GenThumbThread getInstance() {
		if (instance == null) {
			instance = new GenThumbThread();
			instance.start();
		}
		return instance;
	}

	public void push(GenThumbObject obj) {
		if (null != obj)
			genThumbList.add(obj);
	}

	public void run() {
		while (true) {
			while (genThumbList.size() > 0) {
				try {
					GenThumbObject obj = genThumbList.remove();
					Ciyu ciyu = obj.getCiyu();
					System.out.println("生成缩略图，源文件是：" + obj.getCiyu().getIcon().getFilePath());
					if (ResizeImage.generateAndSaveThumbImage(obj.getCiyu().getIcon()
							.getFilePath(), obj.getRatio())) {
						// 生成成功
						System.out.println("***生成成功！");
						ciyu.setThumbStatus(STATUS.CIYU_GEN_THUMB_SUCCESS);
					} else {
						// 生成成功
						System.out.println("生成失败-----");
						ciyu.setThumbStatus(STATUS.CIYU_GEN_THUMB_ERROR);
					}
					// 保存状态
					obj.getGenThumbFinishRule().genThumbFinish(ciyu);
				} catch (Exception e) {
					System.out.println("队列生成缩略图异常");
					e.printStackTrace();
				}
			}
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

	}
}
