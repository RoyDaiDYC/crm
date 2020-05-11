package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.workbench.domain.Transaction;
import com.yuchengdai.crm.workbench.domain.TransactionFunnelVO;
import com.yuchengdai.crm.workbench.domain.TransactionHistory;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/4/2   15:25
 */
public interface TransactionService {

    //通过客户id查询出对应的详细交易信息
    List<Transaction> queryTransactionForDetailByCustomerId(String customerId);

    //通过联系人id查询出对应的详细交易信息
    List<Transaction> queryTransactionForDetailByContactsId(String contactsId);

    //获取阶段stage对应的可能性Possibility
    String getPossibilityByStage(String stage);

    //添加一个交易信息
    //存在客户名如果不在数据库中，则新建，map中存了transaction和客户名
    int addTransaction(Map<String, Object> map);

    //分页查询
    //通过条件查询出交易详细内容和交易总条数
    PaginationResultVO<Transaction> queryAllTransactionForDetailByCondition(Map<String, Object> map);

    //根据id获取交易内容
    Transaction queryTransactionById(String id);

    //根据id更新一个交易内容
    //存在客户名如果不在数据库中，则新建，map中存了transaction和客户名
    int editTransaction(Map<String, Object> map);

    //通过id批量删除对应的交易内容
    int deleteTransactionById(String[] ids);

    //通过id获取交易详细信息
    Transaction queryTransactionForDetailById(String id);

    //通过交易id获取交易历史内容
    List<TransactionHistory> queryTransactionHistoryForDetailById(String id);

    //通过id修改交易的阶段
    int editTransactionForStage(Map<String ,Object> map);

    //获取交易漏斗数据
    List<TransactionFunnelVO> getTransactionFunnel();
}
