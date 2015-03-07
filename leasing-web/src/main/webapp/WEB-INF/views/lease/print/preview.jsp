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
            <div style="height:280px;width:800px;left:10%;position:relative;">
                <div class="order-title">
                    周转工具管理中心发料单
                </div>
                <div>
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 55px;">承租单位：</td>
                            <td id="holder" style="width: 200px;"></td>
                            <td style="width: 32px;">日期：</td>
                            <td id="opentime" style="width: 80px;"></td>
                            <td style="width: 32px;">车号：</td>
                            <td id="carnumber" style="width: 80px;"></td>
                            <td style="width: 32px;">编号：</td>
                            <td id="code" style="width: 140px;"></td>
                        </tr>
                    </table>
                </div>
                <table class="quick4j-datagrid" style="height: 200px;"
                       id="details"
                       data-options="
                        name: 'leaseorderitems',
                        striped: true,
                        queryParams: {_loading: false},
                        onBeforeLoad: function(param){
                            return param._loading;
                        }">
                </table>
            </div>
        </div>
    </body>
</html>
