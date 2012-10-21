App.CodemarkFormView = Backbone.View.extend
  tagName: 'form'
  className: 'codemark_form'

  events:
    'click .cancel': 'cancel'

  render: ->
    @$el.html(@toHtml())

  toHtml: ->
    template = angelo('codemarkForm.html')
    facile(template, @model.attributes)

  cancel: ->
    @trigger('cancel')
