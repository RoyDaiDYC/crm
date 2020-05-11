package com.yuchengdai.crm.settings.service.impl;

import com.yuchengdai.crm.settings.domain.DictionaryType;
import com.yuchengdai.crm.settings.mapper.DictionaryTypeMapper;
import com.yuchengdai.crm.settings.service.DictionaryTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * RoyDai
 * 2017/3/8   16:35
 */
@Service
public class DictionaryTypeServiceImpl implements DictionaryTypeService {


    private DictionaryTypeMapper dictionaryTypeMapper;

    @Autowired
    public DictionaryTypeServiceImpl setDictionaryTypeMapper(DictionaryTypeMapper dictionaryTypeMapper) {
        this.dictionaryTypeMapper = dictionaryTypeMapper;
        return this;
    }

    /**
     * 获取所有数据字典类型值，调用dao层
     *
     * @return
     */
    @Override
    public List<DictionaryType> queryAllDictionaryType() {
        return dictionaryTypeMapper.selectAllDictionaryType();
    }

    /**
     * 根据code获取数据字典类型
     *
     * @param code
     * @return
     */
    @Override
    public DictionaryType getDictionaryTypeByCode(String code) {
        return dictionaryTypeMapper.selectDictionaryTypeByCode(code);
    }

    /**
     * 根据code更新数据字典类型
     *
     * @param dictionaryType
     * @return
     */
    @Override
    public int editDictionaryTypeByCode(DictionaryType dictionaryType) {
        return dictionaryTypeMapper.updateDictionaryTypeByCode(dictionaryType);
    }

    /**
     * 根据code删除对应的数据字典类型
     *
     * @param codes
     * @return
     */
    @Override
    public int deleteDictionaryTypeByCode(String[] codes) {
        return dictionaryTypeMapper.deleteDictionaryTypeByCode(codes);
    }

    /**
     * 添加一个数据字典类型
     *
     * @param dictionaryType
     * @return
     */
    @Override
    public int addDictionaryType(DictionaryType dictionaryType) {
        return dictionaryTypeMapper.insertDictionaryType(dictionaryType);
    }
}
