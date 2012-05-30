define ['Codemark'], (Codemark) ->
  Codemark = Backbone.Model.extend
    model: Codemark
    urlRoot : '/codemarks'
    defaults: ''

    initialize: ->
