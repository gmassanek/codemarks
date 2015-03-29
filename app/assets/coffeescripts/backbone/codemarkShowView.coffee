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
    allData =
      markdown_html: @model.get('resource').html
      'user_image@src': @model.get('user')?.image || ''
      resource_url:
        content: ''
        src: @model.get('resource')?.url
      external_link:
        content: @model.get('title')
        href: @model.get('resource')?.url
      'user_link@href': "/users/#{@model.get('user')?.slug}"
      'name': @model.get('user')?.name
      'nickname': @model.get('user')?.nickname
      'timeago': new Date(@model.get('created_at')).toLocaleDateString()
      description: @model.get('description')
      'main-image':
        content: ''
        src: @model.get('resource').attachment_url
      attachment_name: @model.get('resource').attachment_file_name
      attachment_size: @model.get('resource').attachment_size
      download:
        content: 'Download'
        href: @model.get('resource').attachment_url
      description: @model.get('resource').description
      forks_count: @model.get('resource').forks_count
      watchers_count: @model.get('resource').watchers_count
      pushed_at: @model.get('resource').pushed_at
      repo_created_at: @model.get('resource').repo_created_at
      owner_avatar_url: @model.get('resource').owner_avatar_url
      owner_gravatar_id: @model.get('resource').owner_gravatar_id
      fork: @model.get('resource').fork
      size: @model.get('resource').size
      language: @model.get('resource').language
      owner_login: @model.get('resource').owner_login

    if @model.get('resource_type') != 'Link' && @model.get('resource_type') != 'Repository'
      allData['title'] = @model.get('title')
    allData

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
    angelo("#{@model.get('resource_type').toLowerCase()}/show.html")

  _frameTemplate: ->
    angelo("showCodemark.html")
