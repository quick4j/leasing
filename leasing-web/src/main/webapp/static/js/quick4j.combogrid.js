/**
 * @author zhaojh
 */
;(function($){
    if(typeof quick4j.ui.combogrid === 'undefined'){
        $.namespace("quick4j.ui.combogrid");
    }

    var getDefaultOptions = function(dgname){
            return {
                pageSize: 20,
                pageList: [10, 20, 50, 100],
                url: 'api/rest/datagrid/' + dgname,
                loader: quick4j.ui.datagrid.customJsonLoader
            }
        },

        buildDataGrid = function(target, options){
            var opts = $.extend({}, options);
            $(target).combogrid(opts);
        };


    $.extend(quick4j.ui.combogrid, {
        parse: function(target){
            var dgName = $.parser.parseOptions(target).name;
            var options = $.extend(
                {},
                getDefaultOptions(dgName)
            );
            buildDataGrid(target, $.extend({}, options, {name: dgName}));
        }
    });
})(jQuery);
