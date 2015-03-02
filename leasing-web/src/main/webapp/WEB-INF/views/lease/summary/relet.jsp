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
                    <label for="searchLeaser">租借单位：</label>
                    <input class="easyui-textbox" id="searchLeaser">
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
                initSearchLeaserBoxPlugin();
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
                    url: 'lease/summary/relet',
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

            function initSearchLeaserBoxPlugin(){
                $('#searchLeaser').textbox({
                    buttonIcon: 'icon-search',
                    onClickButton: function(){
                        showSearchLeaserDialog();
                    }
                }).textbox('textbox')
                        .focus()
                        .bind('keypress', function(event){
                            setTimeout(function(){
                                var value = $(event.target).val();
                                if(value.length > 0){
                                    showSearchLeaserDialog();
                                }
                            }, 5);
                        });
            }

            function showSearchLeaserDialog(){
                if($('#leasersDialog').length > 0) return;
                $.showModalDialog({
                    id: 'leasersDialog',
                    title: '选择-租借单位',
                    width: 600,
                    height: 400,
                    data: {
                        code: $('#searchLeaser').textbox('getText'),
                        callback: function(holder){
                            $('#searchLeaser').textbox('setValue', holder.id)
                                    .textbox('setText', holder.name);
                        }
                    },
                    content: 'url:lease/dialog/leasers',
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
                var searchLeaser = $('#searchLeaser').textbox('getValue');
                var params = {};
                if(searchLeaser){
                    $.extend(params, {leaserid: searchLeaser});
                }

                $('#summaryGrid').datagrid('load',params);
            }
        </script>
    </body>
</html>
