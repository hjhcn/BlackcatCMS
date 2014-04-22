/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

/**
 * Created by haojunhua on 14-4-1.
 */
public class Zuciju implements java.io.Serializable {

    private Integer id;
    private String pinyinyindiao;
    private String ci1;
    private String ci2;
    private String ju;
    private Hanzi hanzi;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getPinyinyindiao() {
        return pinyinyindiao;
    }

    public void setPinyinyindiao(String pinyinyindiao) {
        this.pinyinyindiao = pinyinyindiao;
    }

    public String getCi1() {
        return ci1;
    }

    public void setCi1(String ci1) {
        this.ci1 = ci1;
    }

    public String getCi2() {
        return ci2;
    }

    public void setCi2(String ci2) {
        this.ci2 = ci2;
    }

    public String getJu() {
        return ju;
    }

    public void setJu(String ju) {
        this.ju = ju;
    }

    public Hanzi getHanzi() {
        return hanzi;
    }

    public void setHanzi(Hanzi hanzi) {
        this.hanzi = hanzi;
    }
}
