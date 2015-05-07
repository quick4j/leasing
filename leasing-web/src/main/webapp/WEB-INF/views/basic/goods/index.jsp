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
                   name: 'goodsType',
                   fit: true,
                   striped: true,
                   sortName: 'code',
                   singleSelect:true,
                   onLoadSuccess: callbackForLeftGrid"></table>
        </div>
        <div data-options="region:'center', border: false">
            <table class="quick4j-datagrid" id="rightGrid"
                   data-options="
                   name: 'goods',
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
                    handler: queryGoodsByType
                });
            }

            function queryGoodsByType(index, row){
                $('#rightGrid').datagrid('load',{
                    type: row.id
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
                        text: '新增商品分类',
                        iconCls: 'icon-add',
                        handler: showNewGoodsTypeDialog
                    },{
                        text: '编辑商品分类',
                        iconCls: 'icon-edit',
                        handler: showEditGoodsTypeDialog
                    },{
                        text: '删除商品分类',
                        iconCls: 'icon-remove',
                        handler: doDeleteGoodsType
                    },'-',{
                        text: '新增商品',
                        iconCls: 'icon-add',
                        handler: showNewGoodsDialog
                    },{
                        text: '编辑商品',
                        iconCls: 'icon-edit',
                        handler: showEditGoodsDialog
                    },{
                        text: '删除商品',
                        iconCls: 'icon-remove',
                        handler: doDeleteGoods
                    }]
                });
            }

            function showNewGoodsTypeDialog(){
                var $LGrid = $('#leftGrid');

                $.showModalDialog({
                    title: '新建',
                    width: 400,
                    height: 150,
                    content: 'url:leasing/basic/goods/type/new',
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

            function showEditGoodsTypeDialog(){
                var $LGrid = $('#leftGrid');
                var selectedRow = $LGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要编辑的商品!", "warning");
                    return;
                }


                $.showModalDialog({
                    title: '编辑',
                    width: 400,
                    height: 150,
                    content: 'url:leasing/basic/goods/type/edit',
                    data: {datagrid: $LGrid, goodsType: selectedRow},
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

            function showNewGoodsDialog(){
                var $RGrid = $('#rightGrid');

                var goodsType = getGoodsType();

                $.showModalDialog({
                    title: '新建',
                    width: 500,
                    height: 300,
                    content: 'url:leasing/basic/goods/new',
                    data: {datagrid: $RGrid, goodsType: goodsType},
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

            function showEditGoodsDialog(){
                var $RGrid = $('#rightGrid');

                var selectedRow = $RGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要编辑的商品!", "warning");
                    return;
                }

                $.showModalDialog({
                    title: '编辑',
                    width: 500,
                    height: 300,
                    content: 'url:leasing/basic/goods/edit',
                    data: {datagrid: $RGrid, goods: selectedRow},
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

            function doDeleteGoodsType(){
                var $LGrid = $('#leftGrid');

                var selectedRow = $LGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要删除的商品分类!", "warning");
                    return;
                }

                $.messager.confirm('提示', '确认删除此条记录?', function(r){
                    if(r){
                        $.ajax({
                            url: 'leasing/basic/goods/type/' + selectedRow.id + '/delete',
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

            function doDeleteGoods(){
                var $RGrid = $('#rightGrid');

                var selectedRow = $RGrid.datagrid('getSelected');
                if(!selectedRow){
                    $.messager.alert("警告", "请选择要删除的商品!", "warning");
                    return;
                }

                $.messager.confirm('提示', '确认删除此条记录?', function(r){
                    if(r){
                        $.ajax({
                            url: 'leasing/basic/goods/' + selectedRow.id + '/delete',
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

            function getGoodsType(){
                var $LGrid = $('#leftGrid');
                var goodsType;
                var selectedRow = $LGrid.datagrid('getSelected');
                if(!selectedRow){
                    var rows = $LGrid.datagrid('getRows');
                    if(rows.length > 0){
                        goodsType = rows[0].id;
                    }
                }else{
                    goodsType = selectedRow.id;
                }

                return goodsType;
            }
        </script>
    </body>
</html>
