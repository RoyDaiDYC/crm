package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.workbench.domain.TransactionRemark;

import java.util.List;

/**
 * RoyDai
 * 2017/4/15   11:52
 */
public interface TransactionRemarkService {

    //通过交易id获取对应的交易备注详细信息
    List<TransactionRemark> queryTransactionRemarkForDetailByTranId(String tranId);

    //添加一个交易备注内容
    int addTransactionRemark(TransactionRemark transactionRemark);

    //更新一个交易备注内容
    int editTransactionRemark(TransactionRemark transactionRemark);

    //通过id删除对应的交易备注内容
    int deleteTransactionRemarkById(String id);
}
