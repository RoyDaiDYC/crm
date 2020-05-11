package com.yuchengdai.crm.workbench.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.workbench.domain.MarketingActivities;
import com.yuchengdai.crm.workbench.service.ClueService;
import com.yuchengdai.crm.workbench.service.MarketingActivitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/28   09:46
 */
@Controller
public class ClueConvertController {

    private ClueService clueService;


    @Autowired
    public ClueConvertController setClueService(ClueService clueService) {
        this.clueService = clueService;
        return this;
    }


    /**
     * 转换线索操作
     *
     * 1、创建客户内容，2、创建客户备注内容
     * 3、创建联系人内容，4、创建联系人备注内容，5、创建联系人关联市场活动内容
     * 6，判断是否点击了为客户创建交易，点击了创建相关内容
     * 7，删除线索备注
     * 8，删除线索关联活动
     * 9，删除线索
     *
     * @param clueId
     * @param isCreateTransaction
     * @param transactionMoney
     * @param transactionName
     * @param transactionExpectedDate
     * @param transactionStage
     * @param activityId
     * @param session
     * @return
     */
    @RequestMapping(value = "/workbench/clue/saveConvert.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveConvert(String clueId, String isCreateTransaction,
                              String transactionMoney, String transactionName,
                              String transactionExpectedDate, String transactionStage,
                              String activityId, HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        Map<String, Object> map = new HashMap<>();
        map.put("clueId", clueId);
        map.put("user", user);
        map.put("isCreateTransaction", isCreateTransaction);
        map.put("transactionMoney", transactionMoney);
        map.put("transactionName", transactionName);
        map.put("transactionExpectedDate", transactionExpectedDate);
        map.put("transactionStage", transactionStage);
        map.put("activityId", activityId);
        try {
            clueService.saveClueConvert(map);
            returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
            returnObject.setMessage("转换成功");
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("转换失败，请联系管理员");
        }
        return returnObject;
    }

}
