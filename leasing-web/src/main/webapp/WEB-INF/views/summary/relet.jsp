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
                助记码：<input id="searchLeaserBox">
            </div>
            <table id="leaserGrid"></table>
        </div>
        <div data-options="region:'center'">
            <div id="tlb">
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
                initLeaserGrid();
                initSearchLeaserBox();
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
                    url: 'leasing/summary/relet',
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

            function initSearchLeaserBox(){
                $('#searchLeaserBox').textbox({
                    buttonIcon: 'icon-remove',
                    onClickButton:function(){
                        $(this).textbox('clear');
                    },
                    onChange: function(newValue,oldValue){
                        if(newValue.length == 0){
                            $('#leaserGrid').datagrid('load', {});
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
                                $('#leaserGrid').datagrid('load', params);
                            }, 5);
                        });
            }

            function initLeaserGrid(){
                $('#leaserGrid').datagrid({
                    url:'api/rest/datagrid/leasers',
                    title:'承租单位',
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
                        clearSummaryGrid();
                    }
                });
            }

            function doSummary(){
                var selected = $('#leaserGrid').datagrid('getSelected');
                var params = {};
                if(!selected){
                    $.messager.alert("警告", "请选择要汇总的租借单位!", "warning");
                    return;
                }

                $.extend(params, {leaserid: selected.id});
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
