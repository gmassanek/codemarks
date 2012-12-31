$ ->
  $email = $('#user_email')
  $subscribe = $('.subscribe')
  $subscribeCheckbox = $('#subscribe')

  $email.change (e) =>
    toggleSubscribeBox()

  $subscribeCheckbox.change (e) =>
    $target = $(e.currentTarget)
    checked = $target.is(':checked')
    prompt = if checked then 'You will be subscribed. Are you sure?' else 'You will be unsubscribed. Are you sure?'
    if confirm(prompt)
      if checked
        $.ajax
          type: 'POST'
          url: '/users/subscribe'
          data:
            email: $email.val()
          success: (response) ->
            if response.status == 'ok'
              $subscribeCheckbox.addClass('success')
            else
              $subscribeCheckbox.addClass('error')
      else
        $.ajax
          type: 'POST'
          url: '/users/unsubscribe'
          data:
            email: $email.val()
          success: (response) ->
            if response.status == 'ok'
              $subscribeCheckbox.addClass('success')
            else
              $subscribeCheckbox.addClass('error')

    else
      $target.attr('checked', !checked)

  toggleSubscribeBox = =>
    if $email.val() != '' && $email.is(':valid')
      $subscribe.show()
    else
      $subscribe.hide()

  toggleSubscribeBox()

