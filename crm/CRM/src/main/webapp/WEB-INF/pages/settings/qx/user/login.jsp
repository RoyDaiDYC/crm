<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="jstl" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" +
            request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/jQueryMD5/jquery.md5.js"></script>

    <script type="text/javascript">
        $(function () {


            //登录按钮设置点击事件
            $("#submitLoginButton").click(function () {


                //获取登录名称和密码参数
                var loginAct = $.trim($("#loginAct").val());
                var loginPwd = $.trim($("#loginPwd").val());
                //获取免登陆按钮选中值
                var isLoginRemPwd = $("#isLoginRemPwd").prop("checked");

                //验证名称和密码是否为空
                if ("" === loginAct) {
                    /*alert("用户名不能为空");*/
                    $("#msg").html("用户名不能为空");
                    return;
                }
                if ("" === loginPwd) {
                    /*alert("用户密码不能为空");*/
                    $("#msg").html("密码不能为空");
                    return;
                }


                /*
                * 进行判断，首次登陆不进行记住密码，需要进行md5加密
                * 记住密码后，因为拿到的是md5加密过的密码所以不用再加密
                * 当目前cookie的loginPwd是空，再进行加密
                * 当目前cookie的loginPwd有内容（代表上次登陆成功的密码），不做加密操作
                * 如存在cookie，用户又重新输入密码，则再进行md5加密
                *
                * */

                if ("${cookie.loginPwd}" === "" || "${cookie.loginPwd.value}" !== loginPwd) {
                    //进行md5加密
                    loginPwd = $.md5(loginPwd);
                }


                /*
                * 当名称和密码不为空时
                * 使用AJAX异步方式发送请求
                * 如果获取的json串
                * code是1登录成功跳转页面，0登录失败，提示信息
                *
                * */

                $.ajax({
                    url: "settings/qx/user/login.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        loginAct: loginAct,
                        loginPwd: loginPwd,
                        isLoginRemPwd: isLoginRemPwd
                    },
                    success: function (data) {
                        //返回的code是1跳转
                        if (data.code === "1") {
                            window.location.href = "workbench/toIndex.do";
                        } else {
                            //返回的code不是1,显示提示信息内容
                            $("#msg").html(data.message)
                        }
                    },
                    //还未跳转时显示的信息
                    beforeSend: function () {
                        $("#msg").html("验证中...")
                    }

                });
            });

            /*登录页面按下回车按键等同于点击了登录按钮
            * 设置按键点击事件
            * */
            $(window).keydown(function (e) {
                //当按键是回车键（字节码是13），执行登录按钮点击事件
                if (e.keyCode === 13) {
                    $("#submitLoginButton").click();
                }
            });


        });
    </script>

</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;by雨成</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form id="loginForm" action="workbench/toIndex.do" class="form-horizontal" role="form" method="post">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input id="loginAct" class="form-control" value="${cookie.loginAct.value}" type="text"
                           placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input id="loginPwd" class="form-control" value="${cookie.loginPwd.value}" type="password"
                           placeholder="密码">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                    <label>
                        <jstl:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
                            <input id="isLoginRemPwd" type="checkbox">
                        </jstl:if>
                        <jstl:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
                            <input id="isLoginRemPwd" type="checkbox" checked>
                        </jstl:if>
                        十天内免登录
                    </label>
                    &nbsp;&nbsp;
                    <span id="msg" style="color: red"></span>
                </div>
                <button id="submitLoginButton" type="button" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>