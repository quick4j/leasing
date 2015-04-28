<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="padding: 5px;">
    <form method="post" id="newGoodsTypeForm" style="width: 100%">
        <div class="form-group">
            <label class="control-label required" for="goodsTypeCode">助记码</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="goodsTypeCode" style="width: 100%"
                       name="code" data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required" for="goodsTypeName">分类名称</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="goodsTypeName" style="width: 100%"
                       name="name" data-options="required:true">
            </div>
        </div>
    </form>
</div>
<script>
    function doInitData(win){
        $('#goodsTypeCode').textbox('textbox').focus();
    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function doSaveAndNew(win){
        saveData(win, function(){
            $('#newGoodsTypeForm').form('clear');
            $('#goodsTypeCode').textbox('textbox').focus();
        });
    }

    function saveData(win, callback){
        $('#newGoodsTypeForm').form('submit', {
            url: 'leasing/basic/goods/type/new',
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
