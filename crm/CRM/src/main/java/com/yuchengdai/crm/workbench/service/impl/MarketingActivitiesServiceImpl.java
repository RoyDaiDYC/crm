package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.workbench.domain.MarketingActivities;
import com.yuchengdai.crm.workbench.mapper.marketingActivities.MarketingActivitiesMapper;
import com.yuchengdai.crm.workbench.mapper.marketingActivities.MarketingActivitiesRemarkMapper;
import com.yuchengdai.crm.workbench.service.MarketingActivitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/13   15:45
 */
@Service
public class MarketingActivitiesServiceImpl implements MarketingActivitiesService {


    private MarketingActivitiesMapper marketingActivitiesMapper;

    private MarketingActivitiesRemarkMapper marketingActivitiesRemarkMapper;

    @Autowired
    public MarketingActivitiesServiceImpl setMarketingActivitiesMapper(MarketingActivitiesMapper marketingActivitiesMapper) {
        this.marketingActivitiesMapper = marketingActivitiesMapper;
        return this;
    }

    @Autowired
    public MarketingActivitiesServiceImpl setMarketingActivitiesRemarkMapper(MarketingActivitiesRemarkMapper marketingActivitiesRemarkMapper) {
        this.marketingActivitiesRemarkMapper = marketingActivitiesRemarkMapper;
        return this;
    }

    /**
     * 添加一个市场活动
     *
     * @param marketingActivities
     * @return
     */
    @Override
    public int addMarketingActivities(MarketingActivities marketingActivities) {
        return marketingActivitiesMapper.insertMarketingActivities(marketingActivities);
    }

    /**
     * 通过数据库获取到筛选条件下的市场活动所有内容和筛选条件下的内容条数
     * 把这些内容装箱到分页结果容器内
     *
     * @param map
     * @return
     */
    @Override
    public PaginationResultVO<MarketingActivities> queryMarketingActivitiesForDetailByCondition(Map<String, Object> map) {
        PaginationResultVO<MarketingActivities> prVO = new PaginationResultVO<>();
        List<MarketingActivities> activitiesList = marketingActivitiesMapper.selectAllMarketingActivitiesForDetailByCondition(map);
        int totalRows = marketingActivitiesMapper.selectCountAllMarketingActivities(map);
        prVO.setDataList(activitiesList).setTotalRows(totalRows);
        return prVO;
    }

    /**
     * 通过id更新市场活动内容
     *
     * @param marketingActivities
     * @return
     */
    @Override
    public int editMarketingActivitiesById(MarketingActivities marketingActivities) {
        return marketingActivitiesMapper.updateMarketingActivitiesById(marketingActivities);
    }

    /**
     * 通过id查询出市场活动内容
     *
     * @param id
     * @return
     */
    @Override
    public MarketingActivities queryMarketingActivitiesById(String id) {
        return marketingActivitiesMapper.selectMarketingActivitiesById(id);
    }

    /**
     * 通过id删除市场活动信息
     *
     * @param ids
     * @return
     */
    @Override
    public int deleteMarketingActivitiesById(String[] ids) {

        //先删除对应的市场活动备注信息
        marketingActivitiesRemarkMapper.deleteMarketingActivitiesRemarkByActivityId(ids);


        //再删除市场活动内容
        return marketingActivitiesMapper.deleteMarketingActivitiesById(ids);
    }

    /**
     * 获取所有市场活动信息
     *
     * @return
     */
    @Override
    public List<MarketingActivities> queryAllMarketingActivitiesForDetail() {
        return marketingActivitiesMapper.selectAllMarketingActivitiesForDetail();
    }

    /**
     * 通过id查询出市场活动信息
     * 查询出多条活动内容进行导出
     *
     * @param ids
     * @return
     */
    @Override
    public List<MarketingActivities> queryMarketingActivitiesForDetailByIds(String[] ids) {
        return marketingActivitiesMapper.selectMarketingActivitiesForDetailByIds(ids);
    }

    /**
     * 同时插入多条市场活动信息
     *
     * @param marketingActivitiesList
     * @return
     */
    @Override
    public int addMarketingActivitiesList(List<MarketingActivities> marketingActivitiesList) {
        return marketingActivitiesMapper.insertMarketingActivitiesList(marketingActivitiesList);
    }


    /**
     * 通过id查询出市场活动信息，关联user名称
     *
     * @param id
     * @return
     */
    @Override
    public MarketingActivities queryMarketingActivitiesForDetailById(String id) {
        return marketingActivitiesMapper.selectMarketingActivitiesForDetailById(id);
    }

    /**
     * map封装name和clueId
     * 通过name模糊查询出市场活动
     * 通过clueId查询出关联过的市场活动
     * 最后查询出的市场活动不能包含已关联过的内容
     *
     * @param map
     * @return
     */
    @Override
    public List<MarketingActivities> queryMarketingActivitiesForDetailByNameAndClueId(Map<String, Object> map) {
        return marketingActivitiesMapper.selectMarketingActivitiesForDetailByNameAndClueId(map);
    }

    /**
     * 通过name模糊查询获取到对应的市场活动集合
     *
     * @param name
     * @return
     */
    @Override
    public List<MarketingActivities> queryMarketingActivitiesForDetailByName(String name) {
        return marketingActivitiesMapper.selectMarketingActivitiesForDetailByName(name);
    }

    /**
     * map封装name和contactsId
     * 通过name模糊查询出市场活动
     * 通过clueId查询出关联过的市场活动
     * 最后查询出的市场活动不能包含已关联的内容
     *
     * @param map
     * @return
     */
    @Override
    public List<MarketingActivities> queryMarketingActivitiesForDetailByNameAndContactsId(Map<String, Object> map) {
        return marketingActivitiesMapper.selectMarketingActivitiesForDetailByNameAndContactsId(map);
    }


}
