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
        <div data-options="region: 'north', border: true, split:false, minHeight: 35, maxHeight:35"
             style="overflow: hidden; height: 35px;">
            <div id="tb"></div>
        </div>
        <div data-options="region:'center', border: false">
            <table class="quick4j-datagrid" id="mainGrid"
                   data-options="
                           name: 'leasers',
                           fit: true,
                           striped: true,
                           sortName: 'code',
                           singleSelect:true,
                           rownumbers:true"></table>
        </div>

        <!-- script -->
        <script src="static/js/vender/jquery-1.11.1.min.js"></script>
        <script src="static/js/vender/jquery.json-2.3.js"></script>
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
            });

            function initToolbar(){
                $('#tb').toolbar({
                    data:[{
                        text: '新建',
                        iconCls: 'icon-add',
                        handler: showNewDialog
                    },{
                        text: '编辑',
                        iconCls: 'icon-edit',
                        handler: showEditDialog
                    },{
                        text: '删除',
                        iconCls: 'icon-remove',
                        handler: doDelete
                    }]
                });
            }

            function showNewDialog(){
                var $MGrid = $('#mainGrid');

                $.showModalDialog({
                    title: '新建',
                    width: 400,
                    height: 150,
                    content: 'url:leasing/leaser/new',
                    data: {datagrid: $MGrid},
                    locate: 'document',
                    buttons:[{
                        text: '保存并继续新增',
                        iconCls: 'icon-save',
                        handler: 'doSaveAndNew',
                        disabled: false
                    },{
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: 'doSave',
                        disabled: false
                    },{
                        text: '关闭',
                        iconCls: 'icon-cancel',
                        handler: function(win){
                            win.close();
                        }
                    }],
                    onLoad: function(dialog, body){
                        if(body && body.doInitData){
                            body.doInitData(dialog);
                        }
                    }
                });
            }

            function showEditDialog(){
                var $MGrid = $('#mainGrid');
                var selectedRow = $MGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要编辑的商品!", "warning");
                    return;
                }


                $.showModalDialog({
                    title: '编辑',
                    width: 400,
                    height: 150,
                    content: 'url:leasing/leaser/'+selectedRow.id+'/edit',
                    data: {datagrid: $MGrid, leaser: selectedRow},
                    locate: 'document',
                    buttons:[{
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: 'doSave',
                        disabled: false
                    },{
                        text: '关闭',
                        iconCls: 'icon-cancel',
                        handler: function(dialog){
                            dialog.close();
                        }
                    }],
                    onLoad: function(dialog, body){
                        if(body && body.doInitData){
                            body.doInitData(dialog);
                        }
                    }
                });
            }

            function doDelete(){
                var $MGrid = $('#mainGrid');

                var selectedRow = $MGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要删除的商品!", "warning");
                    return;
                }

                $.messager.confirm('提示', '确认删除此条记录?', function(r){
                    if(r){
                        $.ajax({
                            url: 'leasing/leaser/' + selectedRow.id + '/delete',
                            success: function(data){
                                if(data.status == 200){
                                    $MGrid.datagrid('reload');
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
