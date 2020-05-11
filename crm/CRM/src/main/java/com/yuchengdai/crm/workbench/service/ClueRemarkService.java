package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * RoyDai
 * 2017/3/25   16:24
 */
public interface ClueRemarkService {

    //根据线索id获取对应线索的备注内容条目， 为一个集合
    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

    //添加一个线索备注内容
    int addClueRemark(ClueRemark clueRemark);

    //根据id更新线索备注内容
    int editClueRemarkById(ClueRemark clueRemark);

    //根据id删除对应的线索备注信息
    int deleteClueRemarkById(String id);
}
