<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <script type="text/javascript" src="jquery/amountFormatting/formatCurrencyTenThou.js"></script>

    <script type="text/javascript">

        $(function () {

            //当加载默认function函数时调用获取市场活动内容函数，给定默认值
            //首页号1和每页显示10行内容
            queryMarketActivities(1, 10);


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


            /*
            * 点击创建按钮，显示创建市场活动模态窗口，
            * 通过函数控制模态窗口显示和关闭
            * 点击创建按钮启动创建的模态窗口
            *
            * */
            $("#addMarketActivity").click(function () {

                //模态窗口启动
                $("#createActivityModal").modal("show");

                //获取用户信息，名称在拥有着下拉菜单显示，值为用户id
                $.ajax({
                    url: "workbench/activity/getAllUsers.do",
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        //获取的data是一个json数组，每个元素是一个user
                        // 遍历数组
                        //定义一个字符串来接收遍历后格式为html的数据
                        var result = "";
                        $.each(data, function (index, user) {
                            result += "<option value=\"" + user.id + "\">" + user.name + "</option>";
                        });
                        //获取的信息放入所有者下拉菜单
                        $("#create-marketActivityOwner").html(result);
                    }
                });

            });

            /*
            * 给创建市场活动的保存按钮添加点击事件
            * 1、检测名称不能为空
            * 2、日期要么全部不选，要么开始和结束都要选上，结束日期不能小于开始日期
            * 3、成本只能是非负整数
            * */
            $("#create-marketActivitySaveButton").click(function () {
                //获取参数
                //所有者
                var createMarketOwner = $("#create-marketActivityOwner").val();
                //名称
                var createMarketName = $.trim($("#create-marketActivityName").val());
                //开始日期
                var startDate = $("#create-startTime").val();
                //结束日期
                var endDate = $("#create-endTime").val();
                //成本
                var cost = $("#create-cost").val();
                //描述
                var describe = $("#create-describe").val();

                //设置一个变量控制检查是否通过
                var checkFlag = true;

                //光标移开检查内容

                //对提交内容进行检查
                function checkCreateInfo() {

                    if (createMarketOwner === "") {
                        $("#create-marketActivityOwnerMsg").html("所有者不能为空");
                        checkFlag = false;
                    } else {
                        $("#create-marketActivityOwnerMsg").html("");
                    }
                    //判断名称不为空
                    if (createMarketName === "") {
                        $("#create-marketActivityNameMsg").html("名称不能为空");
                        checkFlag = false;
                    } else {
                        $("#create-marketActivityNameMsg").html("");
                    }
                    //日期检查，要么都为空，要么都不为空，必须结束日期大于开始日期
                    if (startDate !== "" && endDate !== "") {
                        if (startDate > endDate) {
                            $("#create-dateCheckMsg").html("结束日期要大于开始日期");
                            $("#create-startDateMsg").html("");
                            $("#create-endDateMsg").html("");
                            checkFlag = false;
                        } else {
                            $("#create-dateCheckMsg").html("");
                            $("#create-startDateMsg").html("");
                            $("#create-endDateMsg").html("");
                        }
                    } else if (startDate !== "" || endDate !== "") {
                        if (startDate === "") {
                            $("#create-startDateMsg").html("有了结束日期开始日期不能为空");
                            $("#create-dateCheckMsg").html("");
                        } else {
                            $("#create-startDateMsg").html("");
                            $("#create-dateCheckMsg").html("");
                        }
                        if (endDate === "") {
                            $("#create-endDateMsg").html("有了开始日期结束日期不能为空");
                            $("#create-dateCheckMsg").html("");
                        } else {
                            $("#create-endDateMsg").html("");
                            $("#create-dateCheckMsg").html("");
                        }
                        checkFlag = false;
                    } else {
                        $("#create-endDateMsg").html("");
                        $("#create-startDateMsg").html("");
                        $("#create-dateCheckMsg").html("");
                    }

                    //非负整数的正则表达式：^\d+$，使用时放在斜杠“//”内
                    //使用test()函数可以测定左边值是否符合正则表达式
                    if (cost === "" || /^\d+$/.test(cost)) {
                        $("#create-costMsg").html("");
                    } else {
                        $("#create-costMsg").html("成本必须填写且只能是非负整数");
                        checkFlag = false;
                    }
                    return checkFlag;
                }

                if (checkCreateInfo()) {
                    $.ajax({
                        url: "workbench/activity/saveCreateMarketActivity.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            owner: createMarketOwner,
                            name: createMarketName,
                            startDate: startDate,
                            endDate: endDate,
                            cost: cost,
                            description: describe
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //关闭模态窗口页面
                                $("#createActivityModal").modal("hide");
                                //还原清空模态窗口内容,清空form表单内全部输入组件内容，0代表form表单对象内第一个对象
                                $("#createActivityForm")[0].reset();
                                queryMarketActivities(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                //继续显示页面
                                $("#createActivityModal").modal("show");
                            }
                        }

                    });
                }
            });

            //对创建市场活动的关闭按钮添加点击事件，点击后确认关闭清空模态窗口所有内容
            $("#create-marketActivityExitButton").click(function () {
                if (window.confirm("确定要关闭吗，关闭后内容不会保存")) {
                    $("#createActivityModal").modal("hide");
                    $("#createActivityForm")[0].reset();
                    $("#create-marketActivityOwnerMsg").html("");
                    $("#create-marketActivityNameMsg").html("");
                    $("#create-dateCheckMsg").html("");
                    $("#create-startDateMsg").html("");
                    $("#create-endDateMsg").html("");
                    $("#create-costMsg").html("");
                }
            });


            //给查询按钮添加点击事件
            $("#queryButton").click(function () {
                //调用封装的查询函数
                //通过分页函数可以调用当前分页内的各类属性值
                queryMarketActivities(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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
            * 给修改按钮添加点击事件
            * 只能对选中的一条进行修改，不选和多选都无法显示修改模态窗口，提示信息
            * */
            $("#modifyMarketActivity").click(function () {
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
                //发送异步请求
                $.ajax({
                    url: "workbench/activity/toModifyMarketingActivitiesById.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id
                    },
                    success: function (data) {
                        var htmlStr = "";
                        $.each(data.userList, function (index, obj) {
                            if (obj.id === data.marketingActivities.owner) {
                                htmlStr += "<option value=\"" + obj.id + "\" selected>" + obj.name + "</option>";
                            } else {
                                htmlStr += "<option value=\"" + obj.id + "\">" + obj.name + "</option>";
                            }
                        });
                        //获取的信息放入所有者下拉菜单
                        $("#edit-marketActivityOwner").html(htmlStr);

                        //把查询到的值赋值给对应内容下
                        $("#edit-marketActivityId").val(data.marketingActivities.id);
                        $("#edit-marketActivityName").val(data.marketingActivities.name);
                        $("#edit-startTime").val(data.marketingActivities.startDate);
                        $("#edit-endTime").val(data.marketingActivities.endDate);
                        $("#edit-cost").val(formatCurrencyTenThou(data.marketingActivities.cost));
                        $("#edit-describe").val(data.marketingActivities.description);

                        //显示模态窗口
                        $("#editActivityModal").modal("show");
                    }
                });
            });

            /*
            *
            * 对修改的保存按钮添加点击事件
            * */
            $("#edit-marketActivityUpdateButton").click(function () {

                /*
                * 获取元素，进行内容的判断
                *
                * */
                var id = $("#edit-marketActivityId").val();
                var editMarketOwner = $("#edit-marketActivityOwner").val();
                var editMarketName = $("#edit-marketActivityName").val();
                var startDate = $("#edit-startTime").val();
                var endDate = $("#edit-endTime").val();
                var cost = $("#edit-cost").val();
                var describe = $("#edit-describe").val();
                //进行判断
                //设置一个变量控制检查是否通过
                var checkFlag = true;

                //光标移开检查内容

                //对提交内容进行检查
                function checkEditInfo() {

                    if (editMarketOwner === "") {
                        $("#edit-marketActivityOwnerMsg").html("所有者不能为空");
                        checkFlag = false;
                    } else {
                        $("#edit-marketActivityOwnerMsg").html("");
                    }
                    //判断名称不为空
                    if (editMarketName === "") {
                        $("#edit-marketActivityNameMsg").html("名称不能为空");
                        checkFlag = false;
                    } else {
                        $("#edit-marketActivityNameMsg").html("");
                    }
                    //日期检查，要么都为空，要么都不为空，必须结束日期大于开始日期
                    if (startDate !== "" && endDate !== "") {
                        if (startDate > endDate) {
                            $("#edit-dateCheckMsg").html("结束日期要大于开始日期");
                            $("#edit-startDateMsg").html("");
                            $("#edit-endDateMsg").html("");
                            checkFlag = false;
                        } else {
                            $("#edit-dateCheckMsg").html("");
                            $("#edit-startDateMsg").html("");
                            $("#edit-endDateMsg").html("");
                        }
                    } else if (startDate !== "" || endDate !== "") {
                        if (startDate === "") {
                            $("#edit-startDateMsg").html("有了结束日期开始日期不能为空");
                            $("#edit-dateCheckMsg").html("");
                        } else {
                            $("#edit-startDateMsg").html("");
                            $("#edit-dateCheckMsg").html("");
                        }
                        if (endDate === "") {
                            $("#edit-endDateMsg").html("有了开始日期结束日期不能为空");
                            $("#edit-dateCheckMsg").html("");
                        } else {
                            $("#edit-endDateMsg").html("");
                            $("#edit-dateCheckMsg").html("");
                        }
                        checkFlag = false;
                    } else {
                        $("#edit-endDateMsg").html("");
                        $("#edit-startDateMsg").html("");
                        $("#edit-dateCheckMsg").html("");
                    }

                    //非负整数的正则表达式：^\d+$，使用时放在斜杠“//”内
                    //使用test()函数可以测定左边值是否符合正则表达式
                    if (cost === "" || /^\d+$/.test(cost)) {
                        $("#edit-costMsg").html("");
                    } else {
                        $("#edit-costMsg").html("成本必须填写且只能是非负整数");
                        checkFlag = false;
                    }
                    return checkFlag;
                }

                if (checkEditInfo()) {
                    $.ajax({
                        url: "workbench/activity/modifyMarketingActivities.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            id: id,
                            owner: editMarketOwner,
                            name: editMarketName,
                            startDate: startDate,
                            endDate: endDate,
                            cost: cost,
                            description: describe
                        },
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //关闭模态窗口页面
                                $("#editActivityModal").modal("hide");
                                //还原清空模态窗口内容,清空form表单内全部输入组件内容，0代表form表单对象内第一个对象
                                $("#editActivityForm")[0].reset();
                                //清空表单隐藏内容
                                $("#edit-marketActivityId").val("");
                                queryMarketActivities(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                //保持当前模态窗口
                                $("#editActivityModal").modal("show");
                            }
                        }

                    });
                }


            });


            //对修改市场活动的关闭按钮添加点击事件，点击后确认关闭清空模态窗口所有内容
            $("#edit-marketActivityExitButton").click(function () {
                if (window.confirm("确定要关闭吗，关闭后内容不会保存")) {
                    $("#editActivityModal").modal("hide");
                    $("#editActivityForm")[0].reset();
                    //清空隐藏标签内容
                    $("#edit-marketActivityId").val("");
                    $("#edit-marketActivityOwnerMsg").html("");
                    $("#edit-marketActivityNameMsg").html("");
                    $("#edit-dateCheckMsg").html("");
                    $("#edit-startDateMsg").html("");
                    $("#edit-endDateMsg").html("");
                    $("#edit-costMsg").html("");
                }
            });

            //对整块面板添加点击事件，点击后确认关闭清空模态窗口所有内容
            $(".btn-toolbar").click(function () {
                //创建模态窗口清空提示信息
                $("#create-marketActivityOwnerMsg").html("");
                $("#create-marketActivityNameMsg").html("");
                $("#create-dateCheckMsg").html("");
                $("#create-startDateMsg").html("");
                $("#create-endDateMsg").html("");
                $("#create-costMsg").html("");
                //修改模态窗口清空提示信息
                $("#edit-marketActivityOwnerMsg").html("");
                $("#edit-marketActivityNameMsg").html("");
                $("#edit-dateCheckMsg").html("");
                $("#edit-startDateMsg").html("");
                $("#edit-endDateMsg").html("");
                $("#edit-costMsg").html("");
                $("#fileMessage").html("");
            });


            /*
            * 给删除按钮添加点击事件
            * 检查选中情况
            * */
            $("#deleteButton").click(function () {
                var innerOnCheckBoxes = $("#tBody input[type='checkbox']:checked");
                if (innerOnCheckBoxes.size() === 0) {
                    alert("选中要进行删除的内容");
                    return;
                }

                var idList = "";
                $.each(innerOnCheckBoxes, function () {
                    idList += "id=" + this.value + "&";
                });
                idList = idList.substr(0, idList.length - 1);
                if (window.confirm("确定要删除吗？")) {
                    $.ajax({
                        url: "workbench/activity/deleteActivity.do",
                        type: "post",
                        dataType: "json",
                        data: idList,
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                queryMarketActivities(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
                            }
                        }
                    })
                }

            });

            /*
            * 对下载按钮（批量导出）创建点击事件
            * */

            $("#exportActivityAllBtn").click(function () {
                //下载文件首选是同步请求
                //通过页面发送请求
                window.location.href = "workbench/activity/downloadAll.do";
            });

            /*
            * 对下载按钮（选中导出）创建点击事件
            *
            * */
            $("#exportActivityXzBtn").click(function () {

                //判断选中情况
                var innerOnCheckBoxes = $("#tBody input[type='checkbox']:checked");
                if (innerOnCheckBoxes.size() === 0) {
                    alert("选择需要导出的内容");
                    return;
                }
                //获取点击的id
                var idList = "";
                $.each(innerOnCheckBoxes, function () {
                    idList += "id=" + this.value + "&";
                });
                //去除最后一位的&符号
                idList = idList.substr(0, idList.length - 1);
                if (window.confirm("确认要导出吗？")) {
                    window.location.href = "workbench/activity/downloadById.do?" + idList;
                }

            });


            //给模板下载按钮添加点击事件
            $("#exportActivityMbBtn").click(function () {
                window.location.href = "workbench/activity/downloadMb.do";
            });


            //给导入按钮添加点击事件
            $("#importActivityBtn").click(function () {
                //获取文件
                var activityFile = $("#activityFile")[0].files[0];
                //判断有没有文件
                if (activityFile == null) {
                    $("#fileMessage").html("请选择上传文件");
                    return;
                }
                //判断上传的文件是否是XLS/XLSX后缀
                var activityFileName = activityFile.name;
                var index = activityFileName.lastIndexOf(".");
                var activityFileSuffix = activityFileName.substr(index + 1);
                if (activityFileSuffix.toLowerCase() !== "xls") {
                    if (activityFileSuffix.toLowerCase() !== "xlsx") {
                        $("#fileMessage").html("仅支持后缀名为XLS/XLSX的文件");
                        return;
                    }
                }
                var activityFileSize = activityFile.size;
                if (activityFileSize > 5 * 1024 * 1024) {
                    $("#fileMessage").html("文件大小不能超过5MB");
                    return;
                }
                //把文件封装进多样类型数据内
                var formData = new FormData();
                formData.append("file", activityFile);

                if (window.confirm("确认导入吗？")) {
                    $.ajax({
                        url: "workbench/activity/importFile.do",
                        type: "post",
                        dataType: "json",
                        data: formData,
                        processData: false,//数据不做处理，原样输出
                        contentType: false,//不设置请求头内容
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //清空模态窗口内信息
                                $("#fileMessage").html("");
                                //跳转主页面
                                queryMarketActivities(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
                                //关闭模态窗口
                                $("#importActivityModal").modal("hide");
                            } else {
                                //保持模态窗口打开
                                $("#importActivityModal").modal("show");
                                //清空模态窗口内信息
                                $("#fileMessage").html("");
                            }
                        }
                    });
                }


            });

            $("#importActivityExitBtn").click(function () {
                $("#importActivityModal").modal("hide");
                $("#fileMessage").html("");
            });


        });


        //把查询页面信息（市场活动总信息和信息行数）封装到一个函数内
        /*
        * 查询函数在点击查询按钮和刚进入市场活动主页面被调用
        * 且在刚进入市场活动主页时给定默认页号和每页内容数
        * */
        function queryMarketActivities(pageNo, pageSize) {
            var name = $("#queryName").val();
            var owner = $("#queryOwner").val();
            var startDate = $("#queryStartDate").val();
            var endDate = $("#queryEndDate").val();
            $.ajax({
                url: "workbench/activity/getMarketingActivitiesByCondition.do",
                type: "post",
                dataType: "json",
                data: {
                    name: name,
                    owner: owner,
                    startDate: startDate,
                    endDate: endDate,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    //获取总共数据条数
                    var totalRows = data.totalRows;
                    //在总共记录位置显示
                    $("#totalRows").html(totalRows);
                    //获取市场活动内容集合
                    var marketActivityList = data.dataList;
                    var htmlStr = "";
                    if (marketActivityList == "") {
                        htmlStr += "<tr style=\"color: grey\">";
                        htmlStr += "<td colspan='5' align='center'><h3>没有查询到数据</h3></td>";
                        htmlStr += "</tr>";
                    } else {
                        $.each(marketActivityList, function (index, obj) {
                            //针对开始日期和结束日期都没有的，显示是提示“未添加”
                            if (obj.startDate === "" || obj.startDate == null) {
                                obj.startDate = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (obj.endDate === "" || obj.endDate == null) {
                                obj.endDate = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (index % 2 === 0) {
                                htmlStr += "<tr class=\"active\">";
                            } else {
                                htmlStr += "<tr>";
                            }
                            htmlStr += "<td><input type=\"checkbox\" class='innerCheck' value=\""
                                + obj.id + "\" \"/></td>";
                            htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" " +
                                "onclick=\"window.location.href='workbench/activity/toDetail.do?id="
                                + obj.id + "';\">" + obj.name + "</a></td>";
                            htmlStr += "<td>" + obj.owner + "</td>";
                            htmlStr += "<td>" + obj.startDate + "</td>";
                            htmlStr += "<td>" + obj.endDate + "</td>";
                            htmlStr += "</tr>";
                        });
                    }
                    //在指定位置显示用户数据内容
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
                            queryMarketActivities(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });

                }
            });
        }

    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="createActivityForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">

                            </select>
                            <span id="create-marketActivityOwnerMsg" style="color:red;"></span>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                            <span id="create-marketActivityNameMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-startTime" readonly>
                            <span id="create-startDateMsg" style="color: red"></span>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-endTime" readonly>
                            <span id="create-endDateMsg" style="color: red"></span>
                            <span id="create-dateCheckMsg" style="color: red"></span>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                            <span id="create-costMsg" style="color: red"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button id="create-marketActivityExitButton" type="button" class="btn btn-default">关闭</button>
                <button id="create-marketActivitySaveButton" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="editActivityForm" class="form-horizontal" role="form">
                    <input id="edit-marketActivityId" type="hidden">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                            <span id="edit-marketActivityOwnerMsg" style="color:red;"></span>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName">
                            <span id="edit-marketActivityNameMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-startTime" readonly>
                            <span id="edit-startDateMsg" style="color: red"></span>
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-endTime" readonly>
                            <span id="edit-endDateMsg" style="color: red"></span>
                            <span id="edit-dateCheckMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                            <span id="edit-costMsg" style="color: red"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button id="edit-marketActivityExitButton" type="button" class="btn btn-default">关闭</button>
                <button id="edit-marketActivityUpdateButton" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                    <span id="fileMessage" style="color: red"></span>
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -60px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS/XLSX的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        <li>为了能更加精确的检测上传文件里的内容，请对文件的最后一行进行空白格式化【使用格式刷格式初始化】</li>
                    </ul>
                    <button id="exportActivityMbBtn" type="button" class="btn btn-default"><span
                            class="glyphicon glyphicon-export"></span> 下载模板
                    </button>
                </div>
            </div>
            <div class="modal-footer">
                <button id="importActivityExitBtn" type="button" class="btn btn-default">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
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
                        <input id="queryName" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="queryOwner" class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control myDate" type="text" id="queryStartDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control myDate" type="text" id="queryEndDate" readonly/>
                    </div>
                </div>

                <button id="queryButton" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="addMarketActivity" type="button" class="btn btn-primary" data-toggle="modal"
                <%--data-target="#createActivityModal"--%>>
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="modifyMarketActivity" type="button" class="btn btn-default" data-toggle="modal"
                <%--data-target="#editActivityModal"--%>><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteButton" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
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
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--<tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2017-10-10</td>
                    <td>2017-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2017-10-10</td>
                    <td>2017-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>
        <div id="pagination"></div>
        <div style="height: 50px; position: relative; top: -10px">
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
            </div>--%>
            <%--<div style="position: relative;top: -88px; left: 285px;">
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