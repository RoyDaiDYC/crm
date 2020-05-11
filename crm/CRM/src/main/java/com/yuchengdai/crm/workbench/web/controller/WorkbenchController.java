package com.yuchengdai.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * RoyDai
 * 2017/3/6   20:22
 */
@Controller
public class WorkbenchController {

    //接收页面请求，跳转index.jsp
    @RequestMapping(value = "/workbench/toIndex.do",method = RequestMethod.GET)
    public String toIndex(){
        return "workbench/index";
    }

}
