package com.yuchengdai.crm.workbench.domain;

/**
 * RoyDai
 * 2017/4/16   23:02
 */
public class TransactionFunnelVO {

    /**
     * 交易名称
     */
    private String name;

    /**
     * 交易阶段
     */
    private Long value;

    public String getName() {
        return name;
    }

    public TransactionFunnelVO setName(String name) {
        this.name = name;
        return this;
    }

    public Long getValue() {
        return value;
    }

    public TransactionFunnelVO setValue(Long value) {
        this.value = value;
        return this;
    }
}
