App.FilterView = Backbone.View.extend
  className: 'filter'
  possibleSorts: ['date', 'visits', 'count']

  events:
    'click .remove': 'removeFilter'
    'click .more': 'toggleOtherSorts'
    'click .other_sort': 'otherSortClicked'

  initialize: ->
    @type = @options.type
    @description = @options.description
    @dataId = @options.dataId
    @codemarks = @options.codemarks
    @filters = @codemarks.filters

  render: ->
    @$el.html(@toHtml())
    if @type != 'sort'
      @$('.remove').data('type', @type)
      @$('.remove').data('id', @dataId)
      @$('.more').remove()
    else
      @$('.remove').remove()
    @$el.addClass(@type)
    if @type == 'user'
      $(@$('.description')[1]).remove()
    else
      $(@$('.description')[0]).remove()

  toHtml: ->
    template = angelo('filter.html')
    data =
      description:
        href: "/users/#{@dataId}"
        content: @description
      other_sorts: @otherSorts()
    facile(template, data)

  otherSorts: ->
    return unless @type == 'sort'
    otherSorts = _.without(@possibleSorts, @dataId)
    _.map otherSorts, (sort) ->
      other_sort:
        content: sort
        'data-sort': sort

  toggleOtherSorts: (e) ->
    e.preventDefault
    @$('.other_sorts').toggleClass('hide')

  otherSortClicked: (e) ->
    e.preventDefault
    sort = $(e.currentTarget).data('sort')
    @filters.setSort(sort)
    @codemarks.fetch()

  removeFilter: (e) ->
    e.preventDefault()
    if @type == 'topic'
      @filters.removeTopic(@dataId)
    if @type == 'user'
      @filters.removeUser()
    if @type == 'query'
      @filters.clearSearchQuery()
    @codemarks.fetch()
