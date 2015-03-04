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
        <style>
            .label{width: 100px; text-align: right;}
        </style>
    </head>
    <body class="easyui-layout">
        <div data-options="region: 'north', border: true, minHeight: 37, split: false, maxHeight:37"
             style="overflow: hidden; height: 37px;">
            <div id="tb"></div>
        </div>
        <div data-options="region:'center', border: false" style="padding: 10px 30px 60px 30px;">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north', split: false, border:false" style="height:150px;">
                    <div class="order-title">周转工具管理中心发料单</div>
                    <div>
                        <table>
                            <tr>
                                <td class="label">编号：</td>
                                <td>保存后自动生成</td>
                                <td class="label">日期：</td>
                                <td><input id="openTime"></td>
                            </tr>
                            <tr>
                                <td class="label">承租单位：</td>
                                <td colspan="3">
                                    <input type="hidden" id="holderId">
                                    <input type="hidden" id="holderName">
                                    <input type="hidden" id="projectId">
                                    <input type="hidden" id="projectName">
                                    <input style="width: 100%" id="holder" tabindex="1">
                                </td>
                            </tr>
                            <tr>
                                <td class="label">车号：</td>
                                <td><input class="easyui-textbox" id="carnumber" tabindex="2"></td>
                                <td class="label">制单人：</td>
                                <td>张三</td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div data-options="region:'south', split: false, border:false" style="height:100px;">
                    <div style="padding-left: 10px; padding-top: 10px; color: #0000ff; font-size: 14px;">
                        提示：
                        <ul style="margin: 0">
                            <li>
                                凡是显示<span style="color: red">红色</span>输入框的都是必填项。
                            </li>
                            <li>
                                选中单据体的某一项后，则进入行编辑状态。此时可以添加（或修改）料具内容。
                            </li>
                            <li>
                                在单据体的<strong>“件数”栏</strong>按<strong>“enter键”</strong>，可结束当前行编辑状态，并新增一行，按<strong>“ctrl+enter键”</strong>可结束当前行编辑状态。
                            </li>
                        </ul>
                    </div>
                </div>
                <div data-options="region:'center', border: false">
                    <table id="items"></table>
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
            });

            function initToolbar(){
                $('#tb').toolbar({
                    data:[{
                        id: 'tbBtnSave',
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: leaseOrder.save
                    },{
                        id: 'tbBtnPrint',
                        text: '打印',
                        iconCls: 'icon-print',
                        disabled: true,
                        handler: function(){}
                    }]
                });
            }

            var leaseOrder = (function(){
                var editingIndex = -1,
                    continueEditing = false,
                    $itemGrid = $('#items'),
                    $hodlerPlugin = $("#holder"),
                    initItemGrid = function(){
                        $itemGrid.datagrid({
                            columns:[[
                                {field: 'goodsCode', title: '料具助记码', width: 100, halign: 'center',
                                    editor:{
                                        type:'textbox',
                                        options: {
                                            buttonIcon: 'icon-search',
                                            width: 150,
                                            onClickButton: function(){
                                                showSearchGoodsDialog();
                                            }
                                        }
                                    }
                                },
                                {field: 'goodsName', title: '料具名称', width: 150, halign: 'center',
                                    editor: {
                                        type: 'textbox',
                                        options: {
                                            editable: false,
                                            required:true
                                        }
                                    }
                                },
                                {field: 'goodsSpec', title: '规格型号', width: 150, halign: 'center',
                                    editor: {
                                        type: 'textbox',
                                        options: {
                                            editable: false
                                        }
                                    }
                                },
                                {field: 'goodsLocation', title: '库位', width: 80, halign: 'center', editor: 'numberbox'},
                                {field: 'packages', title: '件数', width: 100, halign: 'center',
                                    editor: {
                                        type: 'numberbox',
                                        options: {
                                            validType: {min: 1},
                                            required:true
                                        }
                                    }
                                },
                                {field: 'numbers', title: '数量', width: 100, halign: 'center',
                                    editor: {
                                        type: 'numberbox',
                                        options:{
                                            precision:1,
                                            editable: false
                                        }
                                    }
                                },
                                {field: 'oper', title: '操作', width: 80, halign: 'center',
                                    formatter: function(value,row,index){
                                        return '<div class="icon-remove" style="height: 16px; width: 16px; cursor: pointer;" title="删除当前行" onclick="leaseOrder.deleteItem('+index+')"></div>';
                                    }
                                }

                            ]],
                            rownumbers: true,
                            fit: true,
                            striped: true,
                            singleSelect: true,
                            toolbar: [{
                                text:'添加新行',
                                iconCls: 'icon-add',
                                handler: leaseOrder.newOrderItem
                            }]
                        }).datagrid('addEventListener', [{
                            name: 'onClickRow',
                            handler: function(index,row){

                            }
                        },{
                            name: 'onClickCell',
                            handler: function(index,field,value){
                                if(field != 'oper'){
                                    if(editingIndex != -1){
                                        $(this).datagrid('endEdit', editingIndex);
                                    }
                                    $(this).datagrid('beginEdit', index);
                                }
                            }
                        },{
                            name: 'onBeforeEdit',
                            handler: function(index,row){
                                editingIndex = index;
                            }
                        },{
                            name: 'onBeginEdit',
                            handler: function(index, row){
                                registerEditorsEvent();
                            }
                        },{
                            name: 'onCancelEdit',
                            handler: function(index,row){
                                resetEditingIndex();
                            }
                        },{
                            name: 'onAfterEdit',
                            handler: function(index,row,changes){
                                resetEditingIndex();

                                if(continueEditing){
                                    newOrderItem();
                                }
                            }
                        }]);
                    },
                    initHolderPlugin = function(){
                        $hodlerPlugin.textbox({
                            buttonIcon: 'icon-search',
                            required: true,
                            onClickButton: function(){
                                showSearchProjectDialog();
                            }
                        }).textbox('textbox')
                                .focus()
                                .bind('keypress', function(event){
                                    setTimeout(function(){
                                        var value = $(event.target).val();
                                        if(value.length > 0){
                                            showSearchProjectDialog();
                                        }
                                    }, 5);
                                });
                    },
                    initOpenTimePlugin = function(){
                        $('#openTime').datebox({
                            editable: false,
                            required:true,
                            value: new Date().toString(),
                            parser: function(s){
                                var t = Date.parse(s);
                                if(!isNaN(t)){
                                    return new Date(t);
                                }else{
                                    return new Date();
                                }
                            }
                        });
                    },
                    showSearchProjectDialog = function(){
                        if($('#projectsDialog').length > 0) return;
                        $.showModalDialog({
                            id: 'projectsDialog',
                            title: '选择-承建单位',
                            width: 600,
                            height: 400,
                            data: {
                                code: $hodlerPlugin.textbox('getText'),
                                callback: function(project){
                                    $hodlerPlugin.textbox('setValue', project.id)
                                            .textbox('setText', project.name + '(' + project.holderName + ')');
                                    $('#projectId').val(project.id);
                                    $('#projectName').val(project.name);
                                    $('#holderId').val(project.holderId);
                                    $('#holderName').val(project.holderName);
                                }
                            },
                            content: 'url:lease/dialog/projects',
                            buttons:[{
                                text: '确定',
                                iconCls: 'icon-ok',
                                handler: 'doOK'
                            },{
                                text: '取消',
                                iconCls: 'icon-cancel',
                                handler: function(dialog){
                                    dialog.close();
                                }
                            }],
                            onLoad: function(dialog, body){
                                if(body && body.doInit){
                                    body.doInit(dialog);
                                }
                            },
                            onBeforeDestroy: function(){
                                $('#carnumber').textbox('textbox').focus();
                                return true;
                            }
                        });
                    },
                    showSearchGoodsDialog = function(){
                        if($('#searchGoodsDialog').length > 0) return;
                        $.showModalDialog({
                            id: 'searchGoodsDialog',
                            title: '选择-承建单位',
                            width: 600,
                            height: 400,
                            data: {
                                code: $(getCodeEditor()).textbox('textbox').val(),
                                datagrid: $itemGrid,
                                editingIndex: editingIndex,
                                codeEditor: getCodeEditor(),
                                goodsEditor: getGoodsEditor(),
                                goodsSpecEditor: getGoodsSpecEditor()
                            },
                            content: 'url:lease/dialog/goods',
                            buttons:[{
                                text: '确定',
                                iconCls: 'icon-ok',
                                handler: 'doOK'
                            },{
                                text: '取消',
                                iconCls: 'icon-cancel',
                                handler: function(dialog){
                                    dialog.close();
                                }
                            }],
                            onLoad: function(dialog, body){
                                if(body && body.doInit){
                                    body.doInit(dialog);
                                }
                            },
                            onDestroy: function(){
                                $(getLocationEditor()).numberbox('textbox').focus();
                                return true;
                            }
                        });
                    },
                    newOrderItem = function(){
                        if($itemGrid.datagrid('getEditingRow')) return;

                        $itemGrid.datagrid('appendRow',{
                            goodsId: '',
                            goodsName: '',
                            goodsSpec: '',
                            goodsLocation: '',
                            packages: 0,
                            numbers: 0
                        });

                        setTimeout(function(){
                            var newRowIndex = $itemGrid.datagrid('getRows').length - 1;
                            $itemGrid.datagrid('beginEdit', newRowIndex);
                        }, 5);
                    },
                    registerEditorsEvent = function(){
                        bindCoderEditorEvent();
                        bindLocationEditorEvent();
                        bindPackagesEditorEvent();
                        bindNumbersEditorEvent();
                    },
                    bindCoderEditorEvent = function(){
                        var editor = getCodeEditor();
                        $(editor)
                                .textbox('textbox')
                                .focus()
                                .bind('keypress', function(event){
                                    if($(event.target).val().length > 0){
                                        setTimeout(function(){
                                            showSearchGoodsDialog();
                                        }, 2);
                                    }
                                })
                                .bind('keydown', function(event){
                                    if(event.keyCode == 13){
                                        var locationEditor = getLocationEditor();
                                        $(locationEditor).numberbox('textbox').focus();
                                    }
                                });
                    },
                    bindLocationEditorEvent = function(){
                        var editor = getLocationEditor();
                        $(editor)
                                .numberbox('textbox')
                                .bind('keydown', function(event){
                                    if(event.keyCode == 13){
                                        var nextEditor = getReletEditor();
                                        $(nextEditor).focus();
                                    }
                                });
                    },
                    bindPackagesEditorEvent = function(){
                        var editor = getPackagesEditor();
                        $(editor)
                                .textbox("textbox")
                                .bind('keypress', function(event){
                                    setTimeout(function(){
                                        calcNumber();
                                    }, 5);
                                })
                                .bind('keydown', function(event){
                                    if(event.keyCode == 8){
                                        setTimeout(function(){
                                            calcNumber();
                                        }, 5);
                                    }

                                    if(event.keyCode == 13){
                                        if(event.ctrlKey){
                                            continueEditing = false;
                                        }else{
                                            continueEditing = true;
                                        }

                                        $itemGrid.datagrid('endEdit', editingIndex);
                                    }
                                });
                    },
                    bindNumbersEditorEvent = function(){
                    },
                    getCodeEditor = function(){
                        return $itemGrid
                                .datagrid('getEditor', {
                                    index: editingIndex,
                                    field: 'goodsCode'
                                }).target;
                    },
                    getGoodsEditor = function(){
                        return $itemGrid
                                .datagrid('getEditor', {
                                    index: editingIndex,
                                    field: 'goodsName'
                                }).target;
                    },
                    getGoodsSpecEditor = function(){
                        return $itemGrid
                                .datagrid('getEditor', {
                                    index: editingIndex,
                                    field: 'goodsSpec'
                                }).target;
                    },
                    getLocationEditor = function(){
                        return $itemGrid
                                .datagrid('getEditor', {
                                    index: editingIndex,
                                    field: 'goodsLocation'
                                }).target;
                    },
                    getPackagesEditor = function(){
                        return $itemGrid
                                .datagrid('getEditor', {
                                    index: editingIndex,
                                    field: 'packages'
                                }).target;
                    },
                    getNumbersEditor = function(){
                        return $itemGrid
                                .datagrid('getEditor', {
                                    index: editingIndex,
                                    field: 'numbers'
                                }).target;
                    },
                    getReletEditor = function(){
                        return $itemGrid
                                .datagrid('getEditor', {
                                    index: editingIndex,
                                    field: 'relet'
                                }).target;
                    },
                    calcNumber = function(){
                        var packagesEditor = getPackagesEditor();
                        var packages = $(packagesEditor).textbox('textbox').val();
                        var specEditor = getGoodsSpecEditor();
                        var spec = $(specEditor).textbox('getValue');
                        var numbersEditor = getNumbersEditor();
                        if($.trim(spec).length >0 && !isNaN(spec)){
                            var numbers = parseFloat(spec) * parseInt(packages);
                            $(numbersEditor).numberbox('setValue', numbers);
                        }else{
                            $(numbersEditor).numberbox('setValue', parseInt(packages));
                        }
                    },
                    deleteItem = function(index){
                        $itemGrid.datagrid('endEdit', index).datagrid('deleteRow', index);
                        resetEditingIndex();
                        continueEditing = false;
                    },
                    resetEditingIndex = function(){
                        editingIndex = -1;
                    },
                    save = function(){
                        if(!$('#holder').textbox('isValid')){
                            $.messager.alert('警告', '请选择承建单位', 'warning', function(){
                                $('#holder').textbox('textbox').focus();
                            });
                            return;
                        }

                        if($('#holder').textbox('getValue')==$('#holder').textbox('getText')){
                            $.messager.alert('警告', '请选择承建单位', 'warning', function(){
                                $('#holder').textbox('textbox').focus();
                            });
                            return;
                        }

                        if($itemGrid.datagrid('getChanges', 'inserted').length==0){
                            $.messager.alert('警告', '此单据无效，请添加料具。','warning', function(){
                                newOrderItem();
                            });
                            return;
                        }

                        if($itemGrid.datagrid('getEditingRow')){
                            $.messager.alert('警告', '存在未编辑完的单据项，请编辑完后再保存。','warning');
                            return;
                        }


                        var order = {
                            openTime: $('#openTime').datebox('getValue'),
                            holderId: $('#holderId').val(),
                            holderName: $('#holderName').val(),
                            projectId: $('#projectId').val(),
                            projectName: $('#projectName').val(),
                            carNumber: $('#carnumber').val(),
                            items : $itemGrid.datagrid('getChanges', 'inserted')
                        };


                        $.ajax({
                            type: 'post',
                            url: 'lease/orders/faliao/new',
                            data: {leaseorder: $.toJSON(order)},
                            success: function(data){
                                if(data.status == 200){
                                    location.href = 'lease/orders/faliao/' + data.data.id;
                                }else{
                                    $.messager.alert('错误','单据保存失败！' + '<br>' + data.message, 'error');
                                }

                            },
                            error: function(){
                                $.messager.alert('提示','单据保存失败！');
                            }
                        });
                    };


                return {
                    init: function(){
                        $.extend($.fn.validatebox.defaults.rules, {
                            min:{
                                validator: function(value, param){
                                    return parseInt(value) >= param;
                                },
                                message: '改输入项最小值为{0}'
                            }
                        });

                        initToolbar();
                        initItemGrid();
                        initHolderPlugin();
                        initOpenTimePlugin();
                        return this;
                    },
                    save: function(){
                        save();
                    },
                    deleteItem: deleteItem,
                    newOrderItem: newOrderItem
                }
            })();

            leaseOrder.init();
        </script>
    </body>
</html>
