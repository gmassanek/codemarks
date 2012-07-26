window.Codemarks ||= {}

window.Codemarks.Header =

  start: ->
    @setupTextCodemarkLink()

  setupTextCodemarkLink: ->
    $('#header').delegate '#add_text_codemark', 'click', => @prepareTextCodemarkForm()

  prepareTextCodemarkForm: ->
    $.ajax(
      url: "/codemark_forms/text?saver=#{USER_ID}"
      dataType: 'html'
      error: ->
        console.log 'help'
      success: (response) ->
        $('body').append($(response))
    )

$ ->
  window.USER_ID ||= undefined
  if USER_ID
    window.Codemarks.Header.start()
