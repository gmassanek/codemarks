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

function prepareResourceLink(myEvent) {
  $(myEvent.target).parent().parent().find("form").submit();
}

$(function() {

  $(".flash").delay(2500).slideUp(1000);

  $("#link_form_container").dialog({
    autoOpen: false,
    modal: true,
    width: 600,
    closeOnEscape: true,
    title: "Add Link",
    close: function() {
      $.ajax({
        url: "/links/new",
        beforeSend: function(request) { request.setRequestHeader("Accept", "text/javascript"); }
      });
    }
  }); 

  $("#new_link_link").click(function(event) { 
    $("#link_form_container").dialog('open') 
    event.preventDefault(); 
  }); 

  $(".resource_link").click(function() {
    prepareResourceLink(event);
  });

  style_lists();

  $('#topic_autocomplete').bind('railsAutocomplete.select', function(event){
    var redirect = $("#topic_slug").val()
    window.location = TOPICS_PATH + redirect;
  });

  $('#link_search_autocomplete').bind('railsAutocomplete.select', function(event){
    var topic_id = $("#topic_slug").val()
    alert(topic_id);
    //$.get("/links/topic_checkbox.js", { topic_id: topic_id} );
    //$.get({
    //  url: "/links/topic_checkbox",
    //  data: { topic_id: topic_id},
    //  beforeSend: function(request) { request.setRequestHeader("Accept", "text/javascript"); }
    //});
    $.ajax({
      url: "/links/topic_checkbox",
      data: { topic_id: topic_id},
      beforeSend: function(request) { request.setRequestHeader("Accept", "text/javascript"); }
    });
    
    //send topic_id to server
    //have the server give me the partial for a checkbox item for that topic
    //i'm going inject that partial into list below`
  });

});

function style_lists() {
  $('#list_box li:nth-child(even)').addClass('alternate');
}

