package com.yuchengdai.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * RoyDai
 * 2017/3/8   14:19
 */
@Controller
public class SettingsController {

    //设置首页跳转
    @RequestMapping(value = "/settings/toIndex.do",method = RequestMethod.GET)
    public String toIndex() {
        return "settings/index";
    }
}
