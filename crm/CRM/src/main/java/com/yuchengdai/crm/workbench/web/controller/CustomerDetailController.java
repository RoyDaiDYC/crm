package com.yuchengdai.crm.workbench.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.workbench.domain.CustomerRemark;
import com.yuchengdai.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * RoyDai
 * 2017/4/2   21:08
 */
@Controller
public class CustomerDetailController {

    private CustomerRemarkService customerRemarkService;

    @Autowired
    public CustomerDetailController setCustomerRemarkService(CustomerRemarkService customerRemarkService) {
        this.customerRemarkService = customerRemarkService;
        return this;
    }

    /**
     * 添加一条客户备注信息
     *
     * @param customerRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/customer/saveCreateCustomerRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateCustomerRemark(CustomerRemark customerRemark
            , HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //补全备注内容
        //添加备注id
        customerRemark.setId(YuChengUID.getNoHyphenUUID());
        //给备注信息添加创建人
        customerRemark.setCreateBy(user.getId());
        //给备注信息添加创建时间
        customerRemark.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //给备注信息添加修改标记，0代表未修改，1代表修改
        customerRemark.setEditFlag("0");
        try {
            int i = customerRemarkService.addCustomerRemark(customerRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("添加成功");
                returnObject.setData(customerRemark);
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
     * 通过id更新客户备注信息
     *
     * @param customerRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/customer/modifyCustomerRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object modifyCustomerRemark(CustomerRemark customerRemark,
                                       HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //给备注信息添加修改人
        customerRemark.setEditBy(user.getId());
        //给备注信息添加修改时间
        customerRemark.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //给备注信息添加修改标签，0代表未修改，1代表修改
        customerRemark.setEditFlag("1");
        try {
            int i = customerRemarkService.editCustomerRemarkById(customerRemark);
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
     * 通过id删除对应的客户备注信息
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/customer/deleteCustomerRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object removeCustomerRemark(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = customerRemarkService.deleteCustomerRemarkById(id);
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
}
