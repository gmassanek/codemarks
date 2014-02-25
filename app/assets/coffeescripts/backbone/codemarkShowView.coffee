App.CodemarkShowView = Backbone.View.extend
  events:
    'click .add_codemark a': 'addCodemarkClicked'
    'click .edit-codemark': 'editCodemarkClicked'
    'keyup .codemark_form textarea': 'textareaChanged'

  initialize: ->
    App.codemarks.bind 'add', (model) =>
      @appendCodemarks()

  render: ->
    App.codemark = @model
    @$el.html(@toHtml())
    @prepare()
    @renderComments()
    @$('aside .codemarks').html(@_addCodemarkHtml())

  appendCodemarks: ->
    for codemark in App.codemarks.models
      @$('aside .codemarks').append(@codemarkHtml(codemark))

  codemarkHtml: (codemark) ->
    tile = new App.TileView
      model: codemark
    tile.render()
    tile.$el

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
        @$('.comments_container').html(@commentsView.$el)
        @commentsView.render()

  data: ->
    markdown_html: @model.get('resource').html
    title: @model.get('title')
    'user_image@src': @model.get('user')?.image || ''
    'user_link@href': "/users/#{@model.get('user')?.slug}"
    'name': @model.get('user')?.name
    'nickname': @model.get('user')?.nickname
    'timeago': new Date(@model.get('created_at')).toLocaleDateString()

  template: ->
    angelo('showTextCodemark.html')

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
    editView.render()
    @$('.main-codemark').html(editView.$el)

    $hiddenDiv = $("<div class='hide text-height-container'></div>")
    @$('.codemark_form').append($hiddenDiv)

    @resizeTexArea(@$('textarea.text'))

    editView.bind 'cancel', => @render()
    editView.bind 'updated', => @render()

  textareaChanged: (e) ->
    @resizeTexArea($(e.currentTarget))

  resizeTexArea: ($textarea) =>
    val = $textarea.val()
    $hiddenDiv = $('.text-height-container')
    $hiddenDiv.html(val.replace(/\n/g, '<br>') + "</br></br></br>")
    @$('.codemark_form textarea.text').css('height', $hiddenDiv.height())

  openNewCodemarkModal: (e) ->
    e?.preventDefault()
    @addCodemarkParentView = new App.AddCodemarkParentView
      modal: true
      source: 'web'
    @addCodemarkParentView.render()

  toHtml: ->
    facile(@template(), @data())

  _addCodemarkHtml: ->
    angelo('add_codemark.html')
