package com.yuchengdai.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * RoyDai
 * 2017/3/12   21:05
 */
@Controller
public class RoleController {

    /**
     * 跳转到角色维护首页
     * @return
     */
    @RequestMapping(value = "/settings/qx/role/toIndex.do",method = RequestMethod.GET)
    public String toIndex() {
        return "settings/qx/role/index";
    }
}
