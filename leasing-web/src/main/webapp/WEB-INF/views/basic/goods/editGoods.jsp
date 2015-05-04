<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="padding: 5px;">
    <form method="post" id="newGoodsForm">
        <input type="hidden" id="goodsId" name="id">
        <div class="form-group">
            <label class="control-label required" for="goodsType">商品分类</label>
            <div class="form-field">
                <input type="text" id="goodsType" style="width: 100%"
                       name="type" data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required" for="goodsCode">助记码</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="goodsCode" style="width: 100%"
                       name="code" data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required" for="goodsName">品名</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="goodsName" style="width: 100%"
                       name="name" data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label" for="goodsSpec">规格型号</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="goodsSpec" style="width: 100%"
                       name="spec">
            </div>
        </div>
        <div class="row">
            <label class="control-label" for="goodsUnit">计量单位</label>
            <div class="form-field">
                <select id="goodsUnit" name="unit" style="width: 100%;">
                    <option value="">--请选择--</option>
                    <option value="G">根</option>
                    <option value="T">套</option>
                    <option value="J">斤</option>
                    <option value="CM">cm</option>
                </select>
            </div>
        </div>
    </form>
    <div class="tip">
        <a class="tip-icon icon-tip"></a>
        <div class="tip-text">
            如果使用“数量=件数x规格”等式计算数量，请不要在规格中输入单位。
        </div>
    </div>
</div>
<script>
    function doInitData(win){
        var goods = win.getData("goods");


        $('#goodsType').combobox({
            url: 'api/rest/datagrid/goodsType',
            valueField: 'id',
            textField: 'name',
            panelMaxHeight: 100,
            value: goods.type,
            readonly: true,
            loadFilter: function(data){
                return data.data.rows;
            }
        });

        $('#goodsUnit').combobox({
            panelMaxHeight: 100,
            value: goods.unit,
            customAttr:{
                headervalue: '--请选择--'
            }
        }).combo('followCustomHandle');

        $("#goodsId").val(goods.id);
        $("#goodsCode").textbox('setValue', goods.code);
        $("#goodsName").textbox('setValue', goods.name);
        $('#goodsSpec').textbox('setValue', goods.spec);

    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function saveData(win, callback){
        $('#newGoodsForm').form('submit', {
            url: 'leasing/basic/goods/edit',
            onSubmit: function(){
                return $(this).form('validate');
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
