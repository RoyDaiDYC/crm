package com.yuchengdai.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * RoyDai
 * 2017/3/12   21:00
 */
@Controller
public class PermissionController {

    /**
     * 跳转许可维护首页
     * @return
     */
    @RequestMapping(value = "/settings/qx/permission/toIndex.do",method = RequestMethod.GET)
    public String toIndex(){
        return "settings/qx/permission/index";
    }

}
