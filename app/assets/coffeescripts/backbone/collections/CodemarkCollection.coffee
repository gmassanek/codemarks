App.Collections.Codemarks = Backbone.Collection.extend
  model: App.Models.Codemark

  initialize: (url)->
    @url = url || '/codemarks'
