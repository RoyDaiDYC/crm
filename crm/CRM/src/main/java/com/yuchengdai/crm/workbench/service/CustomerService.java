package com.yuchengdai.crm.workbench.service;


import com.yuchengdai.crm.commons.modle.PaginationResultVO;
import com.yuchengdai.crm.workbench.domain.Customer;


import java.util.List;
import java.util.Map;

/**
 * RoyDai
 * 2017/3/28   11:38
 */
public interface CustomerService {

    //添加一个客户信息
    int addCustomer(Customer customer);

    //根据条件进行分页查询出客户内容
    PaginationResultVO<Customer> queryAllCustomerForDetailByCondition(Map<String, Object> map);

    //根据id查询客户内容
    Customer queryCustomerById(String id);

    //通过id跟新客户信息
    int editCustomerById(Customer customer);

    //通过id批量删除对应的客户信息
    int deleteCustomerById(String[] ids);

    //通过id获取到详细的客户信息
    Customer queryCustomerForDetailById(String id);

    //通过名称模糊查询获取客户集合
    List<Customer> queryCustomerByName(String name);

}
