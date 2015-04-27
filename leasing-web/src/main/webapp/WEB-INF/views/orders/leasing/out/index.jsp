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
        <!-- toolbar -->
        <div data-options="region: 'north', border: true"
             style="overflow: hidden; height: 38px;">
            <div id="topToolbar"></div>
        </div>
        <!-- 单据明细 -->
        <div data-options="region:'south', split:true" style="height: 50%;">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region: 'north'"
                     style="overflow: hidden; height: 38px;">
                    <div id="tb"></div>
                </div>
                <div data-options="region:'center', border: false" style="padding-top: 3px;">
                    <div style="height:280px;width:800px;left:10%;position:relative;">
                        <div class="order-sm-title">
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
            </div>
        </div>
        <!-- 列表 -->
        <div data-options="region:'center'">
            <table class="quick4j-datagrid" id="orders"
                   data-options="
                    name: 'leaseorders',
                    fit: true,
                    striped: true,
                    border:false,
                    singleSelect:true,
                    rownumbers: true,
                    queryParams: {type: 'OUT'},
                    pagination: true,
                    onClickRow: showOrderDetail"></table>
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
                initTopToolbar();
            });

            function formateHolder(value,row,index){
                return row.projectName + '(' + value + ')';
            }

            function formateOpenTime(value,row,index){
                return quick4j.util.dateFormate.format(value, 'YYYY-MM-DD');
            }

            function showOrderDetail(index, row){
                var holder = row.projectName + '(' + row.holderName + ')';
                $('#holder').text(holder);
                var opentime = quick4j.util.dateFormate.format(row.openTime, 'YYYY-MM-DD');
                $('#opentime').text(opentime);
                $('#carnumber').text(row.carNumber);
                $('#code').text(row.code);

                $('#details').datagrid('reload', {
                    _loading: true,
                    orderId: row.id
                });
            }

            function clearOrderDetail(){
                $('#holder').text('');
                $('#opentime').text('');
                $('#carnumber').text('');
                $('#code').text('');

                $('#details').datagrid('loadData',{});
            }

            function initTopToolbar(){
                $('#topToolbar').toolbar({
                    data:[{
                        id: 'tbBtnNew',
                        text: '新建',
                        iconCls: 'icon-add',
                        handler: doNewDialog
                    },'-',{
                        id: 'tbBtnEdit',
                        text: '编辑',
                        iconCls: 'icon-edit',
                        handler: doEditDialog
                    },'-',{
                        id: 'tbBtnDelete',
                        text: '删除',
                        iconCls: 'icon-remove',
                        handler: doDelete
                    }]
                });
            }

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

            function doNewDialog(){
                $.showModalDialog({
                    title: '新建--发料单',
                    content: 'url:leasing/orders/leaseorder/out/new',
                    useiframe: true,
                    height: '90%',
                    width: '90%'
                });
            }

            function doEditDialog(){
                var $LGrid = $('#orders');

                var selected = $LGrid.datagrid('getSelected');
                if(!selected){
                    $.messager.alert("警告", "请选择要编辑的数据!", "warning");
                    return;
                }

                $.showModalDialog({
                    title: '新建--发料单',
                    content: 'url:leasing/orders/leaseorder/out/' + selected.id + '/edit',
                    useiframe: true,
                    height: '90%',
                    width: '90%'
                });
            }

            function doDelete(){
                var $LGrid = $('#orders');

                var selectedRow = $LGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要删除的单据!", "warning");
                    return;
                }

                $.messager.confirm('提示', '确认删除此条记录?', function(r){
                    if(r){
                        $.ajax({
                            url: 'leasing/orders/leaseorder/out/' + selectedRow.id + '/delete',
                            success: function(data){
                                if(data.status == 200){
                                    $LGrid.datagrid('reload');
                                }else{
                                    $.messager.alert('错误', data.status + '<br>' + data.message, 'error');
                                }
                            },
                            error: function(){
                                $.messager.alert('错误', '操作过程中发生错误。', 'error');
                            }
                        });
                    }
                });
            }
        </script>
    </body>
</html>
