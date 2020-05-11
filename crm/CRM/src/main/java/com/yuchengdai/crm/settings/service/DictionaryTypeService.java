package com.yuchengdai.crm.settings.service;

import com.yuchengdai.crm.settings.domain.DictionaryType;

import java.util.List;

/**
 * RoyDai
 * 2017/3/8   16:33
 */
public interface DictionaryTypeService {

    //获取所有数据字典类型
    List<DictionaryType> queryAllDictionaryType();

    //添加数据字典类型
    int addDictionaryType(DictionaryType dictionaryType);

    //根据code查询数据字典类型
    DictionaryType getDictionaryTypeByCode(String code);

    //根据code更新数据字典类型
    int editDictionaryTypeByCode(DictionaryType dictionaryType);

    //根据code删除数据字典类型
    int deleteDictionaryTypeByCode(String[] codes);
}
