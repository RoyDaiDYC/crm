package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.workbench.domain.ClueRemark;
import com.yuchengdai.crm.workbench.mapper.clue.ClueRemarkMapper;
import com.yuchengdai.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * RoyDai
 * 2017/3/25   16:28
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    public ClueRemarkServiceImpl setClueRemarkMapper(ClueRemarkMapper clueRemarkMapper) {
        this.clueRemarkMapper = clueRemarkMapper;
        return this;
    }

    /**
     * 通过线索id查询出对应的线索备注信息
     * 备注信息的创建人和修改人都通过user联合查询显示为name
     *
     * @param clueId
     * @return
     */
    @Override
    public List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
    }

    /**
     * 添加一个线索备注信息
     *
     * @param clueRemark
     * @return
     */
    @Override
    public int addClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }

    /**
     * 根据id更新线索备注内容
     *
     * @param clueRemark
     * @return
     */
    @Override
    public int editClueRemarkById(ClueRemark clueRemark) {
        return clueRemarkMapper.updateClueRemark(clueRemark);
    }

    /**
     * 根据id删除对应的线索备注信息
     *
     * @param id
     * @return
     */
    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);
    }
}
