function start() {
  if(!window.Codemarklet) {
    jqueryScriptTag = document.createElement('script');
    jqueryScriptTag.setAttribute('src','http://localhost:3000/javascripts/codemarklet.js');
    document.body.appendChild(jqueryScriptTag);
  } else {
    window.Codemarklet.start();
  }
}

start();
