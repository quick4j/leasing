<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="padding: 5px;">
    <form method="post" id="newGoodsTypeForm">
        <input type="hidden" id="goodsTypeId" name="id">
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
        var goodsType = win.getData('goodsType');
        $('#goodsTypeId').val(goodsType.id);
        $('#goodsTypeCode')
                .textbox('setValue', goodsType.code)
                .textbox('textbox').focus();
        $('#goodsTypeName').textbox('setValue',goodsType.name);
    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function saveData(win, callback){
        $('#newGoodsTypeForm').form('submit', {
            url: 'leasing/basic/goods/type/edit',
            onSubmit: function(){
                return $(this).form('validate');
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
