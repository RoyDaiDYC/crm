package com.yuchengdai.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * RoyDai
 * 2017/3/8   14:37
 */
@Controller
public class DictionaryController {

    //跳转到数据字典首页
    @RequestMapping(value = "/settings/dictionary/toIndex.do",method = RequestMethod.GET)
    public String toIndex() {
        return "settings/dictionary/index";
    }

}
