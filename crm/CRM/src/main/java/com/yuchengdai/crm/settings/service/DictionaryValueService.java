package com.yuchengdai.crm.settings.service;

import com.yuchengdai.crm.settings.domain.DictionaryValue;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/8   19:12
 */
public interface DictionaryValueService {

    //获取所有数据字典值
    List<DictionaryValue> queryAllDictionaryValue();

    //通过value和typeCode获取数据字典值
    DictionaryValue queryDictionaryValueByValue(Map<String, Object> map);

    //添加数据字典值
    int addDictionaryValue(DictionaryValue dictionaryValue);

    //通过id获取数据字典值
    DictionaryValue getDictionaryValueById(String id);

    //根据id更新数据字典值
    int editDictionaryValueById(DictionaryValue dictionaryValue);

    //根据id删除对应数据字典值
    int deleteDictionaryValueById(String[] ids);

    //根据typeCode查询出数据字典值
    List<DictionaryValue> queryDictionaryValueByTypeCode(String typeCode);
}
