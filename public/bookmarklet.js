javascript:function iprl5()
  {
    var d=document;
    var z=d.createElement('scr'+'ipt');
    b=d.body;
    l=d.location;
    try{
      if(!b) throw(0);
      d.title='(Saving...) '+d.title;
      z.setAttribute('src',l.protocol+'//www.instapaper.com/j/tYsTIqPofyOc?u='+encodeURIComponent(l.href)+'&t='+(new Date().getTime()));
      b.appendChild(z);
    }
    catch(e){
      alert('Please wait until the page has loaded.');
    }
  }
iprl5();
void(0)

/*
 * http://www.blooberry.com/indexdot/html/topics/urlencoding.htm
 * 1. replace %20 with spaces
 * 2. replace %7B with {
 * 3. replace %7D with }
 * 4. don't need new lines
 * 5. put all declarations on one line with commas separating them (no spaces)
 * 6. No spaces needed for one line if statements
*/
javascript:function cml1()
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
        url: "http://www.codemarks.org/listener/bookmarklet?l="+l,
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
