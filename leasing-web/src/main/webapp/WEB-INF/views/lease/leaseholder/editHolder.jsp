<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .columns{}
    .row{}
    .row .columns{
        display: inline;
    }
</style>
<div style="padding: 5px;">
    <form method="post" id="newHolderForm">
        <input type="hidden" id="holderId" name="id">
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>助记码</label>
            </div>
            <div class="columns">
                <input class="textbox easyui-validatebox" type="text" id="holderCode"
                       name="code" data-options="required:true">
            </div>
        </div>
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>承建单位名称</label>
            </div>
            <div class="columns">
                <input class="textbox easyui-validatebox" type="text" id="holderName"
                       name="name" data-options="required:true">
            </div>
        </div>
    </form>
</div>
<script>
    function doInitData(win){
        var holder = win.getData('holder');
        $('#holderId').val(holder.id);
        $('#holderCode').val(holder.code);
        $('#holderName').val(holder.name);
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
