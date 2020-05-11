package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.workbench.domain.ContactsActivityRelation;
import com.yuchengdai.crm.workbench.mapper.contacts.ContactsActivityRelationMapper;
import com.yuchengdai.crm.workbench.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


/**
 * RoyDai
 * 2017/4/7   22:09
 */
@Service
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {

    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    public ContactsActivityRelationServiceImpl setContactsActivityRelationMapper(ContactsActivityRelationMapper contactsActivityRelationMapper) {
        this.contactsActivityRelationMapper = contactsActivityRelationMapper;
        return this;
    }

    /**
     * 根据联系人id获取对应的联系人市场活动关系内容
     *
     * @param contactsId
     * @return
     */
    @Override
    public List<ContactsActivityRelation> queryContactsActivityRelationByContactsId(String contactsId) {
        return contactsActivityRelationMapper.selectContactsActivityRelationByContactsId(contactsId);
    }

    /**
     * 批量插入联系人市场活动关系内容
     *
     * @param contactsActivityRelationList
     * @return
     */
    @Override
    public int addContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelationList) {
        return contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelationList);
    }

    /**
     * 通过联系人id确定联系人，再通过市场id确定要删除的对应的联系人市场活动关系内容
     *
     * @param map
     * @return
     */
    @Override
    public int deleteContactsActivityRelationByContactsIdActivityId(Map<String, Object> map) {
        return contactsActivityRelationMapper.deleteContactsActivityRelationByContactsIdActivityId(map);
    }


}
