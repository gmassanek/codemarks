

// DEFLATE, base64 by Dan Kogai http://github.com/dankogai/
var s=null;
(function(){function y(b){for(var i="";b.length>0;)i+=String.fromCharCode.apply(String,b.splice(0,65536));return i}function da(b){return y(x(P(b)))}function n(b){return x(P(b))}function ea(b){return y(Q(P(b)))}function H(b){return y(Q(b))}function R(b){return y(V(b))}function fa(b){return S(P(b))}function Q(b){for(var i=[],j=0,l=b.length;j<l;j++){var h=b[j];if(h<128)i.push(h);else{var m=b[++j];if(h<224)i.push((h&31)<<6|m&63);else{var n=b[++j];i.push((h&15)<<12|(m&63)<<6|n&63)}}}return i}function x(b){for(var i=
[],j=0,l=b.length;j<l;j++){var h=b[j];h<128?i.push(h):h<2048?i.push(192|h>>>6,128|h&63):i.push(224|h>>>12&15,128|h>>>6&63,128|h&63)}return i}function V(b){for(var b=b.replace(/[^A-Za-z0-9+\/]+/g,""),i=[],j=b.length%4,l=0,h=b.length;l<h;l+=4){var m=(ga[b.charAt(l)]||0)<<18|(ga[b.charAt(l+1)]||0)<<12|(ga[b.charAt(l+2)]||0)<<6|(ga[b.charAt(l+3)]||0);i.push(m>>16,m>>8&255,m&255)}i.length-=[0,0,2,1][j];return i}function S(b){for(var i=0;b.length%3;)b.push(0),i++;for(var j=[],l=0,h=b.length;l<h;l+=3){var m=
b[l],n=b[l+1],x=b[l+2];if(m>=256||n>=256||x>=256)throw"unsupported character found";m=m<<16|n<<8|x;j.push(W[m>>>18],W[m>>>12&63],W[m>>>6&63],W[m&63])}for(;i--;)j[j.length-i-1]="=".charCodeAt(0);return y(j)}function P(b){for(var i=[],j=0,l=b.length;j<l;j++)i[j]=b.charCodeAt(j);return i}var W=function(){for(var b=[],i="A".charCodeAt(0),j="a".charCodeAt(0),l="0".charCodeAt(0),h=0;h<26;h++)b.push(i+h);for(h=0;h<26;h++)b.push(j+h);for(h=0;h<10;h++)b.push(l+h);b.push("+".charCodeAt(0));b.push("/".charCodeAt(0));
return b}(),ga=function(b){for(var i={},j=0,l=b.length;j<l;j++)i[b.charAt(j)]=j;return i}("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");if(window.btoa)var X=window.btoa,Y=function(b){return X(da(b))};else X=fa,Y=function(b){return S(n(b))};if(window.atob)var ha=window.atob,ia=function(b){return ea(ha(b))};else ha=R,ia=function(b){return H(V(b))};window.Base64={J:S,w:S,u:V,s:V,C:x,B:x,K:Q,z:Q,m:fa,v:R,M:function(b){return Q(P(b))},L:H,A:H,N:ea,H:n,G:n,D:function(b){return y(x(b))},
I:da,F:Y,t:ia,R:R,T:fa,atob:ha,btoa:X,U:da,r:ea,P:Y,Q:function(b){return Y(b).replace(/[+\/]/g,function(b){return b=="+"?"-":"_"}).replace(/=+$/,"")},O:function(b){return ia(b.replace(/[-_]/g,function(b){return b=="-"?"+":"/"}))}}})();
(function(){function y(){C>8?j(T):C>0&&l(T);C=T=0}function da(a,k){var c=0;do c|=a&1,a>>=1,c<<=1;while(--k>0);return c>>1}function n(a,k){C>16-k?(T|=a<<C,j(T),T=a>>16-C,C+=k-16):(T|=a<<C,C+=k)}function ea(a,k){var c,e=0,d=0,f=0,Aa=0,g,i;if(I!=0){do(e&7)==0&&(Aa=ra[f++]),c=Ba[e++]&255,(Aa&1)==0?b(c,a):(g=ma[c],b(g+256+1,a),i=Ca[g],i!=0&&(c-=Da[g],n(c,i)),c=Ea[d++],g=(c<256?Z[c]:Z[256+(c>>7)])&255,b(g,k),i=na[g],i!=0&&(c-=sa[g],n(c,i))),Aa>>=1;while(e<I)}b(256,a)}function H(a,k){Ba[I++]=k;a==0?D[k].a++:
(a--,D[ma[k]+256+1].a++,J[(a<256?Z[a]:Z[256+(a>>7)])&255].a++,Ea[ta++]=a,oa|=ua);ua<<=1;(I&7)==0&&(ra[Fa++]=oa,oa=0,ua=1);if($>2&&(I&4095)==0){var c=I*8,e=g-K,d;for(d=0;d<30;d++)c+=J[d].a*(5+na[d]);c>>=3;if(ta<parseInt(I/2)&&c<parseInt(e/2))return!0}return I==8191||ta==8192}function R(a){var k,c,e,d;d=g-K;ra[Fa]=oa;x(z);x(A);Q(D,z.c);Q(J,A.c);x(L);for(e=18;e>=3;e--)if(t[La[e]].b!=0)break;ja+=3*(e+1)+14;k=ja+3+7>>3;c=va+3+7>>3;c<=k&&(k=c);if(d+4<=k&&K>=0){n(0+a,3);y();j(d);j(~d);for(e=0;e<d;e++)l(f[K+
e])}else if(c==k)n(2+a,3),ea(M,aa);else{n(4+a,3);d=z.c+1;k=A.c+1;e+=1;n(d-257,5);n(k-1,5);n(e-4,4);for(c=0;c<e;c++)n(t[La[c]].b,3);fa(D,d-1);fa(J,k-1);ea(D,J)}P();a!=0&&y()}function fa(a,k){var c,e=-1,d,g=a[0].b,f=0,i=7,j=4;g==0&&(i=138,j=3);for(c=0;c<=k;c++)if(d=g,g=a[c+1].b,!(++f<i&&d==g)){if(f<j){do b(d,t);while(--f!=0)}else d!=0?(d!=e&&(b(d,t),f--),b(16,t),n(f-3,2)):f<=10?(b(17,t),n(f-3,3)):(b(18,t),n(f-11,7));f=0;e=d;g==0?(i=138,j=3):d==g?(i=6,j=3):(i=7,j=4)}}function Q(a,k){var c,e=-1,d,b=a[0].b,
f=0,g=7,i=4;b==0&&(g=138,i=3);a[k+1].b=65535;for(c=0;c<=k;c++)d=b,b=a[c+1].b,++f<g&&d==b||(f<i?t[d].a+=f:d!=0?(d!=e&&t[d].a++,t[16].a++):f<=10?t[17].a++:t[18].a++,f=0,e=d,b==0?(g=138,i=3):d==b?(g=6,i=3):(g=7,i=4))}function x(a){var k=a.e,c=a.f,e=a.g,d,b=-1,f=e;N=0;ka=573;for(d=0;d<e;d++)k[d].a!=0?(o[++N]=b=d,E[d]=0):k[d].b=0;for(;N<2;)d=o[++N]=b<2?++b:0,k[d].a=1,E[d]=0,ja--,c!=s&&(va-=c[d].b);a.c=b;for(d=N>>1;d>=1;d--)S(k,d);do d=o[1],o[1]=o[N--],S(k,1),c=o[1],o[--ka]=d,o[--ka]=c,k[f].a=k[d].a+k[c].a,
E[f]=E[d]>E[c]+1?E[d]:E[c]+1,k[d].b=k[c].b=f,o[1]=f++,S(k,1);while(N>=2);o[--ka]=o[1];f=a.e;d=a.i;var e=a.h,c=a.c,g=a.j,i=a.f,j,h,l,m,n=0;for(h=0;h<=15;h++)v[h]=0;f[o[ka]].b=0;for(a=ka+1;a<573;a++)if(j=o[a],h=f[f[j].b].b+1,h>g&&(h=g,n++),f[j].b=h,!(j>c))v[h]++,l=0,j>=e&&(l=d[j-e]),m=f[j].a,ja+=m*(h+l),i!=s&&(va+=m*(i[j].b+l));if(n!=0){do{for(h=g-1;v[h]==0;)h--;v[h]--;v[h+1]+=2;v[g]--;n-=2}while(n>0);for(h=g;h!=0;h--)for(j=v[h];j!=0;)if(d=o[--a],!(d>c)){if(f[d].b!=h)ja+=(h-f[d].b)*f[d].a,f[d].a=h;
j--}}V(k,b)}function V(a,b){var c=Array(16),e=0,d;for(d=1;d<=15;d++)e=e+v[d-1]<<1,c[d]=e;for(e=0;e<=b;e++)if(d=a[e].b,d!=0)a[e].a=da(c[d]++,d)}function S(a,b){for(var c=o[b],e=b<<1;e<=N;){e<N&&ia(a,o[e+1],o[e])&&e++;if(ia(a,c,o[e]))break;o[b]=o[e];b=e;e<<=1}o[b]=c}function P(){var a;for(a=0;a<286;a++)D[a].a=0;for(a=0;a<30;a++)J[a].a=0;for(a=0;a<19;a++)t[a].a=0;D[256].a=1;oa=I=ta=Fa=ja=va=0;ua=1}function W(a,b,c){var e,d,f;for(e=0;r!=s&&e<c;){d=c-e;if(d>r.d)d=r.d;for(f=0;f<d;f++)a[b+e+f]=r.l[r.k+f];
r.k+=d;r.d-=d;e+=d;if(r.d==0)d=r,r=r.next,d.next=ba,ba=d}if(e==c)return e;if(u<w){d=c-e;d>w-u&&(d=w-u);for(f=0;f<d;f++)a[b+e+f]=ca[u+f];u+=d;e+=d;w==u&&(w=u=0)}return e}function ga(a,b){var c;if(!Ga){if(!O){C=T=0;var e,d;if(aa[0].b==0){z.e=D;z.f=M;z.i=Ca;z.h=257;z.g=286;z.j=15;z.c=0;A.e=J;A.f=aa;A.i=na;A.h=0;A.g=30;A.j=15;A.c=0;L.e=t;L.f=s;L.i=Pa;L.h=0;L.g=19;L.j=7;for(d=e=L.c=0;d<28;d++){Da[d]=e;for(c=0;c<1<<Ca[d];c++)ma[e++]=d}ma[e-1]=d;for(d=e=0;d<16;d++){sa[d]=e;for(c=0;c<1<<na[d];c++)Z[e++]=
d}for(e>>=7;d<30;d++){sa[d]=e<<7;for(c=0;c<1<<na[d]-7;c++)Z[256+e++]=d}for(c=0;c<=15;c++)v[c]=0;for(c=0;c<=143;)M[c++].b=8,v[8]++;for(;c<=255;)M[c++].b=9,v[9]++;for(;c<=279;)M[c++].b=7,v[7]++;for(;c<=287;)M[c++].b=8,v[8]++;V(M,287);for(c=0;c<30;c++)aa[c].b=5,aa[c].a=da(c,5);P()}for(c=0;c<8192;c++)F[32768+c]=0;Ha=Ia[$].q;Ma=Ia[$].o;Na=Ia[$].p;K=g=0;q=ha(f,0,65536);if(q<=0)O=!0,q=0;else{for(O=!1;q<262&&!O;)X();for(c=G=0;c<2;c++)G=(G<<Ja^f[c]&255)&8191}r=s;u=w=0;$<=3?(B=2,p=0):(p=2,pa=0);wa=!1}Ga=!0;
if(q==0)return wa=!0,0}if((c=W(a,0,b))==b)return b;if(wa)return c;if($<=3)for(;q!=0&&r==s;){i();U!=0&&g-U<=32506&&(p=Y(U),p>q&&(p=q));if(p>=3)if(d=H(g-qa,p-3),q-=p,p<=Ha){p--;do g++,i();while(--p!=0);g++}else g+=p,p=0,G=f[g]&255,G=(G<<Ja^f[g+1]&255)&8191;else d=H(0,f[g]&255),q--,g++;d&&(R(0),K=g);for(;q<262&&!O;)X()}else for(;q!=0&&r==s;){i();B=p;Oa=qa;p=2;U!=0&&B<Ha&&g-U<=32506&&(p=Y(U),p>q&&(p=q),p==3&&g-qa>4096&&p--);if(B>=3&&p<=B){d=H(g-1-Oa,B-3);q-=B-1;B-=2;do g++,i();while(--B!=0);pa=0;p=2;
g++;d&&(R(0),K=g)}else pa!=0?H(0,f[g-1]&255)&&(R(0),K=g):pa=1,g++,q--;for(;q<262&&!O;)X()}q==0&&(pa!=0&&H(0,f[g-1]&255),R(1),wa=!0);return c+W(a,c+0,b-c)}function X(){var a,b,c=65536-q-g;if(c==-1)c--;else if(g>=65274){for(a=0;a<32768;a++)f[a]=f[a+32768];qa-=32768;g-=32768;K-=32768;for(a=0;a<8192;a++)b=F[32768+a],F[32768+a]=b>=32768?b-32768:0;for(a=0;a<32768;a++)b=F[a],F[a]=b>=32768?b-32768:0;c+=32768}O||(a=ha(f,g+q,c),a<=0?O=!0:q+=a)}function Y(a){var b=Na,c=g,e,d=B,i=g>32506?g-32506:0,h=g+258,j=
f[c+d-1],l=f[c+d];B>=Ma&&(b>>=2);do if(e=a,!(f[e+d]!=l||f[e+d-1]!=j||f[e]!=f[c]||f[++e]!=f[c+1])){c+=2;e++;do;while(f[++c]==f[++e]&&f[++c]==f[++e]&&f[++c]==f[++e]&&f[++c]==f[++e]&&f[++c]==f[++e]&&f[++c]==f[++e]&&f[++c]==f[++e]&&f[++c]==f[++e]&&c<h);e=258-(h-c);c=h-258;if(e>d){qa=a;d=e;if(e>=258)break;j=f[c+d-1];l=f[c+d]}}while((a=F[a&32767])>i&&--b!=0);return d}function ha(a,b,c){var e;for(e=0;e<c&&Ka<xa.length;e++)a[b+e]=xa.charCodeAt(Ka++)&255;return e}function ia(a,b,c){return a[b].a<a[c].a||a[b].a==
a[c].a&&E[b]<=E[c]}function b(a,b){n(b[a].a,b[a].b)}function i(){G=(G<<Ja^f[g+3-1]&255)&8191;U=F[32768+G];F[g&32767]=U;F[32768+G]=g}function j(a){a&=65535;u+w<8190?(ca[u+w++]=a&255,ca[u+w++]=a>>>8):(l(a&255),l(a>>>8))}function l(a){ca[u+w++]=a;if(u+w==8192&&w!=0){var b;ba!=s?(a=ba,ba=ba.next):a=new h;a.next=s;a.d=a.k=0;r==s?r=ya=a:ya=ya.next=a;a.d=w-u;for(b=0;b<a.d;b++)a.l[b]=ca[u+b];w=u=0}}function h(){this.next=s;this.d=0;this.l=Array(8192);this.k=0}function m(a,b,c,e){this.o=a;this.q=b;this.S=
c;this.p=e}function za(){this.i=this.f=this.e=s;this.c=this.j=this.g=this.h=0}function la(){this.b=this.a=0}var Ja=parseInt(5),ba,r,ya,Ga,ca=s,w,u,wa,f,Ea,Ba,F,T,C,K,G,U,Oa,pa,p,B,g,qa,O,q,Na,Ha,$,Ma,D,J,M,aa,t,z,A,L,v,o,N,ka,E,ma,Z,Da,sa,ra,I,ta,Fa,oa,ua,ja,va,xa,Ka,Ca=[0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],na=[0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],Pa=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7],La=[16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],Ia=
[new m(0,0,0,0),new m(4,4,8,4),new m(4,5,16,8),new m(4,6,32,32),new m(4,4,16,16),new m(8,16,32,32),new m(8,16,128,128),new m(8,32,128,256),new m(32,128,258,1024),new m(32,258,258,4096)];window.RawDeflate||(window.RawDeflate={});window.RawDeflate.n=function(a){var b;xa=a;Ka=0;typeof b=="undefined"&&(b=6);(a=b)?a<1?a=1:a>9&&(a=9):a=6;$=a;O=Ga=!1;if(ca==s){ba=r=ya=s;ca=Array(8192);f=Array(65536);Ea=Array(8192);Ba=Array(32832);F=Array(65536);D=Array(573);for(a=0;a<573;a++)D[a]=new la;J=Array(61);for(a=
0;a<61;a++)J[a]=new la;M=Array(288);for(a=0;a<288;a++)M[a]=new la;aa=Array(30);for(a=0;a<30;a++)aa[a]=new la;t=Array(39);for(a=0;a<39;a++)t[a]=new la;z=new za;A=new za;L=new za;v=Array(16);o=Array(573);E=Array(573);ma=Array(256);Z=Array(512);Da=Array(29);sa=Array(30);ra=Array(parseInt(1024))}for(var c=Array(1024),e=[];(a=ga(c,c.length))>0;){var d=Array(a);for(b=0;b<a;b++)d[b]=String.fromCharCode(c[b]);e[e.length]=d.join("")}xa=s;return e.join("")}})();window.jbs_deflate=function(y){return Base64.m(RawDeflate.n(unescape(encodeURIComponent(y))))};

var bodyipb830223, _greaderipb830223;

function jbsipb830223(html)
{
    html = html.replace(/<!--.*?-->/ig, '');    
        if (html.length > 768000) return html; /* too big to deflate quickly */
    return '<' + '![D[' + jbs_deflate(html);
    }


function _ipSendipb830223(href, title, from_greader)
{
    var tzd = '';

    var d=document,
        l=d.location,
        e=window.getSelection,
        k=d.getSelection,
        x=d.selection,
        s=String(e? e(): (k)? k(): (x?x.createRange().text: '')),
        e=encodeURIComponent,
        z=d.createElement('scr'+'ipt'),
        p=(from_greader ? 'gr=1&' : '')+'a=&k=tYsTIqPofyOc&u=' + e(href) + '&t=' + e(title) + '&s=' + e(s.length < 10240 ? s : '') + '&tzd=' + e(tzd);
    
            var b = _greaderipb830223 ? '' : jbsipb830223(bodyipb830223);
        if (b.length > 512000) b = '';
    
    var i=document.createElement('iframe');
    i.setAttribute('name', 'ipb830223');
    i.setAttribute('id', 'ipb830223');
    
            var c = 'left:10px;top:10px;width:168px;';
        
    if (from_greader) c += ' position: absolute;';
    else c += ' position: fixed;';

    var ce, container = document.body;
    if (from_greader && (ce = document.getElementById('current-entry')) ) {
        container = ce;
        c += ' position: absolute;';
    }
    i.setAttribute('style', 'z-index: 2147483647;'+c+'width:168px;height: 100px; border: 3px solid #aaa;');
    container.appendChild(i);
    i.onload=function(){ setTimeout('_clipb830223_close()', 600); };

    p = e(p).replace(/'/g, '%27');
    b = e(b).replace(/'/g, '%27');
    window.frames['ipb830223'].document.write(
        '<html><body style="color: #555; background-color: #fff; text-align: center; margin: 0px; font-family: Georgia, Times, serif; font-size: 26px;">' +
                "<div style=\"position: absolute; bottom: 8px; left: 72px;\"><style>#sp{position:relative;width:20px;height:20px;}#sp div{width:2px;height:6px;background:#000;position:absolute;top:7px;left:9px;-moz-border-radius:2px;-webkit-border-radius:2px;}</style><div id=\"sp\"><scr"+"ipt>(function(c,d,i,t){window.setInterval(function(){var s=d.getElementById('sp');s.style.MozTransform=s.style.WebkitTransform='rotate('+c*30+'deg)';c=++c%12;},80);while(i--){t='-transform:rotate('+i*30+'deg) translate(0, -8px);';d.write('<div style=\"-moz'+t+'-webkit'+t+'opacity:'+i/12+';\"></div>');}})(0,document,12);</scr"+"ipt></div></div>" +
                '<div style="text-align: center; width: 80%; padding-bottom: 1px; margin: 0 auto 15px auto; font-size: 13px; border-bottom: 1px solid #ccc; color: #333;">Instapaper</div>' +
        '<div id="txt">Saving...</div>' +
                '<form action="' + document.location.protocol + '//www.instapaper.com/bookmarklet/post_v5" method="post" id="f" accept-charset="utf-8">' +
        '<input type="hidden" name="p" id="p" value=""/>' +
        '<input type="hidden" name="b" id="b" value=""/>' +
        '<input type="hidden" name="id" value="ipb830223"/>' +
        '</form>' +
                "<scr"+"ipt>var e=encodeURIComponent,w=window,d=document,x=w.XMLHttpRequest?new XMLHttpRequest():(w.ActiveXObject?new ActiveXObject('Microsoft.XMLHTTP'):0),f=d.getElementById('f');" +
        "d.getElementById('b').value=decodeURIComponent('" + b + "');d.getElementById('p').value=decodeURIComponent('" + p + "');" +
        "try{if(!x)throw(0);x.open('POST','"+document.location.protocol+"//www.instapaper.com/bookmarklet/post_v5',true);x.setRequestHeader('Content-Type','application/x-www-form-urlencoded');x.onreadystatechange=function(){if(x.readyState==4){if(x.status==200){try{eval(x.responseText);setTimeout('parent._clipb830223_close()', 600)}catch(e){}}else d.getElementById('f').submit();}};x.send('a=&cu=2017402&cp=QIX8b0Xg.MMt7kZH6cxTGLkKf%2F8A.K2n&ch=q8v2E3tVgHad6reCRs6mPhiRY&ce=1357791541&p=" +
        p + "&b=" + b +
        "');}catch(e){" +
        "d.getElementById('f').submit();" +
        "}</scr"+"ipt></body></html>"
    );
}

function _rlipb830223(){var title,d=document,l=d.location,href=l.href;
d.title = title = d.title.substring(12);
if (typeof iptstbt != 'undefined') { alert("The bookmarklet is correctly installed."); throw(0); }


/* Inspired by Pascal Laliberté's code */
if (/www\.google\.[^/]+\/reader/.test(d.location) && typeof(window.getPermalink) == 'function') {
    _greaderipb830223 = true;
    var l = getPermalink();
    if (! l) { alert('Select an item to save before using the Read Later bookmark.'); throw(0); }
    href = l.url;
    title = l.title;
}

    bodyipb830223 = document.body.innerHTML;
    _ipSendipb830223(href, title, false);

}_rlipb830223();void(0)
function _clipb830223_close() 
{
    var f = document.getElementById('ipb830223');
    if (f) {
        f.style.display = 'none'; 
        f.parentNode.removeChild(f);
    }
}

