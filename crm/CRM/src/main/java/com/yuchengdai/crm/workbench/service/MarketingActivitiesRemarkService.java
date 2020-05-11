package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.workbench.domain.MarketingActivitiesRemark;

import java.util.List;

/**
 * RoyDai
 * 2017/3/19   19:55
 */
public interface MarketingActivitiesRemarkService {

    //通过市场活动id查询出对应市场活动备注集合
    List<MarketingActivitiesRemark> queryMarketingActivitiesRemarkByActivityId(String activityId);

    //添加市场活动对应的备注信息
    int addMarketingActivitiesRemark(MarketingActivitiesRemark marketingActivitiesRemark);

    //通过id查询出市场备注信息
    //前端可以通过jsp直接获取，暂停使用
    /*MarketingActivitiesRemark queryMarketingActivitiesnoteContentById(String id);*/

    //根据id更新市场活动备注信息
    int editMarketingActivitiesRemarkById(MarketingActivitiesRemark marketingActivitiesRemark);

    //根据id删除市场活动备注信息
    int deleteMarketingActivitiesRemarkById(String id);
}
