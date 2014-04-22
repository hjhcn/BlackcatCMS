/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import blackcat.SystemConstants;
import blackcat.SystemConstants.EXT_TYPE;
import blackcat.SystemConstants.FEEDBACK;
import blackcat.SystemConstants.OPERATE;
import blackcat.SystemConstants.STATUS;
import blackcat.bgRun.GenThumbThread;
import blackcat.dao.CiyuDao;
import blackcat.model.Admin;
import blackcat.model.Ciyu;
import blackcat.model.CiyuStatistic;
import blackcat.model.GenThumbObject;
import blackcat.model.UploadFile;
import blackcat.model.page.PageView;
import blackcat.rules.GenThumbFinishRule;
import blackcat.service.CiyuService;
import blackcat.service.UploadFileService;
import blackcat.utils.FileUtils;
import blackcat.utils.StringUtils;
import blackcat.utils.Time;

public class CiyuServiceImpl implements CiyuService, GenThumbFinishRule {
	private CiyuDao ciyuDao;
	private UploadFileService uploadFileService;

	public void setCiyuDao(CiyuDao ciyuDao) {
		this.ciyuDao = ciyuDao;
	}

	public void setUploadFileService(UploadFileService uploadFileService) {
		this.uploadFileService = uploadFileService;
	}

	@Override
	public PageView<Ciyu> findScrollData(String ci, Admin admin, String statuses, int page,
			int rows, String order, String sort) {
		ArrayList<String> whereClause = new ArrayList<String>();
		if (ci != null && !ci.isEmpty() && StringUtils.isAllHanzi(ci))
			whereClause.add("ci like '%" + ci + "%'");
		if (admin != null)
			whereClause.add("admin.id=" + admin.getId());
		if (statuses != null && !statuses.isEmpty()) {
			String[] statusArray = statuses.split(",");
			String statusFilterStr = "";
			for (int i = 0; i < statusArray.length; i++) {
				if (i > 0) {
					statusFilterStr += " or ";
				}
				statusFilterStr += "status=" + statusArray[i];
			}
			whereClause.add(statusFilterStr);
		}
		PageView<Ciyu> cies = new PageView<Ciyu>(page, rows);
		LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
		orderbyClause.put(sort, order);
		cies.setQueryResult(ciyuDao.findScrollData(page, rows, whereClause, orderbyClause));
		return cies;
	}

	@Override
	public Ciyu get(int id) {
		Ciyu ci = ciyuDao.get(id);
		return ci;
	}

	/**
	 * 目前只搞了添加
	 */
	@Override
	public int operate(Ciyu ciyuUpload, OPERATE operate, Admin admin) {

		Ciyu ci = null;
		List<Ciyu> ciList = ciyuDao.findByProperty("ci", ciyuUpload.getCi());
		if (operate == OPERATE.UPLOAD) {
			if (ciList.size() > 0) {
				return FEEDBACK.CI_CI_EXSIT;
			}
			ci = new Ciyu();
		} else {
			if (ciList.size() > 1) {
				return FEEDBACK.CI_CI_EXSIT;
			} else {
				if (!ciList.get(0).getId().equals(ciyuUpload.getId())) {
					return FEEDBACK.CI_CI_EXSIT;
				} else {
					ci = ciList.get(0);
				}
			}
		}

		if (ci == null)
			return FEEDBACK.CI_ID_ERROR;
		if (ci.getStatus() == FEEDBACK.CI_DELETED)
			if (ciyuUpload.getCi() != null && !ciyuUpload.getCi().isEmpty()
					&& StringUtils.isAllHanzi(ciyuUpload.getCi())) {
				ci.setCi(ciyuUpload.getCi());
			} else {// 词不对
				return FEEDBACK.CI_CI_ERROR;
			}
		UploadFile icon = uploadFileService.get(ciyuUpload.getIcon().getId());
		if (icon != null) {
			uploadFileService.saveFile(icon);
			ci.setIcon(icon);
			ci.setIconPath(icon.getWebUrl());// 保存后获得的地址才正确
		} else {// 图不对
			return FEEDBACK.CI_ICON_ERROR;
		}
		if (ciyuUpload.getCnAudio() != null && ciyuUpload.getCnAudio().getId() != null) {
			UploadFile cnAudio = uploadFileService.get(ciyuUpload.getCnAudio().getId());
			if (cnAudio != null) {
				uploadFileService.saveFile(cnAudio);
				ci.setCnAudio(cnAudio);
				ci.setCnAudioPath(cnAudio.getWebUrl());
			}
		}
		if (ciyuUpload.getEnAudio() != null && ciyuUpload.getEnAudio().getId() != null) {
			UploadFile enAudio = uploadFileService.get(ciyuUpload.getEnAudio().getId());
			if (enAudio != null) {
				uploadFileService.saveFile(enAudio);
				ci.setEnAudio(enAudio);
				ci.setEnAudioPath(enAudio.getWebUrl());
			}
		}
		ci.setAdmin(admin);
		ci.setEnglish(ciyuUpload.getEnglish());
		ci.setPinyin(ciyuUpload.getPinyin());
		ci.setPinyinyindiao(ciyuUpload.getPinyinyindiao());
		ci.setStatus(STATUS.CIYU_DEFAULT);
		ci.setUpdateTime(Time.getTimeStamp());
		ci.setThumbStatus(STATUS.CIYU_GEN_THUMB_RUNING);
		ciyuDao.saveOrUpdate(ci);

		// 生成缩略图
		GenThumbThread.getInstance().push(new GenThumbObject(ci, SystemConstants.RATIO, this));

		return FEEDBACK.SUCCESS;
	}

	@Override
	public int batchSave(String fileListStr, Admin admin, EXT_TYPE ext) {
		int i = 0;
		String[] fileArray = fileListStr.split(";");
		for (String fileInfo : fileArray) {
			String[] infoArray = fileInfo.split(",");
			if (infoArray.length == 2) {
				try {
					int id = Integer.parseInt(infoArray[0]);
					String ci = infoArray[1];
					if (StringUtils.isAllHanzi(ci) && ci.length() >= 1) {
						UploadFile file = uploadFileService.get(id);
						if (file != null && file.getAdmin().getId() == admin.getId()
								&& file.getStatus() == 0) {
							List<Ciyu> ciList = ciyuDao.findByProperty("ci", ci);
							Ciyu ciyu;
							if (ciList.size() == 0) {
								ciyu = new Ciyu();
								ciyu.setUpdateTime(Time.getTimeStamp());
								ciyu.setThumbStatus(STATUS.CIYU_GEN_THUMB_ERROR);
								ciyu.setStatus(STATUS.CIYU_DEFAULT);
								ciyu.setAdmin(admin);
								ciyu.setIconPath("");
							} else {
								ciyu = ciList.get(0);
							}
							ciyu.setCi(ci);

							if (ext == EXT_TYPE.PIC) {
								ciyu.setIcon(file);
								ciyu.setIconPath(file.getFinalWebUrl());
								ciyu.setThumbStatus(STATUS.CIYU_GEN_THUMB_RUNING);

								// 生成缩略图
								GenThumbThread.getInstance().push(
										new GenThumbObject(ciyu, SystemConstants.RATIO, this));
							} else {
								ciyu.setCnAudio(file);
								ciyu.setCnAudioPath(file.getFinalWebUrl());
							}

							uploadFileService.saveFile(file);
							ciyuDao.saveOrUpdate(ciyu);
							i++;
						}
					}
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}
		}

		return i;
	}

	public int operate(String ids, OPERATE operate) {
		int count = 0;
		String[] idArray = ids.split(",");
		for (String idStr : idArray) {
			try {
				int id = Integer.parseInt(idStr);
				Ciyu ciyu = ciyuDao.get(id);
				if (ciyu != null) {
					if (operate == OPERATE.VERIFY) {
						ciyu.setStatus(STATUS.CIYU_VERIFY_PASS);
						ciyuDao.saveOrUpdate(ciyu);
						count++;
					} else if (operate == OPERATE.UNVERIFY) {
						ciyu.setStatus(STATUS.CIYU_VERIFY_NOTPASS);
						ciyuDao.saveOrUpdate(ciyu);
						count++;
					} else if (operate == OPERATE.DELETE) {
						ciyu.setStatus(STATUS.CIYU_DELETED);
						ciyuDao.saveOrUpdate(ciyu);
						count++;
					}
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		return count;
	}

	@Override
	public CiyuStatistic statistic(int aid) {
		if (aid > 0) {
			CiyuStatistic cs = new CiyuStatistic();
			Map<String, String> exp = new HashMap<String, String>();
			exp.put("count", "count(*)");
			List<String> whereClause = new ArrayList<String>();
			whereClause.add("admin.id=" + aid);
			LinkedList<String> groupbyClause = new LinkedList<String>();
			groupbyClause.add("status");
			LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
			orderbyClause.put("status", "asc");
			List<?> rt = ciyuDao.statistic(exp, whereClause, groupbyClause, orderbyClause);
			for (Object obj : rt) {
				Object[] objArray = (Object[]) obj;
				int status = (Short) objArray[0];
				int count = ((Long) objArray[1]).intValue();
				switch (status) {
				case STATUS.CIYU_DEFAULT:
					cs.setCiyuDF(count);
					break;
				case STATUS.CIYU_DELETED:
					cs.setCiyuD(count);
					break;
				case STATUS.CIYU_VERIFY_NOTPASS:
					cs.setCiyuVNP(count);
					break;
				case STATUS.CIYU_VERIFY_PASS:
					cs.setCiyuVP(count);
					break;
				default:
					break;
				}
			}
			return cs;
		}
		return null;
	}

	@Override
	public Map<Integer, CiyuStatistic> statistic() {
		Map<Integer, CiyuStatistic> csMap = new HashMap<Integer, CiyuStatistic>();
		Map<String, String> exp = new HashMap<String, String>();
		exp.put("count", "count(*)");
		List<String> whereClause = new ArrayList<String>();
		LinkedList<String> groupbyClause = new LinkedList<String>();
		groupbyClause.add("admin.id");
		groupbyClause.add("status");
		LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
		orderbyClause.put("admin.id", "asc");
		List<?> rt = ciyuDao.statistic(exp, whereClause, groupbyClause, orderbyClause);
		int aid = 0;
		CiyuStatistic cs = new CiyuStatistic();
		for (Object obj : rt) {
			Object[] objArray = (Object[]) obj;
			try {
				if (objArray[0] != null) {
					int newAid = (Integer) objArray[0];
					if (newAid != aid) {
						// 下一个aid
						csMap.put(aid, cs);
						aid = newAid;
						cs = new CiyuStatistic();
					}

					int status = (Short) objArray[1];
					int count = ((Long) objArray[2]).intValue();
					switch (status) {
					case STATUS.CIYU_DEFAULT:
						cs.setCiyuDF(count);
						break;
					case STATUS.CIYU_DELETED:
						cs.setCiyuD(count);
						break;
					case STATUS.CIYU_VERIFY_NOTPASS:
						cs.setCiyuVNP(count);
						break;
					case STATUS.CIYU_VERIFY_PASS:
						cs.setCiyuVP(count);
						break;
					default:
						break;
					}

				}

			} catch (Exception e) {
			}

		}
		csMap.put(aid, cs);

		return csMap;
	}

	public void genThumbFinish(Ciyu ciyu) {
		ciyuDao.saveOrUpdate(ciyu);
	}

	public int batchGenThumb() {
		List<String> whereClause = new ArrayList<String>();
		whereClause.add("thumbStatus!=1");
		List<Ciyu> ciyus = ciyuDao.findAllData(whereClause, null, null);
		int count = 0;
		for (Ciyu ciyu : ciyus) {
			// 生成缩略图
			GenThumbThread.getInstance()
					.push(new GenThumbObject(ciyu, SystemConstants.RATIO, this));
			count++;
		}
		return count;
	}

	public void backupPassed() {
		List<String> whereClause = new ArrayList<String>();
		whereClause.add("status=2");
		List<Ciyu> ciyus = ciyuDao.findAllData(whereClause, null, null);
		for (Ciyu ciyu : ciyus) {
			// 备份图片
			String iconUrl = ciyu.getIcon().getFileUrl();
			String thumbUrl =ciyu.getThumbPath();
			String srcPath = ciyu.getIcon().getUploadFolder() + iconUrl;
			String targetPath = SystemConstants.BACKUP_FOLDER + iconUrl;
			String srcThumbPath = ciyu.getIcon().getUploadFolder() + thumbUrl;
			String targetThumbPath = SystemConstants.BACKUP_FOLDER + thumbUrl;
			FileUtils.copyPath(srcPath, targetPath);
			FileUtils.copyPath(srcThumbPath, targetThumbPath);

            // 备份音频
            String audioUrl=ciyu.getCnAudio().getFileUrl();
            String audioSrcPath=ciyu.getCnAudio().getUploadFolder()+audioUrl;
            String audioTargetPath = SystemConstants.BACKUP_FOLDER + audioUrl;
            FileUtils.copyPath(audioSrcPath,audioTargetPath);
		}
	}
}
