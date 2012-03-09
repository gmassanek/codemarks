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
    $.ajax({
      url: "http://www.codemarks.org/listener/prepare_bookmarklet?id=USER_ID&l="+l,
      context: document.body,
      dataType: "script",
      success: function(response) {
        console.log(response);
        $(this).append(response);
      }
    });
  } else {
    window.setTimeout(function(){waitForJquery(cnt+1)}, 100);
  }
}
cml1();
void(0);

