topics_count = $("#topic_tags li").length

$("#codemark_form").keyup (event) ->
  if (event.keyCode == 13)
    event.preventDefault()

$(document).keyup (event) ->
  if (event.keyCode == 27)
    $('#codemark_form').replaceWith("#{ escape_javascript(render('/codemarks/form')) }")

$('input[data-autocomplete]').railsAutocomplete()

$("#link_form_topic_autocomplete").keydown (event) ->
  if (event.keyCode == 13)
    if($("#link_form_topic_count").val() == 0)
      event.preventDefault()

      entered = $("#link_form_topic_autocomplete").val()
      $.ajax
        url: "/links/topic_checkbox",
        data: { topic_title: entered },
        dataType: "script"

if(topics_count == 0)
  $("#codemark_form input[type=submit]").attr('disabled', 'disabled')

$(document).ready ->
  console.log 'woo'
  console.log $("#topic_tags .delete")
  $('#topic_tags').delegate('.delete', 'click', (event) ->
    console.log 'woo'
    event.preventDefault()

    $(event.currentTarget).closest("li").fadeOut 100, ->
      $(this).remove()
      topics_count = $("#topic_tags li").length
      if(topics_count == 0)
        $("#codemark_form input[type=submit]").attr('disabled', 'disabled')
  )
