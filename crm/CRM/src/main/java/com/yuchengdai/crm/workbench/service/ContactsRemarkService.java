package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.workbench.domain.ContactsRemark;

import java.util.List;

/**
 * RoyDai
 * 2017/4/7   21:48
 */
public interface ContactsRemarkService {

    //根据联系人id获取对应的联系人备注详细信息
    List<ContactsRemark> queryContactsForDetailByContactsId(String contactsId);

    //添加一个联系人备注信息
    int addContactsRemark(ContactsRemark contactsRemark);

    //根据id更新一个联系人备注信息
    int updateContactsRemark(ContactsRemark contactsRemark);

    //通过id删除对应的联系人备注信息
    int deleteContactsRemarkById(String id);
}
