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
  $(".ownership.copy").click (e) ->
    $cm = $(e.target).closest('.codemark')
    copy_codemark($cm)

  $(".ownership.delete").click (e) ->
    $cm = $(e.target).closest('.codemark')
    cm_id = $cm.find("#codemark_id").val()
    if(confirm("Are you sure you want to delete your codemark?"))
      $.post "/codemarks/#{cm_id}", {
        _method: 'delete'
        success: ->
          $cm.fadeOut(500, ->
            @remove())
      }

  $('.ownership').mouseover (e) ->
    $target = $(e.target)
    $target.addClass('hover')

  $('.ownership').mouseout (e) ->
    $target = $(e.target)
    $target.removeClass('hover')

  $(".edit_codemark").click (e) ->
    e.preventDefault()
    $cm = $(e.target).closest('.codemark')
    copy_codemark($cm)

  $(".show_note").click (event) =>
    $cm = $(event.target).closest('.codemark')
    $cm.find('.note').toggle()

  $(".show_comments").click (event) ->
    $cm = $(event.target).closest('.codemark')
    $cm.find('.comments').toggle()

  $(".ownership.copy").qtip
    content: 'Add to your codemarks'

  $(".ownership.delete").qtip
    content: 'Remove from your codemarks'

  $(".edit_codemark").qtip
    content: 'Edit your codemark'

  $(".show_note").qtip
    content: 'View your codemark\'s note'

  $(".show_comments").qtip
    content: 'View and add comments'

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
