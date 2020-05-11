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

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/amountFormatting/formatCurrencyTenThou.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            var cost = formatCurrencyTenThou("${transaction.money}");
            $(".tranMoney").append(cost);
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //清空框里内容
                $("#remark").val("");
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#transactionRemarkDiv").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#transactionRemarkDiv").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#transactionRemarkDiv").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#transactionRemarkDiv").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //给返回按钮添加点击事件
            $("#backBtn").click(function () {
                window.location.href = document.referrer;
            });

            /*
            *
            * 给交易备注信息保存按钮添加点击事件
            * 返回内容后在备注框上方显示内容
            * */
            $("#saveCreateTransactionRemarkBtn").click(function () {

                //获取tranId
                var tranId = "${transaction.id}";
                //获取备注信息
                var noteContent = $.trim($("#remark").val());
                //验证表单内容，不能为空
                if (noteContent === "") {
                    alert("备注不能为空");
                    return;
                }
                //发送异步请求
                $.ajax({
                    url: "workbench/transaction/saveCreateTransactionRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        tranId: tranId,
                        noteContent: noteContent
                    },
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //清空备注框信息
                            $("#remark").val("");
                            //拼接内容
                            var htmlStr = "";
                            htmlStr += "<div id=\"div_" + data.data.id + "\" class=\"remarkDiv\" style=\"height: 60px;\">";
                            htmlStr += "<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr += "<div style=\"position: relative; top: -40px; left: 40px;\">";
                            htmlStr += "<h5>" + noteContent + "</h5>";
                            htmlStr += "<font color=\"gray\">交易</font> <font color=\"gray\">-</font> <b>${transaction.name}</b> <small style=\"color: gray;\">";
                            htmlStr += data.data.createTime;
                            htmlStr += "由${sessionScope.sessionUser.name}创建</small>";
                            htmlStr += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr += "<a class=\"myHref\" remark-id=\"" + data.data.id + "\" name=\"myEditBtn\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr += "<a class=\"myHref\" remark-id=\"" + data.data.id + "\" name=\"myDeleteBtn\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            //添加到remarkDiv标签上方
                            $("#remarkDiv").before(htmlStr);
                        }
                    }
                });
            });

            //对修改按钮添加点击事件，因为存在新添加内容，动态的按钮，用on方法
            $("#transactionRemarkDiv").on("click", "a[name='myEditBtn']", function () {
                //获取选中那条内容，把那条内容显示到模态窗口内
                //获取当前选中标签的某个参数值
                //因要拿到兄弟标签的值，要用父标签div
                // remark-id值关联了div父标签，目前在选中的a标签内取remark-id值
                var remarkId = $(this).attr("remark-id");
                //市场活动的备注信息在h5标签内，通过父标签div加空格h5标签获取值
                var noteContent = $("#div_" + remarkId + " h5").html();
                //把值放入模态窗口的指定位置
                $("#edit-noteContent").val(noteContent);
                //把id值赋值给隐藏标签
                $("#edit-remarkId").val(remarkId);
                //显示修改模态窗口
                $("#editRemarkModal").modal("show");
            });

            //对修改模态窗口内更新按钮添加点击事件
            $("#updateRemarkBtn").click(function () {
                //获取当前选中修改的备注信息的id
                var id = $("#edit-remarkId").val();
                //获取更新模态窗口内备注信息值
                var noteContent = $.trim($("#edit-noteContent").val());

                //判断备注信息内容，不能为空
                if (noteContent === "") {
                    alert("备注内容不能为空");
                    return;
                }
                //发送异步请求
                $.ajax({
                    url: "workbench/transaction/modifyTransactionRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                            //更新市场活动备注列表
                            $("#div_" + id + " h5").html(noteContent);
                            //更新修改状态，时间和修改人
                            $("#div_" + id + " small").html(data.data.editTime + "由${sessionScope.sessionUser.name}修改");
                        } else {
                            $("#editRemarkModal").modal("show");
                        }

                    }
                });
            });

            //对删除按钮做点击事件
            $("#transactionRemarkDiv").on("click", "a[name='myDeleteBtn']", function () {
                //获取当前选中的备注id
                var remarkId = $(this).attr("remark-id");
                //发送异步请求
                $.ajax({
                    url: "workbench/transaction/deleteTransactionRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: remarkId
                    },
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //刷新列表
                            //通过删除整个备注信息的标签实现，所有内容的父标签是id='div_id'
                            $("#div_" + remarkId).remove();
                        }

                    }
                });
            });
            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });

            //给图标添加点击事件
            $("span.mystage").click(function () {
                //收集参数
                var id = "${transaction.id}";
                var stage = $(this).attr("stage-id");
                //判断当前交易是不是成交阶段
                var nowStage = "${transaction.stage}";
                if (nowStage === '07成交') {
                    alert("当前已经是成交阶段，不能再更改");
                    return;
                }
                //进行异步请求
                $.ajax({
                    url: "workbench/transaction/modifyTransactionForStage.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id,
                        stage: stage
                    },
                    success: function (data) {
                        if (data.code === "1") {
                            //刷新页面
                            window.location.reload();
                        } else {
                            alert(data.message);
                        }
                    }
                });

            });


        });


    </script>

</head>
<body>

<!-- 修改交易备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myEditRemarkModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label <%--for="edit-describe"--%> class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <%--设置一个隐藏标签，存备注信息的id--%>
                            <input id="edit-remarkId" type="hidden">
                            <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div id="backBtn" style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);"><span class="glyphicon glyphicon-arrow-left"
                                        style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${transaction.name}&nbsp;<small class="tranMoney">￥</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <c:forEach items="${stageList}" var="stage" varStatus="vs">
        <%--先判断后两个阶段，如果遍历阶段集合的值和当前交易阶段相同，则颜色为红色，如果不是就默认颜色--%>
        <c:if test="${vs.count==stageListLength||vs.count==(stageListLength-1)}">
            <c:if test="${stage.value==transaction.stage}">
                <span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}' style="color: red"></span>
                -----------
            </c:if>
            <c:if test="${stage.value!=transaction.stage}">
                <span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}'></span>
                -----------
            </c:if>
        </c:if>
        <%--如果是倒数第三阶段，成交阶段，则颜色为绿色，如果不是就默认颜色--%>
        <c:if test="${vs.count==stageListLength-2}">
            <c:if test="${stage.value==transaction.stage}">
                <span class="glyphicon glyphicon-thumbs-up mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}' style="color: #90F790;"></span>
                -----------
            </c:if>
            <c:if test="${stage.value!=transaction.stage}">
                <span class="glyphicon glyphicon-thumbs-up mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}'></span>
                -----------
            </c:if>
        </c:if>

        <%--非失败阶段内容--%>
        <c:if test="${vs.count<(stageListLength-2)}">
            <%--当前遍历的阶段是成交和之前,则判断前面内容--%>
            <c:if test="${transaction.orderNo<=stageList[stageListLength-3].orderNo}">
                <%--在成交或当前的阶段设定成绿色坐标--%>
                <c:if test="${stage.value==transaction.stage}">
                <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}' style="color: #90F790;"></span>
                    -----------
                </c:if>
                <%--在当前阶段之前的都是绿色打钩--%>
                <c:if test="${stage.orderNo<transaction.orderNo}">
                <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}' style="color: #90F790;"></span>
                    -----------
                </c:if>
                <%--在当前阶段之后的都是默认图标--%>
                <c:if test="${stage.orderNo>transaction.orderNo}">
                <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}'></span>
                    -----------
                </c:if>
            </c:if>
            <%--当前遍历的阶段是成交之后阶段，则判断前面内容--%>
            <c:if test="${transaction.orderNo>stageList[stageListLength-3].orderNo}">
                <%--失败前的阶段显示为绿色坐标--%>
                <c:if test="${stage.orderNo==lastTranIndex}">
                <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}' style="color:orange;"></span>
                    -----------
                </c:if>
                <%--在失败前的阶段之前的都显示为绿色打钩--%>
                <c:if test="${stage.orderNo<lastTranIndex}">
                <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
                      data-content="${stage.value}" stage-id='${stage.id}' style="color: #90F790;"></span>
                    -----------
                </c:if>
                <%--在失败前的阶段之后的都显示为默认图标--%>
                <c:if test="${stage.orderNo>lastTranIndex}">
                 <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
                       data-content="${stage.value}" stage-id='${stage.id}'></span>
                    -----------
                </c:if>
            </c:if>
        </c:if>
    </c:forEach>

    <span class="closingDate">${transaction.expectedDate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b class="tranMoney">&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.customerName}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.type}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.possibility}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.source}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.activityName}&nbsp;</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.contactsName}&nbsp;</b>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${transaction.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${transaction.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${transaction.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${transaction.editTime}&nbsp;</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${transaction.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${transaction.contactSummary}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${transaction.nextContactTime}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="transactionRemarkDiv" style="position: relative; top: 100px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>
    <c:if test="${not empty transactionRemarkList}">
        <c:forEach items="${transactionRemarkList}" var="tr">
            <div id="div_${tr.id}" class="remarkDiv" style="height: 60px;">
                <img title="${tr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
                <div style="position: relative; top: -40px; left: 40px;">
                    <h5>${tr.noteContent}</h5>
                    <font color="gray">交易</font> <font color="gray">-</font><b>${transaction.name}</b> <small
                        style="color: gray;">
                        ${tr.editFlag==0?tr.createTime:tr.editTime}
                    由${tr.editFlag==0?tr.createBy:tr.editBy}${tr.editFlag==0?"创建":"修改"}</small>
                    <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                        <a class="myHref" remark-id="${tr.id}" name="myEditBtn" href="javascript:void(0);"><span
                                class="glyphicon glyphicon-edit"
                                style="font-size: 20px; color: #E6E6E6;"></span></a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a class="myHref" remark-id="${tr.id}" name="myDeleteBtn" href="javascript:void(0);"><span
                                class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>
    <!-- 备注1 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>哎呦！</h5>
            <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;">
            2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <!-- 备注2 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>呵呵！</h5>
            <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;">
            2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveCreateTransactionRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody id="tBodyForTranHistory">
                <c:if test="${not empty transactionHistoryList}">
                    <c:forEach items="${transactionHistoryList}" var="tranHL">
                        <tr id="tranHTr_${tranHL.id}" class="tranHTr">
                            <td>${tranHL.stage}</td>
                            <td>${tranHL.money}</td>
                            <td>${tranHL.possibility}</td>
                            <td>${tranHL.expectedDate}</td>
                            <td>${tranHL.createTime}</td>
                            <td>${tranHL.createBy}</td>
                        </tr>
                    </c:forEach>
                </c:if>
                <%--<tr>
                    <td>资质审查</td>
                    <td>5,000</td>
                    <td>10</td>
                    <td>2017-02-07</td>
                    <td>2016-10-10 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>需求分析</td>
                    <td>5,000</td>
                    <td>20</td>
                    <td>2017-02-07</td>
                    <td>2016-10-20 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>谈判/复审</td>
                    <td>5,000</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>2017-02-09 10:10:10</td>
                    <td>zhangsan</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>