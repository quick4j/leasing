<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="padding: 5px;">
    <form method="post" id="newHolderForm">
        <input type="hidden" id="holderId" name="id">
        <div class="form-group">
            <label class="control-label required" for="holderCode">助记码</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="holderCode" style="width: 100%"
                       name="code" data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required">承建单位名称</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="holderName" style="width: 100%"
                       name="name" data-options="required:true">
            </div>
        </div>
    </form>
</div>
<script>
    function doInitData(win){
        var holder = win.getData('holder');
        $('#holderId').val(holder.id);
        $('#holderCode')
                .textbox('setValue',holder.code)
                .textbox('textbox')
                .focus();
        $('#holderName').textbox('setValue',holder.name);
    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function saveData(win, callback){
        var holderid = $('#holderId').val();
        $('#newHolderForm').form('submit', {
            url: 'lease/holder/'+ holderid +'/edit',
            onSubmit: function(){
                return true;
            },
            success: function(data){
                var result = eval('(' + data + ')');
                if(result.status == 200){
                    $.messager.alert('提示', '数据保存成功！','info', function(){
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
