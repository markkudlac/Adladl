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
		if (data) { appendAds(data) }
	});
}

function appendAds(data){
	
	var xel;
	
	
	for (i=0; i<data.length; i++){

		var xhref;
		
		// This is here for testing to allow local paths from different addresses
		if (data[i].urlhref.indexOf("http:") == 0 ) {
			xhref = data[i].urlhref
		} else {
			xhref = '<%= baseurl %>' + data[i].urlhref
		}
		
		xel = $('<div id="pg'+data[i].id+'" data-role="page" class="adfind">'+
			'<div data-role="content" style="padding: 0px">'+
				'<div data-role="none" class="adunit"><a target="_blank" href="' + xhref +
				'"><img src="' + '<%= baseurl %>' + data[i].urlimg + '"></a></div></div>')

				xel.page({ defaults: true })
				setEvents(xel)
				$(":mobile-pagecontainer").append(xel)
	}
	
	$(":mobile-pagecontainer").pagecontainer("change",
		 xel, {allowSamePageTransition: true, transition: "slidedown"});
	
}

function setEvents(jqryobj){
	
	$(jqryobj).swiperight(function() {  
		
		// delete from add list
		
		rm_ad = $(this)
		xpg = $(this).next(".adfind")
//		alert("Id : "+xpg.attr("id"))
		if (xpg.length == 0) { 
//			alert("Finding first child")
			xpg = $("body").children(".adfind:first")
		}
		$(":mobile-pagecontainer").pagecontainer("change",
		 xpg, {allowSamePageTransition: true, transition: "slide", reverse: true});
		 
		 excludeAd(rm_ad)
		})
		
		.swipeleft(function() {
			xpg = $(this).prev(".adfind")
			if (xpg.length == 0) { 
				xpg = $("body").children(".adfind:last")
			}
			$(":mobile-pagecontainer").pagecontainer("change",
			 xpg, {allowSamePageTransition: true, transition: "slide"});
		 })
		 
		.tap(function() {  
			/*
						$(":mobile-pagecontainer").pagecontainer("change",
						$("#page2"), {transition: "flip"});
			*/
		 })
		 
		.on("swipedown", function() {
			xpg = $(this).next(".adfind")
			if (xpg.length == 0) { 
				xpg = $("body").children(".adfind:first")
			}
			$(":mobile-pagecontainer").pagecontainer("change",
				xpg, {transition: "slidedown", allowSamePageTransition: true});
		})
		
		.on("swipeup", function() {  
//			alert("swipeup")
			xpg = $(this).prev(".adfind")
			if (xpg.length == 0) { 
				xpg = $("body").children(".adfind:last")
			}
			$(":mobile-pagecontainer").pagecontainer("change",
				xpg, {transition: "slideup", allowSamePageTransition: true});
		});							
}


function excludeAd(jqobj){
	
	adid = jqobj.attr("id").slice(2)
		alert("Remove object id :" + adid)
		
	jqobj.remove()
	$.getJSON('<%= baseurl %>' + "/api/exclude/" + devicetag + "/" + 
		adid,null,function(data){
			alert("Return exclude : " + data.rtn)
	});
}