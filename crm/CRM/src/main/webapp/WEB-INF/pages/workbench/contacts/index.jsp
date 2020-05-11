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

            //默认显示内容，第一页和十条内容
            queryContacts(1, 10);

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
                //清空修改模态窗口提示信息
                $("#editOwnerMsg").html("");
                $("#editFullNameMsg").html("");
                $("#editMphoneMsg").html("");
                $("#editEmailMsg").html("");
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
            $("#create-customerName").typeahead({
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
                    $("#create-customerId").val(customerId);
                },


            });

            //当客户名输入发生改变时，清空客户id值
            $("#create-customerName").on("change", function () {
                $("#create-customerId").val("");
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
                                queryContacts(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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

            //给查询按钮添加点击事件
            $("#queryButton").click(function () {
                //调用封装的查询函数
                //通过分页函数可以调用当前分页内的各类属性值
                queryContacts(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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
            //用来存储name:id键值对，*之前创建页面已经在全局里定义过一次，所有目前不用定义，重置为空对象即可
            name2id = {};
            $("#edit-customerName").typeahead({
                //向后台发起请求
                //获取模糊查询名称查询得到的客户内容
                source: function (query, process) {
                    $.ajax({
                        url: "workbench/contacts/getCustomerByCustomerName.do",
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
                            id:id,
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
                                queryContacts(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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
                        url: "workbench/contacts/removeContacts.do",
                        type: "post",
                        dataType: "json",
                        data: idList,
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //刷新页面
                                queryContacts(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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
        function queryContacts(pageNo, pageSize) {
            var owner = $.trim($("#contacts-owner").val());
            var fullName = $.trim($("#contacts-fullName").val());
            var customerName = $.trim($("#contacts-customerName").val());
            var source = $("#contacts-source").val();
            var birth = $("#contacts-birth").val();
            $.ajax({
                url: "workbench/customer/getContactsByCondition.do",
                type: "post",
                dataType: "json",
                data: {
                    owner: owner,
                    fullName: fullName,
                    customerName: customerName,
                    source: source,
                    birth: birth,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    //获取总共数据条数
                    var totalRows = data.totalRows;
                    //在总共记录位置显示
                    $("#totalRows").html(totalRows);
                    //获取市场活动内容集合
                    var contactsList = data.dataList;
                    var htmlStr = "";
                    if (contactsList == "") {
                        htmlStr += "<tr style=\"color: grey\">";
                        htmlStr += "<td colspan='6' align='center'><h3>没有查询到数据</h3></td>";
                        htmlStr += "</tr>";
                    } else {
                        $.each(contactsList, function (index, obj) {
                            //针对没有添加过称呼的，让其不显示
                            if (obj.appellation == null) {
                                obj.appellation = "";
                            }
                            //针对客户名称，来源和生日，未添加情况时，给出提示信息
                            if (obj.customerName === "" || obj.customerName == null) {
                                obj.customerName = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (obj.source === "" || obj.source == null) {
                                obj.source = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (obj.birth === "" || obj.birth == null) {
                                obj.birth = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (index % 2 === 0) {
                                htmlStr += "<tr class=\"active\">";
                            } else {
                                htmlStr += "<tr>";
                            }
                            htmlStr += "<td><input type=\"checkbox\" class='innerCheck' value=\""
                                + obj.id + "\" \"/></td>";
                            htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" " +
                                "onclick=\"window.location.href='workbench/contacts/toDetail.do?id="
                                + obj.id + "';\">" + obj.fullName + obj.appellation + "</a></td>";
                            htmlStr += "<td>" + obj.customerName + "</td>";
                            htmlStr += "<td>" + obj.owner + "</td>";
                            htmlStr += "<td>" + obj.source + "</td>";
                            htmlStr += "<td>" + obj.birth + "</td>";
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
                            queryContacts(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }

            });

        }

    </script>
</head>
<body>


<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
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
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                            <input id="create-customerId" type="hidden">
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

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
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


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>联系人列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="contacts-owner" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">姓名</div>
                        <input id="contacts-fullName" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input id="contacts-customerName" class="form-control" type="text">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="contacts-source">
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
                    <div class="input-group">
                        <div class="input-group-addon">生日</div>
                        <input id="contacts-birth" class="form-control myDate" type="text" readonly>
                    </div>
                </div>

                <button id="queryButton" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createContactsButton" type="button" class="btn btn-primary"
                        data-toggle="modal" <%--data-target="#createContactsModal"--%>>
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editContactsButton" type="button" class="btn btn-default"
                        data-toggle="modal" <%--data-target="#editContactsModal"--%>><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteContactsButton" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="checkAll" type="checkbox"/></td>
                    <td>姓名</td>
                    <td>客户名称</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>生日</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a>
                    </td>
                    <td>动力节点</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>2000-10-10</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a>
                    </td>
                    <td>动力节点</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>2000-10-10</td>
                </tr>--%>
                </tbody>
            </table>
        </div>
        <div id="pagination" style="position: relative;top: 10px;"></div>
        <div style="height: 50px; position: relative;top: 0px;">
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