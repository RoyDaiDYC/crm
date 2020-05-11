package com.yuchengdai.crm.workbench.service.impl;

import com.yuchengdai.crm.workbench.domain.CustomerRemark;
import com.yuchengdai.crm.workbench.mapper.customer.CustomerRemarkMapper;
import com.yuchengdai.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * RoyDai
 * 2017/4/2   10:54
 */
@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    public CustomerRemarkServiceImpl setCustomerRemarkMapper(CustomerRemarkMapper customerRemarkMapper) {
        this.customerRemarkMapper = customerRemarkMapper;
        return this;
    }

    /**
     * 通过客户id获取对应所有备注信息
     *
     * @param customerId
     * @return
     */
    @Override
    public List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkForDetailByCustomerId(customerId);
    }

    /**
     * 添加一个客户备注信息
     *
     * @param customerRemark
     * @return
     */
    @Override
    public int addCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCustomerRemark(customerRemark);
    }

    /**
     * 通过id更新客户备注信息
     *
     * @param customerRemark
     * @return
     */
    @Override
    public int editCustomerRemarkById(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateCustomerRemark(customerRemark);
    }

    /**
     * 根据id删除对应的客户备注信息
     *
     * @param id
     * @return
     */
    @Override
    public int deleteCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteCustomerRemarkById(id);
    }
}
