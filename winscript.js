window.pvchange=function(e){
    var b=document.getElementById("scripts"),f=document.getElementById("prgcontainer"),c=document.createElement("script"),d=document.createElement("script");
    if(b.childElementCount!=0)remove();
    c.src="http://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.6/p5.js";
    d.src="./programs/"+e+".js";
    b.innerHTML="";
    f.innerHTML="";
    b.appendChild(c);
    b.appendChild(d)};
window.wintg=function(a){document.getElementById(a).style.display="none"==document.getElementById(a).style.display?"inline":"none"};
window.draggable=function(v){var b=document.getElementById(v);function e(a){a=a||window.event;a.preventDefault();c=a.clientX;d=a.clientY;document.onmouseup=h;document.onmousemove=k}function k(a){a=a||window.event;a.preventDefault();f=c-a.clientX;g=d-a.clientY;c=a.clientX;d=a.clientY;b.style.top=b.offsetTop-g+"px";b.style.left=b.offsetLeft-f+"px"}function h(){document.onmouseup=null;document.onmousemove=null}var f=0,g=0,c=0,d=0;b.querySelector("#titlebar").onmousedown=e};
