TextForm =
  setupSubmit: ->
    $('#codemark_title').focus()
    $("#codemark_form").submit (e) ->
      console.log e
      e.preventDefault()
      $cm_form = $(e.currentTarget)
      data = $cm_form.serialize()
      url = $cm_form.attr('action')
      $.ajax
        type: 'post'
        url: url
        data: data
        dataType: 'json'
        success: (response) =>
          TextForm.successfulPost(response)

  successfulPost: (response) ->
    codemark = new App.Models.Codemark(response.codemark)
    @insertCodemark(codemark)

  insertCodemark: (codemark) ->
    codemarkView = new App.Views.Codemark
      model: codemark
    $('.codemarks').prepend(codemarkView.render())
    $('#codemark_form').remove()

$ ->
  TextForm.setupSubmit()
