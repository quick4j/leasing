<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center', border: false" style="padding: 2px;">
        <table id="dg"></table>
    </div>
    <div data-options="region:'south', border: false" style="height:40px;">
        <div style="margin-top: 5px; margin-left: 10px;">
            料具助记码：<input id="searchTextBox" data-options="width: 300, height: 28">
        </div>
    </div>
</div>
<script>
    function doInit(dialog){
        initSearchTextBoxPlugin(dialog);
        initGridPlugin();
    }

    function initGridPlugin(){
        $('#dg').datagrid({
            columns:[[
                {field: 'code', title: '助记码', width: 150},
                {field: 'name', title: '品名', width: 150},
                {field: 'spec', title: '规格', width: 150},
                {field: 'unit', title: '计量单位', width: 100}
            ]],
            url: 'api/rest/datagrid/goods',
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
        }).datagrid('addEventListener', [{
            name: 'onLoadSuccess',
            handler: function(data){
                if(data.rows.length){
                    $(this).datagrid('selectRow',0);
                }
            }
        }]);
    }

    function initSearchTextBoxPlugin(dialog){
        var searchCode = dialog.getData('code');
        $('#searchTextBox').textbox({
            width: 300,
            height: 28,
            value: searchCode
        }).textbox('textbox')
                .focus()
                .bind('keypress', function(event){
                    setTimeout(function(){
                        queryGoods($(event.target).val());
                    }, 100);
                })
                .bind('keydown', function(event){
                    if(event.keyCode == 13){
                        queryGoods($(event.target).val());
                    }
                });
    }

    function queryGoods(code){
        $('#dg').datagrid('load',{
            _loading: true,
            code: code
        });
    }

    function doOK(dialog){
        var selected = $('#dg').datagrid('getSelected');
        if(selected){
            dialog.getData('datagrid').datagrid('getEditingRow').goodsId = selected.id;
            dialog.getData('codeEditor').textbox('setValue', selected.code);
            dialog.getData('goodsEditor').textbox('setValue', selected.name);
            dialog.getData('goodsSpecEditor').textbox('setValue', selected.spec);
        }
        dialog.close();
    }
</script>
