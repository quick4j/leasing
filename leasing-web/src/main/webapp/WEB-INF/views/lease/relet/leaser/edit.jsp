<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="padding: 5px;">
    <form method="post" id="editLeaserForm">
        <input type="hidden" id="leaserId" name="id">
        <div class="form-group">
            <label class="control-label required" for="leaserCode">助记码</label>
            <div class="form-field">
                <input class="easyui-textbox"
                       type="text" id="leaserCode" style="width: 100%"
                       name="code" data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required" for="leaserName">名称</label>
            <div class="form-field">
                <input class="easyui-textbox"
                       type="text" id="leaserName" style="width: 100%"
                       name="name" data-options="required:true">
            </div>
        </div>
    </form>
</div>
<script>
    function doInitData(win){
        var leaser = win.getData('leaser');
        $('#leaserId').val(leaser.id);
        $('#leaserCode')
                .textbox('setValue', leaser.code)
                .textbox('textbox')
                .focus();
        $('#leaserName').textbox('setValue', leaser.name);

    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function saveData(win, callback){
        var leaserid = $('#leaserId').val();
        $('#editLeaserForm').form('submit', {
            url: 'lease/relet/leaser/' + leaserid + '/edit',
            onSubmit: function(){
                return true;
            },
            success: function(data){
                var result = eval('(' + data + ')');
                if(result.status == 200){
                    $.messager.alert('提示', '数据保存成功！');
                    win.getData('datagrid').datagrid('reload');
                    callback();
                }else{
                    $.messager.alert('错误', '数据保存失败！' + result.message, 'error');
                }
            }
        });
    }
</script>
