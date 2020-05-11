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
            queryTransaction(1, 10);

            //给创建交易按钮添加点击事件
            $("#createTransactionBtn").click(function () {
                //跳转到创建交易页面
                window.location.href = "workbench/transaction/toCreateTransaction.do";
            });

            //给查询按钮添加点击事件
            $("#queryButton").click(function () {
                //调用封装的查询函数
                //通过分页函数可以调用当前分页内的各类属性值
                queryTransaction(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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

            //给修改交易按钮添加点击事件
            $("#editTransactionBtn").click(function () {
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
                //跳转到创建交易页面
                window.location.href = "workbench/transaction/toModifyTransaction.do?id=" + id;
            });


            //给删除按钮添加点击事件
            $("#deleteTransactionBtn").click(function () {
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
                        url: "workbench/transaction/removeTransaction.do",
                        type: "post",
                        dataType: "json",
                        data: idList,
                        success: function (data) {
                            alert(data.message);
                            if (data.code === "1") {
                                //刷新页面
                                queryTransaction(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
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
        function queryTransaction(pageNo, pageSize) {
            var owner = $.trim($("#transaction-owner").val());
            var name = $.trim($("#transaction-name").val());
            var customerName = $.trim($("#transaction-customerName").val());
            var stage = $("#transaction-stage").val();
            var type = $("#transaction-type").val();
            var source = $("#transaction-source").val();
            var contactsName = $.trim($("#transaction-contactsName").val());
            $.ajax({
                url: "workbench/transaction/getTransactionByCondition.do",
                type: "post",
                dataType: "json",
                data: {
                    owner: owner,
                    name: name,
                    customerName: customerName,
                    stage: stage,
                    type: type,
                    source: source,
                    contactsName: contactsName,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    //获取总共数据条数
                    var totalRows = data.totalRows;
                    //在总共记录位置显示
                    $("#totalRows").html(totalRows);
                    //获取市场活动内容集合
                    var transactionList = data.dataList;
                    var htmlStr = "";
                    if (transactionList == "") {
                        htmlStr += "<tr style=\"color: grey\">";
                        htmlStr += "<td colspan='8' align='center'><h3>没有查询到数据</h3></td>";
                        htmlStr += "</tr>";
                    } else {
                        $.each(transactionList, function (index, obj) {
                            //针对座机和网站未添加，给出提示信息
                            if (obj.type === "" || obj.type == null) {
                                obj.type = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (obj.source === "" || obj.source == null) {
                                obj.source = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (obj.contactsName === "" || obj.contactsName == null) {
                                obj.contactsName = "<font style=\"color: darkgray;\"><i>未添加</i></font>";
                            }
                            if (index % 2 === 0) {
                                htmlStr += "<tr class=\"active\">";
                            } else {
                                htmlStr += "<tr>";
                            }
                            htmlStr += "<td><input type=\"checkbox\" class='innerCheck' value=\""
                                + obj.id + "\" \"/></td>";
                            htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" " +
                                "onclick=\"window.location.href='workbench/transaction/toDetail.do?id="
                                + obj.id + "';\">" + obj.name + "</a></td>";
                            htmlStr += "<td>" + obj.customerName + "</td>";
                            htmlStr += "<td>" + obj.stage + "</td>";
                            htmlStr += "<td>" + obj.type + "</td>";
                            htmlStr += "<td>" + obj.owner + "</td>";
                            htmlStr += "<td>" + obj.source + "</td>";
                            htmlStr += "<td>" + obj.contactsName + "</td>";
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
                            queryTransaction(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });

        }

    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
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
                        <input id="transaction-owner" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input id="transaction-name" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input id="transaction-customerName" class="form-control" type="text">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select id="transaction-stage" class="form-control">
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
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select id="transaction-type" class="form-control">
                            <option></option>
                            <c:if test="${not empty typeList}">
                                <c:forEach items="${typeList}" var="type">
                                    <option value="${type.id}">${type.value}</option>
                                </c:forEach>
                            </c:if>
                            <%--<option>已有业务</option>
                            <option>新业务</option>--%>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="transaction-source">
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
                        <div class="input-group-addon">联系人名称</div>
                        <input id="transaction-contactsName" class="form-control" type="text">
                    </div>
                </div>

                <button id="queryButton" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createTransactionBtn" type="button" class="btn btn-primary"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editTransactionBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteTransactionBtn" type="button" class="btn btn-danger"><span
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
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a>
                    </td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a>
                    </td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div id="pagination"></div>
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