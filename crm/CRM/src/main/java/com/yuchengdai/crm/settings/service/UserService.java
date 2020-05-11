package com.yuchengdai.crm.settings.service;

import com.yuchengdai.crm.settings.domain.User;

import java.util.List;
import java.util.Map;


/**
 * RoyDai
 * 2017/3/5   22:16
 */
public interface UserService {

    //通过登录账户和密码查询用户信息
    User queryUserByActPwd(Map<String, Object> map);

    //通过密码和id查询用户信息
    User queryUserByPwdId(Map<String, Object> map);

    //通过id更新用户信息
    int editUserById(User user);

    //获取所有人员信息
    List<User> queryAllUsers();
}
