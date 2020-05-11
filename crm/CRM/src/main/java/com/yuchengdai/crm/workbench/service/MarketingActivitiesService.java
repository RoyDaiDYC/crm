package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.workbench.domain.MarketingActivities;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/13   15:45
 */
public interface MarketingActivitiesService {

    //添加一个市场活动
    int addMarketingActivities(MarketingActivities marketingActivities);

    //获取所有市场活动内容，且可以通过筛选条件进行筛选
    PaginationResultVO<MarketingActivities> queryMarketingActivitiesForDetailByCondition(Map<String, Object> map);

    //通过id更新市场活动内容
    int editMarketingActivitiesById(MarketingActivities marketingActivities);

    //通过id查询出市场活动内容
    MarketingActivities queryMarketingActivitiesById(String id);

    //通过id删除市场活动信息
    //先删除对应市场活动的备注内容
    int deleteMarketingActivitiesById(String[] ids);

    //获取所有市场活动信息
    List<MarketingActivities> queryAllMarketingActivitiesForDetail();

    //通过id获取市场活动信息
    List<MarketingActivities> queryMarketingActivitiesForDetailByIds(String[] ids);

    //同时插入多条市场活动信息
    int addMarketingActivitiesList(List<MarketingActivities> marketingActivitiesList);

    //通过id获取市场活动信息，关联user表内容
    MarketingActivities queryMarketingActivitiesForDetailById(String id);

    //通过name模糊查询获取市场活动，通过clueId查询出对应线索关联过的市场活动
    //查询出的内容不能包含已关联过的市场活动
    List<MarketingActivities> queryMarketingActivitiesForDetailByNameAndClueId(Map<String, Object> map);

    //通过name模糊查询获取到市场活动集合
    List<MarketingActivities> queryMarketingActivitiesForDetailByName(String name);

    //通过name模糊查询获取市场活动，通过contactsId查询出对应联系人关联过的市场活动
    //查询出的内容不能包含已关联过的市场活动
    List<MarketingActivities> queryMarketingActivitiesForDetailByNameAndContactsId(Map<String, Object> map);
}
