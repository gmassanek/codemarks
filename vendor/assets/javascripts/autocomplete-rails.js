/*
* Unobtrusive autocomplete
*
* To use it, you just have to include the HTML attribute autocomplete
* with the autocomplete URL as the value
*
*   Example:
*       <input type="text" data-autocomplete="/url/to/autocomplete">
*
* Optionally, you can use a jQuery selector to specify a field that can
* be updated with the element id whenever you find a matching value
*
*   Example:
*       <input type="text" data-autocomplete="/url/to/autocomplete" data-id-element="#id_field">
*/

(function(jQuery)
{
  var self = null;
  jQuery.fn.railsAutocomplete = function() {
    //return this.live('focus',function() {
      if (!this.railsAutoCompleter) {
        this.railsAutoCompleter = new jQuery.railsAutocomplete(this);
      }
    //});
  };

  jQuery.railsAutocomplete = function (e) {
    _e = e;
    this.init(_e);
  };

  jQuery.railsAutocomplete.fn = jQuery.railsAutocomplete.prototype = {
    railsAutocomplete: '0.0.1'
  };

  jQuery.railsAutocomplete.fn.extend = jQuery.railsAutocomplete.extend = jQuery.extend;
  jQuery.railsAutocomplete.fn.extend({
    init: function(e) {
      e.delimiter = $(e).attr('data-delimiter') || null;
      function split( val ) {
        return val.split( e.delimiter );
      }
      function extractLast( term ) {
        return split( term ).pop().replace(/^\s+/,"");
      }
	  var append_to = $(e).attr('append_to');
      $(e).autocomplete({
		autoFocus: $(e).attr('auto_focus') || false,
		disabled: $(e).attr('disabled') || false,
		delay: ($(e).attr('delay') || 300),
		appendTo: append_to || "body",
		postion: ($(e).attr('position')) || { my: "left top", at: "left bottom", collision: "none" },

        source: function( request, response ) {
          $.getJSON( $(e).attr('data-autocomplete'), {
            term: extractLast( request.term )
          }, function() {
            $(arguments[0]).each(function(i, el) {
              var obj = {};
              obj[el.id] = el;
              $(e).data(obj);
            });

            count_ele_id = $(e).attr('data-count');
            if (count_ele_id != undefined) {
              count_ele = $("#" + count_ele_id);
              count_ele.val(arguments[0].length);
            }
            response.apply(null, arguments);
          });
        },
		open: function() {
		  // when appending the result list to another element, we need to cancel the "position: relative;" css.
		  if (append_to){
		    $(append_to + ' ul.ui-autocomplete').css('position', 'static');
		  }
		},
        search: function() {
          // custom minLength
		  var minLength = $(e).attr('min_length') || 2;
          var term = extractLast( this.value );
          if ( term.length < minLength ) {
            return false;
          }
        },
        focus: function() {
          // prevent value inserted on focus
          return false;
        },
        select: function( event, ui ) {
          var terms = split( this.value );
          // remove the current input
          terms.pop();
          // add the selected item
          terms.push( ui.item.value );
          // add placeholder to get the comma-and-space at the end
          if (e.delimiter != null) {
            terms.push( "" );
            this.value = terms.join( e.delimiter );
          } else {
            this.value = terms.join("");
            if ($(this).attr('data-id-element')) {
              $($(this).attr('data-id-element')).val(ui.item.id);
            }
            if ($(this).attr('data-update-elements')) {
              var data = $(this).data(ui.item.id.toString());
              var update_elements = $.parseJSON($(this).attr("data-update-elements"));
              for (var key in update_elements) {
                $(update_elements[key]).val(data[key]);
              }
            }
          }
          var remember_string = this.value;
          $(this).bind('keyup.clearId', function(){
            if($(this).val().trim() != remember_string.trim()){
              $($(this).attr('data-id-element')).val("");
              $(this).unbind('keyup.clearId');
            }
          });
          $(this).trigger('railsAutocomplete.select');


          return false;
        }
      });
    }
  });
})(jQuery);
