window.Codemarklet =
  codemarks_url: 'http://staging.codemarks.com/'
  waitForJquery: (cnt) ->
    return if(cnt>20)

    if(window.jQuery)
      console.log 'jquery loaded'
      Codemarklet.loadPopupLibrary()
    else
      console.log 'jquery not loaded yet'
      window.setTimeout((-> Codemarklet.waitForJquery(cnt+1)),100)

  waitForPopup: (cnt) ->
    console.log cnt
    return if(cnt>20)

    if(window.jQuery.fn.popupWindow)
      console.log 'popup loaded'
      Codemarklet.startCodemarklet()
    else
      console.log 'popup not loaded yet'
      window.setTimeout((-> Codemarklet.waitForPopup(cnt+1)),100)

  startCodemarklet: ->
    if window.jQuery("#codemarklet").length == 0
      window.jQuery("<div id='codemarklet'/>").hide().appendTo('body')
      window.jQuery('#codemarklet').popupWindow
        windowURL: Codemarklet.codemarks_url
        centerBrowser: 1
        location: 0
    window.jQuery('#codemarklet').click()

  loadPopupLibrary: ->
    console.log 'loadingPopupLibrary'
    popupScriptTag = document.createElement('script')
    popupScriptTag.setAttribute('src', Codemarklet.codemarks_url + 'javascripts/popup.js')
    document.body.appendChild(popupScriptTag)
    Codemarklet.waitForPopup(0)

  start: ->
    try
      if(!document.body)
        throw(0)
      if(!window.jQuery)
        jqueryScriptTag = document.createElement('script')
        jqueryScriptTag.setAttribute('src','https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js')
        document.body.appendChild(jqueryScriptTag)
      Codemarklet.waitForJquery(0)

Codemarklet.start()
