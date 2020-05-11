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

            //取消按钮点击事件
            $("#backButton").click(function () {
                window.history.back();
            });

            //更新按钮点击事件
            $("#updateButton").click(function () {
                //收集参数
                var code = $.trim($("#edit-code").val());
                var name = $.trim($("#edit-name").val());
                var description = $.trim($("#edit-description").val());

                $.ajax({
                    url: "settings/dictionary/type/updateDictionaryType.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        code: code,
                        name: name,
                        description: description
                    },
                    success: function (data) {
                        if (data.code === "0") {
                            alert(data.message);
                        } else {
                            alert(data.message);
                            window.location.href = "settings/dictionary/type/toIndex.do";
                        }
                    }
                });
            });

        });

    </script>
</head>
<body>

<div style="position:  relative; left: 30px;">
    <h3>修改字典类型</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="updateButton" type="button" class="btn btn-primary">更新</button>
        <button id="backButton" type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form">

    <div class="form-group">
        <label <%--for="create-code"--%> class="col-sm-2 control-label">编码<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-code" style="width: 200%;" value="${dictionaryType.code}" disabled="true">
        </div>
    </div>

    <div class="form-group">
        <label <%--for="create-name"--%> class="col-sm-2 control-label">名称</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-name" style="width: 200%;" value="${dictionaryType.name}">
        </div>
    </div>

    <div class="form-group">
        <label <%--for="create-describe"--%> class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 300px;">
            <textarea class="form-control" rows="3" id="edit-description"
                      style="width: 200%;">${dictionaryType.description}</textarea>
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>