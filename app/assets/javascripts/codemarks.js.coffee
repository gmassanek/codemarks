$ -> 
  $(".edit_codemark").click (e) ->
    e.preventDefault()
    $cm = $(e.target).closest('.codemark')
    url = $cm.find('.codemark_link').attr('href')
    id = $cm.find('#link_id').val()
    $('#resource_attrs_url').val(url)
    $('#resource_attrs_id').val(id)
    $('#codemark_form').submit()
    $(window).scrollTop(0)
