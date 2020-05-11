package com.yuchengdai.crm.settings.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.commons.util.YuChengUID;
import com.yuchengdai.crm.settings.domain.DictionaryType;
import com.yuchengdai.crm.settings.domain.DictionaryValue;
import com.yuchengdai.crm.settings.service.DictionaryTypeService;
import com.yuchengdai.crm.settings.service.DictionaryValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * RoyDai
 * 2017/3/8   17:27
 */
@Controller
public class DictionaryValueController {

    private DictionaryValueService dictionaryValueService;

    private DictionaryTypeService dictionaryTypeService;

    @Autowired
    public DictionaryValueController setDictionaryValueService(DictionaryValueService dictionaryValueService) {
        this.dictionaryValueService = dictionaryValueService;
        return this;
    }

    @Autowired
    public DictionaryValueController setDictionaryTypeService(DictionaryTypeService dictionaryTypeService) {
        this.dictionaryTypeService = dictionaryTypeService;
        return this;
    }

    /**
     * 获取所有的数据字典值
     *
     * @param model
     * @return
     */
    //跳转到数据字典值首页
    @RequestMapping(value = "/settings/dictionary/value/toIndex.do",method = RequestMethod.GET)
    public String toIndex(Model model) {
        //调用service方法获取数据字典值
        List<DictionaryValue> dictionaryValueList = dictionaryValueService.queryAllDictionaryValue();
        //装箱
        model.addAttribute(dictionaryValueList);
        //跳转
        return "settings/dictionary/value/index";
    }

    /**
     * 跳转到创建页面
     *
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/value/toSave.do",method = RequestMethod.GET)
    public String toSave(Model model) {
        //调用service方法获取数据字典类型
        List<DictionaryType> dictionaryTypeList = dictionaryTypeService.queryAllDictionaryType();
        //装箱
        model.addAttribute(dictionaryTypeList);
        //跳转
        return "settings/dictionary/value/save";
    }

    /**
     * 检查value和typeCode对应的数据字典值
     * 有的话代表出现当前typeCode下有这个value，前端不能输入
     * 没有的话代表当前typeCode下没有这个value，前端可以输入
     *
     * @param value
     * @param typeCode
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/value/checkValueInDictionaryValue.do",method = RequestMethod.POST)
    @ResponseBody
    public Object checkValueInDictionaryValue(String value, String typeCode) {
        //封装
        Map<String, Object> map = new HashMap<>();
        map.put("value", value);
        map.put("typeCode", typeCode);
        DictionaryValue dictionaryValue = dictionaryValueService.queryDictionaryValueByValue(map);
        ReturnObject returnObject = new ReturnObject();
        if (dictionaryValue == null) {
            returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
            returnObject.setMessage("可以使用");
        } else {
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("当前选中的字典类型下存在重复");
        }
        return returnObject;
    }


    /**
     * 创建一个数据字典值
     * id通过UUID生成唯一标识
     *
     * @param dictionaryValue
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/value/saveCreateDictionaryValue.do",method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateDictionaryValue(DictionaryValue dictionaryValue) {
        ReturnObject returnObject = new ReturnObject();
        dictionaryValue.setId(YuChengUID.getNoHyphenUUID());
        try {
            int i = dictionaryValueService.addDictionaryValue(dictionaryValue);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("创建成功");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("创建失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，创建失败");
        }
        return returnObject;
    }

    /**
     * 跳转到编辑页面
     *
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/value/toEdit.do",method = RequestMethod.GET)
    public String toEdit(String id, Model model) {
        DictionaryValue dictionaryValueById = dictionaryValueService.getDictionaryValueById(id);
        model.addAttribute(dictionaryValueById);
        return "settings/dictionary/value/edit";
    }

    /**
     * 通过id更新对应的数据字典值
     *
     * @param dictionaryValue
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/value/updateDictionaryValue.do",method = RequestMethod.POST)
    @ResponseBody
    public Object modifyDictionaryValueById(DictionaryValue dictionaryValue) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = dictionaryValueService.editDictionaryValueById(dictionaryValue);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("更新成功");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，更新失败");
        }
        return returnObject;
    }

    /**
     * 通过id删除对应的字典值
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/value/delete.do",method = RequestMethod.POST)
    @ResponseBody
    public Object removeDictionaryValueById(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = dictionaryValueService.deleteDictionaryValueById(id);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("已删除" + i + "个值");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("删除失败");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，删除失败");
        }
        return returnObject;
    }

}
