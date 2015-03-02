<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center', border: false" style="padding: 2px;">
        <table id="projectGrid"></table>
    </div>
    <div data-options="region:'south', border: false" style="height:40px;">
        <div style="margin-top: 5px; margin-left: 10px;">
            承建项目：<input id="searchTextBox" data-options="width: 300, height: 28">
        </div>
    </div>
</div>
<script>
    function doInit(dialog){
        initSearchBoxPlugin(dialog);
        initProjectGridPlugin();
    }

    function initProjectGridPlugin(){
        $('#projectGrid').datagrid({
            columns:[[
                {field: 'code', title: '助记码', width: 150},
                {field: 'name', title: '承建项目名称', width: 300},
                {field: 'holderName', title: '承建单位名称', width: 300}
            ]],
            url: 'api/rest/datagrid/projects',
            fit: true,
            striped: true,
            singleSelect: true,
            queryParams: {
                _loading: false
            },
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

    function initSearchBoxPlugin(dialog){
        var searchCode = dialog.getData('code');
        $('#searchTextBox').textbox({
            width: 300,
            height: 28,
            value: searchCode
        }).textbox('textbox')
                .focus()
                .bind('keypress', function(event){
                    setTimeout(function(){
                        var params = {code: $(event.target).val()};
                        var constraint = dialog.getData('constraint');
                        if(constraint){
                            $.extend(params, constraint);
                        }
                        doQuery(params);
                    }, 100);
                });
    }

    function doQuery(params){
        $('#projectGrid')
                .datagrid('load', $.extend({_loading: true}, params));
    }

    function doOK(dialog){
        var selected = $('#projectGrid').datagrid('getSelected');
        if(selected){
            dialog.getData('callback')(selected);
        }

        dialog.close();
    }
</script>
