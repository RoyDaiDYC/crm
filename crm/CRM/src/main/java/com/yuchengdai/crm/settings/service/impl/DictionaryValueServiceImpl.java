package com.yuchengdai.crm.settings.service.impl;

import com.yuchengdai.crm.settings.domain.DictionaryValue;
import com.yuchengdai.crm.settings.mapper.DictionaryValueMapper;
import com.yuchengdai.crm.settings.service.DictionaryValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/8   19:15
 */
@Service
public class DictionaryValueServiceImpl implements DictionaryValueService {


    private DictionaryValueMapper dictionaryValueMapper;

    @Autowired
    public DictionaryValueServiceImpl setDictionaryValueMapper(DictionaryValueMapper dictionaryValueMapper) {
        this.dictionaryValueMapper = dictionaryValueMapper;
        return this;
    }

    /**
     * 调用dao层获取全部数据字典值
     *
     * @return
     */
    @Override
    public List<DictionaryValue> queryAllDictionaryValue() {
        return dictionaryValueMapper.selectAllDictionaryValue();
    }


    /**
     * 通过value和typeCode查询出数据字典值
     *
     * @param map
     * @return
     */
    @Override
    public DictionaryValue queryDictionaryValueByValue(Map<String, Object> map) {
        return dictionaryValueMapper.selectDictionaryValueByValueAndTypeCode(map);
    }

    /**
     * 添加数据字典值
     *
     * @param dictionaryValue
     * @return
     */
    @Override
    public int addDictionaryValue(DictionaryValue dictionaryValue) {
        return dictionaryValueMapper.insertDictionaryValue(dictionaryValue);
    }

    /**
     * 通过id获取数据字典值
     *
     * @param id
     * @return
     */
    @Override
    public DictionaryValue getDictionaryValueById(String id) {
        return dictionaryValueMapper.selectDictionaryValueById(id);
    }

    /**
     * 通过id更新数据字典值
     *
     * @param dictionaryValue
     * @return
     */
    @Override
    public int editDictionaryValueById(DictionaryValue dictionaryValue) {
        return dictionaryValueMapper.updateDictionaryValueById(dictionaryValue);
    }

    /**
     * 根据id删除对应的数据字典值
     *
     * @param ids
     * @return
     */
    @Override
    public int deleteDictionaryValueById(String[] ids) {
        return dictionaryValueMapper.deleteDictionaryValueById(ids);
    }

    /**
     * 通过typeCode查询出数据字典值集合
     *
     * @param typeCode
     * @return
     */
    @Override
    public List<DictionaryValue> queryDictionaryValueByTypeCode(String typeCode) {
        return dictionaryValueMapper.selectDictionaryValueByTypeCode(typeCode);
    }
}
