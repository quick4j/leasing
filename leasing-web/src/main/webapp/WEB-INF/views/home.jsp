<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <%@include file="/static/global.inc"%>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <title></title>
        <link rel="stylesheet" href="static/css/upm.css">
        <link rel="stylesheet" href="static/js/vender/easyui/themes/default/easyui.css">
        <link rel="stylesheet" href="static/js/vender/easyui/themes/icon.css">
    </head>
    <body class="easyui-layout">
        <div data-options="region:'north'" style="height:50px;"></div>
        <div data-options="region:'east',title:'常用功能',split:true" style="width:250px;">
           <ul id="tt"></ul>
        </div>
        <div data-options="region:'center'">
            <div id="tbs">
                <div data-options="title:'Home'"></div>
            </div>
        </div>
        <!-- script -->
        <script src="static/js/vender/jquery-1.11.1.min.js"></script>
        <script src="static/js/vender/jquery.json-2.3.js"></script>
        <script src="static/js/vender/easyui/jquery.easyui.min.js"></script>
        <script src="static/js/vender/easyui/jquery.easyui.patch.js"></script>
        <script src="static/js/vender/easyui/locale/easyui-lang-zh_CN.js"></script>
        <script src="static/js/jquery.easyui.extension.min.js"></script>
        <script src="static/js/quick4j.parser.js"></script>
        <script src="static/js/quick4j.datagrid.js"></script>
        <script src="static/js/quick4j.util.js"></script>
        <script>
            $(function(){
                $('#tbs').tabs({
                    fit:true,
                    border:false,
                    customAttr: {
                        contextMenu: {
                            isShow: true
                        }
                    }
                }).tabs('followCustomHandle');

                $('#tt').tree({
                    url: 'tree.json',
                    onClick: function(node){
                        var $tabs = $('#tbs');
                        if($tabs.tabs('exists', node.text)){
                            $tabs.tabs('select', node.text);
                            return;
                        }

                        $tabs.tabs('add',{
                            title: node.text,
                            useiframe: true,
                            closable: true,
                            content:'url:' + node.attributes.url
                        });
                    }
                });
            });
        </script>
    </body>
</html>
