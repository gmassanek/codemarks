window.codemarklet=window.codemarklet||{};
var D=550;
var A=450;
var C=screen.height;
var B=screen.width;
var H=Math.round((B/2)-(D/2));
var G=0;
var F=document;
var E;

if(C>A){G=Math.round((C/2)-(A/2))}
window.codemarklet.shareWin=window.open('http://staging.codemarks.com/','','left='+H+',top='+G+',width='+D+',height='+A+',personalbar=0,toolbar=0,scrollbars=1,resizable=1');
