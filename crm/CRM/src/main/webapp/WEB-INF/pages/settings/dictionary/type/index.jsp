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
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {

            //对创建按钮添加点击事件
            $("#addButton").click(function () {
                //点击后同步请求到创建页面
                window.location.href = 'settings/dictionary/type/toSave.do';
            });

            /*
            * 给全选按钮添加单击事件
            * 行头选择，则全部选中，如果全部行选择，则行头自动勾选
            * 行头不勾选，所有行都不勾选，如果全部行不是全部勾选，行头为不勾选
            * */


            //点击全选按钮后，所有行的勾选均选中，再点击全选按钮，取消勾选后，所有行都取消勾选


            $("#checkAll").click(function () {
                /*
                *
                * 获取行头全选按钮值
                * 有多行，需要获取多行的checked的属性
                * $(this).prop("checked")代表全选按钮(#checkAll)状态等同于$("#checkAll").prop("checked")，
                * 全选打开是返回true，关闭是返回false，来控制下面所有行全部选中还是不选中
                *
                * */
                //所有行有选择按钮的对象集，是一个数组
                var innerCheckBoxs = $("#tBody input[type='checkbox']");
                innerCheckBoxs.prop("checked", $(this).prop("checked"));
            });


            //给列表中所有的checkbox添加单击事件
            $("#tBody input[type='checkbox']").click(function () {
                //获取列表中所有checkbox
                /*
                *当所有行的数量等于所有行选中勾选框的数量时，全选按钮为勾选状态
                * 如果所有行的数量不等于所有行勾选的数量时，则全选按钮为不勾选状态
                *
                * */
                //所有行带有选择按钮，且被选中的对象集，是一个数组
                var innerOnCheckBoxes = $("#tBody input[type='checkbox']:checked");
                if ($("#tBody input[type='checkbox']").size() === innerOnCheckBoxes.size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });


            /*
            *
            * 对编辑按钮添加点击事件
            * 未勾选一行内容，不跳转，提示信息
            * 勾选多行内容，不跳转，提示信息
            * 勾选一行内容，带着行内的code参数跳转到编辑页面
            * 发送请求为同步请求
            *
            * */
            $("#modifyButton").click(function () {
                //所有行带有选择按钮，且被选中的对象集，是一个数组
                var innerOnCheckBoxes = $("#tBody input[type='checkbox']:checked");
                /*
                * 编辑只能对选中一行记录进行编辑
                * 一条未选和多选都不能进行编辑
                * 当出现多选和一个不选时候点击编辑按钮后给出提示信息
                *
                * */

                if (innerOnCheckBoxes.size() > 1) {
                    alert("只能编写一条内容，请重新选择");
                    return;
                }

                if (innerOnCheckBoxes.size() === 0) {
                    alert("请选择一条内容进行编辑");
                    return;
                }
                //收集参数
                var code = innerOnCheckBoxes.get(0).value;
                //跳转控制层处理
                window.location.href = 'settings/dictionary/type/toEdit.do?code=' + code;
            });


            /*
            * 删除按钮添加点击事件
            * 未有选中的行，不进行删除，提示信息
            * 选中一行删除一行信息
            * 选中多行删除多行信息
            * 根据code判断
            *
            * */
            $("#deleteButton").click(function () {
                var innerOnCheckBoxes = $("#tBody input[type='checkbox']:checked");
                if (innerOnCheckBoxes.size() === 0) {
                    alert("选择需要删除的内容");
                    return;
                }

                var codeList = "";
                $.each(innerOnCheckBoxes, function () {
                    codeList += "code=" + this.value + "&";
                });
                codeList = codeList.substr(0, codeList.length - 1);
                if (window.confirm("确定要删除吗？")) {
                    $.ajax({
                        url: "settings/dictionary/type/delete.do",
                        type: "post",
                        dataType: "json",
                        data: codeList,
                        success: function (data) {
                            alert(data.message);
                            if (data.code > 0) {
                                window.location.href = "settings/dictionary/type/toIndex.do";
                            }
                        }
                    })
                }

            });

        });

    </script>


</head>
<body>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>字典类型列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button id="addButton" type="button" class="btn btn-primary"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button id="modifyButton" type="button" class="btn btn-default"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button id="deleteButton" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span>
            删除
        </button>
    </div>
</div>
<div style="position: relative; left: 30px; top: 20px;">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input id="checkAll" type="checkbox"/></td>
            <td>序号</td>
            <td>编码</td>
            <td>名称</td>
            <td>描述</td>
        </tr>
        </thead>
        <tbody id="tBody">
        <c:if test="${not empty dictionaryTypeList}">
            <c:forEach items="${dictionaryTypeList}" var="dt" varStatus="vs">
                <c:if test="${vs.count%2==0}">
                    <tr>
                </c:if>
                <c:if test="${vs.count%2!=0}">
                    <tr class="active" >
                </c:if>
                <td><input type="checkbox" value="${dt.code}"/></td>
                <td>${vs.count}</td>
                <td>${dt.code}</td>
                <td>${dt.name}</td>
                <td>${dt.description}</td>
                </tr>
            </c:forEach>
        </c:if>
        </tbody>

    </table>

</div>

</body>
</html>