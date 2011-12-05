// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.16.custom.min.js
//= require_tree .

function prepareResourceLink(myEvent) {
    $(myEvent.target).next("form").submit();
    //myEvent.preventDefault();
}

$(function() {

  $(".flash").delay(2500).slideUp(1000);

  $("#link_form_container").dialog({
    autoOpen: false,
    modal: true,
    width: 550,
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


});

function style_lists() {
  $('#list_box>li:nth-child(even)').addClass('alternate');
}

