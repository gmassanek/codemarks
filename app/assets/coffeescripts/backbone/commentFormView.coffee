App.CommentFormView = Backbone.View.extend
  events:
    'submit .create_comment': 'submitForm'

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

  template: ->
    angelo('commentForm.html')

  submitForm: (e) ->
    e.preventDefault()
    App.comments.create
      body: @$('.body').val()

  loggedOutTemplate: ->
    angelo('loggedOutCommentMessage.html')
