package com.yuchengdai.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * RoyDai
 * 2017/3/12   15:19
 */
@Controller
public class MainController {

    /**
     * 跳转到主页面
     * @return
     */
    @RequestMapping(value = "/workbench/main/toIndex.do",method = RequestMethod.GET)
    public String toIndex(){
        return "workbench/main/index";
    }
}
