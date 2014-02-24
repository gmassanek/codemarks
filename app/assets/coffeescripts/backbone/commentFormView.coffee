App.CommentFormView = Backbone.View.extend
  tagName: 'li'
  className: 'new_comment'

  events:
    'submit .create_comment': 'submitForm'

  initialize: ->
    unless @model
      @model = new App.Comment
      App.comments.add(@model)
    $('body').live 'keyup', (e) => @bodyClicked(e)

  bodyClicked: (e) ->
    if e.keyCode == 27
      e.stopPropagation()
      @trigger('cancel')
      $('body').die 'keyup'

  render: ->
    if App.current_user.get('id')?
      @$el.html(@toHtml())
    else
      @$el.html(@loggedOut())

  toHtml: ->
    facile(@template(), @data())

  loggedOut: ->
    facile(@loggedOutTemplate(), {})

  data: ->
    avatar: if App.current_user.get('image') then {content: '', src: App.current_user.get('image')} else null
    body: @model?.get('body') || ''

  template: ->
    angelo('commentForm.html')

  submitForm: (e) ->
    e.preventDefault()
    @model.set('body', @$('.body').val())
    @model.set('parent_id', @options.parent_id, silent: true) if @options.parent_id?
    @model.save()

  loggedOutTemplate: ->
    angelo('loggedOutCommentMessage.html')
