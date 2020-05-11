package com.yuchengdai.crm.settings.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.settings.domain.DictionaryType;
import com.yuchengdai.crm.settings.service.DictionaryTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * RoyDai
 * 2017/3/8   14:49
 */
@Controller
public class DictionaryTypeController {

    private DictionaryTypeService dictionaryTypeService;

    @Autowired
    public DictionaryTypeController setDictionaryTypeService(DictionaryTypeService dictionaryTypeService) {
        this.dictionaryTypeService = dictionaryTypeService;
        return this;
    }

    /**
     * 跳转到数据字典type首页
     * 通过service获取数据字典类型集合
     * 把集合装箱
     * 通过model设置请求转发的数据
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/type/toIndex.do",method = RequestMethod.GET)
    public String toType(Model model) {
        //获取数据字典的类型集合
        List<DictionaryType> dictionaryTypeList = dictionaryTypeService.queryAllDictionaryType();
        //装箱
        model.addAttribute(dictionaryTypeList);
        //跳转类型值首页
        return "settings/dictionary/type/index";
    }

    /**
     * 点击创建按钮跳转创建页面
     *
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/type/toSave.do",method = RequestMethod.GET)
    public String toSave() {
        return "settings/dictionary/type/save";
    }

    /**
     * 点击保存按钮进行数据添加
     * 返回是否添加成功信息
     *
     * @param dictionaryType
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/type/saveCreateDictionaryType.do",method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateDictionaryType(DictionaryType dictionaryType) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = dictionaryTypeService.addDictionaryType(dictionaryType);
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
     * 检查接收的code值是否和数据字典内code字段重复
     * 返回内容，1代表不重复，2代表重复
     *
     * @param code
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/type/checkCodeInDictionaryType.do",method = RequestMethod.POST)
    @ResponseBody
    public Object checkCodeInDictionaryType(String code) {
        DictionaryType dictionaryTypeByCode = dictionaryTypeService.getDictionaryTypeByCode(code);
        ReturnObject returnObject = new ReturnObject();
        if (dictionaryTypeByCode == null) {
            returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
            returnObject.setMessage("未重复，可以使用");
        } else {
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("编码已存在，请重新输入");
        }

        return returnObject;
    }

    /**
     * 点击编辑跳转到修改页面
     *
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/type/toEdit.do",method = RequestMethod.GET)
    public String toEdit(String code, Model model) {
        DictionaryType dictionaryTypeByCode = dictionaryTypeService.getDictionaryTypeByCode(code);
        model.addAttribute(dictionaryTypeByCode);
        return "settings/dictionary/type/edit";
    }

    /**
     * 通过code更新数据字典类型
     *
     * @param dictionaryType
     * @return
     */
    @RequestMapping(value = "/settings/dictionary/type/updateDictionaryType.do",method = RequestMethod.POST)
    @ResponseBody
    public Object modifyDictionaryTypeByCode(DictionaryType dictionaryType) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = dictionaryTypeService.editDictionaryTypeByCode(dictionaryType);
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

    @RequestMapping(value = "/settings/dictionary/type/delete.do",method = RequestMethod.POST)
    @ResponseBody
    public Object removeDictionaryTypeByCode(String[] code) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = dictionaryTypeService.deleteDictionaryTypeByCode(code);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("已删除" + i + "个类型");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setMessage("网络波动，删除失败");
        }
        return returnObject;
    }

}
