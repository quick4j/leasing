/**
 * @author zhaojh
 */
;(function($){
    if(typeof quick4j.ui.treegrid === 'undefined'){
        $.namespace("quick4j.ui.treegrid");
    }

    var getDefaultOptions = function(dgname){
            return {
                pageSize: 20,
                pageList: [10, 20, 50, 100],
                url: 'api/rest/datagrid/' + dgname,
//                singleSelect: false,
                loader: customJsonLoader
            }
        },

        customJsonLoader = function(param, successFn, errorFn){
            var opts = $(this).treegrid("options");
            if (!opts.url) {
                return false;
            }

            $.ajax({
                type: opts.method,
                url: opts.url,
                data: param,
                dataType: 'json',
                success: function(result){
                    if(result.status == '200'){
                        successFn(result.data);
                    }else{
                        alert(result.message);
                    }
                },
                error: function(){
                    alert('fail')
                    errorFn.apply(this, arguments);
                }
            });
        },

        buildDataGrid = function(target, options){
            var opts = $.extend({}, options);
            quick4j.ui.datagrid.string2ObjectForFormatterProperty(opts);
            quick4j.ui.datagrid.decorateToolbar(opts);
            $(target).treegrid(opts).treegrid('followCustomHandle');
        };

    $.extend(quick4j.ui.treegrid, {
        parse: function(target){
            var dgName = $.parser.parseOptions(target).name;
            $.ajax({
                url: 'api/rest/datagrid/' + dgName + '/options',
                success: function(result){
                    if(result.status != '200'){
                        alert('==>'+result.message)
                    }

                    var options = $.extend(
                        {},
                        getDefaultOptions(dgName),
                        result.data || {columns:[[{field: 'chk', checkbox: true}]]}
                    );
                    buildDataGrid(target, $.extend({}, options, {name: dgName}));
                },
                error: function(){
                    alert('error')
                }
            });
        }
    });
})(jQuery);
