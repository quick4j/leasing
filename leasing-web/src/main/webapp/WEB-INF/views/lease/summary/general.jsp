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
        <div data-options="region:'center', border: false">
            <div id="tlb">
                <div style="float: left; padding: 2px; margin-left: 50px;">
                    <label for="searchHolder">承租单位：</label>
                    <input class="easyui-textbox" id="searchHolder">
                </div>
                <div style="float: left; padding: 2px; margin-left: 10px;">
                    <label for="searchProject">承建项目：</label>
                    <input class="easyui-textbox" id="searchProject">
                </div>
                <a class="easyui-linkbutton" href="javascript:"
                   data-options="iconCls:'icon-search',plain:true"
                   onclick="doSummary()">汇总</a>
            </div>
            <table id="summaryGrid"></table>
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
                initSummaryGridPlugin();
                initSearchHolderBoxPlugin();
                initSearchProjectPlugin();
            });

            function initSummaryGridPlugin(){
                $('#summaryGrid').datagrid({
                    fit: true,
                    striped: true,
                    singleSelect: true,
                    border:false,
                    columns: [[
                        {field: 'goodsName', title: '品名', width: 200},
                        {field: 'goodsSpec', title: '规格', width: 150},
                        {field: 'packages', title: '在用量', width: 150},
                        {field: 'numbers', title: '米数', width: 200}
                    ]],
                    toolbar: '#tlb',
                    url: 'lease/summary/leasing',
                    queryParams: {_loading: false},
                    onBeforeLoad: function(param){
                        return param._loading;
                    },
                    loadFilter: function(data){
                        if(data.status == 200){
                            return data.data;
                        }else{
                            return {}
                        }
                    }
                });
            }

            function initSearchHolderBoxPlugin(){
                $('#searchHolder').textbox({
                    buttonIcon: 'icon-search',
                    onClickButton: function(){
                        showSearchHolderDialog();
                    }
                }).textbox('textbox')
                        .focus()
                        .bind('keypress', function(event){
                            setTimeout(function(){
                                var value = $(event.target).val();
                                if(value.length > 0){
                                    showSearchHolderDialog();
                                }
                            }, 5);
                        });
            }

            function initSearchProjectPlugin(){
                $('#searchProject').textbox({
                    buttonIcon: 'icon-search',
                    onClickButton: function(){
                        showSearchProjectDialog();
                    }
                }).textbox('textbox')
                        .bind('keypress', function(event){
                            setTimeout(function(){
                                var value = $(event.target).val();
                                if(value.length > 0){
                                    showSearchProjectDialog();
                                }
                            }, 5);
                        });
            }

            function showSearchHolderDialog(){
                if($('#projectsDialog').length > 0) return;
                $.showModalDialog({
                    id: 'projectsDialog',
                    title: '选择-承建项目',
                    width: 600,
                    height: 400,
                    data: {
                        code: $('#searchHolder').textbox('getText'),
                        callback: function(holder){
                            $('#searchHolder').textbox('setValue', holder.id)
                                    .textbox('setText', holder.name);
                        }
                    },
                    content: 'url:lease/dialog/holders',
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
                    }
                });
            }

            function showSearchProjectDialog(){
                if($('#projectsDialog').length > 0) return;
                $.showModalDialog({
                    id: 'projectsDialog',
                    title: '选择-承建项目',
                    width: 600,
                    height: 400,
                    data: {
                        code: $('#searchProject').textbox('getText'),
                        constraint:{
                            holderId: $('#searchHolder').textbox('getValue')
                        },
                        callback: function(project){
                            $('#searchProject').textbox('setValue', project.id)
                                    .textbox('setText', project.name);
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
                    }
                });
            }

            function doSummary(){
                var searchHolder = $('#searchHolder').textbox('getValue');
                var searchProject = $('#searchProject').textbox('getValue');
                var params = {};
                if(searchHolder){
                    $.extend(params, {holderid: searchHolder});
                }

                if(searchProject){
                    $.extend(params, {projectid: searchProject});
                }

                $('#summaryGrid').datagrid('load',params);
            }
        </script>
    </body>
</html>
