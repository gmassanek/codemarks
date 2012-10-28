App.TileView = Backbone.View.extend
  className: 'tile'
  tagName: 'section'

  initialize: ->
    @model = new App.Codemark unless @model?
    @isTheAddCodemarkTile = @options.add

  render: ->
    @renderCodemarkView() if @model.exists()
    @renderAddCodemarkView() if @isTheAddCodemarkTile

  replaceElWithView: ->
    @$el.html(@view.$el)

  bindToView: ->
    @view.bind 'turnIntoForm', => @turnViewIntoForm()
    @view.bind 'cancel', => @render()
    @view.bind 'updated', => @render()
    @view.bind 'created', (data) => @codemarkCreated(data)

  codemarkCreated: (data) ->
    # would love to get knowledge of this out
    App.codemarks.add(data)
    @render()

  renderCodemarkView: ->
    return if @isTheAddCodemarkTile
    @view = new App.CodemarkView
      model: @model
    @view.render()

    @replaceElWithView()
    @bindToView()

  renderAddCodemarkView: ->
    return unless @isTheAddCodemarkTile
    @view = new App.AddCodemarkView
      model: @model
    @view.render()

    @replaceElWithView()
    @bindToView()

  turnViewIntoForm: ->
    @model = @view.model
    @view = new App.CodemarkFormView
      model: @model
    @view.render()

    @replaceElWithView()
    @bindToView()
