App.CommentsView = Backbone.View.extend
  className: 'comments'
  tagName: 'ul'

  initialize: ->
    @collection.bind 'change', => @render()

  render: ->
    _.each @collection.where(parent_id: null), (model) =>
      commentView = new App.CommentView
        model: model
      @$el.append(commentView.$el)
      commentView.render()
    @renderNewCommentForm()

  renderNewCommentForm: ->
    renderNewCommentForm = new App.CommentFormView
    @$el.append(renderNewCommentForm.$el)
    renderNewCommentForm.render()
