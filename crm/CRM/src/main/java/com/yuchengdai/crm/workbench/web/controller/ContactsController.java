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
import com.yuchengdai.crm.workbench.domain.*;
import com.yuchengdai.crm.workbench.service.*;
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
 * 2017/3/12   21:27
 */
@Controller
public class ContactsController {

    private ContactsService contactsService;

    private UserService userService;

    private DictionaryValueService dictionaryValueService;


    private ContactsRemarkService contactsRemarkService;

    private TransactionService transactionService;

    private ContactsActivityRelationService contactsActivityRelationService;

    private MarketingActivitiesService marketingActivitiesService;

    @Autowired
    public ContactsController setContactsService(ContactsService contactsService) {
        this.contactsService = contactsService;
        return this;
    }

    @Autowired
    public ContactsController setUserService(UserService userService) {
        this.userService = userService;
        return this;
    }

    @Autowired
    public ContactsController setDictionaryValueService(DictionaryValueService dictionaryValueService) {
        this.dictionaryValueService = dictionaryValueService;
        return this;
    }

    @Autowired
    public ContactsController setContactsRemarkService(ContactsRemarkService contactsRemarkService) {
        this.contactsRemarkService = contactsRemarkService;
        return this;
    }

    @Autowired
    public ContactsController setTransactionService(TransactionService transactionService) {
        this.transactionService = transactionService;
        return this;
    }

    @Autowired
    public ContactsController setContactsActivityRelationService(ContactsActivityRelationService contactsActivityRelationService) {
        this.contactsActivityRelationService = contactsActivityRelationService;
        return this;
    }

    @Autowired
    public ContactsController setMarketingActivitiesService(MarketingActivitiesService marketingActivitiesService) {
        this.marketingActivitiesService = marketingActivitiesService;
        return this;
    }

    /**
     * 跳转到联系人首页
     *
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/toIndex.do", method = RequestMethod.GET)
    public String toIndex(Model model) {
        List<User> userList = userService.queryAllUsers();
        String typeCode = "source";
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        typeCode = "appellation";
        List<DictionaryValue> appellationList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        model.addAttribute("userList", userList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("appellationList", appellationList);
        return "workbench/contacts/index";
    }


    /**
     * 添加一个联系人信息
     *
     * @param contacts
     * @param customerName
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/saveCreateContacts", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateContacts(Contacts contacts, String customerName,
                                     HttpSession session) {
        //使用map封装联系人信息和客户名称
        Map<String, Object> map = new HashMap<>();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //补全联系人信息
        //设置id
        contacts.setId(YuChengUID.getNoHyphenUUID());
        //设置创建人
        contacts.setCreateBy(user.getId());
        //设置创建日期
        contacts.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        map.put("contacts", contacts);
        map.put("customerName", customerName);
        try {
            int i = contactsService.addContacts(map);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("创建成功");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("创建失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，创建失败");
        }
        return returnObject;
    }


    /**
     * 根据筛选条件进行分页查询，获得联系人信息和总条数
     *
     * @param owner
     * @param fullName
     * @param customerName
     * @param source
     * @param birth
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/workbench/customer/getContactsByCondition.do", method = RequestMethod.POST)
    @ResponseBody
    public Object getContactsByCondition(String owner, String fullName,
                                         String customerName, String source, String birth,
                                         @RequestParam(required = false, defaultValue = "1") int pageNo,
                                         @RequestParam(required = false, defaultValue = "5") int pageSize) {
        int beginNo = pageSize * (pageNo - 1);
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("fullName", fullName);
        map.put("customerName", customerName);
        map.put("source", source);
        map.put("birth", birth);
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);
        PaginationResultVO<Contacts> prVO = contactsService.queryAllContactsForDetailByCondition(map);
        return prVO;
    }

    /**
     * 根据id获取详细的联系人信息
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/toModifyContactsById.do", method = RequestMethod.POST)
    @ResponseBody
    public Object toModifyContacts(String id) {
        Map<String, Object> map = new HashMap<>();
        List<User> userList = userService.queryAllUsers();
        String typeCode = "source";
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        typeCode = "appellation";
        List<DictionaryValue> appellationList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        Contacts contacts = contactsService.queryContactsById(id);
        map.put("userList", userList);
        map.put("sourceList", sourceList);
        map.put("appellationList", appellationList);
        map.put("contacts", contacts);
        return map;
    }

    /**
     * 根据id更新对应联系人信息
     *
     * @param contacts
     * @param customerName
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/saveModifyContacts.do", method = RequestMethod.POST)
    @ResponseBody
    public Object modifyContacts(Contacts contacts, String customerName,
                                 HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        //补全联系人信息
        //添加修改人
        contacts.setEditBy(user.getId());
        //添加修改时间
        contacts.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        map.put("customerName", customerName);
        map.put("contacts", contacts);
        try {
            int i = contactsService.editContactsById(map);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("更新成功");
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
     * 通过id批量删除对应的联系人
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "workbench/contacts/removeContacts.do", method = RequestMethod.POST)
    @ResponseBody
    public Object removeContacts(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = contactsService.deleteContactsById(id);
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
     * 接收联系人名称模糊搜索，返回对应的联系人集合
     *
     * @param contactsFullName
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/searchContactsByFullName.do", method = RequestMethod.POST)
    @ResponseBody
    public Object searchContactsByFullName(String contactsFullName) {
        List<Contacts> contactsList = contactsService.queryContactsForDetailByFullName(contactsFullName);
        return contactsList;
    }

    /**
     * 通过id跳转到联系人详细页
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/workbench/contacts/toDetail.do", method = RequestMethod.GET)
    public String toContactsDetail(String id, Model model) {
        //获取id对应的联系人详细信息
        Contacts contacts = contactsService.queryContactsForDetailById(id);
        //获取id对应的联系人备注详细信息
        List<ContactsRemark> contactsRemarkList = contactsRemarkService.queryContactsForDetailByContactsId(id);
        //获取id对应的交易详细信息
        List<Transaction> transactionList = transactionService.queryTransactionForDetailByContactsId(id);
        //获取id对应的联系人市场活动关系内容
        List<ContactsActivityRelation> contactsActivityRelationList = contactsActivityRelationService.queryContactsActivityRelationByContactsId(id);
        //设置市场活动集合
        List<MarketingActivities> marketingActivitiesList = new ArrayList<>();
        for (ContactsActivityRelation activityRelation : contactsActivityRelationList) {
            marketingActivitiesList.add(marketingActivitiesService.queryMarketingActivitiesForDetailById(activityRelation.getActivityId()));
        }
        //获取当前关联的客户
        String customerId = contactsService.queryContactsById(id).getCustomerId();

        model.addAttribute("contacts", contacts);
        model.addAttribute("contactsRemarkList", contactsRemarkList);
        model.addAttribute("transactionList", transactionList);
        model.addAttribute("marketingActivitiesList", marketingActivitiesList);
        model.addAttribute("customerId", customerId);

        return "workbench/contacts/detail";
    }

}
