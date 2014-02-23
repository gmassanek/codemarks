App.CodemarkShowView = Backbone.View.extend
  initialize: ->

  render: ->
    App.codemark = @model
    @$el.html(@toHtml())
    @prepare()
    @renderComments()

  toHtml: ->
    facile(@template(), @data())

  prepare: ->
    unless @model.get('editable')
      @$('.edit-codemark').remove()
    @$('.timeago').timeago()

  renderComments: ->
    App.comments = new App.Comments
    App.comments.resourceId = @model.get('resource').id
    App.comments.fetch
      success: =>
        @commentsView = new App.CommentsView
          collection: App.comments
        @$('.comments_container').append(@commentsView.$el)
        @commentsView.render()

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
