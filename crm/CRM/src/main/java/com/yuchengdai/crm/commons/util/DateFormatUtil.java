package com.yuchengdai.crm.commons.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * RoyDai
 * 2017/3/14   21:42
 */
public class DateFormatUtil {

    //获取一个年与日当前时间
    public static String getNowDateWithyyyyMMdd(){
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }


    //获取一个年月日时分秒当前时间
    public static String getNowDateWithyyyyMMddHHmmss(){
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }

    //获取一个年月日时分秒当前时间
    public static String getNoHyphenNowDateWithyyyyMMddHHmmss(){
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        return sdf.format(date);
    }
}
