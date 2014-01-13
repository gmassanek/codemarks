App.FilterView = Backbone.View.extend
  className: 'filter'
  possibleSorts: ['date', 'visits', 'count', 'popularity', 'buzzing']

  events:
    'click .remove': 'removeFilter'
    'click .more': 'toggleOtherSorts'
    'click .other_sort': 'otherSortClicked'

  initialize: ->
    @type = @options.type
    @description = @options.description
    @dataId = @options.dataId
    @image = @options.image

    @filters = App.codemarks.filters

  render: ->
    @$el.html(@toHtml())
    if @type != 'sort' && @type != 'group'
      @$('.remove').data('type', @type)
      @$('.remove').data('id', @dataId)
      @$('.more').remove()
    else
      @$('.remove').remove()

    if @type == 'user'
      $(@$('.description')[1]).remove()
    else
      $(@$('.description')[0]).remove()

    @$el.addClass(@type)
    @renderImageOrIcon()

  toHtml: ->
    template = angelo('filter.html')
    data =
      description:
        href: "/users/#{@dataId}"
        content: @description
      other_sorts: @otherSorts() || @otherGroups()
    facile(template, data)

  otherSorts: ->
    return unless @type == 'sort'
    otherSorts = _.without(@possibleSorts, @dataId)
    _.map otherSorts, (sort) ->
      other_sort:
        content: sort
        'data-sort': sort

  otherGroups: ->
    return unless @type == 'group'
    groups = App.current_user.groups()
    groups.unshift {id: '', name: 'All Groups'}
    _.map groups, (group) ->
      other_sort:
        content: group.name
        'data-group': group.id

  toggleOtherSorts: (e) ->
    e.preventDefault
    @$('.other_sorts').toggleClass('hide')

  otherSortClicked: (e) ->
    e.preventDefault
    if @type == 'sort'
      sort = $(e.currentTarget).data('sort')
      @filters.setSort(sort)
    else
      group = $(e.currentTarget).data('group')
      @filters.setGroup(group)
    App.vent.trigger('updateCodemarkRequest')

  removeFilter: (e) ->
    e.preventDefault()
    if @type == 'topic'
      @filters.removeTopic(@dataId)
    if @type == 'user'
      @filters.removeUser()
    if @type == 'query'
      @filters.clearSearchQuery()
    App.vent.trigger('updateCodemarkRequest')

  renderImageOrIcon: ->
    switch @type
      when 'user'
        @$('img').attr('src', @image)
      when 'query'
        @$('.description').addClass('icon-search')
      when 'topic'
        @$('.description').addClass('icon-tag')
      else @$('img').remove()
