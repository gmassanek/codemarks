function cml1() {
  var d=document;
  var b=d.body;
  l=d.location;
  try{
    if(!b) throw(0);
    if(!window.jQuery) {
      var z=d.createElement('script');
      z.setAttribute('src','https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js');
      b.appendChild(z);
    } else {
      var z=d.createElement('script');
      z.setAttribute('src','https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js');
      b.appendChild(z);

      var z=d.createElement('script');
      z.setAttribute('src','http://www.codemarks.org/autocomplete-rails.js');
      b.appendChild(z);
    }

    waitForJquery(0);
  }
  catch(e){
    console.log(e);
    alert('Please wait until the page has loaded.');
  }
}
function waitForJquery(cnt) {
  if(cnt>20) return;
  if(window.jQuery) {
    var z=document.createElement('script');
    z.setAttribute('src','https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js');
    document.body.appendChild(z);

    var z=document.createElement('script');
    z.setAttribute('src','http://www.codemarks.org/autocomplete-rails.js');
    document.body.appendChild(z);

    $.ajax({
      url: "http://www.codemarks.org/listener/prepare_bookmarklet?id=USER_ID&l="+l,
      context: document.body,
      dataType: "script"
    });
  } else {
    window.setTimeout(function(){waitForJquery(cnt+1)}, 100);
  }
}
cml1();
void(0);

