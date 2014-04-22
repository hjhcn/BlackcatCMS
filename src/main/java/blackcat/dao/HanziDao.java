/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.dao;

import blackcat.model.Hanzi;

public interface HanziDao extends BaseDao<Hanzi> {
    public void saveOrUpdate(Hanzi hanzi);

    public Hanzi getDetail(int id);
}
