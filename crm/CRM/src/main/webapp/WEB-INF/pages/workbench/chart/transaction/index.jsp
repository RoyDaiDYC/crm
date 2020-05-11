<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getLocalPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath %>">
    <title>演示Echarts使用</title>
    <script src="jquery/jquery-1.11.1-min.js"></script>
    <!-- 引入 echarts.js -->
    <script src="jquery/echars/echarts.min.js"></script>
    <script type="text/javascript">
        $(function () {
            //发送异步请求
            $.ajax({
                url: "workbench/chart/transaction/getTransactionFunnel.do",
                type: "post",
                dateType: "json",
                success: function (data) {
                    //调用echarts插件，把data传递给echarts，生成漏斗图
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    option = {
                        title: {
                            text: '交易统计图表',
                            subtext: '统计交易各阶段数据量'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}"
                        },
                        series: [
                            {
                                name: '数量',
                                type: 'funnel',
                                top:'20%',
                                left: '10%',
                                width: '70%',
                                label: {
                                    formatter: '{b}'
                                },
                                labelLine: {
                                    show: true
                                },
                                itemStyle: {
                                    opacity: 0.7
                                },
                                emphasis: {
                                    label: {
                                        position: 'inside',
                                        formatter: '{b}数量: {c}'
                                    }
                                },
                                data: data
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            });
        });
    </script>
</head>
<body>
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<div id="main" style="width: 800px;height:600px;"></div>
</body>
</html>
