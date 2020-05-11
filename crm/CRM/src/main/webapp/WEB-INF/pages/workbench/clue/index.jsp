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

            //当加载默认function函数时调用获取市场活动内容函数，给定默认值
            //首页号1和每页显示10行内容
            queryClue(1, 10);

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

            //检测创建模态窗口内，所有者，公司，姓名不能为空
            //检查邮箱格式，座机格式，网站格式，手机格式
            //设定一个变量来存储表单验证是否通过
            var checkCreateFormFlag = false;

            function checkCreateOwner() {
                var createOwner = $("#create-clueOwner").val();
                if (createOwner === "") {
                    $("#createOwnerMsg").html("所有者不能为空");
                    checkCreateFormFlag = false;
                } else {
                    $("#createOwnerMsg").html("");
                    checkCreateFormFlag = true;
                }
                return checkCreateFormFlag;
            }

            function checkCreateCompany() {
                var createCompany = $.trim($("#create-company").val());
                if (createCompany === "") {
                    $("#createCompanyMsg").html("公司不能为空");
                    checkCreateFormFlag = false;
                } else {
                    $("#createCompanyMsg").html("");
                    checkCreateFormFlag = true;
                }
                return checkCreateFormFlag;
            }

            function checkCreateSurname() {
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

            function checkCreateWebsite() {
                var createWebSite = $.trim($("#create-website").val());
                if (createWebSite === "" || /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/.test(createWebSite)) {
                    $("#createWebsiteMsg").html("");
                    checkCreateFormFlag = true;
                } else {
                    $("#createWebsiteMsg").html("网站格式不对");
                    checkCreateFormFlag = false;
                }
                return checkCreateFormFlag;
            }

            function checkCreateMphone() {
                var createMphone = $.trim($("#create-mphone").val());
                if (createMphone === "" || /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(caretMphone)) {
                    $("#createMphoneMsg").html("");
                    checkCreateFormFlag = true;
                } else {
                    $("#createMphoneMsg").html("手机号格式不对");
                    checkCreateFormFlag = false;
                }
                return checkCreateFormFlag;
            }

            $("#create-clueOwner").mousedown(function () {
                checkCreateOwner();
            });

            $("#create-company").blur(function () {
                checkCreateCompany();
            });

            $("#create-surname").blur(function () {
                checkCreateSurname();
            });

            $("#create-email").blur(function () {
                checkCreateEmail();
            });

            $("#create-phone").blur(function () {
                checkCreatePhone();
            });

            $("#create-website").blur(function () {
                checkCreateWebsite();
            });

            $("#create-mphone").blur(function () {
                checkCreateMphone();
            });

            function checkCreateForm() {
                checkCreateFormFlag = checkCreateOwner() && checkCreateCompany() &&
                    checkCreateSurname() && checkCreateSurname() &&
                    checkCreateEmail() && checkCreatePhone() &&
                    checkCreateWebsite() && checkCreateMphone();
                return checkCreateFormFlag;
            }

            //给创建按钮添加点击事件
            $("#createClueButton").click(function () {
                //显示创建线索模态窗口
                $("#createClueModal").modal("show");
            });
            //点击面板后，清空提示信息
            $(".btn-toolbar").click(function () {
                //清空创建模态窗口提示信息
                $("#createOwnerMsg").html("");
                $("#createCompanyMsg").html("");
                $("#createFullNameMsg").html("");
                $("#createEmailMsg").html("");
                $("#createPhoneMsg").html("");
                $("#createWebsiteMsg").html("");
                $("#createMphoneMsg").html("");
                //清空修改模态窗口提示信息
                $("#editOwnerMsg").html("");
                $("#editCompanyMsg").html("");
                $("#editFullNameMsg").html("");
                $("#editEmailMsg").html("");
                $("#editPhoneMsg").html("");
                $("#editWebsiteMsg").html("");
                $("#editMphoneMsg").html("");
            });
            //点击创建关闭按钮，清空表单内容
            $("#createClueExitBtn").click(function () {
                if (confirm("关闭不会保存当前内容")) {
                    //清空表单内容
                    $("#createClueForm")[0].reset();
                    //清空提示信息
                    $("#createOwnerMsg").html("");
                    $("#createCompanyMsg").html("");
                    $("#createFullNameMsg").html("");
                    $("#createEmailMsg").html("");
                    $("#createPhoneMsg").html("");
                    $("#createWebsiteMsg").html("");
                    $("#createMphoneMsg").html("");
                    //关闭模态窗口
                    $("#createClueModal").modal("hide");
                }
            });

            //给创建保存按钮添加点击事件
            $("#createClueSaveBtn").click(function () {
                var owner = $("#create-clueOwner").val();
                var company = $.trim($("#create-company").val());
                var appellation = $("#create-call").val();
                var fullName = $.trim($("#create-surname").val());
                var job = $.trim($("#create-job").val());
                var email = $.trim($("#create-email").val());
                var phone = $.trim($("#create-phone").val());
                var website = $.trim($("#create-website").val());
                var mphone = $.trim($("#create-mphone").val());
                var state = $("#create-status").val();
                var source = $("#create-source").val();
                var description = $.trim($("#create-describe").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $.trim($("#create-address").val());

                if (checkCreateForm()) {
                    $.ajax({
                        url: "workbench/clue/saveCreateClue.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            owner: owner,
                            company: company,
                            appellation: appellation,
                            fullName: fullName,
                            job: job,
                            email: email,
                            phone: phone,
                            website: website,
                            mphone: mphone,
                            state: state,
                            source: source,
                            description: description,
                            contactSummary: contactSummary,
                            nextContactTime: nextContactTime,
                            address: address
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //清空表单内容
                                $("#createClueForm")[0].reset();
                                //清空提示信息
                                $("#createOwnerMsg").html("");
                                $("#createCompanyMsg").html("");
                                $("#createFullNameMsg").html("");
                                $("#createEmailMsg").html("");
                                $("#createPhoneMsg").html("");
                                $("#createWebsiteMsg").html("");
                                $("#createMphoneMsg").html("");
                                //关闭模态窗口
                                $("#createClueModal").modal("hide");
                                //刷新页面
                                queryClue(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                //保持当前模态窗口
                                $("#createClueModal").modal("show");
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
                queryClue(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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


            /*
            * 检测修改模态窗口内，所有者，姓名，公司不能为空
            * 检查邮箱格式，座机格式，网站格式，手机格式
            * 设定一个变量来存储表单验证是否通过
            * */
            var checkEditFormFlag = false;

            function checkEditOwner() {
                var editOwner = $("#edit-clueOwner").val();
                if (editOwner === "") {
                    $("#editOwnerMsg").html("所有者不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editOwnerMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditCompany() {
                var editCompany = $.trim($("#edit-company").val());
                if (editCompany === "") {
                    $("#editCompanyMsg").html("公司不能为空");
                    checkEditFormFlag = false;
                } else {
                    $("#editCompanyMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
            }

            function checkEditSurname() {
                var editFullname = $.trim($("#edit-surname").val());
                if (editFullname === "") {
                    $("#editFullNameMsg").html("姓名不能为空");
                    checkeditFormFlag = false;
                } else {
                    $("#editFullNameMsg").html("");
                    checkEditFormFlag = true;
                }
                return checkEditFormFlag;
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

            function checkEditWebsite() {
                var editWebSite = $.trim($("#edit-website").val());
                if (editWebSite === "" || /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/.test(editWebSite)) {
                    $("#editWebsiteMsg").html("");
                    checkEditFormFlag = true;
                } else {
                    $("#editWebsiteMsg").html("网站格式不对");
                    checkEditFormFlag = false;
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
                return checkEditFormFlag;
            }

            $("#edit-clueOwner").mousedown(function () {
                checkEditOwner();
            });

            $("#edit-company").blur(function () {
                checkEditCompany();
            });

            $("#edit-surname").blur(function () {
                checkEditSurname();
            });

            $("#edit-email").blur(function () {
                checkEditEmail();
            });

            $("#edit-phone").blur(function () {
                checkEditPhone();
            });

            $("#edit-website").blur(function () {
                checkEditWebsite();
            });

            $("#edit-mphone").blur(function () {
                checkEditMphone();
            });

            function checkEditForm() {
                checkEditFormFlag = checkEditOwner() && checkEditCompany() &&
                    checkEditSurname() && checkEditEmail() &&
                    checkEditPhone() && checkEditWebsite() && checkEditMphone();
                return checkEditFormFlag;
            }


            /*
            *
            * 给修改按钮添加点击事件
            * 只能对选中的一条进行修改，不选和多选都无法显示修改模态窗口，提示信息
            * */
            $("#editClueButton").click(function () {

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
                    url: "workbench/clue/toModifyClueById.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id
                    },
                    success: function (data) {
                        var htmlStr = "";
                        htmlStr += "<option></option>";
                        $.each(data.userList, function (index, obj) {
                            if (obj.id === data.clue.owner) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.name + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.name + "</option>";
                            }
                        });
                        $("#edit-clueOwner").html(htmlStr);
                        //重置
                        htmlStr = "";
                        htmlStr += "<option></option>";
                        $.each(data.appellationList, function (index, obj) {
                            if (obj.id === data.clue.appellation) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.value + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.value + "</option>";
                            }

                        });
                        $("#edit-call").html(htmlStr);
                        //重置
                        htmlStr = "";
                        htmlStr += "<option></option>";
                        $.each(data.clueStateList, function (index, obj) {
                            if (obj.id === data.clue.state) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.value + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.value + "</option>";
                            }
                        });
                        $("#edit-status").html(htmlStr);
                        //重置
                        htmlStr = "";
                        htmlStr += "<option></option>";
                        $.each(data.sourceList, function (index, obj) {
                            if (obj.id === data.clue.source) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.value + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.value + "</option>";
                            }
                        });
                        $("#edit-source").html(htmlStr);

                        //把信息放入指定位置
                        $("#edit-clueId").val(data.clue.id);
                        $("#edit-company").val(data.clue.company);
                        $("#edit-surname").val(data.clue.fullName);
                        $("#edit-job").val(data.clue.job);
                        $("#edit-email").val(data.clue.email);
                        $("#edit-phone").val(data.clue.phone);
                        $("#edit-website").val(data.clue.website);
                        $("#edit-mphone").val(data.clue.mphone);
                        $("#edit-describe").val(data.clue.description);
                        $("#edit-contactSummary").val(data.clue.contactSummary);
                        $("#edit-nextContactTime").val(data.clue.nextContactTime);
                        $("#edit-address").val(data.clue.address);
                        //显示模态窗口
                        $("#editClueModal").modal("show");
                    }

                });
            });


            //点击修改关闭按钮，清空表单内容
            $("#editClueExitBtn").click(function () {
                if (confirm("关闭不会保存当前内容")) {
                    //清空表单内容
                    $("#editClueForm")[0].reset();
                    //清空提示信息
                    $("#editOwnerMsg").html("");
                    $("#editCompanyMsg").html("");
                    $("#editFullNameMsg").html("");
                    $("#editEmailMsg").html("");
                    $("#editPhoneMsg").html("");
                    $("#editWebsiteMsg").html("");
                    $("#editMphoneMsg").html("");
                    //关闭模态窗口
                    $("#editClueModal").modal("hide");
                }
            });


            /*
            *
            * 给修改模态窗口的保存按钮添加点击事件
            * */
            $("#editClueUpdateBtn").click(function () {
                //收集参数
                var id = $("#edit-clueId").val();
                var owner = $("#edit-clueOwner").val();
                var company = $.trim($("#edit-company").val());
                var appellation = $("#edit-call").val();
                var fullName = $.trim($("#edit-surname").val());
                var job = $.trim($("#edit-job").val());
                var email = $.trim($("#edit-email").val());
                var phone = $.trim($("#edit-phone").val());
                var website = $.trim($("#edit-website").val());
                var mphone = $.trim($("#edit-mphone").val());
                var state = $("#edit-status").val();
                var source = $("#edit-source").val();
                var description = $.trim($("#edit-describe").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $.trim($("#edit-address").val());

                if (checkEditForm()) {
                    $.ajax({
                        url: "workbench/clue/modifyClue.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            id: id,
                            owner: owner,
                            company: company,
                            appellation: appellation,
                            fullName: fullName,
                            job: job,
                            email: email,
                            phone: phone,
                            website: website,
                            mphone: mphone,
                            state: state,
                            source: source,
                            description: description,
                            contactSummary: contactSummary,
                            nextContactTime: nextContactTime,
                            address: address
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //清空表单内容
                                $("#editClueForm")[0].reset();
                                //清空提示信息
                                $("#editOwnerMsg").html("");
                                $("#editCompanyMsg").html("");
                                $("#editFullNameMsg").html("");
                                $("#editEmailMsg").html("");
                                $("#editPhoneMsg").html("");
                                $("#editWebsiteMsg").html("");
                                $("#editMphoneMsg").html("");
                                //关闭模态窗口
                                $("#editClueModal").modal("hide");
                                //刷新页面
                                queryClue(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                //保持模态窗口页面显示
                                $("#editClueModal").modal("show");
                            }
                        }
                    });
                } else {
                    alert("请检查表单内容");
                }
            });

            /*
            * 给删除按钮添加点击事件
            * 判断选中的条目，未选中给出提示信息，对选中内容进行异步请求删除
            *
            * */
            $("#deleteBtn").click(function () {
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
                //发送异步请求
                if (window.confirm("确定要删除吗？")) {
                    $.ajax({
                        url: "workbench/clue/deleteClue.do",
                        type: "post",
                        dataType: "json",
                        data: idList,
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //刷新页面
                                queryClue(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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
        function queryClue(pageNo, pageSize) {
            var fullName = $.trim($("#fullName").val());
            var company = $.trim($("#company").val());
            var phone = $.trim($("#phone").val());
            var source = $("#source").val();
            var owner = $.trim($("#owner").val());
            var mphone = $.trim($("#mphone").val());
            var state = $("#state").val();
            $.ajax({
                url: "workbench/clue/getClueByCondition.do",
                type: "post",
                dataType: "json",
                data: {
                    fullName: fullName,
                    company: company,
                    phone: phone,
                    source: source,
                    owner: owner,
                    mphone: mphone,
                    state: state,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    //获取总共数据条数
                    var totalRows = data.totalRows;
                    //在总共记录位置显示
                    $("#totalRows").html(totalRows);
                    //获取市场活动内容集合
                    var clueList = data.dataList;
                    var htmlStr = "";
                    if (clueList == "") {
                        htmlStr += "<tr style=\"color: grey\">";
                        htmlStr += "<td colspan='7' align='center'><h3>没有查询到数据</h3></td>";
                        htmlStr += "</tr>";
                    } else {
                        $.each(clueList, function (index, obj) {
                            //针对没有添加过称呼的，让其不显示
                            if (obj.appellation == null) {
                                obj.appellation = "";
                            }
                            //针对公司座机，手机，线索来源，线索状态没有添加的，提示信息
                            if (obj.phone === "" || obj.phone == null) {
                                obj.phone = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (obj.mphone === "" || obj.mphone == null) {
                                obj.mphone = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (obj.source === "" || obj.source == null) {
                                obj.source = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (obj.state === "" || obj.state == null) {
                                obj.state = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (index % 2 === 0) {
                                htmlStr += "<tr class=\"active\">";
                            } else {
                                htmlStr += "<tr>";
                            }
                            htmlStr += "<td><input type=\"checkbox\" class='innerCheck' value=\""
                                + obj.id + "\" \"/></td>";
                            htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" " +
                                "onclick=\"window.location.href='workbench/clue/toDetail.do?id="
                                + obj.id + "';\">" + obj.fullName + obj.appellation + "</a></td>";
                            htmlStr += "<td>" + obj.company + "</td>";
                            htmlStr += "<td>" + obj.phone + "</td>";
                            htmlStr += "<td>" + obj.mphone + "</td>";
                            htmlStr += "<td>" + obj.source + "</td>";
                            htmlStr += "<td>" + obj.owner + "</td>";
                            htmlStr += "<td>" + obj.state + "</td>";
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
                            queryClue(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }

            });

        }


    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%; height: 135%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form id="createClueForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                                <option></option>
                                <c:if test="${not empty userList}">
                                    <c:forEach items="${userList}" var="user">
                                        <option value="${user.id}">${user.name}</option>
                                    </c:forEach>
                                </c:if>
                            </select>
                            <span id="createOwnerMsg" style="color: red;"></span>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                        <span id="createCompanyMsg" style="color: red"></span>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <c:if test="${not empty appellationList}">
                                    <c:forEach items="${appellationList}" var="appellation">
                                        <option value="${appellation.id}">${appellation.value}</option>
                                    </c:forEach>
                                </c:if>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                            <span id="createFullNameMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                            <span id="createEmailMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                            <span id="createPhoneMsg" style="color: red"></span>
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                            <span id="createWebsiteMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                            <span id="createMphoneMsg" style="color: red"></span>
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-status">
                                <option></option>
                                <c:if test="${not empty clueStateList}">
                                    <c:forEach items="${clueStateList}" var="clueState">
                                        <option value="${clueState.id}">${clueState.value}</option>
                                    </c:forEach>
                                </c:if>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:if test="${not empty sourceList}">
                                    <c:forEach items="${sourceList}" var="source">
                                        <option value="${source.id}">${source.value}</option>
                                    </c:forEach>
                                </c:if>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
                <button id="createClueExitBtn" type="button" class="btn btn-default" <%--data-dismiss="modal"--%>>关闭
                </button>
                <button id="createClueSaveBtn" type="button" class="btn btn-primary" <%--data-dismiss="modal"--%>>保存
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;height: 135%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form id="editClueForm" class="form-horizontal" role="form">
                    <input id="edit-clueId" type="hidden">
                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueOwner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                            <span id="editOwnerMsg" style="color: red;"></span>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" <%--value="动力节点"--%>>
                            <span id="editCompanyMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
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
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" <%--value="李四"--%>>
                            <span id="editFullNameMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" <%--value="CTO"--%>>
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control"
                                   id="edit-email" <%--value="lisi@bjpowernode.com"--%>>
                            <span id="editEmailMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" <%--value="010-84846003"--%>>
                            <span id="editPhoneMsg" style="color: red"></span>
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                            <%--value="http://www.bjpowernode.com"--%>>
                            <span id="editWebsiteMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" <%--value="12345678901"--%>>
                            <span id="editMphoneMsg" style="color: red"></span>
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-status">
                                <%--<option></option>
                                <option>试图联系</option>
                                <option>将来联系</option>
                                <option selected>已联系</option>
                                <option>虚假线索</option>
                                <option>丢失线索</option>
                                <option>未联系</option>
                                <option>需要条件</option>--%>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
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
                <button id="editClueExitBtn" type="button" class="btn btn-default" <%--data-dismiss="modal"--%>>关闭
                </button>
                <button id="editClueUpdateBtn" type="button" class="btn btn-primary" <%--data-dismiss="modal"--%>>更新
                </button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input id="fullName" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input id="company" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input id="phone" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select id="source" class="form-control">
                            <option></option>
                            <c:if test="${not empty sourceList}">
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="owner" class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input id="mphone" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select id="state" class="form-control">
                            <option></option>
                            <c:if test="${not empty clueStateList}">
                                <c:forEach items="${clueStateList}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>

                <button id="queryButton" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createClueButton" type="button" class="btn btn-primary" data-toggle="modal"
                <%--data-target="#createClueModal"--%>><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editClueButton" type="button" class="btn btn-default"
                        data-toggle="modal" <%--data-target="#editClueModal"--%>><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteBtn" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="checkAll" type="checkbox"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a>
                    </td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a>
                    </td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>--%>
                </tbody>
            </table>
        </div>
        <div id="pagination" style="position: relative;top: 40px;"></div>
        <div style="height: 50px; position: relative;top: 30px;">
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