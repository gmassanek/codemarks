App.CommentView = Backbone.View.extend
  className: 'comment'
  tagName: 'li'

  initialize: ->
    @user = new App.User(@model.get('user'))

  render: ->
    @$el.html(@toHtml())
    @$('.timeago').timeago()
    @renderChildren()

  renderChildren: ->
    _.each @childComments(), (model) =>
      commentView = new App.CommentView
        model: model
      @$('.child_comments').append(commentView.$el)
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
