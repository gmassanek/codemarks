App.CodemarkletView = Backbone.View.extend
  className: 'codemarklet'

  render: ->
    @formView = new App.LinkRecordFormView
      model: App.codemark
    @formView.render()
    @$el.html(@formView.$el)

    @bindToView()
    @registerCloseOnEscape()

  bindToView: ->
    @formView.bind 'updated', => @success()
    @formView.bind 'created', => @success()

  success: ->
    @$('.message').remove()
    @$el.prepend("<div class='success message'>Codemark saved successfully. <a href='http://www.codemarks.com/codemarks?user_id=#{CURRENT_USER}' target='_blank'>Check it out</a></div>")
    setTimeout @close, 5000

  registerCloseOnEscape: ->
    $(document).keyup (e) =>
      if (e.keyCode == 27)
        @close()

  close: ->
    window.close()
