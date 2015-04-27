<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <%@include file="/static/global.inc"%>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <title></title>
        <link rel="stylesheet" href="static/css/upm.css">
        <link rel="stylesheet" href="static/js/vender/easyui/themes/default/easyui.css">
        <link rel="stylesheet" href="static/js/vender/easyui/themes/icon.css">
    </head>
    <body class="easyui-layout">
        <div data-options="region:'center', border: false" style="padding-top: 3px;">
            <div data-options="region: 'north', border: true"
                 style="overflow: hidden; height: 38px;">
                <div id="tb"></div>
            </div>
            <div data-options="region:'center', border: false" style="padding-top: 3px;">
                <div style="height:280px;width:800px;left:10%;position:relative;">
                    <div style="text-align: center;height: 40px;font-size: 20px; padding-top: 5px; letter-spacing: 8px;">
                        周转工具管理中心发料单
                    </div>
                    <div>
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 55px;">承租单位：</td>
                                <td id="holder" style="width: 200px;">${order.holderName}</td>
                                <td style="width: 32px;">日期：</td>
                                <td id="opentime" style="width: 80px;">${order.openTime}</td>
                                <td style="width: 32px;">车号：</td>
                                <td id="carnumber" style="width: 80px;">${order.carNumber}</td>
                                <td style="width: 32px;">编号：</td>
                                <td id="code" style="width: 140px;">${order.code}</td>
                            </tr>
                        </table>
                    </div>
                    <table class="quick4j-datagrid" style="height: 200px;"
                           id="details"
                           data-options="
                                name: 'leaseorderitems',
                                striped: true,
                                singleSelect:true,
                                queryParams: {orderId: '${order.id}'}">
                    </table>
                </div>
            </div>
        </div>

        <!-- script -->
        <script src="static/js/vender/jquery-1.11.1.min.js"></script>
        <script src="static/js/vender/jquery.json-2.3.js"></script>
        <script src="static/js/vender/moment-with-langs.min.js"></script>
        <script src="static/js/vender/easyui/jquery.easyui.min.js"></script>
        <script src="static/js/vender/easyui/jquery.easyui.patch.js"></script>
        <script src="static/js/vender/easyui/locale/easyui-lang-zh_CN.js"></script>
        <script src="static/js/jquery.easyui.extension.min.js"></script>
        <script src="static/js/quick4j.parser.js"></script>
        <script src="static/js/quick4j.datagrid.js"></script>
        <script src="static/js/quick4j.util.js"></script>
        <script>
            $(function(){
                initToolbar();

                var opentime = quick4j.util.dateFormate.format(${order.openTime}, 'YYYY-MM-DD');
                $('#opentime').text(opentime);
            });
            function initToolbar(){
                $('#tb').toolbar({
                    data:[{
                        id: 'tbBtnPrint',
                        text: '打印',
                        iconCls: 'icon-print',
                        handler: function(){}
                    }]
                });
            }
        </script>
    </body>
</html>
