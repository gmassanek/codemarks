App.CodemarkView = Backbone.View.extend
  className: 'codemark'

  events:
    'click .delete': 'deleteCodemark'
    'click .share': 'twitterShare'
    'click .add': 'createCopy'
    'click .author': 'navigateToAuthor'
    'click .topic': 'navigateToTopic'
    'click .title': 'recordClick'
    'click .main': 'mainClicked'
    'click .icon': 'iconClick'

  render: ->
    @$el.html(@toHTML())
    @$el.addClass('mine') if @editable()
    @$('.timeago').timeago()
    if @model.get('author').image?
      @$('.author').removeClass('icon-user-2')
    @$('.icon').addClass('icon-link-2')

  mainClicked: (e) ->
    @$('.main').toggleClass('clicked')

  initialize: ->
    @model.bind 'change', => @render()

  toHTML: ->
    template = angelo('codemark.html')
    facile(template, @presentedAttributes())

  iconClick: (e) ->
    e.preventDefault()
    return unless @editable()
    @showEditForm()

  showEditForm: ->
    @trigger('turnIntoForm')

  editable: ->
    CURRENT_USER == @model.get('author').slug

  presentedAttributes: ->
    resource = @model.get('resource')
    title_link:
      content: @model.get('title'),
      href: resource.url,
    host: resource.host,
    description: @model.get('description') || '<p>ingle-origin coffee terry richardson shoreditch, banksy bespoke vegan craft beer glut.</p><p>Bird on it art party lo-fi, polaroid raw denim brunch jean shorts post-ironic mixtape wolf sustainable. PBR narwhal tumblr PBR</p>.'
    edit:
      content: @editText()
    save_date:
      content: ''
      class: 'timeago'
      title: @model.get('created_at')
    twitter_share:
      content: 'Tweet'
      href: 'http://twitter.com/share'
    author:
      avatar: if @model.get('author').image then {content: '', src: @model.get('author').image} else null
      name: @model.get('author').nickname
    topics: @presentTopics()
    views: @model.get('visit_count')
    saves: if @model.get('save_count') - 1 then "+#{@model.get('save_count') - 1}" else null
    'main-image':
      content: ''
      src: if resource.snapshot_url then resource.snapshot_url else 'assets/loading.gif'
    delete: if @model.mine() then '&#x66;' else null
    add: if @model.mine() || CURRENT_USER == null then null else '&#xe00e;'

  editText: ->
    if @mine() then 'Edit' else 'Save'

  mine: ->
    @model.get('author').nickname == CURRENT_USER

  recordClick: (e) ->
    url = "/links/#{@model.get('resource').id}/click "
    $.post(url)
    $(e.currentTarget).unbind('click')

  presentTopics: ->
    $.map @model.get('topics'), (topic) ->
      topic:
        content: topic.title
        href: ''
        'data-slug': topic.slug

  navigateToAuthor: (e) ->
    e.preventDefault()
    App.codemarks.filters.setUser(@model.get('author').nickname)
    App.codemarks.fetch()

  navigateToTopic: (e) ->
    e.preventDefault()
    slug = $(e.currentTarget).data('slug')
    App.codemarks.filters.setTopic(slug)
    App.codemarks.fetch()

  deleteCodemark: (e) ->
    e.preventDefault()
    if(confirm("Are you sure you want to delete your codemark?"))
      $.post "/codemarks/#{@model.get('id')}",
        _method: 'delete'
        success: =>
          @trigger('delete')

  twitterShare: (e) ->
    e.preventDefault()
    window.open(@tweetShareUrl(), 'twitter', @tweetWindowOptions())

  tweetShareUrl: ->
    data =
      url: ''
      via: "#{@model.get('author').nickname} on @codemarks"
      related: 'codemarks'
    "http://twitter.com/share?#{$.param(data)}&text=#{@tweetText()}"

  tweetText: ->
    escape(@model.get('title')) + " #{@model.get('resource').url}"

  tweetWindowOptions: ->
    width  = 575
    height = 400
    left   = ($(window).width()  - width)  / 2
    top    = ($(window).height() - height) / 2
    "status=1,width=#{width},height=#{height},top=#{top},left=#{left}"

  createCopy: ->
    @trigger('createCopy')
