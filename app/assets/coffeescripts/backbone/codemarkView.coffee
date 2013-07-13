App.CodemarkView = Backbone.View.extend
  className: 'codemark'

  events:
    'click .delete': 'deleteCodemark'
    'click .add': 'createCopy'
    'click .author': 'navigateToAuthor'
    'click .topic': 'navigateToTopic'
    'click .icon': 'iconClick'

  render: ->
    @$el.html(@toHTML())
    @$el.addClass('mine') if @editable()
    @$('.timeago').timeago()
    if @model.get('author').image?
      @$('.author').removeClass('icon-user-2')
    if @model.get('description') == '' || @model.get('description') == null
      @$('.main').addClass('no-description')

  initialize: ->
    @model.bind 'change', => @render()
    @events = _.extend({}, @events, @extraEvents)

  toHTML: ->
    facile(@template(), @presentedAttributes())

  iconClick: (e) ->
    e.preventDefault()
    return unless @editable()
    @trigger('turnIntoForm')

  editable: ->
    CURRENT_USER == @model.get('author').slug

  presentedAttributes: ->
    resource = @model.get('resource')
    edit:
      content: @editText()
    save_date:
      content: ''
      class: 'timeago'
      title: @model.get('created_at')
    'share@href': @tweetShareUrl()
    author:
      avatar: if @model.get('author').image then {content: '', src: @model.get('author').image} else null
      name: @model.get('author').nickname
    topics_list: @presentTopics()
    views: @model.get('resource').clicks_count
    saves: if @model.get('save_count') - 1 then "+#{@model.get('save_count') - 1}" else null
    delete: if @model.mine() then '' else null
    add: if @model.mine() || CURRENT_USER == '' then null else ''

  editText: ->
    if @mine() then 'Edit' else 'Save'

  mine: ->
    @model.get('author').slug == CURRENT_USER

  presentTopics: ->
    $.map @model.get('topics'), (topic) ->
      topic:
        content: topic.title
        href: ''
        'data-slug': topic.slug

  navigateToAuthor: (e) ->
    e.preventDefault()
    App.codemarks.filters.setUser(@model.get('author').slug)
    App.codemarks.filters.setPage(1)
    App.codemarks.fetch()

  navigateToTopic: (e) ->
    e.preventDefault()
    slug = $(e.currentTarget).data('slug')
    App.codemarks.filters.addTopic(slug)
    App.codemarks.filters.setPage(1)
    App.codemarks.fetch()

  deleteCodemark: (e) ->
    e.preventDefault()
    if(confirm("Are you sure you want to delete your codemark?"))
      $.post "/codemarks/#{@model.get('id')}",
        _method: 'delete'
        success: =>
          @trigger('delete')

  tweetShareUrl: ->
    data =
      url: ''
      via: "#{@model.get('author').nickname} on @codemarks"
      text: @tweetText()
    "http://twitter.com/share?#{$.param(data)}"

  tweetText: ->
    "#{@model.get('title')} #{@model.get('resource').url} #{@tweetHashTags()}"

  tweetHashTags: ->
    slugs = _.map @model.get('topics'), (topic) ->
      "##{topic.slug}"
    slugs.join(' ')

  tweetWindowOptions: ->
    width  = 575
    height = 400
    left   = ($(window).width()  - width)  / 2
    top    = ($(window).height() - height) / 2
    "status=1,width=#{width},height=#{height},top=#{top},left=#{left}"

  createCopy: ->
    @trigger('createCopy')
