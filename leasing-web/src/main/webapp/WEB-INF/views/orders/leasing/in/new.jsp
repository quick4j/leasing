<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="easyui-layout" data-options="fit:true">
    <!-- order -->
    <div data-options="region:'center', border: false" style="padding: 10px 30px 20px 30px;">
        <div class="easyui-layout" data-options="fit:true">
            <!-- title + header -->
            <div data-options="region:'north', split: false, border:false" style="height:150px;">
                <div class="order-title">周转工具管理中心收料单</div>
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
            <!-- body -->
            <div data-options="region:'center', border: false">
                <table id="items"></table>
            </div>
        </div>
    </div>
</div>

<!-- script -->
<script>
    var newOrder = {};
    function doInit(dialog){
        initOrderBody();
        initOpenTime();
        initHolder();
    }

    function initOpenTime(){
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
    }

    function initHolder(){
        $('#holder').textbox({
            buttonIcon: 'icon-search',
            icons:[{
                iconCls:'icon-remove',
                handler: function(e){
                    $(e.data.target).textbox('clear');
                }
            }],
            required:true,
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
    }

    function initOrderBody(){
        $('#items').datagrid({
            columns:[[
                {field: 'goodsCode', title: '料具助记码', width: 100, halign: 'center'},
                {field: 'goodsName', title: '料具名称', width: 150, halign: 'center'},
                {field: 'goodsSpec', title: '规格型号', width: 150, halign: 'center'},
                {field: 'goodsLocation', title: '库位', width: 80, halign: 'center'},
                {field: 'packages', title: '件数', width: 100, halign: 'center'},
                {field: 'numbers', title: '数量', width: 100, halign: 'center'},
                {field: 'oper', title: '操作', width: 80, halign: 'center', align: 'center',
                    formatter: function(value,row,index){
                        return '<a href="javascript:" class="grid-sm-btn icon-remove" title="删除" onclick="deleteItem('+index+')"></a>';
                    }
                }
            ]],
            rownumbers: true,
            fit: true,
            striped: true,
            singleSelect: true,
            toolbar: [{
                text:'增加料具',
                iconCls: 'icon-add',
                handler: showNewGoodsDialog
            }],
            onDblClickRow: function(index,row){
                showEditGoodsDialog(index,row);
            }
        });
    }

    function showSearchProjectDialog(){
        $.showModalDialog({
            id: 'projectsDialog',
            title: '选择-承建单位',
            width: 600,
            height: 400,
            data: {
                searchValue: $('#holder').textbox('getText'),
                callback: function(project){
                    $('#holder').textbox('setText', project.name + '(' + project.holderName + ')');

                    $.extend(newOrder, {
                        holderId: project.holderId,
                        holderName: project.holderName,
                        projectId: project.id,
                        projectName: project.name
                    });
                }
            },
            content: 'url:leasing/orders/common/dialog/projects',
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
    }

    function showNewGoodsDialog(){
        $.showModalDialog({
            title: '添加料具',
            content: 'url:leasing/orders/items/add',
            locate: 'document',
            height: '50%',
            width: '450',
            data: {
                callback: function(goods){
                    $('#items').datagrid('appendRow', goods);
                }
            },
            buttons:[{
                text: '保存并继续新增',
                iconCls: 'icon-save',
                handler: 'doSubmitAndNew'
            },{
                text: '保存',
                iconCls: 'icon-save',
                handler: 'doSubmit'
            },{
                text: '关闭',
                iconCls: 'icon-cancel',
                handler: function(win){
                    win.close();
                }
            }],
            onLoad: function(dialog, body){
                if(body&&body.doInit){
                    body.doInit(dialog);
                }
            }
        });
    }

    function showEditGoodsDialog(index,row){
        $.showModalDialog({
            title: '添加料具',
            content: 'url:leasing/orders/items/edit',
            locate: 'document',
            data: {
                goods: row,
                callback: function(goods){
                    $('#items').datagrid('updateRow',{
                        index: index,
                        row: goods
                    });
                }
            },
            buttons:[{
                text: '保存',
                iconCls: 'icon-save',
                handler: 'doSubmit'
            },{
                text: '关闭',
                iconCls: 'icon-cancel',
                handler: function(win){
                    win.close();
                }
            }],
            onLoad: function(dialog, body){
                if(body&&body.doInit){
                    body.doInit(dialog);
                }
            }
        });
    }

    function deleteItem(index){
        $('#items').datagrid('deleteRow',index);
    }

    function doSave(dialog){
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

        if($('#items').datagrid('getChanges', 'inserted').length==0){
            $.messager.alert('警告', '此单据无效，请添加料具。','warning');
            return;
        }

        $.extend(newOrder, {
            openTime: $('#openTime').datebox('getValue'),
            carNumber: $('#carnumber').textbox('getValue'),
            items: $('#items').datagrid('getChanges', 'inserted')
        });

        $.ajax({
            type: 'post',
            url: 'leasing/orders/leaseorder/in/new',
            data: {leaseorder: $.toJSON(newOrder)},
            success: function(data){
                if(data.status == 200){
                    $.messager.alert('提示','单据保存成功！', 'info', function(){
                        dialog.getData('callback')();
                        dialog.close();
                    });
                }else{
                    $.messager.alert('错误','单据保存失败！' + '<br>' + data.message, 'error');
                }

            },
            error: function(){
                $.messager.alert('提示','单据保存失败！');
            }
        });
    }
</script>

