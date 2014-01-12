App.CodemarkShowView = Backbone.View.extend
  initialize: ->

  render: ->
    App.codemark = @model
    @$el.html(@toHtml())
    unless @model.get('editable')
      @$('.edit-codemark').remove()
    @$('.timeago').timeago()

  toHtml: ->
    facile(@template(), @data())

  data: ->
    markdown_html: @model.get('resource').html
    title: @model.get('title')
    'edit-codemark@href': "/codemarks/#{@model.get('id')}/edit"
    'user_image@src': @model.get('user')?.image || ''
    'user_link@href': "/users/#{@model.get('user')?.id}"
    'name': @model.get('user')?.name
    'nickname': @model.get('user')?.nickname
    'timeago': new Date(@model.get('created_at')).toLocaleDateString()

  template: ->
    angelo('showTextCodemark.html')
