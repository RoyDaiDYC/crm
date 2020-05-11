package com.yuchengdai.crm.workbench.mapper.contacts;

import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Sat Mar 28 11:30:22 CST 2017
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Sat Mar 28 11:30:22 CST 2017
     */
    int insert(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Sat Mar 28 11:30:22 CST 2017
     */
    int insertSelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Sat Mar 28 11:30:22 CST 2017
     */
    Contacts selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Sat Mar 28 11:30:22 CST 2017
     */
    int updateByPrimaryKeySelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Sat Mar 28 11:30:22 CST 2017
     */
    int updateByPrimaryKey(Contacts record);

    /**
     * 添加一个联系人信息
     *
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);

    /**
     * 通过客户id获取详细的联系人信息
     *
     * @param customerId
     * @return
     */
    List<Contacts> selectContactsForDetailByCustomerId(String customerId);

    /**
     * 通过客户id批量删除对应的联系人信息
     *
     * @param customerIds
     * @return
     */
    int deleteContactsByCustomerIdArray(String[] customerIds);

    /**
     * 通过客户id数组查询出对应的联系人集合内容
     *
     * @param customerIds
     * @return
     */
    List<Contacts> selectContactsForDetailByCustomerIdArray(String[] customerIds);

    /**
     * 根据条件，查询出详细的联系人信息，分页查询
     *
     * @param map
     * @return
     */
    List<Contacts> selectAllContactsForDetailByCondition(Map<String, Object> map);

    /**
     * 通过条件查询出联系人信息的总条数
     *
     * @param map
     * @return
     */
    int selectAllCountContacts(Map<String, Object> map);

    /**
     * 通过id查询出对应的联系人内容
     *
     * @param id
     * @return
     */
    Contacts selectContactsById(String id);

    /**
     * 通过id更新一个联系人信息
     *
     * @param contacts
     * @return
     */
    int updateContacts(Contacts contacts);

    /**
     * 根据id批量删除对应的联系人
     *
     * @param ids
     * @return
     */
    int deleteContactsById(String[] ids);

    /**
     * 通过id查询获取联系人详细信息
     *
     * @param id
     * @return
     */
    Contacts selectContactsForDetailById(String id);

    /**
     * 通过名称模糊查询出联系人详细信息
     *
     * @param fullName
     * @return
     */
    List<Contacts> selectContactsForDetailByFullName(String fullName);
}