<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .columns{}
    .row{}
    .row .columns{
        display: inline;
    }
</style>
<div style="padding: 5px;">
    <form method="post" id="newProjectForm">
        <input type="hidden" id="holderName" name="holderName">
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>承建单位</label>
            </div>
            <div class="columns">
                <input class="textbox easyui-validatebox" type="text" id="holder"
                       name="holderId" data-options="required:true">
            </div>
        </div>
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>助记码</label>
            </div>
            <div class="columns">
                <input class="textbox easyui-validatebox" type="text" id="projCode"
                       name="code" data-options="required:true">
            </div>
        </div>
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>工程名称</label>
            </div>
            <div class="columns">
                <input class="textbox easyui-validatebox" type="text" id="projName"
                       name="name" data-options="required:true">
            </div>
        </div>
    </form>
</div>
<script>
    function doInitData(win){
        $('#holder').combobox({
            url: 'api/rest/datagrid/holders',
            valueField: 'id',
            textField: 'name',
            panelMaxHeight: 100,
            value: win.getData('holderId'),
            loadFilter: function(data){
                return data.data.rows;
            }
        });

        $('#projCode').focus();
    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function doSaveAndNew(win){
        saveData(win, function(){
            $('#newProjectForm').form('reset');
        });
    }

    function saveData(win, callback){
        $('#newProjectForm').form('submit', {
            url: 'lease/project/new',
            onSubmit: function(){
                var holderName = $('#holder').combobox('getText');
                $('#holderName').val(holderName);

                return true;
            },
            success: function(data){
                var result = eval('(' + data + ')');
                if(result.status == 200){
                    $.messager.alert('提示', '数据保存成功！', 'info', function(){
                        $('#projCode').focus();
                    });
                    win.getData('datagrid').datagrid('reload');
                    callback();
                }else{
                    $.messager.alert('错误', '数据保存失败！' + result.message, 'error');
                }
            }
        });
    }
</script>
