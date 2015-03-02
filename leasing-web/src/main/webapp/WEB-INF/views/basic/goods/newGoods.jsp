<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .columns{}
    .row{}
    .row .columns{
        display: inline;
    }
</style>
<div style="padding: 5px;">
    <form method="post" id="newGoodsForm">
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>商品分类</label>
            </div>
            <div class="columns">
                <input class="textbox easyui-validatebox" type="text" id="goodsType"
                       name="type" data-options="required:true">
            </div>
        </div>
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>助记码</label>
            </div>
            <div class="columns">
                <input class="textbox easyui-validatebox" type="text" id="goodsCode"
                       name="code" data-options="required:true">
            </div>
        </div>
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>品名</label>
            </div>
            <div class="columns">
                <input class="textbox easyui-validatebox" type="text" id="goodsName"
                       name="name" data-options="required:true">
            </div>
        </div>
        <div class="row">
            <div class="columns">
                <label>规格型号</label>
            </div>
            <div class="columns">
                <input class="textbox" type="text" id="goodsSpec"
                       name="spec" data-options="required:true">
            </div>
        </div>
        <div class="row">
            <div class="columns">
                <span style="color: red">*</span>
                <label>计量单位</label>
            </div>
            <div class="columns">
                <select id="goodsUnit" name="unit" style="width: 200px;">
                    <option value="G">根</option>
                    <option value="T">套</option>
                </select>
            </div>
        </div>
    </form>
</div>
<script>
    function doInitData(win){
        $('#goodsType').combobox({
            url: 'api/rest/datagrid/goodsType',
            valueField: 'id',
            textField: 'name',
            panelMaxHeight: 100,
            value: win.getData('goodsType'),
            loadFilter: function(data){
                return data.data.rows;
            }
        });

        $('#goodsUnit').combobox({panelMaxHeight: 100});


    }

    function doSave(win){
        saveData(win, function(){
            win.close();
        });
    }

    function doSaveAndNew(win){
        saveData(win, function(){
            $('#newGoodsForm').form('reset');
            $('#goodsCode').focus();
        });
    }

    function saveData(win, callback){
        $('#newGoodsForm').form('submit', {
            url: 'basic/goods/new',
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
