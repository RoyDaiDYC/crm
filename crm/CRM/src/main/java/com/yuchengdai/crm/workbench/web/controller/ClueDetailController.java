package com.yuchengdai.crm.workbench.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.DictionaryValue;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.settings.service.DictionaryValueService;
import com.yuchengdai.crm.workbench.domain.Clue;
import com.yuchengdai.crm.workbench.domain.ClueActivityRelation;
import com.yuchengdai.crm.workbench.domain.ClueRemark;
import com.yuchengdai.crm.workbench.domain.MarketingActivities;
import com.yuchengdai.crm.workbench.service.ClueActivityRelationService;
import com.yuchengdai.crm.workbench.service.ClueRemarkService;
import com.yuchengdai.crm.workbench.service.ClueService;
import com.yuchengdai.crm.workbench.service.MarketingActivitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/25   20:17
 */
@Controller
public class ClueDetailController {

    private ClueRemarkService clueRemarkService;

    private MarketingActivitiesService marketingActivitiesService;

    private ClueActivityRelationService clueActivityRelationService;

    private ClueService clueService;

    private DictionaryValueService dictionaryValueService;

    @Autowired
    public ClueDetailController setClueRemarkService(ClueRemarkService clueRemarkService) {
        this.clueRemarkService = clueRemarkService;
        return this;
    }

    @Autowired
    public ClueDetailController setMarketingActivitiesService(MarketingActivitiesService marketingActivitiesService) {
        this.marketingActivitiesService = marketingActivitiesService;
        return this;
    }

    @Autowired
    public ClueDetailController setClueActivityRelationService(ClueActivityRelationService clueActivityRelationService) {
        this.clueActivityRelationService = clueActivityRelationService;
        return this;
    }

    @Autowired
    public ClueDetailController setClueService(ClueService clueService) {
        this.clueService = clueService;
        return this;
    }

    @Autowired
    public ClueDetailController setDictionaryValueService(DictionaryValueService dictionaryValueService) {
        this.dictionaryValueService = dictionaryValueService;
        return this;
    }

    /**
     * 插入一条线索备注内容
     *
     * @param clueRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/clue/saveCreateClueRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark clueRemark, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //添加备注信息，补全内容
        //添加备注id
        clueRemark.setId(YuChengUID.getNoHyphenUUID());
        //添加创建人
        clueRemark.setCreateBy(user.getId());
        //添加创建时间
        clueRemark.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //添加是否修改标识，0未修改，1修改
        clueRemark.setEditFlag("0");
        try {
            int i = clueRemarkService.addClueRemark(clueRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("添加成功");
                returnObject.setData(clueRemark);
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("添加失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，添加失败");
        }
        return returnObject;
    }

    /**
     * 通过id更新线索备注内容
     *
     * @param clueRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/clue/modifyClueRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Object modifyClueRemark(ClueRemark clueRemark,
                                   HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //添加修改人
        clueRemark.setEditBy(user.getId());
        //添加修改时间
        clueRemark.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //修改标志改为1
        clueRemark.setEditFlag("1");
        try {
            int i = clueRemarkService.editClueRemarkById(clueRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("更新成功");
                returnObject.setData(clueRemark);
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，更新失败");
        }
        return returnObject;
    }

    /**
     * 根据id删除对应的线索备注内容
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/clue/deleteClueRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Object removeClueRemark(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = clueRemarkService.deleteClueRemarkById(id);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("删除成功");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，删除失败");
        }
        return returnObject;
    }

    /**
     * 根据搜索框 模糊搜索市场活动名称，查询出内容
     * 当前线索已经关联过的市场活动不进行查询获取
     *
     * @param activityName
     * @param clueId
     * @return
     */
    @RequestMapping(value = "/workbench/clue/searchActivities.do",method = RequestMethod.POST)
    @ResponseBody
    public Object searchActivities(String activityName, String clueId) {
        Map<String, Object> map = new HashMap<>();
        map.put("name", activityName);
        map.put("clueId", clueId);
        List<MarketingActivities> activitiesList = marketingActivitiesService.queryMarketingActivitiesForDetailByNameAndClueId(map);
        return activitiesList;
    }


    /**
     * 线索关联市场活动
     * 一个线索可以一次关联多个市场活动
     *
     * @param clueId
     * @param activityIds
     * @return
     */
    @RequestMapping(value = "/workbench/clue/bindClueActivity.do",method = RequestMethod.POST)
    @ResponseBody
    public Object bindClueActivity(String clueId, String[] activityIds) {
        ReturnObject returnObject = new ReturnObject();
        List<ClueActivityRelation> clueActivityRelationList = new ArrayList<>();
        //对活动id进行遍历
        /*
         * 当前线索可以关联多个市场活动
         * 需要达到，一个id对应当前clueId对应一个activityId
         * */
        for (String activityId : activityIds) {
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            //补充id
            clueActivityRelation.setId(YuChengUID.getNoHyphenUUID());
            clueActivityRelation.setClueId(clueId);
            clueActivityRelation.setActivityId(activityId);
            clueActivityRelationList.add(clueActivityRelation);
        }
        //获取当前关联的活动内容
        List<MarketingActivities> marketingActivitiesList = marketingActivitiesService.queryMarketingActivitiesForDetailByIds(activityIds);
        try {
            int i = clueActivityRelationService.addClueActivityRelation(clueActivityRelationList);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("关联成功" + i + "个市场活动");
                returnObject.setData(marketingActivitiesList);
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("关联失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，关联失败");
        }
        return returnObject;
    }

    /**
     * 移除线索和活动关联
     * 一次移除一条内容
     * 获取当前线索id
     * 获取移除的活动
     *
     * @param clueId
     * @param activityId
     * @return
     */
    @RequestMapping(value = "/workbench/clue/removeRelation.do",method = RequestMethod.POST)
    @ResponseBody
    public Object removeClueActivityRelation(String clueId, String activityId) {
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        map.put("clueId", clueId);
        map.put("activityId", activityId);
        try {
            int i = clueActivityRelationService.deleteClueActivityRelationByClueIdActivityId(map);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("解除成功");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("解除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，解除失败");
        }
        return returnObject;
    }

    /**
     * 点击转换按钮跳转到转换页面
     * 附带过去当前线索id和数据字典类型是stage阶段的数据字典值集合
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/workbench/clue/toConvert.do",method = RequestMethod.GET)
    public String toConvert(String id, Model model) {
        Clue clue = clueService.queryClueForDetailById(id);
        String typeCode = "stage";
        List<DictionaryValue> stageList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        model.addAttribute("clue", clue);
        model.addAttribute("stageList", stageList);
        return "workbench/clue/convert";
    }
}
