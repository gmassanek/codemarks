App.CodemarkView = Backbone.View.extend
  className: 'codemark'

  events:
    'click .delete': 'deleteCodemark'
    'click .add': 'createCopy'
    'click .author': 'navigateToAuthor'
    'click .topic': 'navigateToTopic'
    'click .edit': 'editClick'

  render: ->
    @$el.html(@toHTML())
    @$('.timeago').timeago()
    if @model.author().get('image')?
      @$('.author').removeClass('icon-user-2')
    @$('.show-description').remove() if @model.get('description') == '' || @model.get('description') == null

  initialize: ->
    @model.bind 'change', => @render()
    @events = _.extend({}, @events, @extraEvents)

  toHTML: ->
    facile(@template(), @presentedAttributes())

  editClick: (e) ->
    e.preventDefault()
    return unless @editable()
    @trigger('turnIntoForm')

  editable: ->
    @model.mine()

  user: ->
    if @model.author().id == App.current_user.get('id')
      @model.author()
    else if @model.get('resource')?.user
      new App.User(@model.get('resource').user)
    else
      @model.author()

  presentedAttributes: ->
    resource = @model.get('resource')
    save_date:
      content: ''
      class: 'timeago'
      title: @model.get('created_at')
    'share@href': @tweetShareUrl()
    author:
      avatar: if @user().get('image') then {content: '', src: @user().get('image')} else null
      name: @user().get('nickname')
    topics_list: @presentTopics()
    views: resource.clicks_count
    saves: if resource.codemarks_count - 1 > 0 then "+#{resource.codemarks_count - 1}" else null
    delete: if @editable() then '' else null
    edit: if @editable() then '' else null
    add: if @model.mine() then null else ''

  presentTopics: ->
    $.map @model.get('topics'), (topic) ->
      topic:
        content: topic.title
        href: ''
        'data-slug': topic.slug

  navigateToAuthor: (e) ->
    e?.preventDefault()
    return unless @options.navigable
    userSlug = @user().get('slug')
    return if App.codemarks.filters.hasUser(userSlug)
    App.codemarks.filters.setUser(userSlug)
    App.codemarks.filters.setPage(1)
    App.vent.trigger('updateCodemarkRequest')

  navigateToTopic: (e) ->
    e?.preventDefault()
    return unless @options.navigable
    slug = $(e.currentTarget).data('slug')
    return if App.codemarks.filters.hasTopic(slug)
    App.codemarks.filters.addTopic(slug)
    App.codemarks.filters.setPage(1)
    App.codemarks.filters.setSort('popularity')
    App.vent.trigger('updateCodemarkRequest')

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
      via: "#{@model.author().get('nickname')} on @codemarks"
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
