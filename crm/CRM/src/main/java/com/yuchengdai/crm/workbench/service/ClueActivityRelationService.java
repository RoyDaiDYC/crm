package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/26   20:09
 */
public interface ClueActivityRelationService {

    //批量添加线索关联活动关系
    int addClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList);

    //根据clueId获取对应关联的市场活动关系集合
    List<ClueActivityRelation> queryClueActivityRelation(String clueId);

    //通过clueId确定线索，通过activityId确定删除的市场活动
    int deleteClueActivityRelationByClueIdActivityId(Map<String, Object> map);


}
