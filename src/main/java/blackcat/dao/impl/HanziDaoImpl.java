/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.dao.impl;

import blackcat.dao.HanziDao;
import blackcat.model.Hanzi;
import java.util.List;

public class HanziDaoImpl extends BaseDaoImpl<Hanzi> implements HanziDao {

    @Override
    public void saveOrUpdate(Hanzi hanzi) {
//        hanzi.setVersion(version);
        super.saveOrUpdate(hanzi);
    }

    @Override
    public Hanzi getDetail(int id) {
        List<Hanzi> hanzis = this
                .getHibernateTemplate()
                .find("from Hanzi hanzi left outer join fetch hanzi.zucijus where hanzi.id=?",
                        id);
        if (hanzis == null || hanzis.size() == 0)
            return null;
        return hanzis.get(0);
    }
}
