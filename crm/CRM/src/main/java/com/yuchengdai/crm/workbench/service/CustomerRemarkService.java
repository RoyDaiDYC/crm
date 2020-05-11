package com.yuchengdai.crm.workbench.service;

import com.yuchengdai.crm.workbench.domain.CustomerRemark;

import java.util.List;

/**
 * RoyDai
 * 2017/4/2   10:53
 */
public interface CustomerRemarkService {

    //获取客户id对应的备注信息
    List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId);

    //添加一个客户备注信息
    int addCustomerRemark(CustomerRemark customerRemark);

    //通过id更新客户备注信息
    int editCustomerRemarkById(CustomerRemark customerRemark);

    //通过id删除对应的客户信息
    int deleteCustomerRemarkById(String id);
}
