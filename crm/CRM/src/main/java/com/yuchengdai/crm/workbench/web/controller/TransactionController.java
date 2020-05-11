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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * RoyDai
 * 2017/3/12   21:30
 */
@Controller
public class TransactionController {

    private TransactionService transactionService;

    private UserService userService;

    private DictionaryValueService dictionaryValueService;

    private CustomerService customerService;

    private ContactsService contactsService;

    private MarketingActivitiesService marketingActivitiesService;

    private TransactionRemarkService transactionRemarkService;

    @Autowired
    public TransactionController setTransactionService(TransactionService transactionService) {
        this.transactionService = transactionService;
        return this;
    }

    @Autowired
    public TransactionController setUserService(UserService userService) {
        this.userService = userService;
        return this;
    }

    @Autowired
    public TransactionController setDictionaryValueService(DictionaryValueService dictionaryValueService) {
        this.dictionaryValueService = dictionaryValueService;
        return this;
    }

    @Autowired
    public TransactionController setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
        return this;
    }

    @Autowired
    public TransactionController setContactsService(ContactsService contactsService) {
        this.contactsService = contactsService;
        return this;
    }

    @Autowired
    public TransactionController setMarketingActivitiesService(MarketingActivitiesService marketingActivitiesService) {
        this.marketingActivitiesService = marketingActivitiesService;
        return this;
    }

    @Autowired
    public TransactionController setTransactionRemarkService(TransactionRemarkService transactionRemarkService) {
        this.transactionRemarkService = transactionRemarkService;
        return this;
    }

    /**
     * 跳转到交易首页
     *
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/toIndex.do", method = RequestMethod.GET)
    public String toIndex(Model model) {
        //添加阶段内容
        String typeCode = "stage";
        List<DictionaryValue> stageList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //添加类型
        typeCode = "transaction_type";
        List<DictionaryValue> typeList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //添加来源
        typeCode = "source";
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        model.addAttribute("stageList", stageList);
        model.addAttribute("typeList", typeList);
        model.addAttribute("sourceList", sourceList);
        return "workbench/transaction/index";
    }

    /**
     * 跳转到交易创建页面
     *
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/toCreateTransaction.do", method = RequestMethod.GET)
    public String toCreateTransaction(String customerId, String contactsId, Model model) {
        if (customerId != null && !"".equals(customerId)) {
            String customerName = customerService.queryCustomerById(customerId).getName();
            model.addAttribute("customerId", customerId);
            model.addAttribute("customerName", customerName);
        }
        if (contactsId != null && !"".equals(contactsId)) {
            String fullName = contactsService.queryContactsForDetailById(contactsId).getFullName();
            String appellation = contactsService.queryContactsForDetailById(contactsId).getAppellation();
            String contactsName = fullName + appellation;
            model.addAttribute("contactsName", contactsName);
            model.addAttribute("contactsId", contactsId);
        }
        //跳转时附带作用域内容
        //拥有着所有用户列表
        List<User> userList = userService.queryAllUsers();
        //阶段列表
        String typeCode = "stage";
        List<DictionaryValue> stageList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //类型列表
        typeCode = "transaction_type";
        List<DictionaryValue> transactionTypeList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //来源列表
        typeCode = "source";
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        model.addAttribute("userList", userList);
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        return "workbench/transaction/save";
    }

    /**
     * 通过阶段stage获取对应的可能性
     *
     * @param stageId
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/getPossibility.do", method = RequestMethod.POST)
    @ResponseBody
    public Object getPossibilityByStage(String stageId) {
        Map<String, Object> map = new HashMap<>();
        DictionaryValue dictionaryValue = dictionaryValueService.getDictionaryValueById(stageId);
        String stage = dictionaryValue.getValue();
        String possibility = transactionService.getPossibilityByStage(stage);
        map.put("possibility", possibility);
        return map;
    }

    /**
     * 创建一个交易内容
     *
     * @param transaction
     * @param customerName
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/saveCreateTransaction.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateTransaction(Transaction transaction,
                                        String customerName, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        //补全交易信息
        //添加id
        transaction.setId(YuChengUID.getNoHyphenUUID());
        //添加创建人
        transaction.setCreateBy(user.getId());
        //添加创建时间
        transaction.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        map.put("transaction", transaction);
        map.put("customerName", customerName);
        try {
            int i = transactionService.addTransaction(map);
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
     * 通过条件查询获取交易详细内容和对应的总条数
     *
     * @param owner
     * @param name
     * @param customerName
     * @param stage
     * @param type
     * @param source
     * @param contactsName
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/getTransactionByCondition.do", method = RequestMethod.POST)
    @ResponseBody
    public Object getTransactionByCondition(String owner, String name, String customerName,
                                            String stage, String type, String source, String contactsName,
                                            @RequestParam(required = false, defaultValue = "1") int pageNo,
                                            @RequestParam(required = false, defaultValue = "5") int pageSize) {
        int beginNo = pageSize * (pageNo - 1);
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerName", customerName);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contactsName", contactsName);
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);
        PaginationResultVO<Transaction> prVO = transactionService.queryAllTransactionForDetailByCondition(map);
        return prVO;
    }


    @RequestMapping(value = "/workbench/transaction/toModifyTransaction.do", method = RequestMethod.GET)
    public String toEdit(String id, Model model) {
        Transaction transaction = transactionService.queryTransactionById(id);
        Transaction transactionForDetail = transactionService.queryTransactionForDetailById(id);
        String stageDetail = transactionForDetail.getStage();
        //获取stage对应的possibility，customerId对应的customerName，contactsId对应的contactsName
        //进行判断
        String possibility = "";
        String customerName = "";
        String contactsName = "";
        String activityName = "";
        if (transaction.getStage() != null && !"".equals(transaction.getStage())) {
            String stage = dictionaryValueService.getDictionaryValueById(transaction.getStage()).getValue();
            possibility = transactionService.getPossibilityByStage(stage);
        }
        if (transaction.getCustomerId() != null && !"".equals(transaction.getCustomerId())) {
            Customer customer = customerService.queryCustomerById(transaction.getCustomerId());
            if (customer != null) {
                customerName = customer.getName();
            }
        }
        if (transaction.getContactsId() != null && !"".equals(transaction.getContactsId())) {
            Contacts contacts = contactsService.queryContactsById(transaction.getContactsId());
            if (contacts != null) {
                String fullName = contacts.getFullName();
                String appellation = contacts.getAppellation();
                contactsName = fullName + appellation;
            }
        }
        if (transaction.getActivityId() != null && !"".equals(transaction.getActivityId())) {
            MarketingActivities marketingActivities = marketingActivitiesService.queryMarketingActivitiesById(transaction.getActivityId());
            if (marketingActivities != null) {
                activityName = marketingActivities.getName();
            }
        }
        transaction.setPossibility(possibility);
        transaction.setCustomerName(customerName);
        transaction.setContactsName(contactsName);
        transaction.setActivityName(activityName);
        //跳转时附带作用域内容
        //拥有着所有用户列表
        List<User> userList = userService.queryAllUsers();
        //阶段列表
        String typeCode = "stage";
        List<DictionaryValue> stageList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //类型列表
        typeCode = "transaction_type";
        List<DictionaryValue> transactionTypeList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        //来源列表
        typeCode = "source";
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);

        model.addAttribute("transaction", transaction);
        model.addAttribute("transactionStageDetail", stageDetail);
        model.addAttribute("userList", userList);
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        return "workbench/transaction/edit";
    }

    /**
     * 根据id更新交易内容
     *
     * @param transaction
     * @param customerName
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/modifyTransaction.do", method = RequestMethod.POST)
    @ResponseBody
    public Object modifyTransaction(Transaction transaction,
                                    String customerName, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        map.put("transaction", transaction);
        map.put("userId", user.getId());
        map.put("customerName", customerName);
        try {
            int i = transactionService.editTransaction(map);
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
     * 通过id批量删除对应的交易内容
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/removeTransaction.do", method = RequestMethod.POST)
    @ResponseBody
    public Object removeTransaction(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = transactionService.deleteTransactionById(id);
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
     * 跳转到交易详细页面
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/toDetail.do", method = RequestMethod.GET)
    public String toTransactionDetail(String id, Model model) {
        Transaction transaction = transactionService.queryTransactionForDetailById(id);
        List<TransactionRemark> transactionRemarkList = transactionRemarkService.queryTransactionRemarkForDetailByTranId(id);
        List<TransactionHistory> transactionHistoryList = transactionService.queryTransactionHistoryForDetailById(id);
        String typeCode = "stage";
        List<DictionaryValue> stageList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        int stageListLength = stageList.size();

        model.addAttribute("transaction", transaction);
        model.addAttribute("transactionRemarkList", transactionRemarkList);
        model.addAttribute("transactionHistoryList", transactionHistoryList);
        model.addAttribute("stageList", stageList);
        model.addAttribute("stageListLength", stageListLength);
        if (transactionHistoryList != null && transactionHistoryList.size() > 0) {
            //这里要获取在失败前的那一个阶段的编号，需要使用从后往前遍历
            //通过确认历史内容有在成交前的一个阶段，则返回
            for (int i = transactionHistoryList.size() - 1; i >= 0; i--) {
                TransactionHistory transactionHistory = transactionHistoryList.get(i);
                if (Integer.parseInt(transactionHistory.getOrderNo()) < stageListLength - 3) {
                    model.addAttribute("lastTranIndex", transactionHistory.getOrderNo());
                    break;
                }
            }
        }
        return "workbench/transaction/detail";
    }

    /**
     * 通过id更新交易stage
     *
     * @param id
     * @param stage
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/modifyTransactionForStage.do", method = RequestMethod.POST)
    @ResponseBody
    public Object modifyTransactionForStage(String id, String stage,
                                            HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        String editBy = user.getId();
        String editTime = DateFormatUtil.getNowDateWithyyyyMMddHHmmss();
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("stage", stage);
        map.put("editBy", editBy);
        map.put("editTime", editTime);
        try {
            int i = transactionService.editTransactionForStage(map);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
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
     * 跳转到交易图标页面
     *
     * @return
     */
    @RequestMapping(value = "/workbench/chart/transaction/toTransaction.do", method = RequestMethod.GET)
    public String toTranChart() {
        return "workbench/chart/transaction/index";
    }

    /**
     * 获取交易漏斗内容
     *
     * @return
     */
    @RequestMapping(value = "/workbench/chart/transaction/getTransactionFunnel.do", method = RequestMethod.POST)
    @ResponseBody
    public Object getTransactionFunnel() {
        List<TransactionFunnelVO> transactionFunnelList = transactionService.getTransactionFunnel();
        return transactionFunnelList;
    }

}
