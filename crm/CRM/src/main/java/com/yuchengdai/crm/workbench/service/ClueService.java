package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.workbench.domain.Clue;

import java.util.Map;

/**
 * RoyDai
 * 2017/3/24   10:21
 */
public interface ClueService {

    //添加一个市场线索
    int addClue(Clue clue);

    //根据条件查询线索
    PaginationResultVO<Clue> queryAllClueForDetailByCondition(Map<String, Object> map);

    //根据id查询出线索
    Clue queryClueById(String id);

    //根据id更新线索
    int editClueById(Clue clue);

    //根据id删除对应的线索
    //先删除线索拥有的备注内容
    int deleteClueById(String[] ids);

    //根据id查询出线索详细内容，唯一标识替换成文本
    Clue queryClueForDetailById(String id);

    /*
    * 转换线索操作
    * 需满足
    * 1、创建客户内容，2、创建客户备注内容
    * 3、创建联系人内容，4、创建联系人备注内容，5、创建联系人关联市场活动内容
    * 6，判断是否点击了为客户创建交易，点击了创建相关内容
    * 7，删除线索备注
    * 8，删除线索关联活动
    * 9，删除线索
    * */
    void saveClueConvert(Map<String ,Object> map);
}
