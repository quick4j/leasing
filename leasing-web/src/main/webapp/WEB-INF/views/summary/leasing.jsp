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
        <div data-options="region:'west',split:true" style="width: 20%;">
            <div id="tb1">
                助记码：<input id="searchHolderBox">
            </div>
            <table id="holdersGrid"></table>
        </div>
        <div data-options="region:'center', border: false">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'west',split:true" style="width: 25%;padding: 1px;">
                    <table id="projectsGrid"></table>
                </div>
                <div data-options="region:'center', border: false">
                    <table id="summaryGrid"></table>
                </div>
            </div>
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
                initSearchHolderBox();
                initHoldersGrid();
                initProjectsGrid();
                initSummaryGrid();
            });

            function initSearchHolderBox(){
                $('#searchHolderBox').textbox({
                    buttonIcon: 'icon-remove',
                    onClickButton:function(){
                        $(this).textbox('clear');
                    },
                    onChange: function(newValue,oldValue){
                        if(newValue.length == 0){
                            $('#holdersGrid').datagrid('load', {});
                        }
                    }
                }).textbox('textbox')
                        .bind('keypress',function(event){
                            setTimeout(function(){
                                var searchValue = $(event.target).val();
                                var params = {};
                                if(searchValue.length>0){
                                    $.extend(params, {code: searchValue});
                                }
                                $('#holdersGrid').datagrid('load', params);
                            }, 5);
                        });
            }

            function initSummaryGrid(){
                $('#summaryGrid').datagrid({
                    fit: true,
                    striped: true,
                    singleSelect: true,
                    title:'料具汇总',
                    columns: [[
                        {field: 'goodsName', title: '品名', width: 150},
                        {field: 'goodsSpec', title: '规格', width: 100},
                        {field: 'packages', title: '在用量', width: 100},
                        {field: 'numbers', title: '米数', width: 100}
                    ]],
                    toolbar:[{
                        iconCls: 'icon-search',
                        text: '汇总',
                        handler: function(){
                            doSummary();
                        }
                    }],
                    url: 'leasing/summary/leasing',
                    queryParams: {_loading: false},
                    rowStyler: function(index,row){
                        if(row.goodsSpec == '合计'){
                            return 'background-color:#6293BB;color:#fff;font-weight: bold;';
                        }
                    },
                    onBeforeLoad: function(param){
                        return param._loading;
                    },
                    loadFilter: function(data){
                        if(data.status == 200){
                            var handleGoodsTypeTotal = function(data){
                                var tmp = [];
                                var total1 = 0, total2 = 0;
                                if(data.rows && data.rows.length > 0){
                                    for(var i= 0, length = data.rows.length; i<length; i++){
                                        tmp.push(data.rows[i]);
                                        total1 += parseInt(data.rows[i].packages);
                                        total2 += parseInt(data.rows[i].numbers);

                                        if(data.rows[i+1] && data.rows[i].goodsType != data.rows[i+1].goodsType){
                                            tmp.push({
                                                goodsName: '',
                                                goodsSpec: '合计',
                                                packages: total1,
                                                numbers: total2
                                            });

                                            total1 = total2 = 0;
                                        }

                                        if(i == length-1){
                                            tmp.push({
                                                goodsName: '',
                                                goodsSpec: '合计',
                                                packages: total1,
                                                numbers: total2
                                            });

                                            total1 = total2 = 0;
                                        }
                                    }
                                    data.rows = tmp;
                                }
                                return data;
                            }
                            return handleGoodsTypeTotal(data.data);
                        }else{
                            return {}
                        }
                    }
                });
            }

            function initHoldersGrid(){
                $('#holdersGrid').datagrid({
                    url:'api/rest/datagrid/holders',
                    title:'承建单位',
                    fit:true,
                    striped: true,
                    singleSelect:true,
                    border:false,
                    columns:[[
                        {field:'code', title:'助记码', width: 100},
                        {field:'name',title:'名称',width:200}
                    ]],
                    toolbar: '#tb1',
                    loadFilter: function(data){
                        if(data.status == 200){
                            return data.data;
                        }else{
                            return {}
                        }
                    },
                    onSelect: function(index,row){
                        queryProjectsForHolder(row.id);
                        clearSummaryGrid();
                    }
                });
            }

            function initProjectsGrid(){
                $('#projectsGrid').datagrid({
                    url:'api/rest/datagrid/projects',
                    title:'承建项目',
                    fit:true,
                    striped: true,
                    border:false,
                    columns:[[
                        {field:'code', title:'助记码', width: 100},
                        {field:'name',title:'名称',width:200}
                    ]],
                    queryParams: {_loading: false},
                    toolbar:[{
                        iconCls: 'icon-remove',
                        text: '撤销选中',
                        handler: function(){
                            $('#projectsGrid').datagrid('unselectAll');
                        }
                    }],
                    loadFilter: function(data){
                        if(data.status == 200){
                            return data.data;
                        }else{
                            return {}
                        }
                    },
                    onBeforeLoad: function(param){
                        return param._loading;
                    }
                });
            }

            function queryProjectsForHolder(holderid){
                $('#projectsGrid').datagrid('load',{
                    _loading: true,
                    holderId: holderid
                });
            }

            function doSummary(){
                var selectedHolder = $('#holdersGrid').datagrid('getSelected');
                var selectedProjects = $('#projectsGrid').datagrid('getSelections');
                var params = {};
                if(selectedHolder){
                    $.extend(params, {holderid: selectedHolder.id});
                }else{
                    $.messager.alert('提示','请选择要汇总的承建单位!', 'warning');
                    return;
                }

                if(selectedProjects && selectedProjects.length){
                    var projectids = [];
                    $.each(selectedProjects, function(i, project){
                        projectids.push(project.id);
                    });
                    $.extend(params, {projectids: projectids.join(',')});
                }

                $('#summaryGrid').datagrid('load',params);
            }

            function clearSummaryGrid(){
                var $summaryGrid = $('#summaryGrid');
                var length = $summaryGrid.datagrid('getRows').length;
                for(var i=length-1; i>-1; i--){
                    $summaryGrid.datagrid('deleteRow', i);
                }
            }
        </script>
    </body>
</html>
