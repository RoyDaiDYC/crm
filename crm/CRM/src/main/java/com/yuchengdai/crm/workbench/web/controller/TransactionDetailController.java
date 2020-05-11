package com.yuchengdai.crm.workbench.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.workbench.domain.TransactionRemark;
import com.yuchengdai.crm.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * RoyDai
 * 2017/4/16   19:03
 */
@Controller
public class TransactionDetailController {

    private TransactionRemarkService transactionRemarkService;

    @Autowired
    public TransactionDetailController setTransactionRemarkService(TransactionRemarkService transactionRemarkService) {
        this.transactionRemarkService = transactionRemarkService;
        return this;
    }

    /**
     * 添加一个交易备注信息
     *
     * @param transactionRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/saveCreateTransactionRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateTransactionRemark(TransactionRemark transactionRemark,
                                              HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //补全备注信息
        //增加id
        transactionRemark.setId(YuChengUID.getNoHyphenUUID());
        //增加创建人
        transactionRemark.setCreateBy(user.getId());
        //增加创建时间
        transactionRemark.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //增加修改标记，1代表修改，0代表未修改
        transactionRemark.setEditFlag("0");
        try {
            int i = transactionRemarkService.addTransactionRemark(transactionRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("添加成功");
                returnObject.setData(transactionRemark);
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
     * 通过id跟新一个交易备注内容
     *
     * @param transactionRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/modifyTransactionRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object modifyTransactionRemark(TransactionRemark transactionRemark,
                                          HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //补全更新内容
        //添加更新人
        transactionRemark.setEditBy(user.getId());
        //添加更新时间
        transactionRemark.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //更新修改标记，1代表修改，0代表未修改
        transactionRemark.setEditFlag("1");
        try {
            int i = transactionRemarkService.editTransactionRemark(transactionRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("修改成功");
                returnObject.setData(transactionRemark);
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
     * 通过id删除对应的交易备注信息
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/transaction/deleteTransactionRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object removeTransactionRemark(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = transactionRemarkService.deleteTransactionRemarkById(id);
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
