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
    e.preventDefault()
    $cm = $(e.target).closest('.codemark')
    copy_codemark($cm)
    swapClasses($(e.target), "copy", "delete")

  $('.ownership.copy').mouseover (e) ->
    $target = $(e.target)
    $target.addClass('hover')
    $target.html('Steal!')

  $('.ownership.copy').mouseout (e) ->
    $target = $(e.target)
    $target.removeClass('hover')
    $target.html('Not mine')









  $(".edit_codemark").click (e) ->
    e.preventDefault()
    $cm = $(e.target).closest('.codemark')
    copy_codemark($cm)
