App.CommentView = Backbone.View.extend
  className: 'comment'
  tagName: 'li'

  events:
    'click .delete-comment': 'deleteComment'
    'click .edit-comment': 'editComment'
    'click .add-reply': 'addReply'

  initialize: ->
    @user = new App.User(@model.get('user'))

  render: ->
    @$el.html(@toHtml())
    @prepare()
    @renderChildren()

  prepare: ->
    @$el.addClass("comment-#{@model.get('id')}")
    @$('.timeago').timeago()
    @$('.delete-comment').remove() unless @editable()
    @$('.edit-comment').remove() unless @editable()

  renderChildren: ->
    _.each @childComments(), (model) =>
      commentView = new App.CommentView
        model: model
      @childElementsContainer().append(commentView.$el)
      commentView.render()

  toHtml: ->
    facile(@template(), @data())

  data: ->
    body: @model.get('html_body')
    avatar: if @user.get('image') then {content: '', src: @user.get('image')} else null
    nickname:
      content: @user.get('nickname')
      href: "/users/#{@user.get('slug')}"
    created_at:
      content: @model.get('created_at')
      title: @model.get('created_at')

  template: ->
    angelo('commentView.html')

  childComments: ->
    App.comments.where(parent_id: @model.get('id'))

  deleteComment: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if(confirm("Are you sure you want to delete your comment?"))
      @model.destroy
        success: => @remove()

  editComment: (e) ->
    e.preventDefault()
    e.stopPropagation()
    codemarkForm = new App.CommentFormView
      model: @model
    codemarkForm.render()
    @$el.replaceWith(codemarkForm.$el)

  addReply: (e) ->
    e.preventDefault()
    e.stopPropagation()
    codemarkForm = new App.CommentFormView
      parent_id: @model.get('id')
    codemarkForm.render()
    @childElementsContainer().append(codemarkForm.$el)
    codemarkForm.bind 'cancel', => @render()

  childElementsContainer: ->
    $(@$('.child_comments')[0])

  editable: ->
    @model.get('user')?.id == App.current_user?.get('id')
