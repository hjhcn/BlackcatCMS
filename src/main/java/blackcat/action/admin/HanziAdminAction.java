/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.action.admin;

import blackcat.SystemConstants.AUTHORITY;
import blackcat.SystemConstants.OPERATE;
import blackcat.annotation.AdminAuthority;
import blackcat.model.Admin;
import blackcat.model.Hanzi;
import blackcat.model.Zuciju;
import blackcat.model.page.PageView;
import blackcat.service.HanziService;

import java.util.List;

public class HanziAdminAction extends BaseAdminAction {

    private static final long serialVersionUID = -4163982429170402027L;
    private HanziService hanziService;
    private String zi;
    private PageView<Hanzi> hanzis;
    private Hanzi hanzi;
    private String statuses;
    private String ids;
    private OPERATE operate;
    private String fileListStr;
    private Zuciju zuciju;
    private List<Zuciju> zucijuList;
    private int hid;

    @AdminAuthority(authority = AUTHORITY.SUPER)
    public String backupPassed() {
        hanziService.backupPassed();
        return SUCCESS;
    }

    @AdminAuthority(authority = AUTHORITY.EDIT)
    public String updateZuciju() {
        feedback=hanziService.updataZuciju(hid,zucijuList);
        return SUCCESS;
    }

    public String list() {
        Admin findAdmin = admin;
        if (admin.getAuthority() != AUTHORITY.EDIT)
            findAdmin = null;
        if (admin.getAuthority() == AUTHORITY.VIEW) {
            statuses = "4";
        }
        hanzis = hanziService.findScrollData(findAdmin, zi, statuses, 0, page, rows, order, sort);
        return SUCCESS;
    }

    public String detail() {
        hanzi = hanziService.getDetail(id);
        return SUCCESS;
    }

    public String stroke() {
        hanzi = hanziService.get(id);
        return SUCCESS;
    }

    @AdminAuthority(authority = AUTHORITY.EDIT)
    public String updateContourLocus() {
        feedback = hanziService.updateContourLocus(hanzi);
        return SUCCESS;
    }

    @AdminAuthority(authority = AUTHORITY.EDIT)
    public String operate() {
        setCount(hanziService.operate(ids, operate));
        return SUCCESS;
    }

    @AdminAuthority(authority = AUTHORITY.EDIT)
    public String batchSaveAudio() {
        feedback = hanziService.batchSaveAudio(fileListStr, admin);
        return SUCCESS;
    }

    public void setHanziService(HanziService hanziService) {
        this.hanziService = hanziService;
    }

    public String getZi() {
        return zi;
    }

    public void setZi(String zi) {
        this.zi = zi;
    }

    public PageView<Hanzi> getHanzis() {
        return hanzis;
    }

    public void setHanzis(PageView<Hanzi> hanzis) {
        this.hanzis = hanzis;
    }

    public Hanzi getHanzi() {
        return hanzi;
    }

    public void setHanzi(Hanzi hanzi) {
        this.hanzi = hanzi;
    }

    public String getIds() {
        return ids;
    }

    public void setIds(String ids) {
        this.ids = ids;
    }

    public OPERATE getOperate() {
        return operate;
    }

    public void setOperate(OPERATE operate) {
        this.operate = operate;
    }

    public String getStatuses() {
        return statuses;
    }

    public void setStatuses(String statuses) {
        this.statuses = statuses;
    }

    public String getFileListStr() {
        return fileListStr;
    }

    public void setFileListStr(String fileListStr) {
        this.fileListStr = fileListStr;
    }


    public blackcat.model.Zuciju getZuciju() {
        return zuciju;
    }

    public void setZuciju(blackcat.model.Zuciju zuciju) {
        this.zuciju = zuciju;
    }

    public java.util.List<blackcat.model.Zuciju> getZucijuList() {
        return zucijuList;
    }

    public void setZucijuList(java.util.List<blackcat.model.Zuciju> zucijuList) {
        this.zucijuList = zucijuList;
    }

    public int getHid() {
        return hid;
    }

    public void setHid(int hid) {
        this.hid = hid;
    }
}
