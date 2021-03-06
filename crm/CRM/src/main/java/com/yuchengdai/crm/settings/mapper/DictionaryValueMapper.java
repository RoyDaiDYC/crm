package com.yuchengdai.crm.settings.mapper;

import com.yuchengdai.crm.settings.domain.DictionaryValue;

import java.util.List;
import java.util.Map;

public interface DictionaryValueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dictionary_value
     *
     * @mbg.generated Sun Mar 08 16:31:05 CST 2017
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dictionary_value
     *
     * @mbg.generated Sun Mar 08 16:31:05 CST 2017
     */
    int insert(DictionaryValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dictionary_value
     *
     * @mbg.generated Sun Mar 08 16:31:05 CST 2017
     */
    int insertSelective(DictionaryValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dictionary_value
     *
     * @mbg.generated Sun Mar 08 16:31:05 CST 2017
     */
    DictionaryValue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dictionary_value
     *
     * @mbg.generated Sun Mar 08 16:31:05 CST 2017
     */
    int updateByPrimaryKeySelective(DictionaryValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dictionary_value
     *
     * @mbg.generated Sun Mar 08 16:31:05 CST 2017
     */
    int updateByPrimaryKey(DictionaryValue record);

    /**
     * 查询全部的数据字典值
     *
     * @return
     */
    List<DictionaryValue> selectAllDictionaryValue();

    /**
     * 添加数据字典值
     *
     * @param dictionaryValue
     * @return
     */
    int insertDictionaryValue(DictionaryValue dictionaryValue);

    /**
     * 通过value和typeCode查询数据字典值
     *
     * @param map
     * @return
     */
    DictionaryValue selectDictionaryValueByValueAndTypeCode(Map<String, Object> map);

    /**
     * 通过id查询数据字典值
     *
     * @param id
     * @return
     */
    DictionaryValue selectDictionaryValueById(String id);

    /**
     * 根据id更新这个数据字典值
     *
     * @param dictionaryValue
     * @return
     */
    int updateDictionaryValueById(DictionaryValue dictionaryValue);


    /**
     * 通过id删除对应的数据字典值
     * @param ids
     * @return
     */
    int deleteDictionaryValueById(String[] ids);

    /**
     * 通过typeCode查询出数据字典值集合
     * @return
     */
    List<DictionaryValue> selectDictionaryValueByTypeCode(String typeCode);
}