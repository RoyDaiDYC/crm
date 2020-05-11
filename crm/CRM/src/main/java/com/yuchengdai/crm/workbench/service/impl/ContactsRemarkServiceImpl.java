package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.workbench.domain.ContactsRemark;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsRemarkMapper;
import com.yuchengdai.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * RoyDai
 * 2017/4/7   21:50
 */
@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    public ContactsRemarkServiceImpl setContactsRemarkMapper(ContactsRemarkMapper contactsRemarkMapper) {
        this.contactsRemarkMapper = contactsRemarkMapper;
        return this;
    }

    /**
     * 根据联系人id获取对应的联系人备注详细信息
     *
     * @param contactsId
     * @return
     */
    @Override
    public List<ContactsRemark> queryContactsForDetailByContactsId(String contactsId) {
        return contactsRemarkMapper.selectContactsRemarkForDetailByContactsId(contactsId);
    }

    /**
     * 添加一个联系人备注信息
     *
     * @param contactsRemark
     * @return
     */
    @Override
    public int addContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertContactsRemark(contactsRemark);
    }

    /**
     * 根据id更新一个联系人备注信息
     *
     * @param contactsRemark
     * @return
     */
    @Override
    public int updateContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.updateContactsRemark(contactsRemark);
    }

    /**
     * 通过id删除对应的联系人备注信息
     *
     * @param id
     * @return
     */
    @Override
    public int deleteContactsRemarkById(String id) {
        return contactsRemarkMapper.deleteContactsRemarkById(id);
    }
}
