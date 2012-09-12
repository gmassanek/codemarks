App.Views.Pagination = Backbone.View.extend
  className: 'pagination'

  events:
    'click .page': 'pageClick'

  render: ->
    return unless App.codemarks.pagination
    @pagination = App.codemarks.pagination
    @$el.append(@toHtml())

  toHtml: ->
    template = angelo('pagination.html')
    data = {pages: []}
    for num in [1..@pagination.total_pages]
      data.pages.push(page: num)

    facile(template, data)

  pageClick: (e) ->
    e.preventDefault()
    $pageLink = $(e.currentTarget)
    @newPage($pageLink.text())

  newPage: (page) ->
    currentRoute = Backbone.history.fragment
    if /page=/.test(currentRoute)
      currentRoute = currentRoute.replace /page=\d+/, 'page=' + page
    else if /\?/.test(currentRoute)
      currentRoute += '&page=' + page
    else
      currentRoute += '?page=' + page
    App.router.navigate(currentRoute, {trigger: true})
