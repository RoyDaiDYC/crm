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

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

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
                todayBtn: true,//是否显示当天按钮
                pickerPosition: 'top-right'//日期插件显示位置
            });

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

            $("#contactsRemarkDiv").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#contactsRemarkDiv").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#contactsRemarkDiv").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#contactsRemarkDiv").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //给返回按钮添加点击事件
            $("#backBtn").click(function () {
                window.location.href = document.referrer;
            });

            /*
            *
            * 给客户备注信息保存按钮添加点击事件
            * 返回内容后在备注框上方显示内容
            * */
            $("#saveCreateContactsRemarkBtn").click(function () {

                //获取customerId
                var contactsId = "${contacts.id}";
                //获取备注信息
                var noteContent = $.trim($("#remark").val());
                //验证表单内容，不能为空
                if (noteContent === "") {
                    alert("备注不能为空");
                    return;
                }
                //发送异步请求
                $.ajax({
                    url: "workbench/contacts/saveCreateContactsRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        contactsId: contactsId,
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
                            htmlStr += "<font color=\"gray\">联系人</font> <font color=\"gray\">-</font><b>${contacts.fullName}${contacts.appellation}-${contacts.customerName}</b> <small style=\"color: gray;\">";
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
            $("#contactsRemarkDiv").on("click", "a[name='myEditBtn']", function () {
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
                    url: "workbench/contacts/modifyContactsRemark.do",
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
            $("#contactsRemarkDiv").on("click", "a[name='myDeleteBtn']", function () {
                //获取当前选中的备注id
                var remarkId = $(this).attr("remark-id");
                //发送异步请求
                $.ajax({
                    url: "workbench/contacts/deleteContactsRemark.do",
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


            //设置变量存储判断检查修改模态窗口表单内容
            var checkEditFormFlag = false;

            //检查修改的表单
            function checkEditOwner() {
                var editOwner = $("#edit-contactsOwner").val();
                if (editOwner === "") {
                    $("#editOwnerMsg").html("所有者不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#createOwnerMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditFullName() {
                var editFullName = $.trim($("#edit-surname").val());
                if (editFullName === "") {
                    $("#editFullNameMsg").html("姓名不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editFullNameMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditMphone() {
                var editMphone = $.trim($("#edit-mphone").val());
                if (editMphone === "" || /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(editMphone)) {
                    $("#editMphoneMsg").html("");
                    checkEditFormFlag = true;
                } else {
                    $("#editMphoneMsg").html("手机号格式不对");
                    checkEditFormFlag = false;
                }
                return checkEditFormFlag
            }

            function checkEditEmail() {
                var editEmail = $.trim($("#edit-email").val());
                if (editEmail === "" || /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(editEmail)) {
                    $("#editEmailMsg").html("");
                    checkEditFormFlag = true;
                } else {
                    $("#editEmailMsg").html("邮箱格式不对");
                    checkEditFormFlag = false;
                }
                return checkEditFormFlag;
            }

            $("#edit-contactsOwner").mousedown(function () {
                checkEditOwner();
            });

            $("#edit-surname").blur(function () {
                checkEditFullName();
            });

            $("#edit-mphone").blur(function () {
                checkEditMphone();
            });

            $("#edit-email").blur(function () {
                checkEditEmail();
            });

            function checkEditForm() {
                checkEditFormFlag = checkEditOwner() && checkEditFullName()
                    && checkEditMphone() && checkEditEmail();
                return checkEditFormFlag;
            }

            /*
            *
            * 给修改按钮添加点击事件
            * 只能对选中的一条进行修改，不选和多选都无法显示修改模态窗口，提示信息
            * */
            $("#editContactsButton").click(function () {
                //收集参数
                var id = "${contacts.id}";
                //发送请求
                $.ajax({
                    url: "workbench/contacts/toModifyContactsById.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id
                    },
                    success: function (data) {
                        var htmlStr = "";
                        htmlStr += "<option></option>";
                        $.each(data.userList, function (index, obj) {
                            if (obj.id === data.contacts.owner) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.name + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.name + "</option>";
                            }
                        });
                        //放入指定位置
                        $("#edit-contactsOwner").html(htmlStr);
                        //重置
                        htmlStr = "";
                        htmlStr += "<option></option>";
                        $.each(data.sourceList, function (index, obj) {
                            if (obj.id === data.contacts.source) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.value + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.value + "</option>";
                            }
                        });
                        //放入指定位置
                        $("#edit-clueSource").html(htmlStr);
                        //重置
                        htmlStr = "";
                        htmlStr += "<option></option>";
                        $.each(data.appellationList, function (index, obj) {
                            if (obj.id === data.contacts.appellation) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.value + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.value + "</option>";
                            }
                        });
                        //放入指定位置
                        $("#edit-call").html(htmlStr);
                        //补全其他位置
                        $("#edit-id").val(data.contacts.id);
                        $("#edit-surname").val(data.contacts.fullName);
                        $("#edit-job").val(data.contacts.job);
                        $("#edit-mphone").val(data.contacts.mphone);
                        $("#edit-email").val(data.contacts.email);
                        $("#edit-birth").val(data.contacts.birth);
                        $("#edit-customerId").val(data.contacts.customerId);
                        $("#edit-customerName").val(data.contacts.customerName);
                        $("#edit-describe").val(data.contacts.description);
                        $("#edit-contactSummary").val(data.contacts.contactSummary);
                        $("#edit-nextContactTime").val(data.contacts.nextContactTime);
                        $("#edit-address").val(data.contacts.address);
                        //显示修改的模态窗口
                        $("#editContactsModal").modal("show");
                    }
                });
            });

            //给修改关闭按钮添加点击事件
            $("#editExitButton").click(function () {
                if (window.confirm("关闭不会保存当前内容")) {
                    //清空表单内容
                    $("#editContactsForm")[0].reset();
                    //清空修改模态窗口提示信息
                    $("#editOwnerMsg").html("");
                    $("#editFullNameMsg").html("");
                    $("#editMphoneMsg").html("");
                    $("#editEmailMsg").html("");
                    //关闭模态窗口
                    $("#editContactsModal").modal("hide");
                }
            });

            /*
            * 调用自动补全函数
            * 1发起异步请求，通过输入模糊数据，从后台查询出对应的客户信息
            * 对选中的客户名称显示在文本框里
            * 用一个隐藏标签存储文本名称对应的客户id内容
            * 2如果是新的名称，则需要返回名称，进行后台判断，创建客户，再赋值id到数据库中
            *
            * */

            //设置一个空对象，用来在请求后收到的客户集合，把name值对应id值
            //用来存储name:id键值对，*当前是新页面，所以要进行定义
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

            //给修改保存按钮添加点击事件
            $("#editSaveButton").click(function () {
                //收集参数
                var id = $("#edit-id").val();
                var owner = $("#edit-contactsOwner").val();
                var source = $("#edit-clueSource").val();
                var appellation = $("#edit-call").val();
                var fullName = $.trim($("#edit-surname").val());
                var job = $.trim($("#edit-job").val());
                var mphone = $.trim($("#edit-mphone").val());
                var email = $.trim($("#edit-email").val());
                var birth = $("#edit-birth").val();
                var customerId = $("#edit-customerId").val();
                var description = $.trim($("#edit-describe").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $.trim($("#edit-address").val());
                //为了判断客户名是否在数据库中，所以也要返回名称，名称不在就创建新客户
                var customerName = $.trim($("#edit-customerName").val());
                //发起请求
                if (checkEditForm()) {
                    $.ajax({
                        url: "workbench/contacts/saveModifyContacts.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            id: id,
                            owner: owner,
                            source: source,
                            fullName: fullName,
                            appellation: appellation,
                            job: job,
                            mphone: mphone,
                            email: email,
                            birth: birth,
                            customerId: customerId,
                            description: description,
                            contactSummary: contactSummary,
                            nextContactTime: nextContactTime,
                            address: address,
                            customerName: customerName
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //清空表单内容
                                $("#editContactsForm")[0].reset();
                                //清空修改模态窗口提示信息
                                $("#editOwnerMsg").html("");
                                $("#editFullNameMsg").html("");
                                $("#editMphoneMsg").html("");
                                $("#editEmailMsg").html("");
                                //关闭模态窗口
                                $("#editContactsModal").modal("hide");
                                //刷新页面
                                window.location.reload();
                            } else {
                                //保持页面不变
                                $("#editContactsModal").modal("show");
                            }
                        }
                    });
                } else {
                    alert("请检查表单内容");
                }
            });

            //给删除按钮添加点击事件
            $("#deleteContactsButton").click(function () {
                var idList = "id=${contacts.id}";
                //放到隐藏域中
                $("#contactsId2Delete").val(idList);
                //显示解除模态窗口
                $("#removeContactsModal").modal("show");

            });

            //给删除确认按钮添加点击事件
            $("#deleteContactsBtn").click(function () {
                var idList = $("#contactsId2Delete").val();
                //发起异步请求
                $.ajax({
                    url: "workbench/contacts/removeContacts.do",
                    type: "post",
                    dataType: "json",
                    data: idList,
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //跳转到联系人首页
                            window.location.href = "workbench/contacts/toIndex.do";
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
                var contactsId = "${contacts.id}";

                //发送请求
                $.ajax({
                    url: "workbench/contacts/searchActivities.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        activityName: activityName,
                        contactsId: contactsId
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
            $("#bindContactsActivityBtn").click(function () {
                var innerOnCheckBoxes = $("#tBodyBySearchActivities input[type='checkbox']:checked");
                if (innerOnCheckBoxes.size() === 0) {
                    alert("请选择要关联的内容");
                    return;
                }
                //获取当前线索id
                var contactsId = "${contacts.id}";
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
                        url: "workbench/contacts/bindClueActivity.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            contactsId: contactsId,
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
                                $("#tBodyByBindContactsActivity").append(htmlStr);
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
            $("#tBodyByBindContactsActivity").on("click", "a[name='removeRelationBtn']", function () {
                //显示解除模态窗口
                $("#unbindActivityModal").modal("show");
                //获取当前线索id
                var contactsId = "${contacts.id}";
                //放到解除模态窗口的隐藏域里
                $("#unbindContactsId").val(contactsId);
                //获取当前点击按钮id值
                var activityId = $(this).attr("id");
                //放到解除模态窗口的隐藏域里
                $("#unbindActivityId").val(activityId);
            });


            //确认取消关联按钮添加点击事件
            $("#unbindBtn").click(function () {
                var contactsId = $("#unbindContactsId").val();
                var activityId = $("#unbindActivityId").val();
                //发送异步请求
                $.ajax({
                    url: "workbench/contacts/removeRelation.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        contactsId: contactsId,
                        activityId: activityId
                    },
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //移除对应activityId的单元格内容
                            $("#relation_" + activityId).remove();
                            //关闭模态窗口
                            $("#unbindActivityModal").modal("hide");
                        } else {
                            //保持模态窗口显示
                            $("#unbindActivityModal").modal("show");
                        }
                    }
                });
            });

            //给删除交易添加点击事件
            $("#tBodyForTransaction").on("click", "a[name='removeTransaction']", function () {
                //获取当前联系人id
                var transactionId = $(this).attr("tran-id");
                //把联系人id赋值给隐藏域
                $("#transactionId2Delete").val(transactionId);
                //显示删除模态窗口
                $("#removeTransactionModal").modal("show");
            });

            //给删除交易确认按钮添加点击事件
            $("#deleteTransactionBtn").click(function () {
                var transactionId = $("#transactionId2Delete").val();
                //因为发起的请求的参数是一个数组，则用封装成id=键值对
                var idList = "id=" + transactionId;
                //发起请求
                $.ajax({
                    url: "workbench/transaction/removeTransaction.do",
                    type: "post",
                    dataType: "json",
                    data: idList,
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //页面内移除对应id的联系人
                            $("#tranTr_" + transactionId).remove();
                            //关闭删除模态窗口
                            $("#removeTransactionModal").modal("hide");
                        } else {
                            //保持模态窗口显示
                            $("#removeTransactionModal").modal("show");
                        }
                    }
                });
            });


        });

    </script>

</head>
<body>

<!-- 修改联系人备注的模态窗口 -->
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

<!-- 删除联系人的模态窗口 -->
<div class="modal fade" id="removeContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除联系人</h4>
            </div>
            <input id="contactsId2Delete" type="hidden">
            <div class="modal-body">
                <p>您确定要删除该联系人吗？</p>
                <p>删除后相关交易和市场关联也会消失</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="deleteContactsBtn" type="button" class="btn btn-danger" <%--data-dismiss="modal"--%>>删除
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 删除交易的模态窗口 -->
<div class="modal fade" id="removeTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除交易</h4>
            </div>
            <input id="transactionId2Delete" type="hidden">
            <div class="modal-body">
                <p>您确定要删除该交易吗？</p>
                <p>删除后相关交易历史也会消失</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="deleteTransactionBtn" type="button" class="btn btn-danger" <%--data-dismiss="modal"--%>>删除
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 解除联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="unbindActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">解除关联</h4>
            </div>
            <input id="unbindContactsId" type="hidden">
            <input id="unbindActivityId" type="hidden">
            <div class="modal-body">
                <p>您确定要解除该关联关系吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="unbindBtn" type="button" class="btn btn-danger" <%--data-dismiss="modal"--%>>解除</button>
            </div>
        </div>
    </div>
</div>

<!-- 联系人和市场活动关联的模态窗口 -->
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
                <button id="bindContactsActivityBtn" type="button" class="btn btn-primary" <%--data-dismiss="modal"--%>>
                    关联
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;top: 3%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form id="editContactsForm" class="form-horizontal" role="form">
                    <input id="edit-id" type="hidden">
                    <div class="form-group">
                        <label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-contactsOwner">
                                <%--<option selected>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                            <span id="editOwnerMsg" style="color: red"></span>
                        </div>
                        <label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueSource">
                                <%--<option></option>
                                <option selected>广告</option>
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
                    </div>

                    <div class="form-group">
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" <%--value="李四"--%>>
                            <span id="editFullNameMsg" style="color: red"></span>
                        </div>
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <%--<option></option>
                                <option selected>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>--%>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" <%--value="CTO"--%>>
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" <%--value="12345678901"--%>>
                            <span id="editMphoneMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control"
                                   id="edit-email" <%--value="lisi@bjpowernode.com"--%>>
                            <span id="editEmailMsg" style="color: red"></span>
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-birth" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建" <%--value="动力节点"--%>>
                            <input id="edit-customerId" type="hidden">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button id="editExitButton" type="button" class="btn btn-default" <%--data-dismiss="modal"--%>>关闭
                </button>
                <button id="editSaveButton" type="button" class="btn btn-primary" <%--data-dismiss="modal"--%>>更新
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a id="backBtn" href="javascript:void(0);" <%--onclick="window.history.back();"--%>><span
            class="glyphicon glyphicon-arrow-left"
            style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${contacts.fullName}${contacts.appellation} <small> - ${contacts.customerName}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button id="editContactsButton" type="button" class="btn btn-default"
                data-toggle="modal" <%--data-target="#editContactsModal"--%>><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button id="deleteContactsButton" type="button" class="btn btn-danger"><span
                class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.source}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.customerName}&nbsp;</b>
        </div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;">
            <b>${contacts.fullName}${contacts.appellation}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.email}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.mphone}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.job}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.birth}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${contacts.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${contacts.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${contacts.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${contacts.editTime}&nbsp;</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${contacts.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${contacts.contactSummary}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.nextContactTime}&nbsp;</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${contacts.address}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>
<!-- 备注 -->
<div id="contactsRemarkDiv" style="position: relative; top: 20px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>
    <c:if test="${not empty contactsRemarkList}">
        <c:forEach items="${contactsRemarkList}" var="cr">
            <div id="div_${cr.id}" class="remarkDiv" style="height: 60px;">
                <img title="${cr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
                <div style="position: relative; top: -40px; left: 40px;">
                    <h5>${cr.noteContent}</h5>
                    <font color="gray">联系人</font> <font
                        color="gray">-</font><b>${contacts.fullName}${contacts.appellation}-${contacts.customerName}</b>
                    <small style="color: gray;">
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
            <font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;">
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
            <font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;">
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
                <button id="saveCreateContactsRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 交易 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>交易</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable3" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="tBodyForTransaction">
                <c:if test="${not empty transactionList}">
                    <c:forEach items="${transactionList}" var="tran">
                        <tr id="tranTr_${tran.id}" class="tranTr">
                            <td><a href="workbench/transaction/toDetail.do?id=${tran.id}"
                                   style="text-decoration: none;">${tran.name}</a></td>
                            <td>${tran.money}</td>
                            <td>${tran.stage}</td>
                            <td>${tran.possibility}</td>
                            <td>${tran.expectedDate}</td>
                            <td>${tran.type}</td>
                            <td><a tran-id="${tran.id}" name="removeTransaction" href="javascript:void(0);"
                                   data-toggle="modal" <%--data-target="#removeTransactionModal"--%>
                                   style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <%--<tr>
                    <td><a href="../transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>
                    <td>5,000</td>
                    <td>谈判/复审</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>新业务</td>
                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbindModal"
                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="workbench/transaction/toCreateTransaction.do?customerId=${customerId}&contactsId=${contacts.id}"
               style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="tBodyByBindContactsActivity" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="tBodyForActivityRelation">
                <c:if test="${not empty marketingActivitiesList}">
                    <c:forEach items="${marketingActivitiesList}" var="ma">
                        <tr id="relation_${ma.id}" class="activityTr">
                            <td><a href="workbench/activity/toDetail.do?id=${ma.id}"
                                   style="text-decoration: none;">${ma.name}</a></td>
                            <td>${ma.startDate}</td>
                            <td>${ma.endDate}</td>
                            <td>${ma.owner}</td>
                            <td><a id="${ma.id}" name="removeRelationBtn" href="javascript:void(0);"
                                   data-toggle="modal" <%--data-target="#unbindActivityModal"--%>
                                   style="text-decoration: none;"><span
                                    class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                        </tr>
                    </c:forEach>
                </c:if>
                <%--<tr>
                    <td><a href="../activity/detail.jsp" style="text-decoration: none;">发传单</a></td>
                    <td>2017-10-10</td>
                    <td>2017-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbindActivityModal"
                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="bindModalBtn" data-toggle="modal" <%--data-target="#bindActivityModal"--%>
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>