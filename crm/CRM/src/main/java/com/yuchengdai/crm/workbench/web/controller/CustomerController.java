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
import com.yuchengdai.crm.workbench.domain.Contacts;
import com.yuchengdai.crm.workbench.domain.Customer;
import com.yuchengdai.crm.workbench.domain.CustomerRemark;
import com.yuchengdai.crm.workbench.domain.Transaction;
import com.yuchengdai.crm.workbench.service.ContactsService;
import com.yuchengdai.crm.workbench.service.CustomerRemarkService;
import com.yuchengdai.crm.workbench.service.CustomerService;
import com.yuchengdai.crm.workbench.service.TransactionService;
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

/**
 * RoyDai
 * 2017/3/12   21:24
 */
@Controller
public class CustomerController {

    private UserService userService;

    private CustomerService customerService;

    private CustomerRemarkService customerRemarkService;

    private TransactionService transactionService;

    private ContactsService contactsService;

    private DictionaryValueService dictionaryValueService;

    @Autowired
    public CustomerController setUserService(UserService userService) {
        this.userService = userService;
        return this;
    }

    @Autowired
    public CustomerController setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
        return this;
    }

    @Autowired
    public CustomerController setCustomerRemarkService(CustomerRemarkService customerRemarkService) {
        this.customerRemarkService = customerRemarkService;
        return this;
    }

    @Autowired
    public CustomerController setTransactionService(TransactionService transactionService) {
        this.transactionService = transactionService;
        return this;
    }

    @Autowired
    public CustomerController setContactsService(ContactsService contactsService) {
        this.contactsService = contactsService;
        return this;
    }

    @Autowired
    public CustomerController setDictionaryValueService(DictionaryValueService dictionaryValueService) {
        this.dictionaryValueService = dictionaryValueService;
        return this;
    }

    /**
     * 跳转到客户首页
     *
     * @return
     */
    @RequestMapping(value = "/workbench/customer/toIndex.do", method = RequestMethod.GET)
    public String toIndex(Model model) {
        List<User> userList = userService.queryAllUsers();
        model.addAttribute("userList", userList);
        return "workbench/customer/index";
    }

    /**
     * 创建一个客户
     *
     * @param customer
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/customer/saveCreateCustomer.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateCustomer(Customer customer, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //设置id
        customer.setId(YuChengUID.getNoHyphenUUID());
        //设置创建人，创建人为当前登录用户
        customer.setCreateBy(user.getId());
        //设置创建时间，以当前创建时间
        customer.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        try {
            int i = customerService.addCustomer(customer);
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
     * 根据条件进行查询，分页查询，显示总条数
     *
     * @param name
     * @param owner
     * @param phone
     * @param website
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/workbench/customer/getCustomerByCondition.do", method = RequestMethod.POST)
    @ResponseBody
    public Object getCustomerByCondition(String name, String owner,
                                         String phone, String website,
                                         @RequestParam(required = false, defaultValue = "1") int pageNo,
                                         @RequestParam(required = false, defaultValue = "5") int pageSize) {
        int beginNo = pageSize * (pageNo - 1);
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);
        PaginationResultVO<Customer> prVO = customerService.queryAllCustomerForDetailByCondition(map);
        return prVO;
    }

    /**
     * 通过id查询获取到客户内容
     * 进入到修改页面，显示当前选中修改的客户内容
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/customer/toModifyCustomerById.do", method = RequestMethod.POST)
    @ResponseBody
    public Object toModifyCustomer(String id) {
        Map<String, Object> map = new HashMap<>();
        Customer customer = customerService.queryCustomerById(id);
        List<User> userList = userService.queryAllUsers();
        map.put("customer", customer);
        map.put("userList", userList);
        return map;
    }

    /**
     * 根据id更新客户信息
     *
     * @param customer
     * @return
     */
    @RequestMapping(value = "/workbench/customer/saveModifyCustomer.do", method = RequestMethod.POST)
    @ResponseBody
    public Object modifyCustomer(Customer customer, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //为客户增加修改人
        customer.setEditBy(user.getId());
        //为客户增加修改时间
        customer.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        try {
            int i = customerService.editCustomerById(customer);
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
     * 通过id批量删除客户信息
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/customer/removeCustomer.do", method = RequestMethod.POST)
    @ResponseBody
    public Object removeCustomer(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = customerService.deleteCustomerById(id);
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
     * 通过客户名称模糊查询获取对应的客户集合
     *
     * @param customerName
     * @return
     */
    @RequestMapping(value = "/workbench/customer/getCustomerByCustomerName.do", method = RequestMethod.POST)
    @ResponseBody
    public Object getCustomerByCustomerName(String customerName) {
        List<Customer> customerList = customerService.queryCustomerByName(customerName);
        return customerList;
    }

    /**
     * 跳转到选中的客户内容到详细页
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/workbench/customer/toDetail.do", method = RequestMethod.GET)
    public String toCustomerDetail(String id, Model model) {
        //获取当前客户的详细信息
        Customer customer = customerService.queryCustomerForDetailById(id);
        //获取当前对应客户的详细备注信息
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkForDetailByCustomerId(id);
        //获取当前对应的交易信息
        List<Transaction> transactionList = transactionService.queryTransactionForDetailByCustomerId(id);
        //获取当前对应的联系人信息
        List<Contacts> contactsList = contactsService.queryContactsForDetailByCustomerId(id);
        //设置详细页创建联系人必要内容
        List<User> userList = userService.queryAllUsers();
        String typeCode = "source";
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        typeCode = "appellation";
        List<DictionaryValue> appellationList = dictionaryValueService.queryDictionaryValueByTypeCode(typeCode);
        model.addAttribute("customer", customer);
        model.addAttribute("customerRemarkList", customerRemarkList);
        model.addAttribute("transactionList", transactionList);
        model.addAttribute("contactsList", contactsList);
        model.addAttribute("userList", userList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("appellationList", appellationList);
        return "workbench/customer/detail";
    }

}