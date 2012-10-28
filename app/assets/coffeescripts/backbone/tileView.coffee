App.TileView = Backbone.View.extend
  className: 'tile'
  tagName: 'section'

  initialize: ->
    @model = new App.Codemark unless @model?

  render: ->
    @renderCodemarkView() if @model?.exists()

  renderCodemarkView: ->
    return if @model.new()
    @view = new App.CodemarkView
      model: @model
    @view.render()
    @$el.html(@view.$el)
