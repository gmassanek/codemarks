App.MainRouter = Backbone.Router.extend
  routes:
    'codemarks': 'codemarks'
    'codemarks?:params': 'codemarks'

  codemarks: (params) ->
    @codemarks = App.codemarks

    if params
      params = params.split('=')
      if params[0] == 'topic_id'
        @codemarks.filters.setTopic(params[1])
      else if params[0] == 'user'
        @codemarks.filters.setUser(params[1])

    @showCodemarkList()
    @codemarks.fetch()

  showCodemarkList: ->
    codemarkList = new App.Views.CodemarkList
      el: $('#main_content')
      codemarks: @codemarks

    $('.content').html(codemarkList.$el)

    $(window).bind 'beforeunload', (e) ->
      filterData = @codemarks.filters.dataForCookie()
      filterCookieVal = JSON.stringify(filterData)
      $.cookie('filters', filterCookieVal)
      $.cookie('filters-save-date', new Date())
      return
