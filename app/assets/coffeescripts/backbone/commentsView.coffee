App.CommentsView = Backbone.View.extend
  className: 'comments'
  tagName: 'ul'

  render: ->
    _.each @collection.where(parent_id: null), (model) =>
      commentView = new App.CommentView
        model: model
      @$el.append(commentView.$el)
      commentView.render()
