/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.dao;

import blackcat.model.Ciyu;

public interface CiyuDao extends BaseDao<Ciyu> {
    @Override
    public void saveOrUpdate(Ciyu ciyu);
}
