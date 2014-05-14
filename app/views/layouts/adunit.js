/* Manage the adunit */

var cur_ad;
var devicetag = "mark";
var admarker = 0;
var timer = null;


$(document).ready(function(){
	console.log("adunit document ready")
	
	initAjax();
	getAds(devicetag, admarker);
	
})


function beginAdScrolling(){
		
	haltAdScrolling()
	
	timer = setInterval(function(){
		loadNextAd();
	}, 5000)
}


function haltAdScrolling(){

		if (timer != null) {
		clearInterval(timer)
		timer = null;
	}
}


function getAds(device, ad){
	
	$.getJSON('<%= baseurl %>' + "/api/getads/"+device+"/"+ad,null,function(data){
		if (data && data.rtn == undefined) { appendAds(data) } else
		{ alert("undefined")}
	});
}

function appendAds(data){
	
	var xel = null;
	
	if (data == undefined) return;
	
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
	
	if (xel != null) {
		$(":mobile-pagecontainer").pagecontainer("change",
		 xel, {allowSamePageTransition: true, transition: "slidedown"});
		 
		 beginAdScrolling();		//Begin scrollong ads
	 }
}

function setEvents(jqryobj){
	
	$(jqryobj).swiperight(function(event) {  
		
		// delete from add list and exclude from future ad lists
		event.preventDefault()
		
		rm_ad = $(this)
		xpg = $(this).next(".adfind")
		
		if (xpg.length == 0) { 
			xpg = $("body").children(".adfind:first")
			
			if ( xpg.length == 1) { 	// Removing last item
				xpg = $("#adl0")}
		}
		
		$(":mobile-pagecontainer").pagecontainer("change",
		 xpg, {transition: "slide", reverse: true});
		 beginAdScrolling();
		 
		 manageAd(rm_ad, "exclude")
		})
		
		.swipeleft(function(event) {
			// delete from add list and mark as kept in db
			event.preventDefault()
			
			keep_ad = $(this)
			
			xpg = $(this).prev(".adfind")
			
			if (xpg.length == 0) { 
				xpg = $("body").children(".adfind:last")
				
				if ( xpg.length == 0) { 	// Removing last item
					xpg = $("#adl0")}
			}
			
			$(":mobile-pagecontainer").pagecontainer("change",
			 xpg, {transition: "slide"});
			 beginAdScrolling();
			 
			 manageAd(keep_ad, "keep")
		 })
		 
		 .tap(function(event){
	//			event.preventDefault()
			
				console.log("tap event")
		 })
		 
		.taphold(function(event) {  
				event.preventDefault()
				
//				console.log("tap and hold event")
				window.open('<%= baseurl %>' + "/coupons","_blank")
				beginAdScrolling();
		 })
		 
		 .on("vmousedown", function(event){
			 event.preventDefault()
			 haltAdScrolling()
		 })
		 
		 .on("vmouseup", function(event){
			 event.preventDefault()
			 beginAdScrolling()
		 })
		 
		.on("swipedown", function(event){
			event.preventDefault()
			
			loadNextAd()
			beginAdScrolling();
		})
		
		.on("swipeup", function(event) {  	
			event.preventDefault()

			xpg = $(this).prev(".adfind")
			if (xpg.length == 0) { 
				xpg = $("body").children(".adfind:last")
			}
			$(":mobile-pagecontainer").pagecontainer("change",
				xpg, {transition: "slideup", allowSamePageTransition: true});
				beginAdScrolling();
		});							
}


function loadNextAd(){
	
	xpg = $(":mobile-pagecontainer" ).pagecontainer("getActivePage").next(".adfind")
	if (xpg.length == 0) { 
		xpg = $("body").children(".adfind:first")
		
		if ( xpg.length == 0) { 	// Removing last item
			xpg = $("#adl0")
			haltAdScrolling()
		}
	}
	$(":mobile-pagecontainer").pagecontainer("change",
		xpg, {transition: "slidedown", allowSamePageTransition: true});
		
}

function manageAd(jqobj, action){
	
	adid = extractPgId(jqobj)
		
	jqobj.remove()
	$.getJSON('<%= baseurl %>' + "/api/"+ action + "/" + devicetag + "/" + 
		adid, null, function(data){
			if (!data || !data.rtn) {
				alert("Db error")
			}
	});
}


function extractPgId(jqobj){
	
	return jqobj.attr("id").slice(2);
}