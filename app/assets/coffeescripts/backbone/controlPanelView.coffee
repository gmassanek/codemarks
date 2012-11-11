App.ControlPanelView = Backbone.View.extend
  className: 'controlPanel'

  initialize: ->
    @codemarks = @options.codemarks
    @filters = @codemarks.filters

  render: ->
    if CURRENT_USER? && CURRENT_USER != @filters.get('user')
      $filter = @filterHtml('user', CURRENT_USER, 'off')
      @$el.append($filter)

    if @filters.get('user')
      $filter = @filterHtml('user', @filters.get('user'), 'on')
      @$el.append($filter)

    _.each @filters.topicIds(), (topicId) =>
      $filter = @filterHtml('topic', topicId, 'on')
      @$el.append($filter)

  filterHtml: (type, id, mode) ->
    data =
      type: type
      id: id
      description: id
      mode: mode

    filterView = new App.FilterView
      data: data
      codemarks: @codemarks
    filterView.render()
    filterView.$el
