App.NewCodemarkTileView = Backbone.View.extend
  id: 'new_codemarks'
  className: 'codemark'
  tagName: 'article'

  events:
    'click .new_link a': 'newLinkClicked'
    'submit .new_link form': 'newLinkFormSubmitted'

  render: ->
    template = angelo('newCodemarkTile.html')
    @$el.html(template)

  newLinkClicked: (e) ->
    e.preventDefault()
    @showUrlForm()

  showUrlForm: ->
    template = '<form><input placeholder="Paste Link"/><button>Add</button></form>'
    @$('.new_link').html(template)

  newLinkFormSubmitted: (e) ->
    e.preventDefault()
    url = $(e.currentTarget).find('input').val()
    @fetchFullFormFor(url)

  fetchFullFormFor: (url) ->
    data = { url: url }
    $.ajax
      type: 'GET'
      url: '/codemarks/new'
      data: { url: url }
      success: (response) =>
        @showNewLinkForm(response)

  showNewLinkForm: (response) ->
    codemark = new App.Codemark(response)
    @formView = new App.CodemarkFormView
      model: codemark
    @formView.render()
    @formView.bind 'cancel', => @cancelForm()
    @formView.bind 'updated', => @render()
    @formView.bind 'created', => @newCodemarkAdded()
    @$el.html(@formView.$el)
    @$el.addClass('form-mode')
    @$('.topics').chosen()

  newCodemarkAdded: ->
    App.codemarks.add(@formView.model.attributes)
    @render()

  cancelForm: ->
    @render()
    @$el.removeClass('form-mode')
