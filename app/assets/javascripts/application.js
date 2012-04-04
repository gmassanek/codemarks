//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.16.custom.min.js
//= require jquery.qtip-1.0.0-rc3.min
//= require autocomplete-rails
//= require_tree .

var TOPICS_PATH = '/topics/'

function prepareTagDeletes() {
  $("#topic_tags .delete").click(function(event) {
    event.preventDefault();
    $(event.currentTarget).closest("li").fadeOut(100, function() {
      $(this).remove();
      var topics_count = $("#topic_tags li").length;
      if(topics_count == 0) {
        $("#codemark_form input[type=submit]").attr('disabled', 'disabled');
        //$("#save_codemark").attr('disabled', 'disabled');
      }
    });
  });
}

function style_lists() {
  $('#list_box li:nth-child(even)').addClass('alternate');
}

function prepareAutocompletes() {
  $(document).ready(function(){
    $('input[data-autocomplete]').railsAutocomplete();
  });

  $('#link_form_topic_autocomplete').bind('railsAutocomplete.select', function(event){
    var topic_id = $("#link_form_topic_slug").val()
    $.ajax({
      url: "/links/topic_checkbox",
      data: { topic_id: topic_id},
      beforeSend: function(request) { request.setRequestHeader("Accept", "text/javascript"); }
    });
  });
}

function prepareCodemarks() {
  $(".codemark_link").click(function(event) {
    $(event.target).closest("li").find("form").submit();
  });
}

$(function() {

  $('#_topic_autocomplete').bind('railsAutocomplete.select', function(event){
    var redirect = $("#_topic_slug").val()
    window.location = TOPICS_PATH + redirect;
  });

  $(".flash").delay(2500).fadeOut(1000);

  $("#new_link_link").click(function(event) { 
    $("#codemark_form").dialog('open') 
    event.preventDefault(); 
  }); 

  prepareCodemarks();
  style_lists();
  prepareAutocompletes();
  prepareTagDeletes();

});

