copy_codemark = ($codemark) ->
  url = $codemark.find('.codemark_link').attr('href')
  codemark_id = $codemark.find('#codemark_id').val()
  link_id = $codemark.find('#link_id').val()
  $('#url').val(url)
  $('#resource_attrs_id').val(link_id)
  $('#id').val(codemark_id)
  $('#codemark_form').submit()
  $(window).scrollTop(0)

swapClasses = ($ownership_link, class_to_remove, class_to_add) ->
  $ownership_link.removeClass(class_to_remove)
  $ownership_link.addClass(class_to_add)


$ ->
  $(".copy_codemark").click (e) ->
    e.preventDefault()
    $cm = $(e.target).closest('.codemark')
    copy_codemark($cm)

  $(".edit_codemark").click (e) ->
    e.preventDefault()
    $cm = $(e.target).closest('.codemark')
    copy_codemark($cm)

  $(".show_comments").click (event) ->
    event.preventDefault()
    $cm = $(event.target).closest('.codemark')
    $cm.find('.comments').toggle()

  $(".copy_codemark").qtip
    content: 'Save as your codemark'
    show: { delay: 1000 }

  $(".corner.delete").qtip
    content: 'Remove from your codemarks'
    show: { delay: 1000 }

  $(".edit_codemark").qtip
    content: 'Edit your codemark'
    show: { delay: 1000 }

  $(".show_comments").qtip
    content: 'View and add comments'
    show: { delay: 1000 }

  $('.comment_form').submit (event) ->
    event.preventDefault()
    $cm = $(event.target).closest('.codemark')
    data = $(event.target).serialize()
    url = $(event.target).attr('action')
    $.ajax
      type: 'POST'
      url: url
      data: data
      datType: 'script'

  $('.delete_comment').live 'click', (event) ->
    event.preventDefault()
    $comment = $(event.target).closest('.comments li')
    url = $(event.currentTarget).attr('href')
    console.log url

    $.ajax
      type: 'POST'
      url: url
      data:
        _method: 'DELETE'
      datType: 'script'
      success: ->
        $comment.fadeOut 400, ->
          $comment.remove()

  $('.twitter_popup').click (event) ->
    event.preventDefault()
    $link  = $(this)
    width  = 575
    height = 400
    left   = ($(window).width()  - width)  / 2
    top    = ($(window).height() - height) / 2
    url    = $link.attr('href')
    opts   = 'status=1' + ',width='  + width  + ',height=' + height + ',top='    + top    + ',left='   + left
    tweet_text = $link.attr('data-tweet-text')
    referer = 'url=""'
    via = '&via=codemarks'
    text = '&text=' + tweet_text
    url = url + '?' + referer + via + text
    window.open(url, 'twitter', opts)
