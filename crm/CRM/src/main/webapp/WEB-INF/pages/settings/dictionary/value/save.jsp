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
            //取消按钮添加点击事件
            $("#backButton").click(function () {
                window.history.back();
            });


            /*
            *字典类型编码不能为空
            * 字典值value不能为空
            * 当光标离开后进行检测
            * */
            $("#add-typeCode").blur(function () {
                checkTypeCode();
            });
            $("#add-value").blur(function () {
                checkValue();
            });

            //检测字典类型编码和value

            function checkTypeCode() {
                //获取类型编码的值
                var typeCode = $("#typeCode").val();
                if (typeCode === "") {
                    $("#typeCodeF").html("类型编码不能为空");
                    return false;
                } else {
                    $("#typeCodeF").html("");
                    return true;
                }
            }

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
                var value = $.trim($("#add-value").val());
                var typeCode = $("#add-typeCode").val();
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
                //当数据字典类型不为空时，发起请求
                if (checkTypeCode()) {
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
                }
                return checkValueFlag;
            }

            //对保存按钮添加点击事件
            $("#saveInfo").click(function () {
                //获取填入的值
                var value = $.trim($("#add-value").val());
                var typeCode = $("#add-typeCode").val();
                var text = $.trim($("#add-text").val());
                var orderNo = $.trim($("#add-orderNo").val());

                //当typeCode和value检查正确后发起请求
                if (checkValue()) {
                    $.ajax({
                        url: "settings/dictionary/value/saveCreateDictionaryValue.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            value: value,
                            typeCode: typeCode,
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
                    alert("请检查数据类型和数据值");
                }

            });

        });
    </script>
</head>
<body>

<div style="position:  relative; left: 30px;">
    <h3>新增字典值</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="saveInfo" type="button" class="btn btn-primary">保存</button>
        <button id="backButton" type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form">

    <div class="form-group">
        <label for="add-typeCode" class="col-sm-2 control-label">字典类型编码<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="add-typeCode" style="width: 200%;">
                <c:if test="${not empty dictionaryTypeList}">
                    <option></option>
                    <c:forEach items="${dictionaryTypeList}" var="dt">
                        <option value="${dt.code}">${dt.code}</option>
                    </c:forEach>
                </c:if>
            </select>
            <span id="typeCodeF" style="color: red"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="add-value" class="col-sm-2 control-label">字典值<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="add-value" style="width: 200%;">
            <span id="valueF" style="color: red"></span>
            <span id="valueT" style="color: green"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="add-text" class="col-sm-2 control-label">文本</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="add-text" style="width: 200%;">
        </div>
    </div>

    <div class="form-group">
        <label for="add-orderNo" class="col-sm-2 control-label">排序号</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="add-orderNo" style="width: 200%;">
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>