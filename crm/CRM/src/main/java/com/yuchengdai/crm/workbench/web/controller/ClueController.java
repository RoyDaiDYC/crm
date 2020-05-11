package com.yuchengdai.crm.workbench.web.controller;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.DictionaryValue;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.settings.service.DictionaryValueService;
import com.yuchengdai.crm.settings.service.UserService;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/12   21:22
 */
@Controller
public class ClueController {

    private UserService userService;
    private DictionaryValueService dictionaryValueService;
    private ClueService clueService;
    private ClueRemarkService clueRemarkService;
    private ClueActivityRelationService clueActivityRelationService;
    private MarketingActivitiesService marketingActivitiesService;

    @Autowired
    public ClueController setUserService(UserService userService) {
        this.userService = userService;
        return this;
    }

    @Autowired
    public ClueController setDictionaryValueService(DictionaryValueService dictionaryValueService) {
        this.dictionaryValueService = dictionaryValueService;
        return this;
    }

    @Autowired
    public ClueController setClueService(ClueService clueService) {
        this.clueService = clueService;
        return this;
    }

    @Autowired
    public ClueController setClueRemarkService(ClueRemarkService clueRemarkService) {
        this.clueRemarkService = clueRemarkService;
        return this;
    }

    @Autowired
    public ClueController setClueActivityRelationService(ClueActivityRelationService clueActivityRelationService) {
        this.clueActivityRelationService = clueActivityRelationService;
        return this;
    }

    @Autowired
    public ClueController setMarketingActivitiesService(MarketingActivitiesService marketingActivitiesService) {
        this.marketingActivitiesService = marketingActivitiesService;
        return this;
    }

    /**
     * 跳转到线索首页
     * 同时把下拉菜单内容都显示
     *
     * @return
     */
    @RequestMapping(value = "/workbench/clue/toIndex.do",method = RequestMethod.GET)
    public String toIndex(Model model) {
        //获取所有的用户信息，给前端提供拥有着
        List<User> userList = userService.queryAllUsers();
        //获取所有称呼，给前端提供称呼
        String typeCode = "appellation";
        List<DictionaryValue> appellationList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //获取所有线索状态，给前端提供线索状态
        typeCode = "clue_state";
        List<DictionaryValue> clueStateList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //获取所有线索来源，给前端提供线索来源
        typeCode = "source";
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //装箱
        model.addAttribute("userList", userList);
        model.addAttribute("appellationList", appellationList);
        model.addAttribute("clueStateList", clueStateList);
        model.addAttribute("sourceList", sourceList);
        return "workbench/clue/index";
    }

    @RequestMapping(value = "/workbench/clue/saveCreateClue.do",method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //添加线索id
        clue.setId(YuChengUID.getNoHyphenUUID());
        //添加创建人
        clue.setCreateBy(user.getId());
        //添加创建时间
        clue.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        try {
            int i = clueService.addClue(clue);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("添加成功");
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
     * 通过筛查条件，查询出符合条件的线索内容
     *
     * @param fullName
     * @param company
     * @param phone
     * @param source
     * @param owner
     * @param mphone
     * @param state
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/workbench/clue/getClueByCondition.do",method = RequestMethod.POST)
    @ResponseBody
    public Object getClueByCondition(String fullName, String company, String phone,
                                     String source, String owner, String mphone,
                                     String state,
                                     @RequestParam(required = false, defaultValue = "1") int pageNo,
                                     @RequestParam(required = false, defaultValue = "5") int pageSize) {
        int beginNo = pageSize * (pageNo - 1);
        Map<String, Object> map = new HashMap<>();
        map.put("fullName", fullName);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);
        PaginationResultVO<Clue> prVO = clueService.queryAllClueForDetailByCondition(map);
        return prVO;
    }

    /**
     * 进入更新页面，附带查出对应要修改的线索内容
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/clue/toModifyClueById.do",method = RequestMethod.POST)
    @ResponseBody
    public Object toModifyClue(String id) {
        Map<String, Object> map = new HashMap<>();
        Clue clue = clueService.queryClueById(id);
        //获取所有的用户信息，给前端提供拥有着
        List<User> userList = userService.queryAllUsers();
        //获取所有称呼，给前端提供称呼
        String typeCode = "appellation";
        List<DictionaryValue> appellationList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //获取所有线索状态，给前端提供线索状态
        typeCode = "clue_state";
        List<DictionaryValue> clueStateList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //获取所有线索来源，给前端提供线索来源
        typeCode = "source";
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        map.put("userList", userList);
        map.put("appellationList", appellationList);
        map.put("clueStateList", clueStateList);
        map.put("sourceList", sourceList);
        map.put("clue", clue);
        return map;
    }

    /**
     * 对线索进行更新
     *
     * @param clue
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/clue/modifyClue.do",method = RequestMethod.POST)
    @ResponseBody
    public Object modifyClue(Clue clue,
                             HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //添加修改人
        clue.setEditBy(user.getId());
        //添加修改时间
        clue.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //装箱
        try {
            int i = clueService.editClueById(clue);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("修改成功");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("修改失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，修改失败");
        }
        return returnObject;
    }

    /**
     * 通过id删除对应的线索
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/clue/deleteClue.do",method = RequestMethod.POST)
    @ResponseBody
    public Object removeClue(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = clueService.deleteClueById(id);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("成功删除" + i + "条内容");
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
     * 跳转到线索备注页面
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/workbench/clue/toDetail.do",method = RequestMethod.GET)
    public String toClueDetail(String id, Model model) {
        //根据id获取选中的线索详细内容，唯一标识替换成文本
        Clue clue = clueService.queryClueForDetailById(id);
        //根据id获取选中的线索的备注集合内容
        List<ClueRemark> clueRemarks = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        //根据clueId获取当前线索内所有关联活动的关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationService.queryClueActivityRelation(id);
        //使用一个集合存储这些关联的线索活动关联内容
        List<MarketingActivities> marketingActivitiesList = new ArrayList<>();
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            marketingActivitiesList.add(marketingActivitiesService.queryMarketingActivitiesForDetailById(clueActivityRelation.getActivityId()));
        }
        model.addAttribute("clue", clue);
        model.addAttribute("clueRemarkList", clueRemarks);
        model.addAttribute("activityRelationList", marketingActivitiesList);
        return "workbench/clue/detail";
    }

}
