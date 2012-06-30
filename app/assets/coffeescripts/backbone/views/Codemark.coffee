App.Views.Codemark = Backbone.View.extend
  className: 'codemark'
  tagName: 'section'

  initialize: ->

  events:
    'click .corner.delete': 'deleteCodemark'
    'click .twitter_share': 'twitterShare'

  render: ->
    @$el.append(@toHTML())
    if @model.get('mine')
      @$('.copy_codemark').remove()

  toHTML: ->
    template = angelo('codemark.html')
    facile(template, @model.attributes)

  deleteCodemark: (e) ->
    e.preventDefault()
    if(confirm("Are you sure you want to delete your codemark?"))
      $.post "/codemarks/#{@model.get('id')}",
        _method: 'delete'
        success: =>
          @$el.fadeOut 500, =>
            @$el.remove()

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
