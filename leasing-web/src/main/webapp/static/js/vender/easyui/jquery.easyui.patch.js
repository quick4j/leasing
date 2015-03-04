/**
 * The Patch for jQuery EasyUI 1.4.1
 */
(function($){
	function setMe(target){
		var p = $(target).combo('panel');
		p.panel('options').onClose = function(){
			var target = $(this).panel('options').comboTarget;
			var state = $(target).data('combo');
			if (state){
				state.options.onHidePanel.call(target);
			}
		}
	}
	var plugin = $.fn.combo;
	$.fn.combo = function(options, param){
		if (typeof options != 'string'){
			return this.each(function(){
				plugin.call($(this), options, param);
				setMe(this);
			});
		} else {
			return plugin.call(this, options, param);
		}
	};
	$.fn.combo.methods = plugin.methods;
	$.fn.combo.defaults = plugin.defaults;
	$.fn.combo.parseOptions = plugin.parseOptions;

})(jQuery);

