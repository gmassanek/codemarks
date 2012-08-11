App.Views.Codemark = Backbone.View.extend
  className: 'codemark'
  tagName: 'section'

  initialize: ->

  events:
    'click .corner.delete': 'deleteCodemark'
    'click .twitter_share': 'twitterShare'
    'click .edit': 'copyToForm'
    'click .copy': 'copyToForm'
    'click .author': 'navigateToAuthor'

  render: ->
    @$el.append(@toHTML())

  toHTML: ->
    template = angelo("#{@model.get('resource').type}_codemark.html")
    facile(template, @model.attributes)

  navigateToAuthor: (e) ->
    e.preventDefault()
    App.router.navigate(@model.get('author').name, {trigger: true})

  deleteCodemark: (e) ->
    e.preventDefault()
    if(confirm("Are you sure you want to delete your codemark?"))
      $.post "/codemarks/#{@model.get('id')}",
        _method: 'delete'
        success: =>
          @$el.fadeOut 500, =>
            @$el.remove()


  # copying stuff over
  #
  twitterShare: (e) ->
    e.preventDefault()
    $link  = $(e.currentTarget)
    width  = 575
    height = 400
    left   = ($(window).width()  - width)  / 2
    top    = ($(window).height() - height) / 2
    url    = $link.attr('href')
    opts   = 'status=1' + ',width='  + width  + ',height=' + height + ',top='    + top    + ',left='   + left
    tweet_text = $link.attr('data-tweet-text')
    referer = 'url=""'
    via = '&via=jbeiber @codemarks'
    text = '&text=' + tweet_text
    url = url + '?' + referer + via + text
    window.open(url, 'twitter', opts)

  copyToForm: ->
    $('#url').val(@model.get('resource').url)
    $('#resource_attrs_id').val(@model.get('resource').id)
    $('#id').val(@model.get('id'))
    $('#codemark_form').submit()
    $(window).scrollTop(0)
