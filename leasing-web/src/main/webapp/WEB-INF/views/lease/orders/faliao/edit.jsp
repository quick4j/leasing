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
                        <form id="frm" method="post">
                            <input type="hidden" id="id" name="id" value="${order.id}">
                            <table>
                                <tr>
                                    <td class="label">编号：</td>
                                    <td>${order.code}</td>
                                    <td class="label">日期：</td>
                                    <td>
                                        <input type="hidden" id="openTime2" name="openTime">
                                        <input type="text" id="openTime"  value="${order.openTime}">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">承租单位：</td>
                                    <td colspan="3">
                                        <input type="hidden" id="holderId" name="holderId" value="${order.holderId}">
                                        <input type="hidden" id="holderName" name="holderName" value="${order.holderName}">
                                        <input type="hidden" id="projectId" name="projectId" value="${order.projectId}">
                                        <input type="hidden" id="projectName" name="projectName" value="${order.projectName}">
                                        <input style="width: 100%" id="holder" tabindex="1"
                                               value="${order.projectName}(${order.holderName})">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">车号：</td>
                                    <td>
                                        <input class="easyui-textbox" id="carnumber" name="carNumber"
                                               tabindex="2" value="${order.carNumber}">
                                    </td>
                                    <td class="label">制单人：</td>
                                    <td>张三</td>
                                </tr>
                            </table>
                        </form>
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
                initHolderPlugin();
                initOpenTimePlugin();
            });
            function initToolbar(){
                $('#tb').toolbar({
                    data:[{
                        id: 'tbBtnNew',
                        text: '新建',
                        iconCls: 'icon-add',
                        handler: function(){
                            location.href = 'lease/orders/faliao/new';
                        }
                    },{
                        id: 'tbBtnSave',
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: doSubmit
                    },{
                        id: 'tbBtnPrint',
                        text: '打印',
                        iconCls: 'icon-print',
                        handler: function(){}
                    }]
                });
            }

            function initHolderPlugin(){
                $("#holder").textbox({
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
            }

            function initOpenTimePlugin(){
                $('#openTime').datebox({
                    editable: false,
                    required:true,
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

            function showSearchProjectDialog(){
                if($('#projectsDialog').length > 0) return;
                $.showModalDialog({
                    id: 'projectsDialog',
                    title: '选择-承建单位',
                    width: 600,
                    height: 400,
                    data: {
                        code: $("#holder").textbox('getText'),
                        callback: function(project){
                            $("#holder").textbox('setValue', project.id)
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
            }

            function doSubmit(){
                if(!$('#holder').textbox('isValid')){
                    $.messager.alert('警告', '请选择承建单位', 'warning', function(){
                        $('#holder').textbox('textbox').focus();
                    });
                    return;
                }


                var order = {
                    id: $('#id').val(),
                    openTime: $('#openTime').datebox('getValue'),
                    holderId: $('#holderId').val(),
                    holderName: $('#holderName').val(),
                    projectId: $('#projectId').val(),
                    projectName: $('#projectName').val(),
                    carNumber: $('#carnumber').val()
                };

                $.ajax({
                    type: 'post',
                    url: 'lease/orders/faliao/' + order.id + '/edit',
                    data: {leaseorder: $.toJSON(order)},
                    success: function(result){
                        if(result.status == 200){
                            location.href = 'lease/orders/faliao/' + order.id;
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
    </body>
</html>
