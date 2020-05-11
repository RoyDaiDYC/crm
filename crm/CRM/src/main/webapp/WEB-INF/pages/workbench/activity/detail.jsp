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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/amountFormatting/formatCurrencyTenThou.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {

            var cost = formatCurrencyTenThou("${marketingActivities.cost}");
            $("#cost").html(cost);

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

            $("#activityRemarkDiv").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#activityRemarkDiv").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#activityRemarkDiv").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#activityRemarkDiv").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });


            //给保存按钮添加点击事件
            $("#saveRemarkButton").click(function () {

                //获取参数
                var activityId = "${marketingActivities.id}";
                var noteContent = $.trim($("#remark").val());

                //备注内容不能为空
                if (noteContent === "") {
                    alert("备注内容不能为空");
                    return;
                }

                //发送异步请求
                $.ajax({
                    url: "workbench/activity/saveCreateMarketActivityRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        noteContent: noteContent,
                        activityId: activityId
                    },
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //清空备注框信息
                            $("#remark").val("");
                            //添加后在备注栏内显示信息
                            //创建拼接内容
                            var htmlStr = "";
                            htmlStr += "<div id=\"div_" + data.data.id + "\" class=\"remarkDiv\" style=\"height: 60px;\">";
                            htmlStr += "<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr += "<div style=\"position: relative; top: -40px; left: 40px;\">";
                            htmlStr += "<h5>" + noteContent + "</h5>";
                            htmlStr += "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${marketingActivities.name}</b> <small style=\"color: gray;\">";
                            htmlStr += data.data.createTime;
                            htmlStr += "由${sessionScope.sessionUser.name}创建</small>";
                            htmlStr += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr += "<a class=\"myHref\" remark-id=\"" + data.data.id + "\" name=\"myEditBtn\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr += "<a class=\"myHref\" remark-id=\"" + data.data.id + "\" name=\"myDeleteBtn\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            //添加到remarkDiv标签前面（页面上面）
                            $("#remarkDiv").before(htmlStr);
                        }
                    }
                });

            });


            //对修改按钮添加点击事件，因为存在新添加内容，动态的按钮，用on方法
            $("#activityRemarkDiv").on("click", "a[name='myEditBtn']", function () {
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
                    url: "workbench/activity/modifyMarketingActivitiesRemark.do",
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
            $("#activityRemarkDiv").on("click", "a[name='myDeleteBtn']", function () {
                //获取当前选中的备注id
                var remarkId = $(this).attr("remark-id");
                //发送异步请求
                $.ajax({
                    url: "workbench/activity/deleteActivityRemark.do",
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

            //给返回按钮添加点击事件
            $("#backBtn").click(function () {
                window.location.href = document.referrer;
            });


        });

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
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
<div style="position: relative; top: 35px; left: 10px;">
    <a id="backBtn" href="javascript:void(0);"><span class="glyphicon glyphicon-arrow-left"
                                                     style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${marketingActivities.name}
            <small>${marketingActivities.startDate} ~ ${marketingActivities.endDate}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${marketingActivities.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${marketingActivities.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;">
            <b>${marketingActivities.startDate}&nbsp;</b>
        </div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;">
            <b>${marketingActivities.endDate}&nbsp;</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="cost">&nbsp;</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${marketingActivities.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${marketingActivities.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${marketingActivities.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${marketingActivities.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${marketingActivities.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="activityRemarkDiv" style="position: relative; top: 30px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${marketingActivitiesRemarkList}" var="mar">
        <div id="div_${mar.id}" class="remarkDiv" style="height: 60px;">
            <img title="${mar.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${mar.noteContent}</h5>
                <font color="gray">市场活动</font> <font color="gray">-</font> <b>${marketingActivities.name}</b> <small
                    style="color: gray;">
                    ${mar.editFlag==0?mar.createTime:mar.editTime}
                由${mar.editFlag==0?mar.createBy:mar.editBy}${mar.editFlag==0?"创建":"修改"}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" remark-id="${mar.id}" name="myEditBtn" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" remark-id="${mar.id}" name="myDeleteBtn" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- 备注1 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>哎呦！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;">
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
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;">
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
                <button id="saveRemarkButton" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>