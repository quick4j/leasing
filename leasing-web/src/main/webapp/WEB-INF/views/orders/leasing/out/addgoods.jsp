<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="padding: 5px;">
    <form method="post" id="ff">
        <div class="form-group">
            <label class="control-label required" for="code">助记码</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="code" style="width: 100%"
                       data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label" for="name">料具名称</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="name" style="width: 100%"
                       data-options="editable:false">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label" for="spec">规格型号</label>
            <div class="form-field">
                <input class="easyui-textbox" type="text" id="spec" style="width: 100%"
                       data-options="editable:false">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label" for="location">库位</label>
            <div class="form-field">
                <input class="easyui-numberbox" type="text" id="location" style="width: 100%">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required" for="packages">件数</label>
            <div class="form-field">
                <input class="easyui-numberbox" type="text" id="packages" style="width: 100%"
                       data-options="required:true">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label required" for="numbers">数量</label>
            <div class="form-field">
                <input class="easyui-numberbox" type="text" id="numbers" style="width: 100%"
                       data-options="precision:1,editable: false">
            </div>
        </div>
    </form>
</div>
<script>
    var newGoods = {};
    function doInit(dialog){
        bindEventForCodeEditor();
        bindEventForPackagesEditor();
        bindEventForLocationEditor();
    }

    function bindEventForCodeEditor(){
        $('#code').textbox('textbox')
            .focus()
            .bind('keypress', function(event){
                if($(event.target).val().length > 0){
                    setTimeout(function(){
                        showSearchGoodsDialog();
                    }, 2);
                }
            })
            .bind('keydown', function(event){
                if(event.keyCode == 13){
                    $('#location').numberbox('textbox').focus();
                }
            });
    }

    function bindEventForPackagesEditor() {
        $('#packages').textbox("textbox")
            .bind('keypress', function(event){
                setTimeout(function(){
                    calcNumber();
                }, 5);
            })
            .bind('keydown', function(event){
                if(event.keyCode == 8){
                    setTimeout(function(){
                        calcNumber();
                    }, 5);
                }

                if(event.keyCode == 13){
                    $('#packages').numberbox('textbox').focus();
                }
            });
    }

    function bindEventForLocationEditor(){
        $('#location').textbox('textbox')
                .bind('keydown', function(event){
                    if(event.keyCode == 13){
                        $('#packages').numberbox('textbox').focus();
                    }
                });
    }

    function calcNumber(){
        var packages = $('#packages').textbox('textbox').val();
        var spec = $('#spec').textbox('getValue');
        if($.trim(spec).length >0 && !isNaN(spec)){
            var numbers = parseFloat(spec) * parseInt(packages);
            $('#numbers').numberbox('setValue', numbers);
        }else{
            $('#numbers').numberbox('setValue', parseInt(packages));
        }
    }

    function showSearchGoodsDialog(){
        $.showModalDialog({
            id: 'searchGoodsDialog',
            title: '选择-料具',
            width: 600,
            height: 400,
            data: {
                searchValue: $('#code').textbox('textbox').val(),
                callback: function(goods){
                    $('#code').textbox('setValue', goods.code);
                    $('#name').textbox('setValue', goods.name);
                    $('#spec').textbox('setValue', goods.spec);

                    $.extend(newGoods, {
                        goodsId: goods.id,
                        goodsType: goods.type,
                        goodsCode: goods.code,
                        goodsName: goods.name,
                        goodsSpec: goods.spec
                    });
                }
            },
            content: 'url:leasing/orders/common/dialog/goods',
            buttons:[{
                text: '确定',
                iconCls: 'icon-ok',
                handler: 'doOK'
            },{
                text: '取消',
                iconCls: 'icon-cancel',
                handler: function(dialog){
                    dialog.close();
                }
            }],
            onLoad: function(dialog, body){
                if(body && body.doInit){
                    body.doInit(dialog);
                }
            },
            onDestroy: function(){
                $('#location').numberbox('textbox').focus();
            }
        });
    }

    function doSaveAndNew(dialog){
        if(!$.isEmptyObject(newGoods)){
            $.extend(newGoods, {
                goodsLocation: $('#location').numberbox('getValue'),
                packages: $('#packages').numberbox('getValue'),
                numbers: $('#numbers').numberbox('getValue')
            });
            dialog.getData('datagrid').datagrid('appendRow',newGoods);
        }
        $('#ff').form('clear');
    }

    function doSave(dialog){
        if(!$.isEmptyObject(newGoods)){
            $.extend(newGoods, {
                goodsLocation: $('#location').textbox('getValue'),
                packages: $('#packages').numberbox('getValue'),
                numbers: $('#numbers').numberbox('getValue')
            });
            dialog.getData('datagrid').datagrid('appendRow',newGoods);
        }
        dialog.close();
    }
</script>
