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

    <script type="text/javascript">

        $(function () {

            //默认显示内容，第一页和十条内容
            queryCustomer(1, 10);

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

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });


            //检测创建页面，所有者和名称不能为空,当光标移开后检测
            //设置一个变量来存储检测清空
            var checkCreateFormFlag = false;

            function checkCreateOwner() {
                var createOwner = $("#create-customerOwner").val();
                if (createOwner === "") {
                    $("#createOwnerMsg").html("所有着不能为空");
                    checkCreateFormFlag = false;
                } else {
                    $("#createOwnerMsg").html("");
                    checkCreateFormFlag = true;
                }
                return checkCreateFormFlag;

            }

            function checkCreateName() {
                var createName = $.trim($("#create-customerName").val());
                if (createName === "") {
                    $("#createNameMsg").html("名称不能为空");
                    checkCreateFormFlag = false;
                } else {
                    $("#createNameMsg").html("");
                    checkCreateFormFlag = true;
                }
                return checkCreateFormFlag;
            }

            function checkCreateWebsite() {
                var createWebsite = $.trim($("#create-website").val());
                if (createWebsite === "" || /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/.test(createWebsite)) {
                    $("#createWebsiteMsg").html("");
                    checkCreateFormFlag = true;
                } else {
                    $("#createWebsiteMsg").html("网站格式不对");
                    checkCreateFormFlag = false;
                }
                return checkCreateFormFlag;
            }

            function checkCreatePhone() {
                var createPhone = $.trim($("#create-phone").val());
                if (createPhone === "" || /^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$/.test(createPhone)) {
                    $("#createPhoneMsg").html("");
                    checkCreateFormFlag = true;
                } else {
                    $("#createPhoneMsg").html("座机格式不对");
                    checkCreateFormFlag = false;
                }
                return checkCreateFormFlag;
            }

            $("#create-customerOwner").mousedown(function () {
                checkCreateOwner();
            });
            $("#create-customerName").blur(function () {
                checkCreateName();
            });
            $("#create-website").blur(function () {
                checkCreateWebsite();
            });
            $("#create-phone").blur(function () {
                checkCreatePhone();
            });

            function checkCreateForm() {
                checkCreateFormFlag = checkCreateOwner() && checkCreateName() &&
                    checkCreateWebsite() && checkCreatePhone();
                return checkCreateFormFlag;
            }

            //给创建按钮添加点击事件
            $("#createCustomerBtn").click(function () {
                //显示模态窗口
                $("#createCustomerModal").modal("show");
            });
            //点击面板后，清空提示信息
            $(".btn-toolbar").click(function () {
                //清空创建模态窗口提示信息
                $("#createOwnerMsg").html("");
                $("#createNameMsg").html("");
                $("#createWebsiteMsg").html("");
                $("#createPhoneMsg").html("");
                //清空修改模态窗口提示信息
                $("#editOwnerMsg").html("");
                $("#editNameMsg").html("");
                $("#editWebsiteMsg").html("");
                $("#editPhoneMsg").html("");
            });

            //点击创建的关闭按钮，清空表单内容
            $("#createExitBtn").click(function () {
                if (window.confirm("关闭不会保存当前内容")) {
                    //清空表单内容
                    $("#createCustomerForm")[0].reset();
                    //清空提示信息
                    $("#createOwnerMsg").html("");
                    $("#createNameMsg").html("");
                    $("#createWebsiteMsg").html("");
                    $("#createPhoneMsg").html("");
                    //关闭模态窗口
                    $("#createCustomerModal").modal("hide");
                }
            });

            //给创建的保存按钮添加点击事件
            $("#createSaveBtn").click(function () {
                //收集参数
                var owner = $("#create-customerOwner").val();
                var name = $.trim($("#create-customerName").val());
                var website = $.trim($("#create-website").val());
                var phone = $.trim($("#create-phone").val());
                var description = $.trim($("#create-describe").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $.trim($("#create-address").val());
                //表单验证通过进行异步请求
                if (checkCreateForm()) {
                    $.ajax({
                        url: "workbench/customer/saveCreateCustomer.do",
                        type: "post",
                        dataType: "json",
                        data: {
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
                                $("#createCustomerForm")[0].reset();
                                //清空提示信息
                                $("#createOwnerMsg").html("");
                                $("#createNameMsg").html("");
                                $("#createWebsiteMsg").html("");
                                $("#createPhoneMsg").html("");
                                //关闭模态窗口
                                $("#createCustomerModal").modal("hide");
                                //刷新页面
                                queryCustomer(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                //保持模态窗口显示
                                $("#createCustomerModal").modal("show");
                            }
                        }
                    });
                } else {
                    alert("请检查表单内容");
                }
            });

            //给查询按钮添加点击事件
            $("#queryButton").click(function () {
                //调用封装的查询函数
                //通过分页函数可以调用当前分页内的各类属性值
                queryCustomer(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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
                var innerCheckBoxes = $("#tBody input[type='checkbox']");
                innerCheckBoxes.prop("checked", $(this).prop("checked"));
            });

            //给列表中所有的checkbox添加单击事件
            //动态获取的列表进行点击事件添加需要用到on方法，可以设定id，标签，class来识别
            $("#tBody").on("click", ".innerCheck", function () {
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


            /*
            *
            * 给修改按钮添加点击事件
            * 只能对选中的一条进行修改，不选和多选都无法显示修改模态窗口，提示信息
            * */
            $("#editCustomerBtn").click(function () {

                //判断选中情况
                var innerOnCheckBoxes = $("#tBody input[type='checkbox']:checked");
                if (innerOnCheckBoxes.size() > 1) {
                    alert("只能编写一条内容，请重新选择");
                    return;
                }

                if (innerOnCheckBoxes.size() === 0) {
                    alert("请选择一条内容进行编辑");
                    return;
                }

                //收集参数
                var id = innerOnCheckBoxes.get(0).value;
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
                                queryCustomer(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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
            $("#deleteCustomerBtn").click(function () {
                var innerOnCheckBoxes = $("#tBody input[type='checkbox']:checked");
                if (innerOnCheckBoxes.size() === 0) {
                    alert("请选择要删除的内容");
                    return;
                }
                var idList = "";
                $.each(innerOnCheckBoxes, function () {
                    idList += "id=" + this.value + "&";
                });
                idList = idList.substr(0, idList.length - 1);
                //发送请求
                if (window.confirm("确认要删除吗？")) {

                    $.ajax({
                        url: "workbench/customer/removeCustomer.do",
                        type: "post",
                        dataType: "json",
                        data: idList,
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //刷新页面
                                queryCustomer(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
                            }
                        }
                    });
                }
            });


        });

        /*
        *
        * 分页查询，封装到一个函数内
        * 查询函数在点击查询按钮和刚进入市场活动主页面被调用
        * 且在刚进入市场活动主页时给定默认页号和每页内容数
        * */
        function queryCustomer(pageNo, pageSize) {
            var name = $.trim($("#customer-name").val());
            var owner = $.trim($("#customer-owner").val());
            var phone = $.trim($("#customer-phone").val());
            var website = $.trim($("#customer-website").val());
            $.ajax({
                url: "workbench/customer/getCustomerByCondition.do",
                type: "post",
                dataType: "json",
                data: {
                    name: name,
                    owner: owner,
                    phone: phone,
                    website: website,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    //获取总共数据条数
                    var totalRows = data.totalRows;
                    //在总共记录位置显示
                    $("#totalRows").html(totalRows);
                    //获取市场活动内容集合
                    var customerList = data.dataList;
                    var htmlStr = "";
                    if (customerList == "") {
                        htmlStr += "<tr style=\"color: grey\">";
                        htmlStr += "<td colspan='5' align='center'><h3>没有查询到数据</h3></td>";
                        htmlStr += "</tr>";
                    } else {
                        $.each(customerList, function (index, obj) {
                            //针对座机和网站未添加，给出提示信息
                            if (obj.phone === "" || obj.phone == null) {
                                obj.phone = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (index % 2 === 0) {
                                htmlStr += "<tr class=\"active\">";
                            } else {
                                htmlStr += "<tr>";
                            }
                            htmlStr += "<td><input type=\"checkbox\" class='innerCheck' value=\""
                                + obj.id + "\" \"/></td>";
                            htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" " +
                                "onclick=\"window.location.href='workbench/customer/toDetail.do?id="
                                + obj.id + "';\">" + obj.name + "</a></td>";
                            htmlStr += "<td>" + obj.owner + "</td>";
                            htmlStr += "<td>" + obj.phone + "</td>";
                            htmlStr += "<td>" + obj.website + "</td>";
                            htmlStr += "</tr>";
                        });
                    }
                    //放入指定位置，显示内容
                    $("#tBody").html(htmlStr);

                    //计算所有市场活动内容，所需要的总页数
                    /*
                    * 总共有22条记录，每页显示有5条记录
                    * 则需要5个页面显示
                    * 前4个页面每个页面显示5条记录，最后一个页面显示2条记录
                    * 总行数/每页显示的记录
                    * totalRows/pageSize
                    *
                    * */
                    var totalPages = 1;
                    if (totalRows % pageSize === 0) {
                        totalPages = totalRows / pageSize;
                    } else {
                        totalPages = parseInt(totalRows / pageSize) + 1;
                    }

                    /*
                    * 当调用查询函数时候，显示分页功能
                    *
                    * 在这个位置创建分页功能
                    * */

                    $("#pagination").bs_pagination({
                        currentPage: pageNo,//当前页
                        rowsPerPage: pageSize,//每页显示条数
                        totalRows: data.totalRows,//总条数
                        totalPages: totalPages,//总页数
                        visiblePageLinks: 5,//最多可以显示的页号卡片数
                        showGoToPage: true,//是否显示跳转到第几页
                        showRowsPerPage: true,//是否显示每页显示多少条
                        showRowsInfo: true,//是否显示分页信息
                        onChangePage: function (e, pageObj) {
                            // returns page_num and rows_per_page after a link has clicked
                            //赋值的首页和每页条数重新调用查询函数，显示内容，
                            //实现点击某一页显示的是某一页分页后的内容
                            queryCustomer(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }

            });

        }

    </script>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;height:105%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form id="createCustomerForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-customerOwner">
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
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName">
                            <span id="createNameMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                            <span id="createWebsiteMsg" style="color: red"></span>
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                            <span id="createPhoneMsg" style="color: red"></span>
                        </div>
                    </div>
                    <div class="form-group">
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
    <div class="modal-dialog" role="document" style="width: 85%;height: 105%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
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


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="customer-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="customer-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="customer-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="customer-website">
                    </div>
                </div>

                <button id="queryButton" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createCustomerBtn" type="button" class="btn btn-primary"
                        data-toggle="modal" <%--data-target="#createCustomerModal"--%>>
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editCustomerBtn" type="button" class="btn btn-default"
                        data-toggle="modal" <%--data-target="#editCustomerModal"--%>><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteCustomerBtn" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="checkAll" type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a>
                    </td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a>
                    </td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>--%>
                </tbody>
            </table>
        </div>
        <div id="pagination" <%--style="position: relative;top: 40px;"--%>></div>
        <div style="height: 50px; position: relative;top: -10px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRows"></b>条记录
                </button>
            </div>
            <%--<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>--%>
        </div>

    </div>

</div>
</body>
</html>