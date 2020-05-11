package com.yuchengdai.crm.settings.service.impl;

import com.yuchengdai.crm.settings.service.UserService;
import com.yuchengdai.crm.settings.domain.User;
import com.yuchengdai.crm.settings.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


/**
 * RoyDai
 * 2017/3/5   22:22
 */
@Service("userService")
public class UserServiceImpl implements UserService {


    private UserMapper userMapper;

    @Autowired
    public UserServiceImpl setUserMapper(UserMapper userMapper) {
        this.userMapper = userMapper;
        return this;
    }

    /**
     * 通过登录账户和密码查询用户
     *
     * @param map
     * @return
     */
    @Override
    public User queryUserByActPwd(Map<String, Object> map) {
        return userMapper.selectUserByActPwd(map);
    }

    /**
     * 通过密码和id查询用户
     *
     * @param map
     * @return
     */
    @Override
    public User queryUserByPwdId(Map<String, Object> map) {
        return userMapper.selectUserByPwdId(map);
    }

    /**
     * 通过id更新用户信息
     *
     * @param user
     * @return
     */
    @Override
    public int editUserById(User user) {
        return userMapper.updateUserById(user);
    }

    /**
     * 获取所有人员信息
     *
     * @return
     */
    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }
}
