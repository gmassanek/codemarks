(function() {

  window.Codemarklet = {
    codemarks_url: 'http://www.staging.codemarks.com/',
    waitForJquery: function(cnt) {
      if (cnt > 20) return;
      if (window.jQuery) {
        console.log('jquery loaded');
        return Codemarklet.loadPopupLibrary();
      } else {
        console.log('jquery not loaded yet');
        return window.setTimeout((function() {
          return Codemarklet.waitForJquery(cnt + 1);
        }), 100);
      }
    },
    waitForPopup: function(cnt) {
      console.log(cnt);
      if (cnt > 20) return;
      if (window.jQuery.fn.popupWindow) {
        console.log('popup loaded');
        return Codemarklet.startCodemarklet();
      } else {
        console.log('popup not loaded yet');
        return window.setTimeout((function() {
          return Codemarklet.waitForPopup(cnt + 1);
        }), 100);
      }
    },
    startCodemarklet: function() {
      if (window.jQuery("#codemarklet").length === 0) {
        window.jQuery("<div id='codemarklet'/>").hide().appendTo('body');
        window.jQuery('#codemarklet').popupWindow({
          windowURL: Codemarklet.codemarks_url,
          centerBrowser: 1,
          location: 0
        });
      }
      return window.jQuery('#codemarklet').click();
    },
    loadPopupLibrary: function() {
      var popupScriptTag;
      console.log('loadingPopupLibrary');
      popupScriptTag = document.createElement('script');
      popupScriptTag.setAttribute('src', Codemarklet.codemarks_url + 'javascripts/popup.js');
      document.body.appendChild(popupScriptTag);
      return Codemarklet.waitForPopup(0);
    },
    start: function() {
      var jqueryScriptTag;
      try {
        if (!document.body) throw 0.;
        if (!window.jQuery) {
          jqueryScriptTag = document.createElement('script');
          jqueryScriptTag.setAttribute('src', 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js');
          document.body.appendChild(jqueryScriptTag);
        }
        return Codemarklet.waitForJquery(0);
      } catch (_error) {}
    }
  };

  Codemarklet.start();

}).call(this);
