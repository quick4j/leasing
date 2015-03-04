<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="padding: 5px;">
    <form method="post" id="newLeaserForm">
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
        $('#leaserCode').textbox('textbox').focus();
    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function doSaveAndNew(win){
        saveData(win, function(){
            $('#newLeaserForm').form('clear');
            setTimeout(function(){
                $('#leaserCode').textbox('textbox').focus();
            },20);
        });
    }

    function saveData(win, callback){
        $('#newLeaserForm').form('submit', {
            url: 'lease/relet/leaser/new',
            onSubmit: function(){
                return true;
            },
            success: function(data){
                var result = eval('(' + data + ')');
                if(result.status == 200){
                    win.getData('datagrid').datagrid('reload');
                    $.messager.alert('提示', '数据保存成功！','info', callback);
                }else{
                    $.messager.alert('错误', '数据保存失败！' + result.message, 'error');
                }
            }
        });
    }
</script>
