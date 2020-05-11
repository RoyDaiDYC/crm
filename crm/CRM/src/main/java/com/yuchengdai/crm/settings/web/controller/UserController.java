package com.yuchengdai.crm.settings.web.controller;

import com.yuchengdai.crm.commons.modle.ReturnObject;
import com.yuchengdai.crm.commons.util.Constants;
import com.yuchengdai.crm.settings.domain.User;

import com.yuchengdai.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


/**
 * RoyDai
 * 2017/3/5   19:48
 */
@Controller
public class UserController {

    private UserService userService;

    @Autowired
    public UserController setUserService(UserService userService) {
        this.userService = userService;
        return this;
    }

    /**
     * 接收页面请求，跳转login.jsp页面
     *
     * @return
     */
    @RequestMapping(value = "/settings/qx/user/toLogin.do",method = RequestMethod.GET)
    public String toLogin() {
        return "settings/qx/user/login";
    }


    /**
     * @param loginAct
     * @param loginPwd
     * @param isLoginRemPwd
     * @param request
     * @param session
     * @param response
     * @return 用户名或者密码错误, 用户已过期, 用户状态被锁定, ip受限 都不能登录成功
     * 返回内容是一个json串，标志0代表登录失败1代表成功，msg代表提示信息，返回附带session等数据
     */
    @RequestMapping(value = "/settings/qx/user/login.do", method = RequestMethod.POST)
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isLoginRemPwd,
                        HttpServletRequest request,
                        HttpSession session,
                        HttpServletResponse response) {
        //使用MD5对密码进行加密，前端已经用了md5了
        //String loginPwdMD5 = DigestUtils.md5DigestAsHex(loginPwd.getBytes());
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);

        //调service层查询用户
        User user = userService.queryUserByActPwd(map);

        ReturnObject returnObj = new ReturnObject();

        String ip = request.getRemoteAddr();
        //用户名和密码
        if (user == null) {
            //不能登录,返回msg用户名或密码错误
            returnObj.setCode(Constants.JSON_RETURN_FAIL);
            returnObj.setMessage("用户名或密码错误");
        } else {
            //获取当前时间
            Date date = new Date();
            //设置时间格式
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
            //当前日期格式为String
            String nowDate = sdf.format(date);
            if (nowDate.compareTo(user.getExpireTime()) > 0) {
                //不能登录，返回msg账号已过期
                returnObj.setCode(Constants.JSON_RETURN_FAIL);
                returnObj.setMessage("账号已过期");
            } else if ("0".equals(user.getLockState())) {
                //不能登录，返回msg账号被锁定
                returnObj.setCode(Constants.JSON_RETURN_FAIL);
                returnObj.setMessage("账号被锁定");
            } else if (!user.getAllowIps().contains(ip)) {
                //不能登录，返回msg用户ip受限（不在允许访问ip中）
                returnObj.setCode(Constants.JSON_RETURN_FAIL);
                returnObj.setMessage("当前IP无法访问");
            } else {
                //登录成功,设置session
                returnObj.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObj.setMessage("登录成功");
                //创建session，放入的是查询到的用户信息
                session.setAttribute(Constants.SESSION_USER, user);

                //检查cookie以及创建cookie，需要用到登录页面十天免登录按钮选中信息
                if ("true".equals(isLoginRemPwd)) {
                    Cookie cookie1 = new Cookie("loginAct", loginAct);
                    cookie1.setMaxAge(60);//设置用户名的生命周期
                    response.addCookie(cookie1);
                    Cookie cookie2 = new Cookie("loginPwd", loginPwd);
                    cookie2.setMaxAge(60);//设置用户密码的生命周期
                    response.addCookie(cookie2);
                } else {
                    //相同名称cookie可以进行属性覆盖，设置生命周期为0后清空cookie
                    Cookie cookie1 = new Cookie("loginAct", loginAct);
                    cookie1.setMaxAge(0);//设置用户名的生命周期
                    response.addCookie(cookie1);
                    Cookie cookie2 = new Cookie("loginPwd", loginPwd);
                    cookie2.setMaxAge(0);//设置用户密码的生命周期
                    response.addCookie(cookie2);
                }

            }
        }
        return returnObj;
    }

    /**
     * @param session
     * @param response
     * @return 安全退出
     * 删除session，删除cookie，返回登录首页
     */
    @RequestMapping(value = "/settings/qx/user/toLogOut.do",method = RequestMethod.GET)
    public String logOut(HttpSession session, HttpServletResponse response) {
        //清除session，invalidate方法效率高，对比清空session内容不会遗留session占用内存
        session.invalidate();

        //清除cookie
        Cookie cookie1 = new Cookie("loginAct", "0");
        cookie1.setMaxAge(0);//设置用户名的生命周期
        response.addCookie(cookie1);
        Cookie cookie2 = new Cookie("loginPwd", "0");
        cookie2.setMaxAge(0);//设置用户密码的生命周期
        response.addCookie(cookie2);
        return "redirect:/";
    }


    /**
     * 跳转用户维护首页
     *
     * @return
     */
    @RequestMapping(value = "/settings/qx/user/toIndex.do",method = RequestMethod.GET)
    public String toIndex() {
        return "settings/qx/user/index";
    }


    /**
     * 通过密码和id检查用户信息
     *
     * @param loginPwd
     * @param id
     * @return
     */
    @RequestMapping(value = "/settings/qx/user/checkPwd.do",method = RequestMethod.POST)
    @ResponseBody
    public Object checkPwd(String loginPwd, String id) {
        //对密码进行MD5加密，前端已经用了md5了
        //loginPwd = DigestUtils.md5DigestAsHex(loginPwd.getBytes());
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("loginPwd", loginPwd);
        User user = userService.queryUserByPwdId(map);
        ReturnObject returnObject = new ReturnObject();
        if (user == null) {
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("请重新输入，原密码错误");
        } else {
            returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
        }
        return returnObject;
    }

    /**
     * 更新用户信息，修改密码
     *
     * @param user
     * @return
     */
    @RequestMapping(value = "/settings/qx/user/updatePwd.do",method = RequestMethod.POST)
    @ResponseBody
    public Object modifyUserById(User user) {
        //对密码进行MD5加密，前端已经用了md5了
        //user.setLoginPwd(DigestUtils.md5DigestAsHex(user.getLoginPwd().getBytes()));
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = userService.editUserById(user);
            if (i > 0) {
                returnObject.setCode(Constants.JSON_RETURN_SUCCESS);
                returnObject.setMessage("修改成功，请重新登录！");
            } else {
                returnObject.setCode(Constants.JSON_RETURN_FAIL);
                returnObject.setMessage("修改失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.JSON_RETURN_FAIL);
            returnObject.setMessage("网络波动，修改失败");
        }
        return returnObject;
    }

}
