//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.16.custom.min.js
//= require jquery.qtip-1.0.0-rc3.min
//= require jquery.timeago
//= require autocomplete-rails
//= require codemark_form

window.Codemarks =
  prepareAutocompletes: ->
    $('input[data-autocomplete]').railsAutocomplete()

    $('#link_form_topic_autocomplete').bind('railsAutocomplete.select', (event) ->
      topic_id = $("#link_form_topic_slug").val()
      $.ajax
        url: "/codemarks/topic_checkbox",
        data: { topic_id: topic_id},
        beforeSend: (request) ->
          request.setRequestHeader("Accept", "text/javascript")
    )

$ ->
  $('#_topic_autocomplete').bind('railsAutocomplete.select', (event) ->
    slug = $("#_topic_slug").val()
    App.router.navigate("topics/#{slug}", {trigger: true})
  )
    
  $(".flash").delay(2500).fadeOut(1000)

  $("#new_link_link").click((event) ->
    $("#codemark_form").dialog('open')
    event.preventDefault()
  )
    
  Codemarks.prepareAutocompletes()
