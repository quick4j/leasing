<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="easyui-layout" data-options="fit:true">
    <!-- order -->
    <div data-options="region:'center', border: false" style="padding: 10px 30px 20px 30px;">
        <div class="easyui-layout" data-options="fit:true">
            <!-- title + header -->
            <div data-options="region:'north', split: false, border:false" style="height:150px;">
                <div class="order-title">周转工具管理中心发料单</div>
                <div>
                    <table>
                        <tr>
                            <td class="label">编号：</td>
                            <td>${order.code}</td>
                            <td class="label">日期：</td>
                            <td><input id="openTime" type="text"></td>
                        </tr>
                        <tr>
                            <td class="label">承租单位：</td>
                            <td colspan="3">
                                <input style="width: 100%" id="holder" tabindex="1">
                            </td>
                        </tr>
                        <tr>
                            <td class="label">车号：</td>
                            <td><input class="easyui-textbox" id="carnumber" tabindex="2" value="${order.carNumber}"></td>
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
    var editingOrder = {};
    var opentime = quick4j.util.dateFormate.format(${order.openTime}, 'YYYY-MM-DD');
    function doInit(dialog){
        $.extend(editingOrder, {
            id: '${order.id}',
            openTime: opentime,
            holderId: '${order.holderId}',
            holderName: '${order.holderName}',
            projectId: '${order.projectId}',
            projectName: '${order.projectName}',
            carNumber: '${order.carNumber}'
        });

        initOrderBody();
        initOpenTime();
        initHolder();
    }

    function initOpenTime(){
        $('#openTime').datebox({
            editable: false,
            required:true,
            value: opentime,
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
            value: editingOrder.projectName +'(' + editingOrder.holderName + ')',
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
                {field: 'numbers', title: '数量', width: 100, halign: 'center'}
            ]],
            url: 'api/rest/datagrid/leaseorderitems',
            rownumbers: true,
            fit: true,
            striped: true,
            singleSelect: true,
            queryParams: {
                orderId: editingOrder.id
            },
            loadFilter: function(data){
                if(data.status == '200'){
                    return data.data;
                }else{
                    $.messager.alert('警告', '发生错误:' + '<br>' + data.message, 'warning');
                    return {};
                }
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

                    $.extend(editingOrder, {
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

    function doSave(dialog){
        if(!$('#holder').textbox('isValid')){
            $.messager.alert('警告', '请选择承建单位', 'warning', function(){
                $('#holder').textbox('textbox').focus();
            });
            return;
        }

        $.extend(editingOrder, {
            openTime: $('#openTime').datebox('getValue'),
            carNumber: $('#carnumber').textbox('getValue')
        });


        $.ajax({
            type: 'post',
            url: 'leasing/orders/leaseorder/out/' + editingOrder.id + '/edit',
            data: {leaseorder: $.toJSON(editingOrder)},
            success: function(result){
                if(result.status == 200){
                    $.messager.alert('提示','单据保存成功！', 'info', function(){
                        dialog.getData('callback')();
                        dialog.close();
                    });
                }else{
                    $.messager.alert('错误','单据保存失败！' + '<br>' + result.message, 'error');
                }
            },
            error: function(){
                $.messager.alert('提示','单据保存失败！');
            }
        });
    }

</script>

