App.Collections.Codemarks = Backbone.Collection.extend
  model: App.Models.Codemark

  initialize: (filters)->
    @url = '/codemarks'
    @filters = _.extend(@defaults, filters)

  defaults:
    by: 'date'

  flush: (success) ->
    response = $.ajax
      url: @url
      data: @filters
      dataType: 'json'
      success: (response) =>
        @setAttributes(response, success)

  setAttributes: (response, success) ->
    success ||= App.router.showCodemarkList
    @pagination = response.pagination
    @models = []
    _.each response.codemarks, (codemark) =>
      @models.push(new Backbone.Model(codemark))
    success?()
