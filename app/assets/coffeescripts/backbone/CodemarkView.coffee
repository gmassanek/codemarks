define [], () ->
  CodemarkView = Backbone.View.extend
    className: 'codemark'

    initialize: ->

    render: ->
      @toHTML()

    toHTML: ->
      # TODO: Ideally, this would always just return a string and render would append it to the
      # dom
      @$el.append("<h2>#{@model.get('title')}</h2>")
