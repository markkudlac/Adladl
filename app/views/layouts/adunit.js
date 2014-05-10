/* Manage the adunit */

var cur_ad;
var devicetag = "mark";
var admarker = 0;

$(document).ready(function(){
	console.log("In adunit document ready")
	
	initAjax();
	getAds(devicetag, admarker);
	
})


function initAjax() {
	
	$(document).ajaxError(function(ev,xhdr,status,err) {
		alert("Ajax error : "+err)
		console.log(status)
	})
	
	$(document).ajaxStart(function() {
		console.log("Ajax Start")
	})
}



function getAds(device, ad){
	
	$.getJSON('<%= baseurl %>' + "/api/getads/"+device+"/"+ad,null,function(data){
//		alert("got json : "+data[0].urlimg)
		if (data) { appendAds(data) }
	});
}

function appendAds(data){
	
	var xel;
	
	
	for (i=0; i<data.length; i++){
//		alert("Load add : "+data[i].urlimg)
		
			xel = $('<div id="pg'+data[i].id+'" data-role="page" class="adfind">'+
				'<div data-role="content" style="padding: 0px">'+
					'<div data-role="none" class="adunit">'+
					'<img src="' + '<%= baseurl %>' + data[i].urlimg + '"></div></div>')

					xel.page({ defaults: true })
					setEvents(xel)
					$(":mobile-pagecontainer").append(xel)
	}
	
	$(":mobile-pagecontainer").pagecontainer("change",
		 xel, {allowSamePageTransition: true, transition: "slidedown"});
	
}

function setEvents(jqryobj){
	
	$(jqryobj).swiperight(function() {  
		xpg = $(this).next(".adfind")
//		alert("Id : "+xpg.attr("id"))
		if (xpg.length == 0) { 
//			alert("Finding first child")
			xpg = $("body").children(".adfind:first")
		}
		$(":mobile-pagecontainer").pagecontainer("change",
		 xpg, {allowSamePageTransition: true, transition: "slide", reverse: true});
		})
		.swipeleft(function() {
			xpg = $(this).prev(".adfind")
	//		alert("Id : "+xpg.attr("id"))
			if (xpg.length == 0) { 
	//			alert("Finding last child")
				xpg = $("body").children(".adfind:last")
			}
			$(":mobile-pagecontainer").pagecontainer("change",
			 xpg, {allowSamePageTransition: true, transition: "slide"});
		 })
		.tap(function() {  
						$(":mobile-pagecontainer").pagecontainer("change",
						$("#page2"), {transition: "flip"});
		 })
		.on("swipedown", function() {
							$(":mobile-pagecontainer").pagecontainer("change",
							$("#page2"), {transition: "slidedown"});
		})
		.on("swipeup", function() {  
				$(":mobile-pagecontainer").pagecontainer("change",
				$("#page2"), {transition: "slideup"});
		});							
}

