<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center', border: false" style="padding: 2px;">
        <table id="dg"></table>
    </div>
    <div data-options="region:'south', border: false" style="height:40px;">
        <div style="margin-top: 5px; margin-left: 10px;">
            助记码：<input id="searchTextBox" data-options="width: 300, height: 28">
        </div>
    </div>
</div>
<script>
    function doInit(dialog){
        initSearchBox(dialog);
        initGrid();
    }

    function initGrid(){
        $('#dg').datagrid({
            columns:[[
                {field: 'code', title: '助记码', width: 150},
                {field: 'name', title: '名称', width: 150}
            ]],
            url: 'api/rest/datagrid/holders',
            fit: true,
            striped: true,
            singleSelect: true,
            queryParams: {_loading: false},
            loadFilter: function(data){
                if(data.status == '200'){
                    return data.data;
                }else{
                    $.messager.alert('警告', '发生错误:' + '<br>' + data.message, 'warning');
                    return {};
                }
            },
            onBeforeLoad: function(param){
                return param._loading;
            }
        });
    }

    function initSearchBox(dialog){
        var searchValue = dialog.getData('searchValue');
        $('#searchTextBox').textbox({
            width: 300,
            height: 28,
            value: searchValue
        }).textbox('textbox')
                .focus()
                .bind('keypress', function(event){
                    setTimeout(function(){
                        doQuery($(event.target).val());
                    }, 100);
                })
                .bind('keydown', function(event){
                    if(event.keyCode == 13){
                        doQuery($(event.target).val());
                    }
                });
    }

    function doQuery(code){
        $('#dg').datagrid('load',{
            _loading: true,
            code: code
        });
    }

    function doOK(dialog){
        var selected = $('#dg').datagrid('getSelected');
        if(selected){
            dialog.getData('callback')(selected);
        }

        dialog.close();
    }
</script>