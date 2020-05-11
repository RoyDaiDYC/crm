package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/4/7   22:09
 */
public interface ContactsActivityRelationService {

    //根据联系人id获取对应的联系人市场活动关系内容
    List<ContactsActivityRelation> queryContactsActivityRelationByContactsId(String contactsId);

    //批量插入联系人市场活动关系内容
    int addContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelationList);

    //通过联系人id确定联系人，再通过市场id确定要删除的对应的联系人市场关系内容
    int deleteContactsActivityRelationByContactsIdActivityId(Map<String, Object> map);
}
