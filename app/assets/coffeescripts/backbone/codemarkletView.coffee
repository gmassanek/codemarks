App.CodemarkletView = Backbone.View.extend
  className: 'codemarklet'

  render: ->
    console.log App.codemark
    @formView = new App.CodemarkFormView
      model: App.codemark
    @formView.render()
    @$el.html(@formView.$el)
    @bindToView()

  bindToView: ->
    @formView.bind 'cancel', => @handleCancel()
    @formView.bind 'updated', => @success()
    @formView.bind 'created', => @success()

  handleCancel: ->
    console.log 'Cancel'

  success: ->
    console.log 'success'
