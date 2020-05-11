package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.workbench.domain.Contacts;
import com.yuchengdai.crm.workbench.domain.Customer;
import com.yuchengdai.crm.workbench.domain.Transaction;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsActivityRelationMapper;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsMapper;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsRemarkMapper;
import com.yuchengdai.crm.workbench.mapper.customer.CustomerMapper;
import com.yuchengdai.crm.workbench.mapper.customer.CustomerRemarkMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionHistoryMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionRemarkMapper;
import com.yuchengdai.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


/**
 * RoyDai
 * 2017/3/28   11:40
 */
@Service
public class CustomerServiceImpl implements CustomerService {

    private CustomerMapper customerMapper;

    private CustomerRemarkMapper customerRemarkMapper;

    private TransactionMapper transactionMapper;

    private TransactionHistoryMapper transactionHistoryMapper;

    private TransactionRemarkMapper transactionRemarkMapper;

    private ContactsMapper contactsMapper;

    private ContactsRemarkMapper contactsRemarkMapper;

    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    public CustomerServiceImpl setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
        return this;
    }

    @Autowired
    public CustomerServiceImpl setCustomerRemarkMapper(CustomerRemarkMapper customerRemarkMapper) {
        this.customerRemarkMapper = customerRemarkMapper;
        return this;
    }

    @Autowired
    public CustomerServiceImpl setTransactionMapper(TransactionMapper transactionMapper) {
        this.transactionMapper = transactionMapper;
        return this;
    }

    @Autowired
    public CustomerServiceImpl setTransactionHistoryMapper(TransactionHistoryMapper transactionHistoryMapper) {
        this.transactionHistoryMapper = transactionHistoryMapper;
        return this;
    }

    @Autowired
    public CustomerServiceImpl setTransactionRemarkMapper(TransactionRemarkMapper transactionRemarkMapper) {
        this.transactionRemarkMapper = transactionRemarkMapper;
        return this;
    }

    @Autowired
    public CustomerServiceImpl setContactsMapper(ContactsMapper contactsMapper) {
        this.contactsMapper = contactsMapper;
        return this;
    }

    @Autowired
    public CustomerServiceImpl setContactsRemarkMapper(ContactsRemarkMapper contactsRemarkMapper) {
        this.contactsRemarkMapper = contactsRemarkMapper;
        return this;
    }

    @Autowired
    public CustomerServiceImpl setContactsActivityRelationMapper(ContactsActivityRelationMapper contactsActivityRelationMapper) {
        this.contactsActivityRelationMapper = contactsActivityRelationMapper;
        return this;
    }

    /**
     * 添加一个客户信息内容
     *
     * @param customer
     * @return
     */
    @Override
    public int addCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    /**
     * 根据条件查询出对应的客户内容及总条数
     *
     * @param map
     * @return
     */
    @Override
    public PaginationResultVO<Customer> queryAllCustomerForDetailByCondition(Map<String, Object> map) {
        PaginationResultVO<Customer> prVO = new PaginationResultVO<>();
        List<Customer> customerList = customerMapper.selectAllCustomerForDetailByCondition(map);
        int totalRows = customerMapper.selectAllCountCustomer(map);
        prVO.setDataList(customerList);
        prVO.setTotalRows(totalRows);
        return prVO;
    }

    /**
     * 根据id获取客户内容信息
     *
     * @param id
     * @return
     */
    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    /**
     * 根据id更新客户信息
     *
     * @param customer
     * @return
     */
    @Override
    public int editCustomerById(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }

    /**
     * 根据id批量删除客户信息
     * 需要先删除关联的内容
     * 1、删除客户备注信息
     * 2、删除相关交易的备注信息；3、删除相关交易的历史记录；4、删除相关交易内容
     * 5、删除相关联系人备注信息；6、删除相关联系人市场活动关联内容；7、删除相关联系人内容
     * 8、删除对应的客户内容
     *
     * @param ids
     * @return
     */
    @Override
    public int deleteCustomerById(String[] ids) {
        //先获取批量客户id对应的交易id数组内容
        List<Transaction> transactionList = transactionMapper.selectTransactionForDetailByCustomerIdArray(ids);
        //进行判断，如果没有查询出关联的交易内容就不执行删除交易模块操作
        if (transactionList != null && transactionList.size() > 0) {
            List<String> tranIdList = new ArrayList<>();
            for (Transaction transaction : transactionList) {
                tranIdList.add(transaction.getId());
            }
            String[] tranIds = tranIdList.toArray(new String[]{});
            //删除对应的交易备注信息
            transactionRemarkMapper.deleteTransactionRemarkByTranIdArray(tranIds);
            //删除对应的交易历史记录
            transactionHistoryMapper.deleteTransactionHistoryByTranIdArray(tranIds);
            //删除对应的交易信息
            transactionMapper.deleteTransactionFromCustomerByCustomerIdArray(ids);
        }
        //获取批量客户id对应的联系人id数组内容
        List<Contacts> contactsList = contactsMapper.selectContactsForDetailByCustomerIdArray(ids);
        //进行判断，如果没有查询出关联的联系人内容就不执行删除联系人模块操作
        if (contactsList != null && contactsList.size() > 0) {
            List<String> contactsIdList = new ArrayList<>();
            for (Contacts contacts : contactsList) {
                contactsIdList.add(contacts.getId());
            }
            String[] contactsIds = contactsIdList.toArray(new String[]{});
            //删除相关的联系人备注信息
            contactsRemarkMapper.deleteContactsRemarkByContactsIdArray(contactsIds);
            //删除相关的联系人市场活动关系
            contactsActivityRelationMapper.deleteContactsActivityRelationByContactsIdArray(contactsIds);
            //删除相关的联系人
            contactsMapper.deleteContactsByCustomerIdArray(ids);
        }

        //进行客户模块删除操作
        //删除客户id对应的备注信息
        customerRemarkMapper.deleteCustomerRemarkByCustomerId(ids);
        //最后删除客户信息
        return customerMapper.deleteCustomerById(ids);
    }

    /**
     * 通过id获取到详细的客户信息
     *
     * @param id
     * @return
     */
    @Override
    public Customer queryCustomerForDetailById(String id) {
        return customerMapper.selectCustomerForDetailById(id);
    }

    /**
     * 通过名称模糊查询获取客户集合
     *
     * @param name
     * @return
     */
    @Override
    public List<Customer> queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }


}
