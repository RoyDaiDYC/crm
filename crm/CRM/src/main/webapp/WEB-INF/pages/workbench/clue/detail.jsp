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

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
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
                //清空内容
                $("#remark").val("");
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#clueRemarkDiv").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#clueRemarkDiv").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#clueRemarkDiv").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#clueRemarkDiv").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });


            /*
            * 给线索备注信息保存按钮添加点击事件
            *  返回内容后在备注框上方显示内容
            * */
            $("#saveCreateClueRemarkBtn").click(function () {

                //获取clueId
                var clueId = "${clue.id}";
                //获取备注信息
                var noteContent = $.trim($("#remark").val());
                //验证表单内容，不能为空
                if (noteContent === "") {
                    alert("备注不能为空");
                    return;
                }
                //发送异步请求
                $.ajax({
                    url: "workbench/clue/saveCreateClueRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        clueId: clueId,
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
                            htmlStr += "<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\">";
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
            $("#clueRemarkDiv").on("click", "a[name='myEditBtn']", function () {
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
                    url: "workbench/clue/modifyClueRemark.do",
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
            $("#clueRemarkDiv").on("click", "a[name='myDeleteBtn']", function () {
                //获取当前选中的备注id
                var remarkId = $(this).attr("remark-id");
                //发送异步请求
                $.ajax({
                    url: "workbench/clue/deleteClueRemark.do",
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

            //给关联市场活动按钮添加点击事件
            $("#bindModalBtn").click(function () {
                //清空之前在文本框内输入的内容
                $("#searchActivity").val("");
                //初始化全选按钮为未选中
                $("#checkAll").prop("checked", false);
                //清空显示的市场活动内容
                $("#tBodyBySearchActivities").html("");
                //显示关联模态窗口
                $("#bindModal").modal("show");

            });

            //给搜索框添加键盘弹起检测事件
            /*
            * 当输入内容键盘弹起后，进行搜索框内容传递到服务器进行数据返回
            * */
            $("#searchActivity").keyup(function () {
                //获取文本框输入的内容
                var activityName = this.value;
                //获取当前所在的线索id
                var clueId = "${clue.id}";

                //发送请求
                $.ajax({
                    url: "workbench/clue/searchActivities.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        activityName: activityName,
                        clueId: clueId
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
                                htmlStr += "<td><input value='" + obj.id + "' class='innerCheck' type=\"checkbox\"/></td>";
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


            /*
          * 给全选按钮添加单击事件
          * 行头选择，则全部选中，如果全部行选择，则行头自动勾选
          * 行头不勾选，所有行都不勾选，如果全部行不是全部勾选，行头为不勾选
          * */
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
                var innerCheckBoxes = $("#tBodyBySearchActivities input[type='checkbox']");
                innerCheckBoxes.prop("checked", $(this).prop("checked"));
            });

            //给列表中所有的checkbox添加单击事件
            //动态获取的列表进行点击事件添加需要用到on方法，可以设定id，标签，class来识别
            $("#tBodyBySearchActivities").on("click", ".innerCheck", function () {
                //获取列表中所有checkbox
                /*
                *当所有行的数量等于所有行选中勾选框的数量时，全选按钮为勾选状态
                * 如果所有行的数量不等于所有行勾选的数量时，则全选按钮为不勾选状态
                *
                * */
                //所有行带有选择按钮，且被选中的对象集，是一个数组
                var innerOnCheckBoxes = $("#tBodyBySearchActivities input[type='checkbox']:checked");
                if ($("#tBodyBySearchActivities input[type='checkbox']").size() === innerOnCheckBoxes.size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });


            /*
            * 给关联按钮添加点击事件
            *
            * */
            $("#bindClueActivityBtn").click(function () {
                var innerOnCheckBoxes = $("#tBodyBySearchActivities input[type='checkbox']:checked");
                if (innerOnCheckBoxes.size() === 0) {
                    alert("请选择要关联的内容");
                    return;
                }
                //获取当前线索id
                var clueId = "${clue.id}";
                //获取勾选的活动id数组
                //通过&连接
                var activityIdList = "";
                $.each(innerOnCheckBoxes, function () {
                    activityIdList += this.value + ",";
                });
                activityIdList = activityIdList.substr(0, activityIdList.length - 1);
                //当确认是否关联时，发送异步请求
                if (window.confirm("确认关联吗？")) {
                    $.ajax({
                        url: "workbench/clue/bindClueActivity.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            clueId: clueId,
                            activityIds: activityIdList
                        },
                        success: function (data) {
                            if (data.code === "1") {
                                //把关联过的活动显示到市场活动位置内
                                var activityRelationList = data.data;
                                var htmlStr = "";
                                $.each(activityRelationList, function (index, obj) {
                                    //给单元格添加id方便后面解除时候用
                                    htmlStr += "<tr id='relation_" + obj.id + "'>";
                                    htmlStr += "<td><a href=\"workbench/activity/toDetail.do?id=" + obj.id + "\" style=\"text-decoration: none;\">" + obj.name + "</a></td>";
                                    htmlStr += "<td>" + obj.startDate + "</td>";
                                    htmlStr += "<td>" + obj.endDate + "</td>";
                                    htmlStr += "<td>" + obj.owner + "</td>";
                                    htmlStr += "<td><a id='" + obj.id + "' name='removeRelationBtn' href=\"javascript:void(0);\" style=\"text-decoration: none;\">";
                                    htmlStr += "<span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
                                    htmlStr += "</tr>";
                                });
                                //添加到原有关联活动后面
                                $("#tBodyByBindClueActivity").append(htmlStr);
                                //关闭关联模态窗口
                                $("#bindModal").modal("hide");
                            } else {
                                //继续显示模态窗口
                                $("#bindModal").modal("show");
                            }
                        }
                    });
                }
            });

            /*
            * 给解除按钮添加点击事件
            * 一次解除一个活动
            * 传递当前页面的线索id和解除对应的活动id
            *
            * */
            $("#tBodyByBindClueActivity").on("click", "a[name='removeRelationBtn']", function () {
                //获取当前线索id
                var clueId = "${clue.id}";
                //获取当前点击按钮id值
                var activityId = $(this).attr("id");
                //确认取消关联发送异步请求
                if (window.confirm("确认解除关联吗？")) {
                    $.ajax({
                        url: "workbench/clue/removeRelation.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            clueId: clueId,
                            activityId: activityId
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //移除对应activityId的单元格内容
                                $("#relation_" + activityId).remove();
                            }
                        }
                    });
                }
            });


            //给转换按钮添加点击事件
            $("#convertBtn").click(function () {
                var clueId = "${clue.id}";
                window.location.href = "workbench/clue/toConvert.do?id=" + clueId;
            });

            //给返回按钮添加点击事件
            $("#backBtn").click(function () {
                window.location.href = document.referrer;
            });


        });

    </script>

</head>
<body>

<!-- 修改线索备注的模态窗口 -->
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

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bindModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="searchActivity" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input id="checkAll" type="checkbox"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="tBodyBySearchActivities">

                    <%--<tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2017-10-10</td>
                        <td>2017-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2017-10-10</td>
                        <td>2017-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="bindClueActivityBtn" type="button" class="btn btn-primary" <%--data-dismiss="modal"--%>>关联
                </button>
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
        <h3>${clue.fullName}${clue.appellation} <small>${clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button id="convertBtn" type="button" class="btn btn-default"><span
                class="glyphicon glyphicon-retweet"></span> 转换
        </button>

    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;">
            <b>${clue.fullName}${clue.appellation}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${clue.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.contactSummary}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}&nbsp;</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.address}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="clueRemarkDiv" style="position: relative; top: 40px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>
    <c:if test="${not empty clueRemarkList}">
        <c:forEach items="${clueRemarkList}" var="cr">
            <div id="div_${cr.id}" class="remarkDiv" style="height: 60px;">
                <img title="${cr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
                <div style="position: relative; top: -40px; left: 40px;">
                    <h5>${cr.noteContent}</h5>
                    <font color="gray">线索</font> <font color="gray">-</font>
                    <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small
                        style="color: gray;">
                        ${cr.editFlag==0?cr.createTime:cr.editTime}
                    由${cr.editFlag==0?cr.createBy:cr.editBy}${cr.editFlag==0?"创建":"修改"}</small>
                    <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                        <a class="myHref" remark-id="${cr.id}" name="myEditBtn" href="javascript:void(0);"><span
                                class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a class="myHref" remark-id="${cr.id}" name="myDeleteBtn" href="javascript:void(0);"><span
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
            <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;">
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
            <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;">
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
                <button id="saveCreateClueRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="tBodyByBindClueActivity">
                <c:if test="${not empty activityRelationList}">
                    <c:forEach items="${activityRelationList}" var="arl">
                        <tr id="relation_${arl.id}">
                            <td><a href="workbench/activity/toDetail.do?id=${arl.id}"
                                   style="text-decoration: none;">${arl.name}</a></td>
                            <td>${arl.startDate}</td>
                            <td>${arl.endDate}</td>
                            <td>${arl.owner}</td>
                            <td><a id="${arl.id}" name='removeRelationBtn' href="javascript:void(0);"
                                   style="text-decoration: none;"><span
                                    class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                        </tr>
                    </c:forEach>
                </c:if>
                <%--<tr>
                    <td>发传单</td>
                    <td>2017-10-10</td>
                    <td>2017-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);" style="text-decoration: none;"><span
                            class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>
                <tr>
                    <td>发传单</td>
                    <td>2017-10-10</td>
                    <td>2017-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);" style="text-decoration: none;"><span
                            class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="bindModalBtn" data-toggle="modal" <%--data-target="#bindModal"--%>
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>