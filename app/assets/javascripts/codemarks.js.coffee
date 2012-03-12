$ -> 
  $(".edit_codemark").click (e) ->
    e.preventDefault()
    $cm = $(e.target).closest('.codemark')
    url = $cm.find('.codemark_link').attr('href')
    $('#resource_attrs_url').val(url)
    $('#codemark_form').submit()
    $(window).scrollTop(0)
