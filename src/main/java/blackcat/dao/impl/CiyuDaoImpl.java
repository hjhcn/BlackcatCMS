/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.dao.impl;

import blackcat.dao.CiyuDao;
import blackcat.model.Ciyu;

public class CiyuDaoImpl extends BaseDaoImpl<Ciyu> implements CiyuDao {

    @Override
    public void saveOrUpdate(Ciyu ciyu){
//        ciyu.setVersion(version);
        super.saveOrUpdate(ciyu);
    }
}
