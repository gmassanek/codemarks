App.Collections.Codemarks = Backbone.Collection.extend
  model: App.Models.Codemark

  initialize: (filters)->
    @url = '/codemarks'
    @filters = _.extend(@defaults, filters)

  defaults:
    by: 'saves'

  flush: (success) ->
    success ||= App.router.showCodemarkList
    @fetch
      data: @filters
      success: => success()
