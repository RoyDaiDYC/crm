package com.yuchengdai.crm.commons.util;

import java.util.UUID;

/**
 * RoyDai
 * 2017/3/11   19:59
 */
public class YuChengUID {

    //获取一个UUID
    public static String getUUID() {
        return UUID.randomUUID().toString();
    }

    //获取一个删除-的UUID
    public static String getNoHyphenUUID() {
        return UUID.randomUUID().toString().replace("-", "");
    }

}
