package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.commons.util.DateFormatUtil;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.workbench.domain.*;
import com.yuchengdai.crm.workbench.mapper.clue.ClueActivityRelationMapper;
import com.yuchengdai.crm.workbench.mapper.clue.ClueMapper;
import com.yuchengdai.crm.workbench.mapper.clue.ClueRemarkMapper;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsActivityRelationMapper;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsMapper;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsRemarkMapper;
import com.yuchengdai.crm.workbench.mapper.customer.CustomerMapper;
import com.yuchengdai.crm.workbench.mapper.customer.CustomerRemarkMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionHistoryMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionMapper;
import com.yuchengdai.crm.workbench.mapper.transaction.TransactionRemarkMapper;
import com.yuchengdai.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/24   10:22
 */
@Service
public class ClueServiceImpl implements ClueService {

    private ClueMapper clueMapper;

    private ClueRemarkMapper clueRemarkMapper;

    private ClueActivityRelationMapper clueActivityRelationMapper;

    private CustomerMapper customerMapper;

    private CustomerRemarkMapper customerRemarkMapper;

    private ContactsMapper contactsMapper;

    private ContactsRemarkMapper contactsRemarkMapper;

    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    private TransactionMapper transactionMapper;

    private TransactionHistoryMapper transactionHistoryMapper;

    private TransactionRemarkMapper transactionRemarkMapper;

    @Autowired
    public ClueServiceImpl setClueMapper(ClueMapper clueMapper) {
        this.clueMapper = clueMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setClueRemarkMapper(ClueRemarkMapper clueRemarkMapper) {
        this.clueRemarkMapper = clueRemarkMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setCustomerRemarkMapper(CustomerRemarkMapper customerRemarkMapper) {
        this.customerRemarkMapper = customerRemarkMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setContactsMapper(ContactsMapper contactsMapper) {
        this.contactsMapper = contactsMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setContactsRemarkMapper(ContactsRemarkMapper contactsRemarkMapper) {
        this.contactsRemarkMapper = contactsRemarkMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setContactsActivityRelationMapper(ContactsActivityRelationMapper contactsActivityRelationMapper) {
        this.contactsActivityRelationMapper = contactsActivityRelationMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setClueActivityRelationMapper(ClueActivityRelationMapper clueActivityRelationMapper) {
        this.clueActivityRelationMapper = clueActivityRelationMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setTransactionMapper(TransactionMapper transactionMapper) {
        this.transactionMapper = transactionMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setTransactionHistoryMapper(TransactionHistoryMapper transactionHistoryMapper) {
        this.transactionHistoryMapper = transactionHistoryMapper;
        return this;
    }

    @Autowired
    public ClueServiceImpl setTransactionRemarkMapper(TransactionRemarkMapper transactionRemarkMapper) {
        this.transactionRemarkMapper = transactionRemarkMapper;
        return this;
    }

    /**
     * 添加一个市场线索
     *
     * @param clue
     * @return
     */
    @Override
    public int addClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }


    /**
     * 根据条件查询出线索内容
     *
     * @param map
     * @return
     */
    @Override
    public PaginationResultVO<Clue> queryAllClueForDetailByCondition(Map<String, Object> map) {
        PaginationResultVO<Clue> prVO = new PaginationResultVO<>();
        List<Clue> clueList = clueMapper.selectAllClueForDetailByCondition(map);
        int totalRows = clueMapper.selectAllCountClue(map);
        prVO.setDataList(clueList).setTotalRows(totalRows);
        return prVO;
    }

    /**
     * 根据id查询出线索
     *
     * @param id
     * @return
     */
    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    /**
     * 根据id更新线索内容
     *
     * @param clue
     * @return
     */
    @Override
    public int editClueById(Clue clue) {
        return clueMapper.updateClueById(clue);
    }

    /**
     * 通过id删除对应的线索
     * 在删除线索前，先把对应的备注信息删除
     *
     * @param ids
     * @return
     */
    @Override
    public int deleteClueById(String[] ids) {
        //先删除对应的线索备注内容
        clueRemarkMapper.deleteClueRemarkByClueIdArray(ids);
        //再删除对应的交易市场活动关联内容
        clueActivityRelationMapper.deleteClueActivityRelationByClueIdArray(ids);
        //最后删除对应的线索
        return clueMapper.deleteClueById(ids);
    }

    /**
     * 通过id查询出线索
     * 详细内容从唯一标识符替换成文本
     *
     * @param id
     * @return
     */
    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }


    @Override
    public void saveClueConvert(Map<String, Object> map) {
        /*
         * 通过解压map集合获取对应内容
         * */
        //获取线索id，查询出对应的线索内容
        String clueId = (String) map.get("clueId");
        //获取session内的用户信息
        User user = (User) map.get("user");
        //获取是否点击了为客户创建交易
        String isCreateTransaction = (String) map.get("isCreateTransaction");
        //通过id获取对应线索
        Clue clue = clueMapper.selectClueById(clueId);
        //通过id获取对应线索备注内容
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
        //通过id获取线索对应的活动关系表
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);

        //给客户创建内容
        Customer customer = new Customer();
        customer.setId(YuChengUID.getNoHyphenUUID());
        customer.setOwner(clue.getOwner());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        //创建人这里是当前点击转换的用户
        customer.setCreateBy(user.getId());
        //创建时间为当前点击转换后写入的时间
        customer.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        //通过持久层插入客户信息
        customerMapper.insertCustomer(customer);

        //判断一下是否有对应的线索集合
        if (clueRemarkList != null && clueRemarkList.size() > 0) {
            //给客户创建对应备注内容
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            for (ClueRemark clueRemark : clueRemarkList) {
                CustomerRemark customerRemark = new CustomerRemark();
                customerRemark.setId(YuChengUID.getNoHyphenUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                //创建对应客户的id
                customerRemark.setCustomerId(customer.getId());
                //把当前备注放到客户备注内容集合中
                customerRemarkList.add(customerRemark);
            }
            //通过持久层插入客户备注信息
            customerRemarkMapper.insertCustomerRemarkFromClueConvert(customerRemarkList);
        }

        //给联系人创建内容
        Contacts contacts = new Contacts();
        //创建id
        contacts.setId(YuChengUID.getNoHyphenUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        //对应客户id使用当前创建客户内容时候的id值
        contacts.setCustomerId(customer.getId());
        contacts.setFullName(clue.getFullName());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        //联系人出生日期当前未能获取到，后续可以进行修改添加
        //contacts.setBirth(null);
        //创建人设置为当前点击转换按钮的用户
        contacts.setCreateBy(user.getId());
        //创建时间为当前点击转换按钮后程序目前时间
        contacts.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        //调用持久层添加联系人内容
        contactsMapper.insertContacts(contacts);

        //先判断下clueRemarkList是否是空
        if (clueRemarkList != null && clueRemarkList.size() > 0) {
            //给联系人备注创建内容集合
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            for (ClueRemark clueRemark : clueRemarkList) {
                ContactsRemark contactsRemark = new ContactsRemark();
                contactsRemark.setId(YuChengUID.getNoHyphenUUID());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                //创建对应联系人的id
                contactsRemark.setContactsId(contacts.getId());
                //把联系人备注内容添加集合中
                contactsRemarkList.add(contactsRemark);
            }
            //调用持久层添加联系人备注集合内容
            contactsRemarkMapper.insertContactsRemarkFromClueConvert(contactsRemarkList);
        }

        //先判断下clueActivityRelationList是否是空
        if (clueActivityRelationList != null && clueActivityRelationList.size() > 0) {
            //给联系人市场活动关系创建内容
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
                ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(YuChengUID.getNoHyphenUUID());
                //使用当前创建的联系人内容的id赋值
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                //把联系人市场活动关系内容添加进集合中
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelationList);
        }

        //判断是否为客户创建交易
        //如果返回的值是一个true则进行交易的创建
        if ("true".equals(isCreateTransaction)) {
            Transaction transaction = new Transaction();
            transaction.setId(YuChengUID.getNoHyphenUUID());
            transaction.setOwner(user.getId());
            transaction.setMoney((String) map.get("transactionMoney"));
            transaction.setName((String) map.get("transactionName"));
            transaction.setExpectedDate((String) map.get("transactionExpectedDate"));
            //添加客户id
            transaction.setCustomerId(customer.getId());
            transaction.setStage((String) map.get("transactionStage"));
            /*transaction.setType();*/
            transaction.setSource(clue.getSource());
            transaction.setActivityId((String) map.get("activityId"));
            transaction.setContactsId(contacts.getId());
            transaction.setCreateBy(user.getId());
            transaction.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
            transaction.setDescription(clue.getDescription());
            transaction.setContactSummary(clue.getContactSummary());
            transaction.setNextContactTime(clue.getNextContactTime());
            //调用持久层添加交易内容
            transactionMapper.insertTransaction(transaction);

            //创建交易后，进行添加交易历史内容
            TransactionHistory transactionHistory = new TransactionHistory();
            transactionHistory.setId(YuChengUID.getNoHyphenUUID());
            transactionHistory.setMoney((String) map.get("transactionMoney"));
            transactionHistory.setStage((String) map.get("transactionStage"));
            transactionHistory.setExpectedDate((String) map.get("transactionExpectedDate"));
            transactionHistory.setCreateBy(user.getId());
            transactionHistory.setCreateTime(DateFormatUtil.getNowDateWithyyyyMMddHHmmss());
            transactionHistory.setTranId(transaction.getId());
            //调用持久层条件交易历史
            transactionHistoryMapper.insertTransactionHistory(transactionHistory);

            //创建了交易后，交易的备注信息也需要从线索内转换到交易内
            //先判断clueRemarkList是否为空
            if (clueRemarkList != null && clueRemarkList.size() > 0) {
                //创建交易备注集合存储备注内容
                List<TransactionRemark> transactionRemarkList = new ArrayList<>();
                for (ClueRemark clueRemark : clueRemarkList) {
                    TransactionRemark transactionRemark = new TransactionRemark();
                    transactionRemark.setId(YuChengUID.getNoHyphenUUID());
                    transactionRemark.setNoteContent(clueRemark.getNoteContent());
                    transactionRemark.setCreateBy(clueRemark.getCreateBy());
                    transactionRemark.setCreateTime(clueRemark.getCreateTime());
                    transactionRemark.setEditBy(clueRemark.getEditBy());
                    transactionRemark.setEditTime(clueRemark.getEditTime());
                    transactionRemark.setEditFlag(clueRemark.getEditFlag());
                    //添加交易id，为当前创建的交易
                    transactionRemark.setTranId(transaction.getId());
                    //把当前备注添加到集合内
                    transactionRemarkList.add(transactionRemark);
                }
                //调用持久层插入交易备注内容
                transactionRemarkMapper.insertTransactionRemarkFromClueConvert(transactionRemarkList);
            }
        }

        /*
         * 对线索相关进行删除
         * 删除线索相关的备注
         * 删除线索关联活动
         * 删除线索
         *
         * */

        clueRemarkMapper.deleteClueRemarkById(clueId);

        clueActivityRelationMapper.deleteCLueActivityRelationByClueId(clueId);

        String[] id = {clueId};
        clueMapper.deleteClueById(id);
    }


}
