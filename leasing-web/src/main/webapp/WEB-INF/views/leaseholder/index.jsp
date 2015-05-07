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
        <div data-options="region: 'north', border: true, split:false"
             style="overflow: hidden; height: 38px;">
            <div id="tb"></div>
        </div>
        <div data-options="region:'west', border: false, split:true, minWidth: 300, maxWidth: 300">
            <table class="quick4j-datagrid" id="leftGrid"
                   data-options="
                           name: 'holders',
                           fit: true,
                           striped: true,
                           singleSelect:true,
                           onLoadSuccess: callbackForLeftGrid"></table>
        </div>
        <div data-options="region:'center', border: false">
            <table class="quick4j-datagrid" id="rightGrid"
                   data-options="
                           name: 'projects',
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
            $(function () {
                initToolbar();
            });

            function callbackForLeftGrid(data){
                showDefaultGoodsType()
                registerRowClickForLeftGrid();
            }

            function registerRowClickForLeftGrid(){
                var $LGrid = $('#leftGrid');
                $LGrid.datagrid('addEventListener',{
                    name: 'onSelect',
                    handler: queryProjectByHolder
                });
            }

            function queryProjectByHolder(index, row){
                $('#rightGrid').datagrid('load',{
                    holderId: row.id
                });
            }

            function showDefaultGoodsType(){
                var $LGrid = $('#leftGrid');
                var count = $LGrid.datagrid('getRows').length;
                if(count>0){
                    $LGrid.datagrid('selectRow', 0);
                }
            }

            function initToolbar(){
                $('#tb').toolbar({
                    data:[{
                        text: '新建承建单位',
                        iconCls: 'icon-add',
                        handler: showNewHolderDialog
                    },{
                        text: '编辑承建单位',
                        iconCls: 'icon-edit',
                        handler: showEditHolderDialog
                    },{
                        text: '删除承建单位',
                        iconCls: 'icon-remove',
                        handler: doDeleteHolder
                    },'-',{
                        text: '新增工程',
                        iconCls: 'icon-add',
                        handler: showNewProjectDialog
                    },{
                        text: '编辑工程',
                        iconCls: 'icon-edit',
                        handler: showEditProjectDialog
                    },{
                        text: '删除工程',
                        iconCls: 'icon-remove',
                        handler: doDeleteProject
                    }]
                });
            }

            function showNewHolderDialog(){
                var $LGrid = $('#leftGrid');

                $.showModalDialog({
                    title: '新建--承建单位',
                    width: 400,
                    height: 150,
                    content: 'url:leasing/holder/new',
                    data: {datagrid: $LGrid},
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

            function showEditHolderDialog(){
                var $LGrid = $('#leftGrid');
                var selectedRow = $LGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要编辑的数据!", "warning");
                    return;
                }


                $.showModalDialog({
                    title: '编辑--承建单位',
                    width: 400,
                    height: 150,
                    content: 'url:leasing/holder/'+selectedRow.id+'/edit',
                    data: {datagrid: $LGrid, holder: selectedRow},
                    locate: 'document',
                    buttons:[{
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

            function showNewProjectDialog(){
                var $RGrid = $('#rightGrid');

                var holderId = getHolder();

                $.showModalDialog({
                    title: '新建--工程',
                    width: 400,
                    height: 200,
                    content: 'url:leasing/project/new',
                    data: {datagrid: $RGrid, holderId: holderId},
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
                        if(body&&body.doInitData){
                            body.doInitData(dialog);
                        }
                    }
                });
            }

            function showEditProjectDialog(){
                var $RGrid = $('#rightGrid');

                var selectedRow = $RGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要编辑的数据!", "warning");
                    return;
                }

                $.showModalDialog({
                    title: '编辑--工程',
                    width: 400,
                    height: 200,
                    content: 'url:leasing/project/'+selectedRow.id+'/edit',
                    data: {datagrid: $RGrid, project: selectedRow},
                    locate: 'document',
                    buttons:[{
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
                        if(body&&body.doInitData){
                            body.doInitData(dialog);
                        }
                    }
                });
            }

            function doDeleteHolder(){
                var $LGrid = $('#leftGrid');

                var selectedRow = $LGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要删除数据!", "warning");
                    return;
                }

                $.messager.confirm('提示', '确认删除当前数据?', function(r){
                    if(r){
                        $.ajax({
                            url: 'leasing/holder/' + selectedRow.id + '/delete',
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

            function doDeleteProject(){
                var $RGrid = $('#rightGrid');

                var selectedRow = $RGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要删除的数据!", "warning");
                    return;
                }

                $.messager.confirm('提示', '确认删除当前数据?', function(r){
                    if(r){
                        $.ajax({
                            url: 'leasing/project/' + selectedRow.id + '/delete',
                            success: function(data){
                                if(data.status == 200){
                                    $RGrid.datagrid('reload');
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

            function getHolder(){
                var $LGrid = $('#leftGrid');
                var holder;
                var selectedRow = $LGrid.datagrid('getSelected');
                if(!selectedRow){
                    var rows = $LGrid.datagrid('getRows');
                    if(rows.length > 0){
                        holder = rows[0].id;
                    }
                }else{
                    holder = selectedRow.id;
                }

                return holder;
            }
        </script>
    </body>
</html>
