<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="padding: 5px;">
    <form method="post" id="newProjectForm">
        <input type="hidden" id="holderName" name="holderName">
        <div class="form-group">
            <label class="control-label required" for="holder">承建单位</label>
            <div class="form-field">
                <input type="text" id="holder" style="width: 100%"
                       name="holderId" data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required" for="projCode">助记码</label>
            <div class="form-field">
                <input class="easyui-textbox"
                       type="text" id="projCode" style="width: 100%"
                       name="code" data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required" for="projName">工程名称</label>
            <div class="form-field">
                <input class="easyui-textbox"
                       type="text" id="projName" style="width: 100%"
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

        $('#projCode').textbox('textbox').focus();
    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function doSaveAndNew(win){
        saveData(win, function(){
            $('#newProjectForm').form('reset');
            $('#projCode').textbox('textbox').focus();
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
                        win.getData('datagrid').datagrid('reload');
                        callback();
                    });
                }else{
                    $.messager.alert('错误', '数据保存失败！' + result.message, 'error');
                }
            }
        });
    }
</script>
