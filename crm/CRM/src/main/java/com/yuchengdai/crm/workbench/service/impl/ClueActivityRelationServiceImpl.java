package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.workbench.domain.ClueActivityRelation;
import com.yuchengdai.crm.workbench.mapper.clue.ClueActivityRelationMapper;
import com.yuchengdai.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/26   20:22
 */
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    public ClueActivityRelationServiceImpl setClueActivityRelationMapper(ClueActivityRelationMapper clueActivityRelationMapper) {
        this.clueActivityRelationMapper = clueActivityRelationMapper;
        return this;
    }

    /**
     * 批量添加线索活动关联内容
     *
     * @param clueActivityRelationList
     * @return
     */
    @Override
    public int addClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList) {
        return clueActivityRelationMapper.insertClueActivityRelation(clueActivityRelationList);
    }

    /**
     * 通过clueId获取对应关系市场活动集合内容
     *
     * @param clueId
     * @return
     */
    @Override
    public List<ClueActivityRelation> queryClueActivityRelation(String clueId) {
        return clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
    }

    /**
     * 通过clueId确定线索
     * 通过activityId确定删除的市场活动
     *
     * @param map
     * @return
     */
    @Override
    public int deleteClueActivityRelationByClueIdActivityId(Map<String, Object> map) {
        return clueActivityRelationMapper.deleteClueActivityRelationByClueIdActivityId(map);
    }
}
