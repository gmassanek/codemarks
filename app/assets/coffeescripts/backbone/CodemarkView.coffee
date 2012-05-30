define [], () ->
  CodemarkView = Backbone.View.extend
    initialize: ->

    render: ->
      @$el.append(@toHTML())

    toHTML: ->
      "<div class='codemark'>#{@model.get('title')}</div>"
