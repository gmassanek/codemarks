var loc = document.location;
var server = 'http://staging.codemarks.com/';
window.codemarklet=window.codemarklet||{};
var H=450;
var W=604;
var SW=screen.width;
var SH=screen.height;
var LFT=Math.round((SW/2)-(W/2));
var G=0;
var url = server + 'codemarklet/new?url=' + loc;
if(SH>H){G=Math.round((SH/W)-(H/2))}
window.codemarklet.shareWin=window.open(url,'','left='+LFT+',top='+G+',width='+W+',height='+H+',personalbar=0,toolbar=0,scrollbars=1,resizable=1');
