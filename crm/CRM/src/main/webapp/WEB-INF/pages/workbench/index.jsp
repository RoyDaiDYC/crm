<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        //页面加载完毕
        $(function () {

            //导航中所有文本颜色为黑色
            $(".liClass > a").css("color", "black");

            //默认选中导航菜单中的第一个菜单项
            $(".liClass:first").addClass("active");

            //第一个菜单项的文字变成白色
            $(".liClass:first > a").css("color", "white");

            //给所有的菜单项注册鼠标单击事件
            $(".liClass").click(function () {
                //移除所有菜单项的激活状态
                $(".liClass").removeClass("active");
                //导航中所有文本颜色为黑色
                $(".liClass > a").css("color", "black");
                //当前项目被选中
                $(this).addClass("active");
                //当前项目颜色变成白色
                $(this).children("a").css("color", "white");
            });


            window.open("workbench/main/toIndex.do", "workareaFrame");

            //安全退出点击事件
            $("#safeLoginOutButton").click(function () {
                window.location.href = 'settings/qx/user/toLogOut.do';
            });

            //密码修改，原密码输入后光标离开检查
            $("#oldPwd").blur(function () {
                checkOldPwd();
            });

            //发送异步请求检查输入的原密码是否正确
            //设置一个变量checkOldPwdFlag来显示确认是否无误
            var checkOldPwdFlag = false;

            function checkOldPwd() {
                var oldPwd = $("#oldPwd").val();
                //对密码进行md5加密
                oldPwd = $.md5(oldPwd);
                var id = "${sessionScope.sessionUser.id}";
                $.ajax({
                    url: "settings/qx/user/checkPwd.do",
                    type: "post",
                    dataType: "json",
                    async: false,
                    data: {
                        loginPwd: oldPwd,
                        id: id
                    },
                    success: function (data) {
                        if (data.code === "1") {
                            $("#oldPwdMsg").html("");
                            checkOldPwdFlag = true;
                        } else {
                            $("#oldPwdMsg").html(data.message);
                            checkOldPwdFlag = false;
                        }
                    }
                });
                return checkOldPwdFlag;
            }

            //新密码和确认密码是否一致确认，通过确认密码光标移开后检查
            $("#confirmPwd").blur(function () {
                checkConfirmPwd()
            });

            function checkConfirmPwd() {
                var newPwd = $.trim($("#newPwd").val());
                var confirmPwd = $.trim($("#confirmPwd").val());

                if (newPwd === "") {
                    $("#newPwdMsg").html("密码不能为空");
                    return false
                } else {
                    $("#newPwdMsg").html("");
                }

                if (newPwd === confirmPwd) {
                    $("#confirmPwdMsg").html("");
                    return true;
                } else {
                    $("#confirmPwdMsg").html("输入的和新密码不一致");
                    return false;
                }
            }

            /*
            * 给更新按钮添加点击事件
            *
            * */
            $("#updateButton").click(function () {
                var newPwd = $.trim($("#newPwd").val());
                var id = "${sessionScope.sessionUser.id}";
                //对新密码进行md5加密
                newPwd = $.md5(newPwd);
                //当老密码和新密码确认无误后才执行提交按钮
                if (checkOldPwd() && checkConfirmPwd()) {
                    $.ajax({
                        url: "settings/qx/user/updatePwd.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            loginPwd: newPwd,
                            id: id
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                window.location.href = 'settings/qx/user/toLogOut.do';
                            }
                        }
                    });
                }

            });


            //取消按钮点击事件
            $("#cancelButton").click(function () {
                $("#oldPwd").val("");
                $("#newPwd").val("");
                $("#confirmPwd").val("");
                $("#oldPwdMsg").html("");
                $("#newPwdMsg").html("");
                $("#confirmPwdMsg").html("");
            });


        });


    </script>

</head>
<body>

<!-- 我的资料 -->
<div class="modal fade" id="myInformation" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">我的资料</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${sessionScope.sessionUser.name}</b><br><br>
                    登录帐号：<b>${sessionScope.sessionUser.loginAct}</b><br><br>
                    组织机构：<b> ${sessionScope.sessionUser.deptno}，市场部，二级部门<%--1005，市场部，二级部门--%></b><br><br>
                    邮箱：<b>${sessionScope.sessionUser.email}</b><br><br>
                    失效时间：<b>${sessionScope.sessionUser.expireTime}</b><br><br>
                    允许访问IP：<b>${sessionScope.sessionUser.allowIps}</b>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="oldPwd" class="col-sm-2 control-label">原密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="oldPwd" style="width: 200%;">
                            <span id="oldPwdMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPwd" class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="newPwd" style="width: 200%;">
                            <span id="newPwdMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
                            <span id="confirmPwdMsg" style="color: red"></span>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="cancelButton" type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="updateButton" type="button" class="btn btn-primary" >更新
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">离开</h4>
            </div>
            <div class="modal-body">
                <p>您确定要退出系统吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="safeLoginOutButton" type="button" class="btn btn-primary" data-dismiss="modal">确定
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;by雨成</span></div>
    <div style="position: absolute; top: 15px; right: 15px;">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle"
                   data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user"></span>${sessionScope.sessionUser.name}<span
                        class="caret"></span>
                </a>
                <ul class="dropdown-menu" style="left: -50px ;">
                    <li><a href="settings/toIndex.do"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span
                            class="glyphicon glyphicon-file"></span> 我的资料</a></li>
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span
                            class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
                    <li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span
                            class="glyphicon glyphicon-off"></span> 退出</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<!-- 中间 -->
<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">

    <!-- 导航 -->
    <div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">

        <ul id="no1" class="nav nav-pills nav-stacked">
            <li class="liClass"><a href="workbench/main/toIndex.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-home"></span> 工作台</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-tag"></span> 动态</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-time"></span> 审批</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-user"></span> 客户公海</a></li>
            <li class="liClass"><a href="workbench/activity/toIndex.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-play-circle"></span> 市场活动</a></li>
            <li class="liClass"><a href="workbench/clue/toIndex.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-search"></span> 线索（潜在客户）</a></li>
            <li class="liClass"><a href="workbench/customer/toIndex.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-user"></span> 客户</a></li>
            <li class="liClass"><a href="workbench/contacts/toIndex.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-earphone"></span> 联系人</a></li>
            <li class="liClass"><a href="workbench/transaction/toIndex.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-usd"></span> 交易（商机）</a></li>
            <li class="liClass"><a href="visit/index.html" target="workareaFrame"><span
                    class="glyphicon glyphicon-phone-alt"></span> 售后回访</a></li>
            <li class="liClass">
                <a href="#no2" class="collapsed" data-toggle="collapse"><span class="glyphicon glyphicon-stats"></span>
                    统计图表</a>
                <ul id="no2" class="nav nav-pills nav-stacked collapse">
                    <li class="liClass"><a href="chart/activity/index.html"
                                           target="workareaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span> 市场活动统计图表</a></li>
                    <li class="liClass"><a href="chart/clue/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span> 线索统计图表</a></li>
                    <li class="liClass"><a href="chart/customerAndContacts/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span> 客户和联系人统计图表</a></li>
                    <li class="liClass"><a href="workbench/chart/transaction/toTransaction.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span> 交易统计图表</a></li>
                </ul>
            </li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-file"></span> 报表</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-shopping-cart"></span> 销售订单</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-send"></span> 发货单</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-earphone"></span> 跟进</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-leaf"></span> 产品</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-usd"></span> 报价</a></li>
        </ul>

        <!-- 分割线 -->
        <div id="divider1"
             style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
    </div>

    <!-- 工作区 -->
    <div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
        <iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
    </div>

</div>

<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>

<!-- 底部 -->
<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>

</body>
</html>