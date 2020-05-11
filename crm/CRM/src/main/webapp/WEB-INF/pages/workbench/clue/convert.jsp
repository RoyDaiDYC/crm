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

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {

            //对时间类型创建时间容器
            //位置问题，可以参考https://www.cnblogs.com/alkq1989/p/5484836.html
            //改offset.top + this.height + 50;原有基础+50
            $(".myDate").datetimepicker({
                language: "zh_CN",//使用中文【*zh-CN语言插件出现乱码，直接在源js页面修改】
                format: "yyyy-mm-dd",//时间格式
                minView: "month",//最小可选时间
                initialDate: new Date(),//默认显示时间
                autoclose: true,//选中日期之后是否自动关闭日历
                todayBtn: true//是否显示当天按钮
            });


            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    //打开保持一开始的线索里的"公司-"内容
                    $("#tradeName").val("${clue.company}-");
                    $("#create-transaction2").show(200);
                } else {
                    //清空保留的内容
                    $("#amountOfMoney").val("");
                    $("#tradeName").val("");
                    $("#expectedClosingDate").val("");
                    $("#stage").val("");
                    $("#activity").val("");
                    $("#amountOfMoneyMsg").html("");
                    $("#create-transaction2").hide(200);
                }
            });


            //设置一个变量存储表单检查是否正确
            var checkFormFlag = true;

            //用正则表达式检查金额的书写，当光标移开时候检查
            function checkMoney() {
                var transactionMoney = $.trim($("#amountOfMoney").val());
                //金额不是必填，填写必须格式正确
                if (transactionMoney === "" || /^\d+$/.test(transactionMoney)) {
                    $("#amountOfMoneyMsg").html("");
                    checkFormFlag = true;
                } else {
                    $("#amountOfMoneyMsg").html("金额填写只能是非负整数");
                    checkFormFlag = false;
                }
                return checkFormFlag;
            }

            //检查交易名称，名称不能为空
            function checkTranName() {
                var transactionName = $.trim($("#tradeName").val());
                if (transactionName === "") {
                    $("#tranNameMsg").html("交易名称不能为空");
                    checkFormFlag = false;
                } else {
                    $("#tranNameMsg").html("");
                    checkFormFlag = true;
                }
                return checkFormFlag;
            }

            //检查阶段，阶段不能为空
            function checkStage() {
                var isCreateTransaction = $("#isCreateTransaction").prop("checked");
                var transactionStage = $("#stage").val();
                if (isCreateTransaction === true && transactionStage === "") {
                    $("#stageMsg").html("阶段不能为空");
                    checkFormFlag = false;
                } else {
                    $("#stageMsg").html("");
                    checkFormFlag = true;
                }
                return checkFormFlag;
            }

            //给金额添加光标移开事件，检查金额
            $("#amountOfMoney").blur(function () {
                checkMoney();
            });
            //给交易名称加光标移开事件，检查名称
            $("#tradeName").blur(function () {
                checkTranName();
            });
            //给阶段添加鼠标单击事件
            $("#stage").mousedown(function () {
                checkStage();
            });

            function checkForm() {
                checkFormFlag = checkMoney() && checkStage() && checkTranName();
                return checkFormFlag;
            }

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
                    url: "workbench/activity/searchActivitiesInConvert.do",
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
                $("#activityId").val(activityId);
                $("#activity").val(activityName);
                //关闭搜索模态窗口
                $("#searchActivityModal").modal("hide");

            });

            /*
            * 给转换按钮添加点击事件
            * 传递参数，当前线索id，是否点击了为客户创建交易
            * 如果点击了交易，传递参数增加模态窗口内的元素和市场活动的id
            *
            *
            * */
            $("#convertBtn").click(function () {

                var clueId = "${clue.id}";
                var isCreateTransaction = $("#isCreateTransaction").prop("checked");
                var transactionMoney = $.trim($("#amountOfMoney").val());
                var transactionName = $.trim($("#tradeName").val());
                var transactionExpectedDate = $.trim($("#expectedClosingDate").val());
                var transactionStage = $("#stage").val();
                var activityId = $("#activityId").val();

                //如果点击了为用户创建交易，金额书写不对，则不发起请求，如果金额正确，则发起请求
                //如果未点击为用户创建交易，则发起请求
                if (checkForm()) {
                    if (window.confirm("确认转换吗?这是不可逆操作")) {
                        $.ajax({
                            url: "workbench/clue/saveConvert.do",
                            type: "post",
                            dataType: "json",
                            data: {
                                clueId: clueId,
                                isCreateTransaction: isCreateTransaction,
                                transactionMoney: transactionMoney,
                                transactionName: transactionName,
                                transactionExpectedDate: transactionExpectedDate,
                                transactionStage: transactionStage,
                                activityId: activityId
                            },
                            success: function (data) {
                                alert(data.message);
                                if (data.code === "1") {
                                    //跳转到线索首页
                                    window.location.href = "workbench/clue/toIndex.do";
                                }
                            }
                        });
                    }
                } else {
                    alert("请检查表单内容");
                }
            });

            //给取消按钮添加点击事件
            $("#cancelBtn").click(function () {
                //返回上一页
                window.history.back();
            });

        });
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

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${clue.fullName}${clue.appellation}-${clue.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${clue.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${clue.fullName}${clue.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

    <form>
        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney">
            <span id="amountOfMoneyMsg" style="color: red"></span>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="${clue.company}-" <%--value="动力节点-"--%>>
            <span id="tranNameMsg" style="color: red"></span>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control myDate" id="expectedClosingDate" readonly>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control">
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
            <span id="stageMsg" style="color: red"></span>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activity">市场活动源&nbsp;&nbsp;<a id="searchActivityBtn" href="javascript:void(0);"
                                                      data-toggle="modal"
            <%--data-target="#searchActivityModal"--%> style="text-decoration: none;"><span
                    class="glyphicon glyphicon-search"></span></a></label>
            <input id="activityId" type="hidden">
            <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${sessionScope.sessionUser.name}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input id="convertBtn" class="btn btn-primary" type="button" value="转换">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input id="cancelBtn" class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>