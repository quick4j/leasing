/**
 * @author zhaojh
 */
;(function($){
    if(typeof quick4j.ui.datagrid === 'undefined'){
        $.namespace("quick4j.ui.datagrid");
    }

    var decorateToolbar = function(options){
        if(options.toolbar){
            var tb = [];
            for(var i=0; i<options.toolbar.length; i++){
                tb.push(options.toolbar[i]);
                tb.push('-');
            }

            $.extend(options, {toolbar: tb});
        }
    },

    buildDataGrid = function(target, options){
        var opts = $.extend({}, options);

        string2ObjectForFormatterProperty(opts);
        decorateToolbar(opts);

        var onLoadSuccessHandler = function(){};
        if(opts.onLoadSuccess){
            onLoadSuccessHandler = opts.onLoadSuccess;
            delete opts.onLoadSuccess;
        }


        $(target)
            .datagrid(opts)
            .datagrid('addEventListener',[{
                name: 'onClickCell',
                handler: unselectForOperationColumn
            },{
                name: 'onLoadSuccess',
                handler: onLoadSuccessHandler
            }]);
    },

    string2ObjectForFormatterProperty = function(options){
        $.each(options.columns, function(i, row){
            $.each(row, function(i, column){
                if(column.formatter && typeof column.formatter == 'string' && $.trim(column.formatter)!=''){
                    column.formatter = eval(column.formatter);
                }
            });
        });
    },

    unselectForOperationColumn = function(rowIndex, field, value){
        if(field == 'operation'){
            var target = this;
            setTimeout(function(){
                $(target).datagrid('unselectRow', rowIndex);
            }, 1);
        }
    },

    customJsonLoader = function(param, successFn, errorFn){
        var opts = $(this).datagrid("options");
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

    getDefaultOptions = function(dgname){
        return {
            pageSize: 20,
            pageList: [10, 20, 50, 100],
            url: dgname ? 'api/rest/datagrid/' + dgname : null,
            loader: customJsonLoader
        }
    };

    $.extend(quick4j.ui.datagrid, {
        parse: function(target){
            var htmlOptions = $.parser.parseOptions(target);
            var dgName = htmlOptions.name;

            if(htmlOptions.columns){
                buildDataGrid(target, $.extend({}, getDefaultOptions(dgName),htmlOptions, {name: dgName}));
            }else{
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

        },
        customJsonLoader: customJsonLoader,
        string2ObjectForFormatterProperty: function(options){
            string2ObjectForFormatterProperty(options);
        },
        decorateToolbar: function(options){
            decorateToolbar(options);
        }
    });
})(jQuery);