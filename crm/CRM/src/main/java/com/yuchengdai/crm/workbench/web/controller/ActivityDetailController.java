package com.yuchengdai.crm.workbench.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.workbench.domain.MarketingActivitiesRemark;
import com.yuchengdai.crm.workbench.service.MarketingActivitiesRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * RoyDai
 * 2017/3/20   20:05
 */
@Controller
public class ActivityDetailController {

    private MarketingActivitiesRemarkService marketingActivitiesRemarkService;

    @Autowired
    public ActivityDetailController setMarketingActivitiesRemarkService(MarketingActivitiesRemarkService marketingActivitiesRemarkService) {
        this.marketingActivitiesRemarkService = marketingActivitiesRemarkService;
        return this;
    }

    /**
     * 插入市场活动备注信息
     *
     * @param marketingActivitiesRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/activity/saveCreateMarketActivityRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateMarketActivityRemark(
            MarketingActivitiesRemark marketingActivitiesRemark,
            HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //添加id
        marketingActivitiesRemark.setId(YuChengUID.getNoHyphenUUID());
        //添加创建时间
        marketingActivitiesRemark.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //添加创建者，根据当前session的用户的id添加
        marketingActivitiesRemark.setCreateBy(user.getId());
        //设置修改标志，0代表未修改
        marketingActivitiesRemark.setEditFlag("0");

        //调用业务层执行添加
        try {
            int i = marketingActivitiesRemarkService.addMarketingActivitiesRemark(marketingActivitiesRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("添加成功");
                returnObject.setData(marketingActivitiesRemark);
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
     * 通过id更新市场备注信息
     *
     * @param marketingActivitiesRemark
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/activity/modifyMarketingActivitiesRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Object modifyMarketingActivitiesRemark(MarketingActivitiesRemark marketingActivitiesRemark,
                                                  HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //设置修改时间
        marketingActivitiesRemark.setEditTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        //设置修改者
        marketingActivitiesRemark.setEditBy(user.getId());
        //设置修改标记，0为未修改，1为修改
        marketingActivitiesRemark.setEditFlag("1");
        //装箱给业务层
        try {
            int i = marketingActivitiesRemarkService.editMarketingActivitiesRemarkById(marketingActivitiesRemark);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("更新成功");
                returnObject.setData(marketingActivitiesRemark);
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
     * 通过id删除对应的市场活动备注信息
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/workbench/activity/deleteActivityRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Object removeMarketingActivities(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = marketingActivitiesRemarkService.deleteMarketingActivitiesRemarkById(id);
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


