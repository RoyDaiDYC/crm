package com.yuchengdai.crm.commons.modle;

/**
 * RoyDai
 * 2017/3/6   15:00
 */
public class ReturnObject {
    //0代表失败，1代表成功
    private String code;
    private String message;
    private Object data;

    public String getCode() {
        return code;
    }

    public ReturnObject setCode(String code) {
        this.code = code;
        return this;
    }

    public String getMessage() {
        return message;
    }

    public ReturnObject setMessage(String message) {
        this.message = message;
        return this;
    }

    public Object getData() {
        return data;
    }

    public ReturnObject setData(Object data) {
        this.data = data;
        return this;
    }
}
