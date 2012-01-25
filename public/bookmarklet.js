function cml1()
  {
    var d=document;
    var z=d.createElement('scr'+'ipt');
    b=d.body;
    l=d.location;
    try{
      if(!b) throw(0);
      z.setAttribute('src','https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js');
      b.appendChild(z);
      var req = $.ajax({
        url: "http://www.codemarks.org/listener/bookmarklet?id=USER_ID&l="+l,
        dataType: "script"
      });
      console.log(req);
    }
    catch(e){
      alert('Please wait until the page has loaded.');
    }
  }
cml1();
void(0)
