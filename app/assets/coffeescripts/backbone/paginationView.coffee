App.PaginationView = Backbone.View.extend
  className: 'pagination'
  pageSpan: 5

  events:
    'click .page': 'pageClick'

  initialize: ->
    @collection = @options.collection
    @currentPage = @collection?.filters?.get('currentPage') || 1

  render: ->
    return unless @collection && @collection.pagination
    @pagination = @collection.pagination
    return unless @pagination.total_pages > 1

    @$el.append(@toHtml())
    @$(".page[data-page=#{@currentPage}]").addClass('current')

  toHtml: ->
    min = parseInt(@currentPage, 10) - @pageSpan
    max = parseInt(@currentPage, 10) + @pageSpan
    if min <= 0 then min = 1
    if max > @pagination.total_pages then max = @pagination.total_pages

    data = {pages: []}
    if min > 1
      data.pages.push page:
        content: 'first'
        'data-page': 1
        'data-info': 'first'
    for num in [min..max]
      data.pages.push page:
        content: num
        'data-page': num
    if max < @pagination.total_pages
      data.pages.push page:
        content: 'last'
        'data-page': @pagination.total_pages
        'data-info': 'last'

    template = angelo('pagination.html')
    facile(template, data)

  pageClick: (e) ->
    e.preventDefault()
    $pageLink = $(e.currentTarget)
    @collection.filters.setPage($pageLink.data('page'))
    @collection.fetch()
