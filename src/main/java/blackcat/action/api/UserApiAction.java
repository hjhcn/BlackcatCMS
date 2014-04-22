/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.action.api;

import blackcat.action.BaseAction;
import blackcat.annotation.UserAuthority;
import blackcat.model.Ranking;
import blackcat.model.User;
import blackcat.model.page.PageView;
import blackcat.rules.UserRule;
import blackcat.service.RankingService;
import blackcat.utils.Ip;
import blackcat.utils.Time;
import org.apache.struts2.interceptor.ServletRequestAware;

import javax.servlet.http.HttpServletRequest;

public class UserApiAction extends BaseAction implements UserRule, ServletRequestAware {

    private static final long serialVersionUID = 5963893670905748460L;
    private User user;
    private Ranking ranking;
    private RankingService rankingService;
    private PageView<Ranking> rankings;
    public HttpServletRequest request;
    private String hanziWriteData;

    @UserAuthority(needLogin = true)
    public String ranking() {
        ranking = rankingService.getRankingById(user.getUid());
        return SUCCESS;
    }

    public String rankingList() {
        rankings = rankingService.findScrollData(page, rows, order, sort);
        return SUCCESS;
    }

    @UserAuthority(needLogin = true)
    public String updateRanking() {
        String ip = Ip.getIpAddr(request);
        if (ip.length() > 15) ip = ip.substring(0, 15);
        ranking.setLastIp(ip);
        ranking.setUid(user.getUid());
        ranking.setUsername(user.getUsername());
        ranking.setUpdateTime(Time.getTimeStamp());
        feedback = rankingService.update(ranking);
        return SUCCESS;
    }

    @UserAuthority(needLogin = true)
    public String uploadHanziWriteData(){

        return SUCCESS;
    }

    @Override
    public void setUser(User user) {
        this.user = user;
    }

    public Ranking getRanking() {
        return ranking;
    }

    public void setRanking(Ranking ranking) {
        this.ranking = ranking;
    }

    public void setRankingService(RankingService rankingService) {
        this.rankingService = rankingService;
    }

    public PageView<Ranking> getRankings() {
        return rankings;
    }

    public void setRankings(PageView<Ranking> rankings) {
        this.rankings = rankings;
    }

    @Override
    public void setServletRequest(HttpServletRequest request) {
        this.request = request;
    }

    public String getHanziWriteData() {
        return hanziWriteData;
    }

    public void setHanziWriteData(String hanziWriteData) {
        this.hanziWriteData = hanziWriteData;
    }
}
