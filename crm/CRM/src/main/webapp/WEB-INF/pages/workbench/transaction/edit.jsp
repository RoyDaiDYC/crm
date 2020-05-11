<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        $(function () {

            //对时间类型创建时间容器
            //位置问题，可以参考https://www.cnblogs.com/alkq1989/p/5484836.html
            //改offset.top + this.height + 50;原有基础+50
            $(".myDate1").datetimepicker({
                language: "zh_CN",//使用中文【*zh-CN语言插件出现乱码，直接在源js页面修改】
                format: "yyyy-mm-dd",//时间格式
                minView: "month",//最小可选时间
                initialDate: new Date(),//默认显示时间
                autoclose: true,//选中日期之后是否自动关闭日历
                todayBtn: true//是否显示当天按钮
            });

            $(".myDate2").datetimepicker({
                language: "zh_CN",//使用中文【*zh-CN语言插件出现乱码，直接在源js页面修改】
                format: "yyyy-mm-dd",//时间格式
                minView: "month",//最小可选时间
                initialDate: new Date(),//默认显示时间
                autoclose: true,//选中日期之后是否自动关闭日历
                todayBtn: true,//是否显示当天按钮
                pickerPosition: 'top-right'//日期插件显示位置
            });

            //给取消按钮添加点击事件
            $("#cancelButton").click(function () {
                window.location.href = document.referrer;
            });


            //给对应的内容赋值，从选中的交易返回对应内容
            $("#edit-transactionOwner").val("${transaction.owner}");
            $("#edit-amountOfMoney").val("${transaction.money}");
            $("#edit-transactionName").val("${transaction.name}");
            $("#edit-expectedClosingDate").val("${transaction.expectedDate}");
            $("#edit-customerId").val("${transaction.customerId}");
            $("#edit-transactionStage").val("${transaction.stage}");
            $("#edit-transactionType").val("${transaction.type}");
            $("#edit-possibility").val("${transaction.possibility}");
            $("#edit-clueSource").val("${transaction.source}");
            $("#edit-activityId").val("${transaction.activityId}");
            $("#edit-activityName").val("${transaction.activityName}");
            $("#edit-contactsId").val("${transaction.contactsId}");
            $("#edit-contactsName").val("${transaction.contactsName}");
            $("#edit-describe").val("${transaction.description}");
            $("#edit-contactSummary").val("${transaction.contactSummary}");
            $("#edit-nextContactTime").val("${transaction.nextContactTime}");
            //需要验证客户名称是否已存在数据库中，如果不存在则新建客户
            $("#edit-customerName").val("${transaction.customerName}");


            //对阶段进行添加点击事件，读取可能性，赋值到指定位置
            $("#edit-transactionStage").on("change", function () {
                var stageId = $(this).find(":selected").val();
                //判断下内容，如果为空则不发请求
                if (stageId == "") {
                    $("#edit-possibility").val("");
                    return;
                }
                //发送异步请求
                $.ajax({
                    url: "workbench/transaction/getPossibility.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        stageId: stageId
                    },
                    success: function (data) {
                        //把获取到的可能性放到指定位置
                        $("#edit-possibility").val(data.possibility);
                    }
                });
            });


            //设置一个标记
            var checkEditFormFlag = false;

            //进行创建页面表单内容检查
            function checkEditOwner() {
                var editOwner = $("#edit-transactionOwner").val();
                if (editOwner === "") {
                    $("#editOwnerMsg").html("拥有着不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editOwnerMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditMoney() {
                var editMoney = $.trim($("#edit-amountOfMoney").val());
                if (editMoney === "" || /^\d+$/.test(editMoney)) {
                    $("#editMoneyMsg").html("");
                    checkEditFormFlag = true;
                } else {
                    $("#editMoneyMsg").html("金额填写只能是非负整数");
                    checkEditFormFlag = false;
                }
                return checkEditFormFlag;
            }

            function checkEditName() {
                var editName = $.trim($("#edit-transactionName").val());
                if (editName === "") {
                    $("#editNameMsg").html("名称不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editNameMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditExpectedClosingDate() {
                var expectedDate = $("#edit-expectedClosingDate").val();
                if (expectedDate === "") {
                    $("#editExpectedDateMsg").html("预计成交日期不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editExpectedDateMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditCustomerName() {
                var editCustomerName = $.trim($("#edit-customerName").val());
                if (editCustomerName === "") {
                    $("#editCustomerNameMsg").html("客户名称不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editCustomerNameMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditStage() {
                var editStage = $("#edit-transactionStage").val();
                if (editStage === "") {
                    $("#editStageMsg").html("阶段不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editStageMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            $("#edit-transactionOwner").mousedown(function () {
                checkEditOwner();
            });
            $("#edit-amountOfMoney").blur(function () {
                checkEditMoney();
            });
            $("#edit-transactionName").blur(function () {
                checkEditName();
            });
            $("#edit-expectedClosingDate").mouseleave(function () {
                checkEditExpectedClosingDate();
            });
            $("#edit-customerName").blur(function () {
                checkEditCustomerName();
            });
            $("#edit-transactionStage").mousedown(function () {
                checkEditStage();
            });

            function checkEditForm() {
                checkEditFormFlag = checkEditOwner() && checkEditMoney() &&
                    checkEditName() && checkEditExpectedClosingDate() &&
                    checkEditCustomerName() && checkEditStage();
                return checkEditFormFlag;
            }


            /*
            * 调用自动补全函数
            * 1发起异步请求，通过输入模糊数据，从后台查询出对应的客户信息
            * 对选中的客户名称显示在文本框里
            * 用一个隐藏标签存储文本名称对应的客户id内容
            * 2如果是新的名称，则需要返回名称，进行后台判断，创建客户，再赋值id到数据库中
            *
            * */

            //设置一个空对象，用来在请求后收到的客户集合，把name值对应id值
            //用来存储name:id键值对
            var name2id = {};
            $("#edit-customerName").typeahead({
                //向后台发起请求
                //获取模糊查询名称查询得到的客户内容
                source: function (query, process) {
                    $.ajax({
                        url: "workbench/customer/getCustomerByCustomerName.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            customerName: query
                        },
                        //获取的内容是根据模糊查询获取的客户集合
                        success: function (data) {
                            //把客户集合中的名称变成数组传递给process函数
                            //定义一个空数组接收集合的名称
                            var customerNameArray = [];
                            //遍历返回集合
                            $.each(data, function (index, obj) {
                                //把遍历的每一个客户信息中的name传给数组,传递使用push函数
                                customerNameArray.push(obj.name);
                                //存储遍历到的客户，把id赋值给名称
                                //因为当前名称是未知状态，所以采取obj[name]=id的方式进行赋值
                                name2id[obj.name] = obj.id;
                            });
                            //把数组给process
                            process(customerNameArray);
                        },

                    });
                },

                //当选中内容，文本框有值后，提取出名称对应的客户id给隐藏标签
                //item就是当前选中的名称
                afterSelect: function (item) {
                    //获取item对应的id
                    var customerId = name2id[item];
                    //赋值到隐藏标签
                    $("#edit-customerId").val(customerId);
                },


            });

            //当客户名输入发生改变时，清空客户id值
            $("#edit-customerName").on("change", function () {
                $("#edit-customerId").val("");
            });


            //给市场活动源查询图标添加点击事件
            $("#searchActivityBtn").click(function () {
                //清空搜索栏内的内容
                $("#searchActivityText").val("");
                //清空搜索出来的内容
                $("#tBodyBySearchActivities").html("");
                //搜索模态窗口显示
                $("#searchActivityModal").modal("show");
            });

            /*
           * 在搜索栏内进行输入内容，给定键盘弹起事件
           * */
            $("#searchActivityText").keyup(function () {
                //获取输入的内容
                var activityName = this.value;
                //发起请求
                $.ajax({
                    url: "workbench/activity/searchActivitiesByName.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        activityName: activityName
                    },
                    success: function (data) {
                        var htmlStr = "";
                        if (data == "") {
                            htmlStr += "<tr style=\"color: grey\">";
                            htmlStr += "<td colspan='5' align='center'><h4>没有查询到数据</h4></td>";
                            htmlStr += "</tr>";
                        } else {
                            $.each(data, function (index, obj) {
                                if (obj.startDate === "" || obj.startDate == null) {
                                    obj.startDate = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                                }
                                if (obj.endDate === "" || obj.endDate == null) {
                                    obj.endDate = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                                }
                                htmlStr += "<tr>";
                                htmlStr += "<td><input value='" + obj.id + "' class='activity' activity-name='" + obj.name + "' name='activity' type='radio'/></td>";
                                htmlStr += "<td>" + obj.name + "</td>";
                                htmlStr += "<td>" + obj.startDate + "</td>";
                                htmlStr += "<td>" + obj.endDate + "</td>";
                                htmlStr += "<td>" + obj.owner + "</td>";
                                htmlStr += "</tr>";
                            });
                        }
                        //放到指定位置
                        $("#tBodyBySearchActivities").html(htmlStr);
                    }
                });
            });

            //当对单选按钮点击后，把对应的市场活动名称放到指定位置
            //因为单选按钮是动态插入的，面板点击事件通过on添加
            $("#activityTable").on("click", ".activity", function () {
                //给选中的单选框的值赋值给市场活动源下面的文本框
                var activityId = this.value;
                var activityName = $(this).attr("activity-name");
                $("#edit-activityId").val(activityId);
                $("#edit-activityName").val(activityName);
                //关闭搜索模态窗口
                $("#searchActivityModal").modal("hide");

            });


            //给联系人查询图标添加点击事件
            $("#searchContactsBtn").click(function () {
                //清空搜索栏内的内容
                $("#searchContactsText").val("");
                //清空搜索出来的内容
                $("#tBodyBySearchContacts").html("");
                //搜索模态窗口显示
                $("#searchContactsModal").modal("show");
            });

            /*
           * 在搜索栏内进行输入内容，给定键盘弹起事件
           * */
            $("#searchContactsText").keyup(function () {
                //获取输入的内容
                var contactsName = this.value;
                //发起请求
                $.ajax({
                    url: "workbench/contacts/searchContactsByFullName.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        contactsFullName: contactsName
                    },
                    success: function (data) {
                        var htmlStr = "";
                        if (data == "") {
                            htmlStr += "<tr style=\"color: grey\">";
                            htmlStr += "<td colspan='4' align='center'><h4>没有查询到数据</h4></td>";
                            htmlStr += "</tr>";
                        } else {
                            $.each(data, function (index, obj) {
                                if (obj.email === "" || obj.email == null) {
                                    obj.email = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                                }
                                if (obj.mphone === "" || obj.mphone == null) {
                                    obj.mphone = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                                }
                                if (obj.appellation === "" || obj.appellation == null) {
                                    obj.appellation = "";
                                }
                                htmlStr += "<tr>";
                                htmlStr += "<td><input value='" + obj.id + "' class='contacts' contacts-name='" + obj.fullName + obj.appellation + "' name='contacts' type='radio'/></td>";
                                htmlStr += "<td>" + obj.fullName + obj.appellation + "</td>";
                                htmlStr += "<td>" + obj.email + "</td>";
                                htmlStr += "<td>" + obj.mphone + "</td>";
                                htmlStr += "</tr>";
                            });
                        }
                        //放到指定位置
                        $("#tBodyBySearchContacts").html(htmlStr);
                    }
                });
            });

            //当对单选按钮点击后，把对应的市场活动名称放到指定位置
            //因为单选按钮是动态插入的，面板点击事件通过on添加
            $("#contactsTable").on("click", ".contacts", function () {
                //给选中的单选框的值赋值给市场活动源下面的文本框
                var contactsId = this.value;
                var contactsName = $(this).attr("contacts-name");
                $("#edit-contactsId").val(contactsId);
                $("#edit-contactsName").val(contactsName);
                //关闭搜索模态窗口
                $("#searchContactsModal").modal("hide");
            });


            //给修改按钮添加点击事件
            $("#editTransactionButton").click(function () {
                //收集参数
                var id = "${transaction.id}";
                var owner = $("#edit-transactionOwner").val();
                var money = $.trim($("#edit-amountOfMoney").val());
                var name = $.trim($("#edit-transactionName").val());
                var expectedDate = $("#edit-expectedClosingDate").val();
                var customerId = $("#edit-customerId").val();
                var stage = $("#edit-transactionStage").val();
                var type = $("#edit-transactionType").val();
                var source = $("#edit-clueSource").val();
                var activityId = $("#edit-activityId").val();
                var contactsId = $("#edit-contactsId").val();
                var description = $.trim($("#edit-describe").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $("#edit-nextContactTime").val();
                //需要验证客户名称是否已存在数据库中，如果不存在则新建客户
                var customerName = $.trim($("#edit-customerName").val());

                //当表单验证通过后进行异步请求发布
                if (checkEditForm()) {
                    $.ajax({
                        url: "workbench/transaction/modifyTransaction.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            id: id,
                            owner: owner,
                            money: money,
                            name: name,
                            expectedDate: expectedDate,
                            customerId: customerId,
                            stage: stage,
                            type: type,
                            source: source,
                            activityId: activityId,
                            contactsId: contactsId,
                            description: description,
                            contactSummary: contactSummary,
                            nextContactTime: nextContactTime,
                            customerName: customerName
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //跳转到交易页面首页
                                window.location.href = "workbench/transaction/toIndex.do";
                            }
                        }
                    });
                } else {
                    alert("请检查表单内容");
                }

            });


        })
    </script>
</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="searchActivityText" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">

                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="tBodyBySearchActivities">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2017-10-10</td>
                        <td>2017-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2017-10-10</td>
                        <td>2017-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="searchContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="searchContactsText" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="contactsTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="tBodyBySearchContacts">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>修改交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="editTransactionButton" type="button" class="btn btn-primary">修改</button>
        <button id="cancelButton" type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-transactionOwner">
                <option></option>
                <c:if test="${not empty userList}">
                    <c:forEach items="${userList}" var="user">
                        <option value="${user.id}">${user.name}</option>
                    </c:forEach>
                </c:if>
                <%--<option>zhangsan</option>
                <option>lisi</option>
                <option>wangwu</option>--%>
            </select>
            <span id="editOwnerMsg" style="color: red"></span>
        </div>
        <label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-amountOfMoney">
            <span id="editMoneyMsg" style="color: red"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-transactionName" class="col-sm-2 control-label">名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-transactionName">
            <span id="editNameMsg" style="color: red"></span>
        </div>
        <label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate1" id="edit-expectedClosingDate" readonly>
            <span id="editExpectedDateMsg" style="color: red"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-customerName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
            <input id="edit-customerId" type="hidden">
            <span id="editCustomerNameMsg" style="color: red"></span>
        </div>
        <label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">

            <c:if test="${transactionStageDetail=='07成交'}">
                <%--这里使用disabled可以是因为当前不是submit提交表单，是通过异步发送--%>
                <select class="form-control" id="edit-transactionStage" disabled>
                    <c:if test="${not empty stageList}">
                        <c:forEach items="${stageList}" var="stage">
                            <option value="${stage.id}">${stage.value}</option>
                        </c:forEach>
                    </c:if>
                </select>
            </c:if>
            <c:if test="${transactionStageDetail!='07成交'}">
                <select class="form-control" id="edit-transactionStage">
                    <option></option>
                    <c:if test="${not empty stageList}">
                        <c:forEach items="${stageList}" var="stage">
                            <option value="${stage.id}">${stage.value}</option>
                        </c:forEach>
                    </c:if>

                        <%--<option>资质审查</option>
                        <option>需求分析</option>
                        <option>价值建议</option>
                        <option>确定决策者</option>
                        <option>提案/报价</option>
                        <option>谈判/复审</option>
                        <option>成交</option>
                        <option>丢失的线索</option>
                        <option>因竞争丢失关闭</option>--%>
                </select>
            </c:if>
            <span id="editStageMsg" style="color: red"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-transactionType">
                <option></option>
                <c:if test="${not empty transactionTypeList}">
                    <c:forEach items="${transactionTypeList}" var="transactionType">
                        <option value="${transactionType.id}">${transactionType.value}</option>
                    </c:forEach>
                </c:if>
                <%--<option>已有业务</option>
                <option>新业务</option>--%>
            </select>
        </div>
        <label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-possibility" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-clueSource">
                <option></option>
                <c:if test="${not empty sourceList}">
                    <c:forEach items="${sourceList}" var="source">
                        <option value="${source.id}">${source.value}</option>
                    </c:forEach>
                </c:if>
                <%--<option>广告</option>
                <option>推销电话</option>
                <option>员工介绍</option>
                <option>外部介绍</option>
                <option>在线商场</option>
                <option>合作伙伴</option>
                <option>公开媒介</option>
                <option>销售邮件</option>
                <option>合作伙伴研讨会</option>
                <option>内部研讨会</option>
                <option>交易会</option>
                <option>web下载</option>
                <option>web调研</option>
                <option>聊天</option>--%>
            </select>
        </div>
        <label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a id="searchActivityBtn"
                                                                                          href="javascript:void(0);"
                                                                                          data-toggle="modal"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-activityName" readonly>
            <input id="edit-activityId" type="hidden">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;
            <a id="searchContactsBtn" href="javascript:void(0);" data-toggle="modal">
                <span class="glyphicon glyphicon-search"></span></a>
        </label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-contactsName" readonly>
            <input id="edit-contactsId" type="hidden">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate2" id="edit-nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>