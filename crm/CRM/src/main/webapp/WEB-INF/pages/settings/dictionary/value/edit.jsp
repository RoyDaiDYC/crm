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
            //给取消按钮添加点击事件
            $("#backButton").click(function () {
                window.history.back();
            });


            //检测字典数据值是否为空
            $("#edit-value").blur(function () {
                checkValue();
            });
            /*
            *
            * 字典值不能为空
            * 字典值在当前选定的类型下不能重复
            * 设置checkValueFlag为接收返回值内容
            *
            * */
            var checkValueFlag = false;

            function checkValue() {
                //获取字典值和字典类型
                var value = $.trim($("#edit-value").val());
                var typeCode = $("#edit-typeCode").val();
                if (value === "") {
                    $("#valueF").html("字典值不能为空");
                    $("#valueT").html("");
                    return false;
                } else {
                    $("#valueF").html("");
                    $("#valueT").html("");
                }

                /*
                *
                * 通过ajax同步请求
                * 确认在同一个字典类型下
                * 输入的是否是重复的字典值
                * */
                //发起请求
                $.ajax({
                    url: "settings/dictionary/value/checkValueInDictionaryValue.do",
                    type: "post",
                    dataType: "json",
                    async: false,
                    data: {
                        value: value,
                        typeCode: typeCode
                    },
                    success: function (data) {
                        if (data.code === "0") {
                            $("#valueF").html(data.message);
                            checkValueFlag = false;
                        }
                        if (data.code === "1") {
                            $("#valueT").html(data.message);
                            checkValueFlag = true;
                        }
                    }
                });

                return checkValueFlag;
            }

            //给更新按钮添加点击事件
            $("#updateButton").click(function () {
                //获取字段值
                var id = "${dictionaryValue.id}";
                var typeCode = $.trim($("#edit-typeCode").val());
                var value = $.trim($("#edit-value").val());
                var text = $.trim($("#edit-text").val());
                var orderNo = $.trim($("#edit-orderNo").val());

                //当checkValue通过后发起请求
                if (checkValue()) {
                    $.ajax({
                        url: "settings/dictionary/value/updateDictionaryValue.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            id: id,
                            typeCode: typeCode,
                            value: value,
                            text: text,
                            orderNo: orderNo
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                window.location.href = "settings/dictionary/value/toIndex.do";
                            }
                        }

                    });
                } else {
                    alert("请检查数据字典值");
                }


            });


        });
    </script>
</head>
<body>

<div style="position:  relative; left: 30px;">
    <h3>修改字典值</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="updateButton" type="button" class="btn btn-primary">更新</button>
        <button id="backButton" type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form">

    <div class="form-group">
        <label for="edit-typeCode" class="col-sm-2 control-label">字典类型编码</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-typeCode" style="width: 200%;"
                   value="${dictionaryValue.typeCode}" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-value" class="col-sm-2 control-label">字典值<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-value" style="width: 200%;"
                   value="${dictionaryValue.value}">
            <span id="valueF" style="color: red"></span>
            <span id="valueT" style="color: green"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-text" class="col-sm-2 control-label">文本</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-text" style="width: 200%;" value="${dictionaryValue.text}">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-orderNo" style="width: 200%;"
                   value="${dictionaryValue.orderNo}">
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>