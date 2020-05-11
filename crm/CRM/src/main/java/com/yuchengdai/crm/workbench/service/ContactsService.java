package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/28   11:42
 */
public interface ContactsService {

    //通过客户id获取详细的联系人信息
    List<Contacts> queryContactsForDetailByCustomerId(String customerId);

    //添加一个联系人信息
    //存在客户名如果不在数据库中，则新建，map中存了contacts和客户名
    int addContacts(Map<String, Object> map);

    //进行分页查询，通过条件获取对应的联系人信息和总条数
    PaginationResultVO<Contacts> queryAllContactsForDetailByCondition(Map<String, Object> map);

    //根据id查询出对应的联系人内容
    Contacts queryContactsById(String id);

    //根据id更新一个联系人信息
    //存在客户名如果不在数据库中，则新建，map中存了contacts和客户名
    int editContactsById(Map<String, Object> map);

    //通过id盘批量删除对应的联系人
    int deleteContactsById(String[] ids);

    //通过id获取详细的联系人信息
    Contacts queryContactsForDetailById(String id);

    //通过联系人名称模糊查询获取对应的联系人详细信息
    List<Contacts> queryContactsForDetailByFullName(String fullName);
}
