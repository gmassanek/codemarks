// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.16.custom.min.js
//= require autocomplete-rails
//= require_tree .

var TOPICS_PATH = '/topics/'

function prepareTagDeletes() {
  $("#topic_tags .delete").click(function(event) {
    event.preventDefault();
    $(event.currentTarget).closest("li").fadeOut(500, function() {
      $(this).remove();
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

function prepareResourceLink() {
  $(".resource_link").click(function(event) {
    $(event.target).parent().parent().find("form").submit();
  });
}

$(function() {

  $('#_topic_autocomplete').bind('railsAutocomplete.select', function(event){
    var redirect = $("#_topic_slug").val()
    window.location = TOPICS_PATH + redirect;
  });

  $(".flash").delay(2500).slideUp(1000);

  $("#new_link_link").click(function(event) { 
    $("#link_form_container").dialog('open') 
    event.preventDefault(); 
  }); 

  prepareResourceLink();
  style_lists();
  prepareAutocompletes();
  prepareTagDeletes();

});

