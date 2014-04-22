/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.service.impl;

import blackcat.SystemConstants;
import blackcat.SystemConstants.OPERATE;
import blackcat.SystemConstants.STATUS;
import blackcat.dao.HanziDao;
import blackcat.model.page.PageView;
import blackcat.service.HanziService;
import blackcat.service.UploadFileService;
import blackcat.utils.FileUtils;
import blackcat.utils.StringUtils;
import blackcat.model.*;

import java.util.*;


public class HanziServiceImpl implements HanziService {
    private HanziDao hanziDao;
    private UploadFileService uploadFileService;

    public void setHanziDao(HanziDao hanziDao) {
        this.hanziDao = hanziDao;
    }

    public void setUploadFileService(UploadFileService uploadFileService) {
        this.uploadFileService = uploadFileService;
    }

    @Override
    public PageView<Hanzi> findScrollData(Admin admin, String zi, String statuses, int selected,
                                          int page, int rows, String order, String sort) {
        ArrayList<String> whereClause = new ArrayList<String>();
        if (zi != null && !zi.isEmpty())
            whereClause.add("zi='" + zi + "'");
        if (admin != null)
            whereClause.add("admin.id=" + admin.getId());
        if (selected > 0)
            whereClause.add("selected>=" + selected);
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
        PageView<Hanzi> hanzis = new PageView<Hanzi>(page, rows);
        LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
        orderbyClause.put(sort, order);
        hanzis.setQueryResult(hanziDao.findScrollData(page, rows, whereClause, orderbyClause));
        return hanzis;
    }

    @Override
    public Hanzi get(int id) {
        return hanziDao.get(id);
    }

    @Override
    public Hanzi getDetail(int id) {
        return hanziDao.getDetail(id);
    }

    @Override
    public int updateContourLocus(Hanzi hanziUpload) {
        Hanzi hanzi = hanziDao.get(hanziUpload.getId());
        if (hanzi != null) {
            hanzi.setLocus(hanziUpload.getLocus());
            hanzi.setContour(hanziUpload.getContour());
            hanzi.setLocus(hanziUpload.getLocus());
            hanzi.setStatus(STATUS.HANZI_EDITED);
            hanziDao.saveOrUpdate(hanzi);
            return SystemConstants.FEEDBACK.SUCCESS;
        }
        return SystemConstants.FEEDBACK.HANZI_ID_ERROR;
    }

    public int operate(String ids, OPERATE operate) {
        int count = 0;
        String[] idArray = ids.split(",");
        for (String idStr : idArray) {
            try {
                int id = Integer.parseInt(idStr);
                Hanzi hanzi = hanziDao.get(id);
                if (hanzi != null) {
                    if (operate == OPERATE.VERIFY) {
                        if (hanzi.getStatus() == STATUS.HANZI_EDITED) {
                            hanzi.setStatus(STATUS.HANZI_VERIFY_PASS);
                            hanziDao.saveOrUpdate(hanzi);
                            count++;
                        }
                    } else if (operate == OPERATE.UNVERIFY) {
                        if (hanzi.getStatus() == STATUS.HANZI_EDITED) {
                            hanzi.setStatus(STATUS.HANZI_VERIFY_NOTPASS);
                            hanziDao.saveOrUpdate(hanzi);
                            count++;
                        }
                    } else if (operate == OPERATE.SELECT_FOR_WEB) {
                        hanzi.setSelected((short) 1);
                        hanziDao.saveOrUpdate(hanzi);
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
    public HanziStatistic statistic(int aid) {
        if (aid > 0l) {
            HanziStatistic hs = new HanziStatistic();
            Map<String, String> exp = new HashMap<String, String>();
            exp.put("count", "count(*)");
            List<String> whereClause = new ArrayList<String>();
            whereClause.add("admin.id=" + aid);
            LinkedList<String> groupbyClause = new LinkedList<String>();
            groupbyClause.add("status");
            LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
            orderbyClause.put("status", "asc");
            List<?> rt = hanziDao.statistic(exp, whereClause, groupbyClause, orderbyClause);
            for (Object obj : rt) {
                Object[] objArray = (Object[]) obj;
                int status = (Short) objArray[0];
                int count = ((Long) objArray[1]).intValue();
                switch (status) {
                    case STATUS.HANZI_SELECTED:
                        hs.setHanziS(count);
                        break;
                    case STATUS.HANZI_EDITED:
                        hs.setHanziE(count);
                        break;
                    case STATUS.HANZI_VERIFY_NOTPASS:
                        hs.setHanziVNP(count);
                        break;
                    case STATUS.HANZI_VERIFY_PASS:
                        hs.setHanziVP(count);
                        break;
                    default:
                        break;
                }
            }
            return hs;
        }
        return null;
    }

    @Override
    public Map<Integer, HanziStatistic> statistic() {
        Map<Integer, HanziStatistic> hsMap = new HashMap<Integer, HanziStatistic>();
        Map<String, String> exp = new HashMap<String, String>();
        exp.put("count", "count(*)");
        List<String> whereClause = new ArrayList<String>();
        LinkedList<String> groupbyClause = new LinkedList<String>();
        groupbyClause.add("admin.id");
        groupbyClause.add("status");
        LinkedHashMap<String, String> orderbyClause = new LinkedHashMap<String, String>();
        orderbyClause.put("admin.id", "asc");
        List<?> rt = hanziDao.statistic(exp, whereClause, groupbyClause, orderbyClause);
        int aid = 0;
        HanziStatistic hs = new HanziStatistic();
        for (Object obj : rt) {
            Object[] objArray = (Object[]) obj;
            try {
                if (objArray[0] != null) {
                    int newAid = (Integer) objArray[0];
                    if (newAid != aid) {
                        // 下一个aid
                        hsMap.put(aid, hs);
                        aid = newAid;
                        hs = new HanziStatistic();
                    }

                    int status = (Short) objArray[1];
                    int count = ((Long) objArray[2]).intValue();
                    switch (status) {
                        case STATUS.HANZI_SELECTED:
                            hs.setHanziS(count);
                            break;
                        case STATUS.HANZI_EDITED:
                            hs.setHanziE(count);
                            break;
                        case STATUS.HANZI_VERIFY_NOTPASS:
                            hs.setHanziVNP(count);
                            break;
                        case STATUS.HANZI_VERIFY_PASS:
                            hs.setHanziVP(count);
                            break;
                        default:
                            break;
                    }

                }

            } catch (Exception e) {
                System.out.println(e.getMessage());
            }

        }
        hsMap.put(aid, hs);

        return hsMap;
    }

    @Override
    public Hanzi get(String zi) {
        List<Hanzi> hanzis = hanziDao.findByProperty("zi", zi);
        if (hanzis.size() > 0)
            return hanzis.get(0);
        return null;
    }


    @Override
    public int batchSaveAudio(String fileListStr, Admin admin) {
        int i = 0;
        String[] fileArray = fileListStr.split(";");
        for (String fileInfo : fileArray) {
            String[] infoArray = fileInfo.split(",");
            if (infoArray.length == 2) {
                try {
                    int id = Integer.parseInt(infoArray[0]);
                    String zi = infoArray[1];
                    if (StringUtils.isAllHanzi(zi) && zi.length() == 1) {
                        UploadFile file = uploadFileService.get(id);
                        if (file != null && file.getAdmin().getId() == admin.getId()
                                && file.getStatus() == 0) {
                            List<Hanzi> hanzis = hanziDao.findByProperty("zi", zi);
                            if (hanzis.size() == 1) {
                                Hanzi hanzi = hanzis.get(0);
                                hanzi.setCnAudio(file);
                                hanzi.setCnAudioPath(file.getFinalWebUrl());
                                uploadFileService.saveFile(file);
                                hanziDao.saveOrUpdate(hanzi);
                                i++;
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
        return i;
    }


    @Override
    public void backupPassed() {
        List<String> whereClause = new ArrayList<String>();
        whereClause.add("status=4");
        List<Hanzi> hanzis = hanziDao.findAllData(whereClause, null, null);
        for (Hanzi hanzi : hanzis) {
            // 备份音频
            if (hanzi.getCnAudio() != null) {
                String audioUrl = hanzi.getCnAudio().getFileUrl();
                String audioSrcPath = hanzi.getCnAudio().getUploadFolder() + audioUrl;
                String audioTargetPath = SystemConstants.BACKUP_FOLDER + audioUrl;
                FileUtils.copyPath(audioSrcPath, audioTargetPath);
            }
        }
    }

    @Override
    public synchronized int updateZuciju(Zuciju zuciju) {
        Hanzi hanzi = hanziDao.get(zuciju.getHanzi().getId());
        if (hanzi != null) {
            String pyyd = zuciju.getPinyinyindiao();
            String hanziPyyd = hanzi.getPinyinyindiao();
            boolean tag = false;
            for (String _pyyd : hanziPyyd.split(",")) {
                if (pyyd.equals(_pyyd)) {
                    tag = true;
                }
            }
            if (!tag) return blackcat.SystemConstants.FEEDBACK.HANZI_ZUCUJU_PINYINYINDIAO_ERROR;

            tag = false;//重置tag，用于判断拼音是否重复
            for (Zuciju _zuciju : hanzi.getZucijus()) {
                if (_zuciju.getPinyinyindiao().equals(zuciju.getPinyinyindiao())) {
                    tag = true;
                    _zuciju.setCi1(zuciju.getCi1());
                    _zuciju.setCi2(zuciju.getCi2());
                    _zuciju.setJu(zuciju.getJu());
                }
            }

            if (!tag) {
                //不存在拼音重复
                if (zuciju.getId() != null) {
                    //判断ID是否重复
                    for (Zuciju _zuciju : hanzi.getZucijus()) {
                        if (zuciju.getId().equals(_zuciju.getId())) {
                            _zuciju.setCi1(zuciju.getCi1());
                            _zuciju.setCi2(zuciju.getCi2());
                            _zuciju.setJu(zuciju.getJu());
                        }
                    }
                } else {
                    hanzi.getZucijus().add(zuciju);
                }
            }

            hanziDao.saveOrUpdate(hanzi);
        } else {
            return blackcat.SystemConstants.FEEDBACK.HANZI_ID_ERROR;
        }
        return SystemConstants.FEEDBACK.SUCCESS;
    }

    @Override
    public synchronized int updataZuciju(int hid, List<Zuciju> zucijuList) {
        Hanzi hanzi = hanziDao.get(hid);
        if (hanzi != null) {
            for (Zuciju zuciju : zucijuList) {
                zuciju.setHanzi(hanzi);
                String pyyd = zuciju.getPinyinyindiao();
                String hanziPyyd = hanzi.getPinyinyindiao();
                boolean tag = false;
                for (String _pyyd : hanziPyyd.split(",")) {
                    if (pyyd.equals(_pyyd)) {
                        tag = true;
                    }
                }
                if (tag){
                    tag = false;//重置tag，用于判断拼音是否重复
                    for (Zuciju _zuciju : hanzi.getZucijus()) {
                        if (_zuciju.getPinyinyindiao().equals(zuciju.getPinyinyindiao())) {
                            tag = true;
                            _zuciju.setCi1(zuciju.getCi1());
                            _zuciju.setCi2(zuciju.getCi2());
                            _zuciju.setJu(zuciju.getJu());
                        }
                    }

                    if (!tag) {
                        //不存在拼音重复
                        if (zuciju.getId() != null) {
                            //判断ID是否重复
                            for (Zuciju _zuciju : hanzi.getZucijus()) {
                                if (zuciju.getId().equals(_zuciju.getId())) {
                                    _zuciju.setCi1(zuciju.getCi1());
                                    _zuciju.setCi2(zuciju.getCi2());
                                    _zuciju.setJu(zuciju.getJu());
                                }
                            }
                        } else {
                            hanzi.getZucijus().add(zuciju);
                        }
                    }
                }
            }
            hanzi.setCijuStatus((short)1);
            hanziDao.saveOrUpdate(hanzi);
        } else {
            return blackcat.SystemConstants.FEEDBACK.HANZI_ID_ERROR;
        }
        return SystemConstants.FEEDBACK.SUCCESS;
    }
}
