package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.commons.util.CompareUtil;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.workbench.domain.*;
import com.yuchengdai.crm.workbench.mapper.customer.CustomerMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionHistoryMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionRemarkMapper;
import com.yuchengdai.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * RoyDai
 * 2017/4/2   15:26
 */
@Service
public class TransactionServiceImpl implements TransactionService {

    private TransactionMapper transactionMapper;

    private CustomerMapper customerMapper;

    private TransactionHistoryMapper transactionHistoryMapper;

    private TransactionRemarkMapper transactionRemarkMapper;


    @Autowired
    public TransactionServiceImpl setTransactionMapper(TransactionMapper transactionMapper) {
        this.transactionMapper = transactionMapper;
        return this;
    }

    @Autowired
    public TransactionServiceImpl setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
        return this;
    }

    @Autowired
    public TransactionServiceImpl setTransactionHistoryMapper(TransactionHistoryMapper transactionHistoryMapper) {
        this.transactionHistoryMapper = transactionHistoryMapper;
        return this;
    }

    @Autowired
    public TransactionServiceImpl setTransactionRemarkMapper(TransactionRemarkMapper transactionRemarkMapper) {
        this.transactionRemarkMapper = transactionRemarkMapper;
        return this;
    }

    /**
     * 通过客户id获取对应的详细交易信息
     *
     * @param customerId
     * @return
     */
    @Override
    public List<Transaction> queryTransactionForDetailByCustomerId(String customerId) {
        List<Transaction> transactionList = transactionMapper.selectTransactionForDetailByCustomerId(customerId);
        //通过调用ResourceBundle获取possibility配置文件内的对应值
        //先进行缓存清空
        //注意，这个加了后可以做到热更新，在程序不重启情况下可以读取新修改的配置文件
        ResourceBundle.clearCache();
        //获取读取到的配置文件
        ResourceBundle bundle = ResourceBundle.getBundle("conf/possibility");
        for (Transaction transaction : transactionList) {
            //获取当前交易的阶段
            String stage = transaction.getStage();
            //通过配置文件找出对应的可能性
            String possibility = bundle.getString(stage);
            //把可能性赋值给当前交易
            transaction.setPossibility(possibility);
        }
        return transactionList;
    }

    /**
     * 通过联系人id获取对应的详细交易信息
     *
     * @param contactsId
     * @return
     */
    @Override
    public List<Transaction> queryTransactionForDetailByContactsId(String contactsId) {
        List<Transaction> transactionList = transactionMapper.selectTransactionForDetailByContactsId(contactsId);
        //通过调用ResourceBundle获取possibility配置文件内的对应值
        //先进行缓存清空
        //注意，这个加了后可以做到热更新，在程序不重启情况下可以读取新修改的配置文件
        ResourceBundle.clearCache();
        //获取读取到的配置文件
        ResourceBundle bundle = ResourceBundle.getBundle("conf/possibility");
        for (Transaction transaction : transactionList) {
            //获取当前交易的阶段
            String stage = transaction.getStage();
            //通过配置文件找出对应的可能性
            String possibility = bundle.getString(stage);
            //把可能性赋值给当前交易
            transaction.setPossibility(possibility);
        }
        return transactionList;
    }

    /**
     * 通过阶段stage获取对应的可能性possibility
     *
     * @param stage
     * @return
     */
    @Override
    public String getPossibilityByStage(String stage) {
        ResourceBundle.clearCache();
        ResourceBundle bundle = ResourceBundle.getBundle("conf/possibility");
        String possibility = bundle.getString(stage);
        return possibility;
    }

    /**
     * 添加一个交易信息
     * 存在客户名如果不在数据库中，则新建，map中存了contacts和客户名
     *
     * @param map
     * @return
     */
    @Override
    public int addTransaction(Map<String, Object> map) {
        //解压map中数据
        Transaction transaction = (Transaction) map.get("transaction");
        String customerName = (String) map.get("customerName");
        //判断名称是否在数据库中
        List<Customer> customerListAccurately = customerMapper.selectCustomerByNameAccurately(customerName);
        //判断如果查询出是空
        if (customerListAccurately == null || customerListAccurately.size() == 0) {
            //且名称不为空时进行客户创建
            if (!"".equals(customerName)) {
                //创建客户，补充信息
                Customer customer = new Customer();
                customer.setId(YuChengUID.getNoHyphenUUID());
                customer.setOwner(transaction.getOwner());
                customer.setName(customerName);
                customer.setCreateBy(transaction.getCreateBy());
                customer.setCreateTime(transaction.getCreateTime());
                //调用持久层创建客户
                customerMapper.insert(customer);
                //把创建好的客户id赋值给联系人的customerId
                transaction.setCustomerId(customer.getId());
            }
        } else if (transaction.getCustomerId() == null || "".equals(transaction.getCustomerId())) {
            for (Customer customer : customerListAccurately) {
                //添加
                //*这里存在一个bug，当有完全一致的名称的客户时，会获取到集合内容
                //按理这里需要和项目经理或用户确认是否对客户名称进行唯一判断添加
                //目前按照查询出的集合第一个元素进行id赋值，则赋值后直接break
                transaction.setCustomerId(customer.getId());
                break;
            }
        }
        //创建一个交易历史
        TransactionHistory transactionHistory = new TransactionHistory();
        //补全内容
        transactionHistory.setId(YuChengUID.getNoHyphenUUID());
        transactionHistory.setStage(transaction.getStage());
        transactionHistory.setMoney(transaction.getMoney());
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setCreateBy(transaction.getCreateBy());
        transactionHistory.setCreateTime(transaction.getCreateTime());
        transactionHistory.setTranId(transaction.getId());
        //调用持久层创建历史交易
        transactionHistoryMapper.insertTransactionHistory(transactionHistory);
        //调用持久层创建交易
        return transactionMapper.insertTransaction(transaction);
    }

    /**
     * 根据条件查询出交易详细内容和交易的总条数
     *
     * @param map
     * @return
     */
    @Override
    public PaginationResultVO<Transaction> queryAllTransactionForDetailByCondition(Map<String, Object> map) {
        PaginationResultVO<Transaction> prVO = new PaginationResultVO<>();
        List<Transaction> transactionList = transactionMapper.selectAllTransactionForDetailByCondition(map);
        prVO.setDataList(transactionList);
        int totalRows = transactionMapper.selectAllCountTransaction(map);
        prVO.setTotalRows(totalRows);
        return prVO;
    }

    /**
     * 通过id获取对应的交易内容
     *
     * @param id
     * @return
     */
    @Override
    public Transaction queryTransactionById(String id) {
        return transactionMapper.selectTransactionById(id);
    }

    /**
     * 修改一个交易信息
     * 存在客户名如果不在数据库中，则新建，map中存了contacts和客户名，且存了session的userId
     *
     * @param map
     * @return
     */
    @Override
    public int editTransaction(Map<String, Object> map) {
        //解压map中数据
        Transaction transaction = (Transaction) map.get("transaction");
        String customerName = (String) map.get("customerName");
        String userId = (String) map.get("userId");
        //添加同步时间戳
        String nowDate = DateFormatUtil.getNowDateWithyyyyMMddHHmmss();
        //判断名称是否在数据库中
        List<Customer> customerListAccurately = customerMapper.selectCustomerByNameAccurately(customerName);
        //判断如果查询出是空
        if (customerListAccurately == null || customerListAccurately.size() == 0) {
            //且名称不为空时进行客户创建
            if (!"".equals(customerName)) {
                //创建客户，补充信息
                Customer customer = new Customer();
                customer.setId(YuChengUID.getNoHyphenUUID());
                customer.setOwner(transaction.getOwner());
                customer.setName(customerName);
                customer.setCreateBy(userId);
                customer.setCreateTime(nowDate);
                //调用持久层创建客户
                customerMapper.insert(customer);
                //把创建好的客户id赋值给联系人的customerId
                transaction.setCustomerId(customer.getId());
            }
        } else if (transaction.getCustomerId() == null || "".equals(transaction.getCustomerId())) {
            for (Customer customer : customerListAccurately) {
                //添加
                //*这里存在一个bug，当有完全一致的名称的客户时，会获取到集合内容
                //按理这里需要和项目经理或用户确认是否对客户名称进行唯一判断添加
                //目前按照查询出的集合第一个元素进行id赋值，则赋值后直接break
                transaction.setCustomerId(customer.getId());
                break;
            }
        }
        /*
         * 这里需要进行一个判断
         * 如果更新的内容和之前内容一致，则不进行添加交易历史数据
         * 如果有区别，则添加交易历史数据
         *
         * */
        Transaction transactionHistory = transactionMapper.selectTransactionById(transaction.getId());
        //调用比较工具
        //添加忽略比较属性
        String[] ignoreArr = {"owner", "name", "customerId", "type", "source", "activityId", "contactsId", "description", "contactSummary", "nextContactTime", "customerName", "createBy", "createTime", "editBy", "editTime"};
        boolean checkFlag = CompareUtil.compareObject(transaction, transactionHistory, ignoreArr);
        //如果不相等则创建历史交易记录
        if (!checkFlag) {
            TransactionHistory newTransactionHistory = new TransactionHistory();
            //补全内容
            newTransactionHistory.setId(YuChengUID.getNoHyphenUUID());
            newTransactionHistory.setStage(transaction.getStage());
            newTransactionHistory.setMoney(transaction.getMoney());
            newTransactionHistory.setExpectedDate(transaction.getExpectedDate());
            newTransactionHistory.setCreateBy(userId);
            newTransactionHistory.setCreateTime(nowDate);
            newTransactionHistory.setTranId(transaction.getId());
            //调用持久层创建历史交易
            transactionHistoryMapper.insertTransactionHistory(newTransactionHistory);
        }
        //给交易创建修改人和修改日期
        transaction.setEditBy(userId);
        transaction.setEditTime(nowDate);
        //调用持久层修改交易
        return transactionMapper.updateTransaction(transaction);
    }

    /**
     * 通过id批量删除对应的交易内容
     *
     * @param ids
     * @return
     */
    @Override
    public int deleteTransactionById(String[] ids) {
        //先删除对应的交易备注内容
        transactionRemarkMapper.deleteTransactionRemarkByTranIdArray(ids);
        //删除交易历史内容
        transactionHistoryMapper.deleteTransactionHistoryByTranIdArray(ids);
        //再删除对应的交易内容
        return transactionMapper.deleteTransactionById(ids);
    }

    /**
     * 通过id获取交易详细内容
     *
     * @param id
     * @return
     */
    @Override
    public Transaction queryTransactionForDetailById(String id) {
        Transaction transaction = transactionMapper.selectTransactionForDetailById(id);
        ResourceBundle.clearCache();
        ResourceBundle bundle = ResourceBundle.getBundle("conf/possibility");
        String possibility = bundle.getString(transaction.getStage());
        transaction.setPossibility(possibility);
        return transaction;
    }


    /**
     * 通过交易id获取对应交易历史内容
     *
     * @param id
     * @return
     */
    @Override
    public List<TransactionHistory> queryTransactionHistoryForDetailById(String id) {
        List<TransactionHistory> transactionHistoryList = transactionHistoryMapper.selectTransactionHistoryForDetailByTranId(id);
        ResourceBundle.clearCache();
        ResourceBundle bundle = ResourceBundle.getBundle("conf/possibility");
        for (TransactionHistory transactionHistory : transactionHistoryList) {
            //获取当前交易的阶段
            String stage = transactionHistory.getStage();
            //通过配置文件找出对应的可能性
            String possibility = bundle.getString(stage);
            //把可能性赋值给当前交易
            transactionHistory.setPossibility(possibility);
        }
        return transactionHistoryList;
    }

    /**
     * 通过id跟新交易stage
     *
     * @param map
     * @return
     */
    @Override
    public int editTransactionForStage(Map<String, Object> map) {
        String id = (String) map.get("id");
        String stage = (String) map.get("stage");
        String editBy = (String) map.get("editBy");
        String editTime = (String) map.get("editTime");
        //获取当前交易的内容
        Transaction transaction = transactionMapper.selectTransactionById(id);
        //新增一个交易历史
        TransactionHistory transactionHistory = new TransactionHistory();
        //补全内容
        transactionHistory.setId(YuChengUID.getNoHyphenUUID());
        transactionHistory.setStage(stage);
        transactionHistory.setMoney(transaction.getMoney());
        transactionHistory.setCreateBy(editBy);
        transactionHistory.setCreateTime(editTime);
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setTranId(id);
        //调用持久层创建交易历史信息
        transactionHistoryMapper.insertTransactionHistory(transactionHistory);
        //调用持久层更新交易
        return transactionMapper.updateTransactionForStage(map);
    }

    /**
     * 获取交易漏斗数据
     *
     * @return
     */
    @Override
    public List<TransactionFunnelVO> getTransactionFunnel() {
        return transactionMapper.selectTransactionFunnel();
    }
}
