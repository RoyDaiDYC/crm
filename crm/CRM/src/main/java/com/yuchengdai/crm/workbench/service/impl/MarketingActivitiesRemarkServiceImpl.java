package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.workbench.domain.MarketingActivitiesRemark;
import com.yuchengdai.crm.workbench.mapper.marketingActivities.MarketingActivitiesRemarkMapper;
import com.yuchengdai.crm.workbench.service.MarketingActivitiesRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * RoyDai
 * 2017/3/19   19:57
 */
@Service
public class MarketingActivitiesRemarkServiceImpl implements MarketingActivitiesRemarkService {


    private MarketingActivitiesRemarkMapper marketingActivitiesRemarkMapper;

    @Autowired
    public MarketingActivitiesRemarkServiceImpl setMarketingActivitiesRemarkMapper(MarketingActivitiesRemarkMapper marketingActivitiesRemarkMapper) {
        this.marketingActivitiesRemarkMapper = marketingActivitiesRemarkMapper;
        return this;
    }

    /**
     * 通过市场活动id查询出对应市场活动备注集合
     *
     * @param activityId
     * @return
     */
    @Override
    public List<MarketingActivitiesRemark> queryMarketingActivitiesRemarkByActivityId(String activityId) {
        return marketingActivitiesRemarkMapper.selectMarketingActivitiesRemarkForDetailByActivityId(activityId);
    }

    /**
     * 添加市场活动备注信息
     *
     * @param marketingActivitiesRemark
     * @return
     */
    @Override
    public int addMarketingActivitiesRemark(MarketingActivitiesRemark marketingActivitiesRemark) {
        return marketingActivitiesRemarkMapper.insertMarketingActivitiesRemark(marketingActivitiesRemark);
    }

    /**
     * 根据id更新市场活动备注信息
     *
     * @param marketingActivitiesRemark
     * @return
     */
    @Override
    public int editMarketingActivitiesRemarkById(MarketingActivitiesRemark marketingActivitiesRemark) {
        return marketingActivitiesRemarkMapper.updateMarketingActivitiesRemark(marketingActivitiesRemark);
    }

    /**
     * 根据id删除市场活动备注信息
     *
     * @param id
     * @return
     */
    @Override
    public int deleteMarketingActivitiesRemarkById(String id) {
        return marketingActivitiesRemarkMapper.deleteMarketingActivitiesRemarkById(id);
    }


    //前端可以通过jsp直接获取市场活动备注信息，暂停使用
    /*@Override
    public MarketingActivitiesRemark queryMarketingActivitiesnoteContentById(String id) {
        return marketingActivitiesRemarkMapper.selectMarketingActivitiesnoteContentById(id);
    }*/
}
