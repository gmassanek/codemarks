App.CodemarkFormView = Backbone.View.extend
  className: 'codemark form-mode'
  tagName: 'article'

  events:
    'click .cancel': 'cancel'

  render: ->
    @$el.html(@toHtml())

  toHtml: ->
    template = angelo('codemarkForm.html')
    facile(template, @model.attributes)

  cancel: ->
    @trigger('cancel')

  mode: ->
    if @model.get('id')?
      'update'
    else
      'new'
