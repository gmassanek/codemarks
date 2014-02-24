App.CommentFormView = Backbone.View.extend
  events:
    'submit .create_comment': 'submitForm'

  initialize: ->
    unless @model
      @model = new App.Comment
      App.comments?.add(@model)

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
    @model.save()

  loggedOutTemplate: ->
    angelo('loggedOutCommentMessage.html')
