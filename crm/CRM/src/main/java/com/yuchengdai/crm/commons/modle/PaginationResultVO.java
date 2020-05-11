package com.yuchengdai.crm.commons.modle;

import java.util.List;

/**
 * RoyDai
 * 2017/3/15   15:29
 */
public class PaginationResultVO<T> {

    private List<T> dataList;
    private int totalRows;

    public List<T> getDataList() {
        return dataList;
    }

    public PaginationResultVO<T> setDataList(List<T> dataList) {
        this.dataList = dataList;
        return this;
    }

    public int getTotalRows() {
        return totalRows;
    }

    public PaginationResultVO<T> setTotalRows(int totalRows) {
        this.totalRows = totalRows;
        return this;
    }
}
