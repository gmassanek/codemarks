App.CodemarkShowView = Backbone.View.extend
  events:
    'click .add_codemark a': 'addCodemarkClicked'
    'click .edit-codemark': 'editCodemarkClicked'

  initialize: ->
    App.codemark = @model

  render: ->
    @renderFrameHTML()
    @renderCodemark()
    @prepare()
    @renderComments()
    @renderAddCodemarkView()
    @renderCodemarksList()

  renderFrameHTML: ->
    @$el.html(facile(@_frameTemplate(), @data()))

  renderCodemark: ->
    @$('.main-codemark').html(@_codemarkHtml())

  renderAddCodemarkView: ->
    @addCodemarkView = new App.AddCodemarkView
      modal: true
      source: 'web-codemarkShow'
    @addCodemarkView.render()
    @$('aside').append(@addCodemarkView.$el)

  renderCodemarksList: ->
    @codemarksView = new App.CodemarksView
      paginated: false
    @codemarksView.render()
    @$('aside').append(@codemarksView.$el)

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
        @$('.comments_container').html('<h3>Comments</h3>')
        @$('.comments_container').append(@commentsView.$el)
        @commentsView.render()

  data: ->
    markdown_html: @model.get('resource').html
    title: @model.get('title')
    'user_image@src': @model.get('user')?.image || ''
    linkmark:
      content: ''
      src: @model.get('resource')?.url
    'user_link@href': "/users/#{@model.get('user')?.slug}"
    'name': @model.get('user')?.name
    'nickname': @model.get('user')?.nickname
    'timeago': new Date(@model.get('created_at')).toLocaleDateString()

  addCodemarkClicked: (e) ->
    e?.preventDefault()
    if App.current_user.get('id')?
      @openNewCodemarkModal()
    else
      window.location = '/sessions/new'

  editCodemarkClicked: (e) ->
    e?.preventDefault()
    editView = new App.EditCodemarkParentView
      model: @model
    @$('.main-codemark').html(editView.$el)
    editView.render()

    editView.bind 'cancel', => @renderCodemark()
    editView.bind 'updated', => @renderCodemark()

  openNewCodemarkModal: (e) ->
    e?.preventDefault()
    @addCodemarkParentView = new App.AddCodemarkParentView
      modal: true
      source: 'web'
    @addCodemarkParentView.render()

  _codemarkHtml: ->
    facile(@_codemarkTemplate(), @data())

  _addCodemarkHtml: ->
    angelo('add_codemark.html')

  _codemarkTemplate: ->
    angelo("show#{@model.get('resource_type')}Codemark.html")

  _frameTemplate: ->
    angelo("showCodemark.html")
