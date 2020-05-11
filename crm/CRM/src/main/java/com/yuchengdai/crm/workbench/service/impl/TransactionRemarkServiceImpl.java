package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.workbench.domain.TransactionRemark;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionRemarkMapper;
import com.yuchengdai.crm.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * RoyDai
 * 2017/4/15   11:52
 */
@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService {

    private TransactionRemarkMapper transactionRemarkMapper;

    @Autowired
    public TransactionRemarkServiceImpl setTransactionRemarkMapper(TransactionRemarkMapper transactionRemarkMapper) {
        this.transactionRemarkMapper = transactionRemarkMapper;
        return this;
    }

    /**
     * 通过交易id获取详细交易备注内容
     *
     * @param tranId
     * @return
     */
    @Override
    public List<TransactionRemark> queryTransactionRemarkForDetailByTranId(String tranId) {
        return transactionRemarkMapper.selectTransactionRemarkForDetailByTranId(tranId);
    }

    /**
     * 添加一个交易备注信息
     *
     * @param transactionRemark
     * @return
     */
    @Override
    public int addTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.insertTransactionRemark(transactionRemark);
    }

    /**
     * 更新一个交易备注内容
     *
     * @param transactionRemark
     * @return
     */
    @Override
    public int editTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.updateTransactionRemark(transactionRemark);
    }

    /**
     * 通过id删除对应的交易备注内容
     *
     * @param id
     * @return
     */
    @Override
    public int deleteTransactionRemarkById(String id) {
        return transactionRemarkMapper.deleteTransactionRemarkById(id);
    }
}
