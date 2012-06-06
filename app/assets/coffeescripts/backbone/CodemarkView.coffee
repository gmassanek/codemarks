define ['text!../../templates/codemark.html'], (template) ->
  CodemarkView = Backbone.View.extend
    className: 'codemark'

    initialize: ->
      console.log template

    render: ->
      @toHTML()

    toHTML: ->
      # TODO: Ideally, this would always just return a string and render would append it to the
      # DOM
      @$el.append(template)
