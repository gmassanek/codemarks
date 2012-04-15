//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.16.custom.min.js
//= require jquery.qtip-1.0.0-rc3.min
//= require autocomplete-rails
//= require_tree .

TOPICS_PATH = '/topics/'

prepareTagDeletes = ->
  $("#topic_tags .delete").click (event) ->
    event.preventDefault()
    $(event.currentTarget).closest("li").fadeOut 100, ->
      $(this).remove()
      topics_count = $("#topic_tags li").length
      if(topics_count == 0)
        $("#codemark_form input[type=submit]").attr('disabled', 'disabled')

style_lists = ->
  $('#list_box li:nth-child(even)').addClass('alternate')

prepareAutocompletes = ->
  $ ->
    $('input[data-autocomplete]').railsAutocomplete()

  $('#link_form_topic_autocomplete').bind('railsAutocomplete.select', (event) ->
    topic_id = $("#link_form_topic_slug").val()
    $.ajax
      url: "/links/topic_checkbox",
      data: { topic_id: topic_id},
      beforeSend: (request) ->
        request.setRequestHeader("Accept", "text/javascript")
  )

prepareCodemarks = ->
  $(".codemark_link").click (event) ->
    $(event.target).closest("li").find("form").submit()

$ ->
    
  $('#_topic_autocomplete').bind('railsAutocomplete.select', (event) ->
    redirect = $("#_topic_slug").val()
    window.location = TOPICS_PATH + redirect
  )
    
  $(".flash").delay(2500).fadeOut(1000)

  $("#new_link_link").click((event) ->
    $("#codemark_form").dialog('open')
    event.preventDefault()
  )
    
  prepareCodemarks()
  style_lists()
  prepareAutocompletes()
  prepareTagDeletes()
