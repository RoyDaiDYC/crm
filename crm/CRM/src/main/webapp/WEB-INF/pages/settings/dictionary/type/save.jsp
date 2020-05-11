<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">


        $(function () {

            //点击取消按钮，内部不会更新，回撤上一个页面
            $("#backToIndex").click(function () {
                window.history.back();
            });

            /*
            * 验证编码栏内容
            * 【添加光标离开事件】，离开检测
            * 【添加code栏内容检测事件】如果为空，提示信息，返回false
            * 如果不为空，不提示信息
            * （如果先为空提示了信息，不为空后要覆盖之前提示过的信息，可以用空字符），继续执行code内容是否重复检测
            *
            * 光标离开后除了检测code栏是否为空外，还需要检测输入的内容是否和数据库内已有的code重复，code是主键，添加不能重复
            * 如果重复，在光标移开后，提示信息
            * 不重复继续
            *
            * */


            //当光标离开后进行code栏检测
            $("#add-code").blur(function () {
                checkCode();
            });

            /*
            * 检测code栏内容
            * 1检测code栏内容是否为空
            * 2检测code栏输入的内容是否有重复
            *
            * 1内容为空以及内容重复，不能点击保存提交按钮
            * 2内容不为空且内容不重复，可以点击保存提交按钮
            *
            * 使用变量checkFlag存布尔值
            * checkCode方法返回值为checkFlag
            * 提供checkCode是否正确
            * */
            var checkFlag = false;

            function checkCode() {
                //获取code的值
                var code = $.trim($("#add-code").val());

                //先进行值是否为空判断
                if (code === "") {
                    $("#codeMsgF").html("编码不能为空");
                    //返回false后不会继续执行下面的代码
                    return false;
                } else {
                    $("#codeMsgF").html("");
                    $("#codeMsgT").html("");
                }

                /*
                * 进行code内容是否重复判断
                *选择同步请求，和提交事件同步执行
                * 在未确认code内容前不进行提交操作
                * */
                $.ajax({
                    url: "settings/dictionary/type/checkCodeInDictionaryType.do",
                    type: "post",
                    dataType: "json",
                    async: false,
                    data: {
                        code: code
                    },
                    success: function (data) {
                        if (data.code === "0") {
                            $("#codeMsgF").html(data.message);
                            checkFlag = false;
                        }
                        if (data.code === "1") {
                            $("#codeMsgT").html(data.message);
                            checkFlag = true;
                        }
                    }

                });

                return checkFlag;
            }


            /*
            * 点击保存按钮后，进行内容传递给后台
            * 添加成功后跳转返回数据字典类型查询首页
            * 添加失败后不跳转，提示信息
            *
            *根据code检测内容返回来判断是否执行添加操作
            *
            * */
            $("#saveInfo").click(function () {
                /*
                * 获取编码，名称，描述
                * */
                var code = $.trim($("#add-code").val());
                var name = $.trim($("#add-name").val());
                var description = $.trim($("#add-description").val());

                if (checkCode()) {
                    $.ajax({
                        url: "settings/dictionary/type/saveCreateDictionaryType.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            code: code,
                            name: name,
                            description: description
                        },

                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                window.location.href = "settings/dictionary/type/toIndex.do";
                            }
                        }

                    });
                } else {
                    alert("请检查编码");
                }

            });

        });

    </script>
</head>
<body>

<div style="position:  relative; left: 30px;">
    <h3>新增字典类型</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="saveInfo" type="button" class="btn btn-primary">保存</button>
        <button id="backToIndex" type="button" class="btn btn-default" <%--onclick="window.history.back();"--%>>取消
        </button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form">

    <div class="form-group">
        <label <%--for="create-code"--%> class="col-sm-2 control-label">编码<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="add-code" style="width: 200%;">
            <span id="codeMsgF" style="color: red"></span><span id="codeMsgT" style="color: green"></span>
        </div>
    </div>

    <div class="form-group">
        <label <%--for="create-name"--%> class="col-sm-2 control-label">名称</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="add-name" style="width: 200%;">
        </div>
    </div>

    <div class="form-group">
        <label <%--for="create-describe"--%> class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 300px;">
            <textarea class="form-control" rows="3" id="add-description" style="width: 200%;"></textarea>
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>