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
        <div data-options="region:'center', border: false" style="padding: 1px;">
            <div id="tlb">
                <div style="float: left; padding: 2px; margin-left: 50px;">
                    <label for="searchHolder">承建单位：</label>
                    <input id="searchHolder">
                </div>
                <div style="float: left; padding: 2px; margin-left: 10px;">
                    <label for="searchProject">项目：</label>
                    <input id="searchProject">
                </div>
                <a class="easyui-linkbutton" href="javascript:"
                   data-options="iconCls:'icon-search'"
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
                initSearchHolderCombo();
                initSearchProjectCombo();
                initSummaryGrid();
            });

            function initSearchHolderCombo(){
                $('#searchHolder').combogrid({
                    required:true,
                    idField:'id',
                    textField:'name',
                    panelWidth: 300,
                    columns:[[
                        {field:'code', title:'助记码', width: 100},
                        {field:'name',title:'名称',width:200}
                    ]],
                    url:'api/rest/datagrid/holders',
                    loadFilter: function(data){
                        if(data.status == 200){
                            return data.data
                        }else{
                            return {}
                        }
                    },
                    onChange: function(newValue, oldValue){
                        $('#searchProject')
                                .combogrid('clear')
                                .combogrid('grid')
                                .datagrid('load',{holderId: newValue});
                    }
                });
            }

            function initSearchProjectCombo(){
                $('#searchProject').combogrid({
                    idField:'id',
                    textField:'name',
                    panelWidth: 400,
                    columns:[[
                        {field:'code', title:'助记码', width: 100},
                        {field:'name',title:'名称',width:200}
                    ]],
                    url: 'api/rest/datagrid/projects',
                    queryParams:{_loading: false},
                    loadFilter: function(data){
                        if(data.status == 200){
                            return data.data
                        }else{
                            return {}
                        }
                    },
                    onBeforeLoad: function(param){
                        return param._loading;
                    }
                });
            }

            function initSummaryGrid(){
                $('#summaryGrid').datagrid({
                    fit: true,
                    striped: true,
                    singleSelect: true,
                    columns: [[
                        {field: 'goodsName', title: '品名', width: 200, sortable: true},
                        {field: 'goodsSpec', title: '规格', width: 150, sortable: true},
                        {field: 'packages', title: '在用量', width: 150},
                        {field: 'numbers', title: '米数', width: 200}
                    ]],
                    url: 'lease/summary/leasing',
                    queryParams: {_loading: false},
                    remoteSort:false,
                    pagination: true,
                    sortName: 'goodsName',
                    toolbar:'#tlb',
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

            function doSummary(){
                var searchHolder = $('#searchHolder').combogrid('getValue');
                var searchProject = $('#searchProject').combogrid('getValue');
                var params = {};
                if(searchHolder){
                    $.extend(params, {holderid: searchHolder});
                }else{
                    $.messager.alert('提示','请选择要汇总的承建单位!', 'warning');
                    return;
                }

                if(searchProject){
                    $.extend(params, {projectid: searchProject});
                }

                $('#summaryGrid').datagrid('load',params);
            }
        </script>
    </body>
</html>
