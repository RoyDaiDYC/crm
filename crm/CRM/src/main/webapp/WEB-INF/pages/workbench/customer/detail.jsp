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

            $("#customerRemarkDiv").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#customerRemarkDiv").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#customerRemarkDiv").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#customerRemarkDiv").on("mouseout", ".myHref", function () {
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
            $("#saveCreateCustomerRemarkBtn").click(function () {

                //获取customerId
                var customerId = "${customer.id}";
                //获取备注信息
                var noteContent = $.trim($("#remark").val());
                //验证表单内容，不能为空
                if (noteContent === "") {
                    alert("备注不能为空");
                    return;
                }
                //发送异步请求
                $.ajax({
                    url: "workbench/customer/saveCreateCustomerRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        customerId: customerId,
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
                            htmlStr += "<font color=\"gray\">客户</font> <font color=\"gray\">-</font><b>${customer.name}-<a href=\"${customer.website}\" target=\"_blank\">${customer.website}</a></b> <small style=\"color: gray;\">";
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
            $("#customerRemarkDiv").on("click", "a[name='myEditBtn']", function () {
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
                    url: "workbench/customer/modifyCustomerRemark.do",
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
            $("#customerRemarkDiv").on("click", "a[name='myDeleteBtn']", function () {
                //获取当前选中的备注id
                var remarkId = $(this).attr("remark-id");
                //发送异步请求
                $.ajax({
                    url: "workbench/customer/deleteCustomerRemark.do",
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

            //检测修改页面，所有者和名称不能为空,当光标移开后检测
            //设置一个变量来存储检测清空
            var checkEditFormFlag = false;

            function checkEditOwner() {
                var editOwner = $("#edit-customerOwner").val();
                if (editOwner === "") {
                    $("#editOwnerMsg").html("所有着不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editOwnerMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;

            }

            function checkEditName() {
                var editName = $.trim($("#edit-customerName").val());
                if (editName === "") {
                    $("#editNameMsg").html("名称不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editNameMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditWebsite() {
                var editWebsite = $.trim($("#edit-website").val());
                if (editWebsite === "" || /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/.test(editWebsite)) {
                    $("#editWebsiteMsg").html("");
                    checkEditFormFlag = true;
                } else {
                    $("#editWebsiteMsg").html("网站格式不对");
                    checkEditFormFlag = false;
                }
                return checkEditFormFlag;
            }

            function checkEditPhone() {
                var editPhone = $.trim($("#edit-phone").val());
                if (editPhone === "" || /^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$/.test(editPhone)) {
                    $("#editPhoneMsg").html("");
                    checkEditFormFlag = true;
                } else {
                    $("#editPhoneMsg").html("座机格式不对");
                    checkEditFormFlag = false;
                }
                return checkEditFormFlag;
            }

            $("#edit-customerOwner").mousedown(function () {
                checkEditOwner();
            });
            $("#edit-customerName").blur(function () {
                checkEditName();
            });
            $("#edit-website").blur(function () {
                checkEditWebsite();
            });
            $("#edit-phone").blur(function () {
                checkEditPhone();
            });

            function checkEditForm() {
                checkEditFormFlag = checkEditOwner() && checkEditName() &&
                    checkEditWebsite() && checkEditPhone();
                return checkEditFormFlag;
            }


            //给编辑按钮添加点击事件
            $("#editCustomerBtn").click(function () {

                //收集参数
                var id = "${customer.id}";
                //发送请求
                $.ajax({
                    url: "workbench/customer/toModifyCustomerById.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id
                    },
                    success: function (data) {
                        var htmlStr = "";
                        htmlStr += "<option></option>";
                        $.each(data.userList, function (index, obj) {
                            if (obj.id === data.customer.owner) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.name + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.name + "</option>";
                            }
                        });
                        //放入指定位置
                        $("#edit-id").val(data.customer.id);
                        $("#edit-customerOwner").html(htmlStr);
                        $("#edit-customerName").val(data.customer.name);
                        $("#edit-website").val(data.customer.website);
                        $("#edit-phone").val(data.customer.phone);
                        $("#edit-describe").val(data.customer.description);
                        $("#edit-contactSummary").val(data.customer.contactSummary);
                        $("#edit-nextContactTime").val(data.customer.nextContactTime);
                        $("#edit-address").val(data.customer.address);
                        //显示修改的模态窗口
                        $("#editCustomerModal").modal("show");
                    }
                });
            });

            //给修改关闭按钮添加点击事件
            $("#editExitButton").click(function () {
                if (window.confirm("关闭不会保存当前内容")) {
                    //清空表单内容
                    $("#editCustomerForm")[0].reset();
                    //清空修改模态窗口提示信息
                    $("#editOwnerMsg").html("");
                    $("#editNameMsg").html("");
                    $("#editWebsiteMsg").html("");
                    $("#editPhoneMsg").html("");
                    //关闭模态窗口
                    $("#editCustomerModal").modal("hide");
                }
            });

            //给修改保存按钮添加点击事件
            $("#editSaveButton").click(function () {
                //收集参数
                var id = $("#edit-id").val();
                var owner = $("#edit-customerOwner").val();
                var name = $.trim($("#edit-customerName").val());
                var website = $.trim($("#edit-website").val());
                var phone = $.trim($("#edit-phone").val());
                var description = $.trim($("#edit-describe").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $.trim($("#edit-address").val());

                //发起请求
                if (checkEditForm()) {
                    $.ajax({
                        url: "workbench/customer/saveModifyCustomer.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            id: id,
                            owner: owner,
                            name: name,
                            website: website,
                            phone: phone,
                            description: description,
                            contactSummary: contactSummary,
                            nextContactTime: nextContactTime,
                            address: address
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //清空表单内容
                                $("#editCustomerForm")[0].reset();
                                //清空修改模态窗口提示信息
                                $("#editOwnerMsg").html("");
                                $("#editNameMsg").html("");
                                $("#editWebsiteMsg").html("");
                                $("#editPhoneMsg").html("");
                                //关闭模态窗口
                                $("#editCustomerModal").modal("hide");
                                //刷新页面
                                window.location.reload();
                            } else {
                                //保持页面不变
                                $("#editCustomerModal").modal("show");
                            }
                        }
                    });
                } else {
                    alert("请检查表单内容");
                }
            });

            //给删除按钮添加点击事件
            $("#deleteCustomerButton").click(function () {
                var idList = "id=${customer.id}";
                //放入隐藏域
                $("#customerId2Delete").val(idList);
                //显示删除模态窗口
                $("#removeCustomerModal").modal("show");
            });

            //删除模态窗口点击确定后，添加点击事件
            $("#deleteCustomerBtn").click(function () {
                var idList = $("#customerId2Delete").val();
                //发起异步请求
                $.ajax({
                    url: "workbench/customer/removeCustomer.do",
                    type: "post",
                    dataType: "json",
                    data: idList,
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //关闭模态窗口
                            $("#removeCustomerModal").modal("hide");
                            //跳转到客户首页
                            window.location.href = "workbench/customer/toIndex.do";
                        } else {
                            //显示删除模态窗口
                            $("#removeCustomerModal").modal("show");
                        }
                    }
                });
            });

            //设置变量存储判断检查创建模态窗口表单内容
            var checkCreateFormFlag = false;

            //检查创建的表单
            function checkCreateOwner() {
                var createOwner = $("#create-contactsOwner").val();
                if (createOwner === "") {
                    $("#createOwnerMsg").html("所有者不能为空");
                    checkCreateFormFlag = false;
                } else {
                    $("#createOwnerMsg").html("");
                    checkCreateFormFlag = true;
                }
                return checkCreateFormFlag;
            }

            function checkCreateFullName() {
                var createFullName = $.trim($("#create-surname").val());
                if (createFullName === "") {
                    $("#createFullNameMsg").html("姓名不能为空");
                    checkCreateFormFlag = false;
                } else {
                    $("#createFullNameMsg").html("");
                    checkCreateFormFlag = true;
                }
                return checkCreateFormFlag;
            }

            function checkCreateMphone() {
                var createMphone = $.trim($("#create-mphone").val());
                if (createMphone === "" || /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(createMphone)) {
                    $("#createMphoneMsg").html("");
                    checkCreateFormFlag = true;
                } else {
                    $("#createMphoneMsg").html("手机号格式不对");
                    checkCreateFormFlag = false;
                }
                return checkCreateFormFlag
            }

            function checkCreateEmail() {
                var createEmail = $.trim($("#create-email").val());
                if (createEmail === "" || /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(createEmail)) {
                    $("#createEmailMsg").html("");
                    checkCreateFormFlag = true;
                } else {
                    $("#createEmailMsg").html("邮箱格式不对");
                    checkCreateFormFlag = false;
                }
                return checkCreateFormFlag;
            }

            $("#create-contactsOwner").mousedown(function () {
                checkCreateOwner();
            });

            $("#create-surname").blur(function () {
                checkCreateFullName();
            });

            $("#create-mphone").blur(function () {
                checkCreateMphone();
            });

            $("#create-email").blur(function () {
                checkCreateEmail();
            });

            function checkCreateForm() {
                checkCreateFormFlag = checkCreateOwner() && checkCreateFullName()
                    && checkCreateMphone() && checkCreateEmail();
                return checkCreateFormFlag;
            }

            //给创建按钮添加点击事件
            $("#createContactsButton").click(function () {
                //显示创建模态窗口
                $("#createContactsModal").modal("show");
            });

            //点击面板后清空提示信息
            $(".btn-toolbar").click(function () {
                //清空创建模态窗口的信息
                $("#createOwnerMsg").html("");
                $("#createFullNameMsg").html("");
                $("#createMphoneMsg").html("");
                $("#createEmailMsg").html("");
            });

            //点击创建模态窗口的关闭按钮，清空表单内容和提示信息
            $("#createExitBtn").click(function () {
                if (window.confirm("关闭不会保存当前内容")) {
                    //清空表单内容
                    $("#createContactsForm")[0].reset();
                    //清空创建的隐藏标签内容
                    $("#create-customerId").val("");
                    //清空创建模态窗口的信息
                    $("#createOwnerMsg").html("");
                    $("#createFullNameMsg").html("");
                    $("#createMphoneMsg").html("");
                    $("#createEmailMsg").html("");
                    //关闭模态窗口
                    $("#createContactsModal").modal("hide");
                }
            });

            //给创建模态窗口的保存按钮添加点击事件
            $("#createSaveBtn").click(function () {
                //收集参数
                var owner = $("#create-contactsOwner").val();
                var source = $("#create-clueSource").val();
                var fullName = $.trim($("#create-surname").val());
                var appellation = $('#create-call').val();
                var job = $.trim($("#create-job").val());
                var mphone = $.trim($("#create-mphone").val());
                var email = $.trim($("#create-email").val());
                var birth = $("#create-birth").val();
                var customerId = $("#create-customerId").val();
                var description = $.trim($("#create-describe").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $.trim($("#create-address").val());
                //因为存在客户名称不在后台，所以也要传递新的name
                var customerName = $.trim($("#create-customerName").val());

                //发起请求
                if (checkCreateForm()) {
                    $.ajax({
                        url: "workbench/contacts/saveCreateContacts.do",
                        type: "post",
                        dataType: "json",
                        data: {
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
                                $("#createContactsForm")[0].reset();
                                //清空创建的隐藏标签内容
                                $("#create-customerId").val("");
                                //清空创建模态窗口的信息
                                $("#createOwnerMsg").html("");
                                $("#createFullNameMsg").html("");
                                $("#createMphoneMsg").html("");
                                $("#createEmailMsg").html("");
                                //关闭模态窗口
                                $("#createContactsModal").modal("hide");
                                //刷新页面
                                window.location.reload();
                            } else {
                                //保持模态窗口显示
                                $("#createContactsModal").modal("show");
                            }
                        }
                    });
                } else {
                    alert("请检查表单内容");
                }
            });

            //给删除联系人添加点击事件
            $("#tBodyForContacts").on("click", "a[name='removeContacts']", function () {
                //获取当前联系人id
                var contactsId = $(this).attr("contacts-id");
                //把联系人id赋值给隐藏域
                $("#contactsId2Delete").val(contactsId);
                //显示删除模态窗口
                $("#removeContactsModal").modal("show");
            });

            //给删除联系人确认按钮添加点击事件
            $("#deleteContactsBtn").click(function () {
                var contactsId = $("#contactsId2Delete").val();
                //因为发起的请求的参数是一个数组，则用封装成id=键值对
                var idList = "id=" + contactsId;
                //发起请求
                $.ajax({
                    url: "workbench/contacts/removeContacts.do",
                    type: "post",
                    dataType: "json",
                    data: idList,
                    success: function (data) {
                        alert(data.message);
                        if (data.code === "1") {
                            //页面内移除对应id的联系人
                            $("#conTr_" + contactsId).remove();
                            //关闭删除模态窗口
                            $("#removeContactsModal").modal("hide");
                        } else {
                            //保持模态窗口显示
                            $("#removeContactsModal").modal("show");
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

<!-- 修改客户备注的模态窗口 -->
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
                <p>删除后联系人相关信息也会消失</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="deleteContactsBtn" type="button" class="btn btn-danger" <%--data-dismiss="modal"--%>>删除
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 删除客户的模态窗口 -->
<div class="modal fade" id="removeCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除客户</h4>
            </div>
            <input id="customerId2Delete" type="hidden">
            <div class="modal-body">
                <p>您确定要删除该客户吗？</p>
                <p>删除后相关交易和联系人也会消失</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="deleteCustomerBtn" type="button" class="btn btn-danger" <%--data-dismiss="modal"--%>>删除
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

<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;top: 3%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form id="createContactsForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-contactsOwner">
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
                            <span id="createOwnerMsg" style="color: red"></span>
                        </div>
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueSource">
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
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                            <span id="createFullNameMsg" style="color: red"></span>
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <c:if test="${not empty appellationList}">
                                    <c:forEach items="${appellationList}" var="appellation">
                                        <option value="${appellation.id}">${appellation.value}</option>
                                    </c:forEach>
                                </c:if>
                                <%--<option>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>--%>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                            <span id="createMphoneMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                            <span id="createEmailMsg" style="color: red"></span>
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-birth" readonly>
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control"
                                   id="create-customerName"<%--placeholder="支持自动补全，输入客户不存在则新建"--%>
                                   value="${customer.name}" readonly>
                            <input id="create-customerId" value="${customer.id}" type="hidden">
                        </div>
                    </div>
                    <div class="form-group" style="position: relative;">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button id="createExitBtn" type="button" class="btn btn-default" <%--data-dismiss="modal"--%>>关闭
                </button>
                <button id="createSaveBtn" type="button" class="btn btn-primary" <%--data-dismiss="modal"--%>>保存
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myEditModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form id="editCustomerForm" class="form-horizontal" role="form">
                    <input id="edit-id" type="hidden">
                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-customerOwner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                            <span id="editOwnerMsg" style="color: red"></span>
                        </div>
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName" <%--value="动力节点"--%>>
                            <span id="editNameMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website">
                            <span id="editWebsiteMsg" style="color: red"></span>
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" <%--value="010-84846003"--%>>
                            <span id="editPhoneMsg" style="color: red"></span>
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

<div class="btn-toolbar">
    <!-- 返回按钮 -->
    <div style="position: relative; top: 35px; left: 10px;">
        <a id="backBtn" href="javascript:void(0);"><span class="glyphicon glyphicon-arrow-left"
                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
    </div>

    <!-- 大标题 -->
    <div style="position: relative; left: 40px; top: -30px;">
        <div class="page-header">
            <h3>${customer.name} <small><a href="${customer.website}" target="_blank">${customer.website}</a></small>
            </h3>
        </div>
        <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
            <button id="editCustomerBtn" type="button" class="btn btn-default"
                    data-toggle="modal" <%--data-target="#editCustomerModal"--%>><span
                    class="glyphicon glyphicon-edit"></span> 编辑
            </button>
            <button id="deleteCustomerButton" type="button" class="btn btn-danger"><span
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
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
            <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
            <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 10px;">
            <div style="width: 300px; color: gray;">公司网站</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>
                <a href="${customer.website}" target="_blank">${customer.website}</a>&nbsp;</b>
            </div>
            <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
            <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}&nbsp;</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 20px;">
            <div style="width: 300px; color: gray;">创建者</div>
            <div style="width: 500px;position: relative; left: 200px; top: -20px;">
                <b>${customer.createBy}&nbsp;&nbsp;</b><small
                    style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
            <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 30px;">
            <div style="width: 300px; color: gray;">修改者</div>
            <div style="width: 500px;position: relative; left: 200px; top: -20px;">
                <b>${customer.editBy}&nbsp;&nbsp;</b><small
                    style="font-size: 10px; color: gray;">${customer.editTime}&nbsp;</small></div>
            <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.contactSummary}&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;">
                <b>${customer.nextContactTime}&nbsp;</b>
            </div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 60px;">
            <div style="width: 300px; color: gray;">描述</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.description}&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.address}&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
    </div>

    <!-- 备注 -->
    <div id="customerRemarkDiv" style="position: relative; top: 10px; left: 40px;">
        <div class="page-header">
            <h4>备注</h4>
        </div>
        <c:if test="${not empty customerRemarkList}">
            <c:forEach items="${customerRemarkList}" var="cr">
                <div id="div_${cr.id}" class="remarkDiv" style="height: 60px;">
                    <img title="${cr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
                    <div style="position: relative; top: -40px; left: 40px;">
                        <h5>${cr.noteContent}</h5>
                        <font color="gray">客户</font> <font color="gray">-</font><b>${customer.name}-<a
                            href="${customer.website}" target="_blank">${customer.website}</a></b> <small
                            style="color: gray;">
                            ${cr.editFlag==0?cr.createTime:cr.editTime}
                        由${cr.editFlag==0?cr.createBy:cr.editBy}${cr.editFlag==0?"创建":"修改"}</small>
                        <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                            <a class="myHref" remark-id="${cr.id}" name="myEditBtn" href="javascript:void(0);"><span
                                    class="glyphicon glyphicon-edit"
                                    style="font-size: 20px; color: #E6E6E6;"></span></a>
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
                    <button id="saveCreateCustomerRemarkBtn" type="button" class="btn btn-primary">保存</button>
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
                <table id="activityTable2" class="table table-hover" style="width: 900px;">
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
                                       data-toggle="modal"
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
                        <td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeTransactionModal"
                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>

            <div>
                <a href="workbench/transaction/toCreateTransaction.do?customerId=${customer.id}"
                   style="text-decoration: none;"><span
                        class="glyphicon glyphicon-plus"></span>新建交易</a>
            </div>
        </div>
    </div>

    <!-- 联系人 -->
    <div>
        <div style="position: relative; top: 20px; left: 40px;">
            <div class="page-header">
                <h4>联系人</h4>
            </div>
            <div style="position: relative;top: 0px;">
                <table id="activityTable" class="table table-hover" style="width: 900px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="tBodyForContacts">
                    <c:if test="${not empty contactsList}">
                        <c:forEach items="${contactsList}" var="con">
                            <tr id="conTr_${con.id}" class="conTr">
                                <td><a href="workbench/contacts/toDetail.do?id=${con.id}"
                                       style="text-decoration: none;">${con.fullName}${con.appellation}</a></td>
                                <td>${con.email}</td>
                                <td>${con.mphone}</td>
                                <td><a contacts-id="${con.id}" name="removeContacts" href="javascript:void(0);"
                                       data-toggle="modal"
                                       style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <%--<tr>
                        <td><a href="../contacts/detail.jsp" style="text-decoration: none;">李四</a></td>
                        <td>lisi@bjpowernode.com</td>
                        <td>13543645364</td>
                        <td><a con-id="${con.id}" name="conDeleteBtn"href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal"
                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>

            <div>
                <a id="createContactsButton" href="javascript:void(0);"
                   data-toggle="modal" <%--data-target="#createContactsModal"--%>
                   style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
            </div>
        </div>
    </div>
    <div style="height: 200px;"></div>
</div>
</body>
</html>