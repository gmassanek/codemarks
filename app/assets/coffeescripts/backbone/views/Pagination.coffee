App.Views.Pagination = Backbone.View.extend
  className: 'pagination'

  events:
    'click .page': 'pageClick'

  initialize: ->
    @collection = @options.collection
    @currentPage = @collection.filters.get('currentPage')

  render: ->
    return unless @collection && @collection.pagination
    @pagination = @collection.pagination
    @$el.append(@toHtml())
    @$(".page[data-page=#{@currentPage}]").addClass('current')

  toHtml: ->
    template = angelo('pagination.html')
    data = {pages: []}
    for num in [1..@pagination.total_pages]
      data.pages.push page:
        content: num
        'data-page': num

    facile(template, data)

  pageClick: (e) ->
    e.preventDefault()
    $pageLink = $(e.currentTarget)
    @collection.filters.setPage($pageLink.text())
    @collection.fetch()
