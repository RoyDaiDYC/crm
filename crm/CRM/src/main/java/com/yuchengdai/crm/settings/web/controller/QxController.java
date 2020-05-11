package com.yuchengdai.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * RoyDai
 * 2017/3/12   16:10
 */
@Controller
public class QxController {

    /**
     * 跳转到主页面
     * @return
     */
    @RequestMapping(value = "/settings/qx/toIndex.do",method = RequestMethod.GET)
    public String toIndex(){
        return "settings/qx/index";
    }

}
