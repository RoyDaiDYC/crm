package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.workbench.domain.Contacts;
import com.yuchengdai.crm.workbench.domain.Customer;
import com.yuchengdai.crm.workbench.domain.Transaction;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsActivityRelationMapper;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsMapper;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsRemarkMapper;
import com.yuchengdai.crm.workbench.mapper.customer.CustomerMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionHistoryMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionRemarkMapper;
import com.yuchengdai.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/28   11:42
 */
@Service
public class ContactsServiceImpl implements ContactsService {

    private ContactsMapper contactsMapper;

    private CustomerMapper customerMapper;

    private ContactsRemarkMapper contactsRemarkMapper;

    private TransactionMapper transactionMapper;

    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    private TransactionRemarkMapper transactionRemarkMapper;

    private TransactionHistoryMapper transactionHistoryMapper;

    @Autowired
    public ContactsServiceImpl setContactsMapper(ContactsMapper contactsMapper) {
        this.contactsMapper = contactsMapper;
        return this;
    }

    @Autowired
    public ContactsServiceImpl setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
        return this;
    }

    @Autowired
    public ContactsServiceImpl setContactsRemarkMapper(ContactsRemarkMapper contactsRemarkMapper) {
        this.contactsRemarkMapper = contactsRemarkMapper;
        return this;
    }

    @Autowired
    public ContactsServiceImpl setTransactionMapper(TransactionMapper transactionMapper) {
        this.transactionMapper = transactionMapper;
        return this;
    }

    @Autowired
    public ContactsServiceImpl setContactsActivityRelationMapper(ContactsActivityRelationMapper contactsActivityRelationMapper) {
        this.contactsActivityRelationMapper = contactsActivityRelationMapper;
        return this;
    }

    @Autowired
    public ContactsServiceImpl setTransactionRemarkMapper(TransactionRemarkMapper transactionRemarkMapper) {
        this.transactionRemarkMapper = transactionRemarkMapper;
        return this;
    }

    @Autowired
    public ContactsServiceImpl setTransactionHistoryMapper(TransactionHistoryMapper transactionHistoryMapper) {
        this.transactionHistoryMapper = transactionHistoryMapper;
        return this;
    }

    /**
     * 根据客户id获取对应详细的联系人信息
     *
     * @param customerId
     * @return
     */
    @Override
    public List<Contacts> queryContactsForDetailByCustomerId(String customerId) {
        return contactsMapper.selectContactsForDetailByCustomerId(customerId);
    }

    /**
     * 添加一个联系人信息
     * 存在客户名如果不在数据库中，则新建，map中存了contacts和客户名
     *
     * @param map
     * @return
     */
    @Override
    public int addContacts(Map<String, Object> map) {
        //解压map中数据
        Contacts contacts = (Contacts) map.get("contacts");
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
                customer.setOwner(contacts.getOwner());
                customer.setName(customerName);
                customer.setCreateBy(contacts.getCreateBy());
                customer.setCreateTime(contacts.getCreateTime());
                //调用持久层创建客户
                customerMapper.insert(customer);
                //把创建好的客户id赋值给联系人的customerId
                contacts.setCustomerId(customer.getId());
            }
        } else if (contacts.getCustomerId() == null || "".equals(contacts.getCustomerId())) {
            for (Customer customer : customerListAccurately) {
                //添加
                //*这里存在一个bug，当有完全一致的名称的客户时，会获取到集合内容
                //按理这里需要和项目经理或用户确认是否对客户名称进行唯一判断添加
                //目前按照查询出的集合第一个元素进行id赋值，则赋值后直接break
                contacts.setCustomerId(customer.getId());
                break;
            }
        }
        //调用持久层创建联系人
        return contactsMapper.insertContacts(contacts);
    }

    /**
     * 通过条件进行分页查询，获取对应的联系人信息和总条数
     *
     * @param map
     * @return
     */
    @Override
    public PaginationResultVO<Contacts> queryAllContactsForDetailByCondition(Map<String, Object> map) {
        PaginationResultVO<Contacts> prVO = new PaginationResultVO<>();
        List<Contacts> contactsList = contactsMapper.selectAllContactsForDetailByCondition(map);
        int totalRows = contactsMapper.selectAllCountContacts(map);
        prVO.setDataList(contactsList).setTotalRows(totalRows);
        return prVO;
    }

    /**
     * 根据id获取对应的联系人内容
     *
     * @param id
     * @return
     */
    @Override
    public Contacts queryContactsById(String id) {
        return contactsMapper.selectContactsById(id);
    }

    /**
     * 根据id更新一个联系人信息
     * 存在客户名如果不在数据库中，则新建，map中存了contacts和客户名
     *
     * @param map
     * @return
     */
    @Override
    public int editContactsById(Map<String, Object> map) {
        //解压map中数据
        Contacts contacts = (Contacts) map.get("contacts");
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
                customer.setOwner(contacts.getOwner());
                customer.setName(customerName);
                customer.setCreateBy(contacts.getCreateBy());
                customer.setCreateTime(contacts.getCreateTime());
                //调用持久层创建客户
                customerMapper.insert(customer);
                //把创建好的客户id赋值给联系人的customerId
                contacts.setCustomerId(customer.getId());
            }
        } else if (contacts.getCustomerId() == null || "".equals(contacts.getCustomerId())) {
            for (Customer customer : customerListAccurately) {
                //添加
                //*这里存在一个bug，当有完全一致的名称的客户时，会获取到集合内容
                //按理这里需要和项目经理或用户确认是否对客户名称进行唯一判断添加
                //目前按照查询出的集合第一个元素进行id赋值，则赋值后直接break
                contacts.setCustomerId(customer.getId());
                break;
            }
        }
        //调用持久层创建联系人
        return contactsMapper.updateContacts(contacts);
    }

    /**
     * 通过id批量删除对应的联系人
     *
     * @param ids
     * @return
     */
    @Override
    public int deleteContactsById(String[] ids) {

        //获取批量客户id对应的交易id数组内容
        List<Transaction> transactionList = transactionMapper.selectTransactionFromContactsByContactsIdArray(ids);
        //进行判断，如果对应的交易信息没有，就不进行交易模块删除
        if (transactionList != null && transactionList.size() > 0) {
            List<String> tranIdList = new ArrayList<>();
            for (Transaction transaction : transactionList) {
                tranIdList.add(transaction.getId());
            }
            String[] tranIds = tranIdList.toArray(new String[]{});
            //删除相关的交易内容
            //删除交易备注信息
            transactionRemarkMapper.deleteTransactionRemarkByTranIdArray(tranIds);
            //删除交易历史内容
            transactionHistoryMapper.deleteTransactionHistoryByTranIdArray(tranIds);
            //删除交易内容
            transactionMapper.deleteTransactionFromContactsByContactsIdArray(ids);
        }

        //进行联系人模块删除
        //根据id删除对应的联系人市场活动关系
        contactsActivityRelationMapper.deleteContactsActivityRelationByContactsIdArray(ids);
        //删除联系人id对应的备注信息
        contactsRemarkMapper.deleteContactsRemarkByContactsIdArray(ids);
        //最后删除联系人信息
        return contactsMapper.deleteContactsById(ids);
    }

    /**
     * 通过id获取详细的联系人信息
     *
     * @param id
     * @return
     */
    @Override
    public Contacts queryContactsForDetailById(String id) {
        return contactsMapper.selectContactsForDetailById(id);
    }

    /**
     * 通过联系人名称模糊查询获取对应的联系人详细信息
     *
     * @param fullName
     * @return
     */
    @Override
    public List<Contacts> queryContactsForDetailByFullName(String fullName) {
        return contactsMapper.selectContactsForDetailByFullName(fullName);
    }


}
