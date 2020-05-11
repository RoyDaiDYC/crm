package com.yuchengdai.crm.commons.util;


import org.apache.poi.hssf.usermodel.HSSFCell;
import sun.misc.BASE64Encoder;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;


/**
 * RoyDai
 * 2017/3/17   20:10
 */
public class FileUtil {
    /**
     * 对response文件进行编码转译
     *
     * @param filename
     * @param request
     * @return
     * @throws IOException
     */
    public static String filenameEncoding(String filename, HttpServletRequest request) throws IOException {
        String agent = request.getHeader("User-Agent"); //获取浏览器
        if (agent.contains("Firefox")) {
            BASE64Encoder base64Encoder = new BASE64Encoder();
            filename = "=?utf-8?B?"
                    + base64Encoder.encode(filename.getBytes(StandardCharsets.UTF_8))
                    + "?=";
        } else if (agent.contains("MSIE")) {
            filename = URLEncoder.encode(filename, "utf-8");
        } else if (agent.contains("Safari")) {
            filename = new String(filename.getBytes(StandardCharsets.UTF_8), "ISO8859-1");
        } else {
            filename = URLEncoder.encode(filename, "utf-8");
        }
        return filename;
    }

    /**
     * 判断文件内格式，转换成字符串
     * @param cell
     * @return
     */
    public static String getValueFromCell(HSSFCell cell) {
        String cellValue = "";
        switch (cell.getCellType()) {
            case BLANK:
            case ERROR:
                cellValue = "";
                break;
            case BOOLEAN:
                cellValue = cell.getBooleanCellValue() + "";
                break;
            case FORMULA:
                cellValue = cell.getCellFormula();
                break;
            case NUMERIC:
                cellValue = cell.getNumericCellValue() + "";
                break;
            case STRING:
                cellValue = cell.getStringCellValue();
                break;
        }
        return cellValue;
    }

}
