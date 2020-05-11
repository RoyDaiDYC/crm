package com.yuchengdai.crm.workbench.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.workbench.domain.ContactsActivityRelation;
import com.yuchengdai.crm.workbench.domain.ContactsRemark;
import com.yuchengdai.crm.workbench.domain.MarketingActivities;
import com.yuchengdai.crm.workbench.service.ContactsActivityRelationService;
import com.yuchengdai.crm.workbench.service.ContactsRemarkService;
import com.yuchengdai.crm.workbench.service.MarketingActivitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
 * 2017/4/8   15:25
 */
@Controller
public class ContactsDetailController {

    private ContactsRemarkService contactsRemarkService;

    private MarketingActivitiesService marketingActivitiesService;

    private ContactsActivityRelationService contactsActivityRelationService;

    @Autowired
    public ContactsDetailController setContactsRemarkService(ContactsRemarkService contactsRemarkService) {
        this.contactsRemarkService = contactsRemarkService;
        return this;
    }

    @Autowired
    public ContactsDetailController setMarketingActivitiesService(MarketingActivitiesService marketingActivitiesService) {
        this.marketingActivitiesService = marketingActivitiesService;
        return this;
    }

    @Autowired
    public ContactsDetailController setContactsActivityRelationService(ContactsActivityRelationService contactsActivityRelationService) {
        this.contactsActivityRelationService = contactsActivityRelationService;
        return this;
    }

    /**
     * 添加一个联系人备注信息
     *
     * @param contactsRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/saveCreateContactsRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object addContactsRemark(ContactsRemark contactsRemark,
                                    HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //补全联系人备注信息
        //添加id
        contactsRemark.setId(YuChengUID.getNoHyphenUUID());
        //添加创建人
        contactsRemark.setCreateBy(user.getId());
        //添加创建时间
        contactsRemark.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //添加修改标记，0是未修改，1是修改
        contactsRemark.setEditFlag("0");
        try {
            int i = contactsRemarkService.addContactsRemark(contactsRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("添加成功");
                returnObject.setData(contactsRemark);
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
     * 通过id修改对应的联系人备注信息
     *
     * @param contactsRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/modifyContactsRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object modifyContactsRemark(ContactsRemark contactsRemark,
                                       HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //补全修改内容
        //添加修改人
        contactsRemark.setEditBy(user.getId());
        //添加修改时间
        contactsRemark.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //改变修改标签，0代表未修改，1代表修改
        contactsRemark.setEditFlag("1");
        try {
            int i = contactsRemarkService.updateContactsRemark(contactsRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("修改成功");
                returnObject.setData(contactsRemark);
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
     * 通过id删除对应的联系人备注信息
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/deleteContactsRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object removeContactsRemarkById(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = contactsRemarkService.deleteContactsRemarkById(id);
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
     * 当前联系人已经关联过的市场活动不进行查询获取
     *
     * @param activityName
     * @param contactsId
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/searchActivities.do", method = RequestMethod.POST)
    @ResponseBody
    public Object searchActivities(String activityName, String contactsId) {
        Map<String, Object> map = new HashMap<>();
        map.put("name", activityName);
        map.put("contactsId", contactsId);
        List<MarketingActivities> activitiesList = marketingActivitiesService.queryMarketingActivitiesForDetailByNameAndContactsId(map);
        return activitiesList;
    }

    /**
     * 关联市场活动
     * 一个联系人可以一次关联多个市场活动
     *
     * @param contactsId
     * @param activityIds
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/bindClueActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public Object bindContactsActivity(String contactsId, String[] activityIds) {
        ReturnObject returnObject = new ReturnObject();
        List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
        for (String activityId : activityIds) {
            ContactsActivityRelation activityRelation = new ContactsActivityRelation();
            activityRelation.setId(YuChengUID.getNoHyphenUUID());
            activityRelation.setContactsId(contactsId);
            activityRelation.setActivityId(activityId);
            contactsActivityRelationList.add(activityRelation);
        }
        List<MarketingActivities> activitiesRelationList = marketingActivitiesService.queryMarketingActivitiesForDetailByIds(activityIds);
        try {
            int i = contactsActivityRelationService.addContactsActivityRelation(contactsActivityRelationList);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("关联成功" + i + "个市场活动");
                returnObject.setData(activitiesRelationList);
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
     * 通过联系人id和市场id确认要删除的联系人市场活动关系内容
     *
     * @param contactsId
     * @param activityId
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/removeRelation.do", method = RequestMethod.POST)
    @ResponseBody
    public Object removeRelation(String contactsId, String activityId) {
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        map.put("contactsId", contactsId);
        map.put("activityId", activityId);
        try {
            int i = contactsActivityRelationService.deleteContactsActivityRelationByContactsIdActivityId(map);
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

}
