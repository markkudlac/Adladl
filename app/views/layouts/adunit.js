/* Manage the adunit */

/* var devicetag = "mark"; */

var admarker = 0;
var timer = null;
var prizetimer = null;
var prizecnt = 0;
var prizeobj = null;

$(document).ready(function(){
	console.log("adunit document ready")
	
	initAjax();
	getAds('<%= devicetag %>' , admarker);
	
	instructMess(0);
})


function beginAdScrolling(){
		
	haltAdScrolling()
	timer = setInterval(loadNextAd, 5000)
}


function haltAdScrolling(){

	if (timer != null) {
		clearInterval(timer)
		timer = null;
	}
}


function beginPrizeScrolling(){
		
	haltPrizeScrolling()
	prizetimer = setInterval(scrollPrize, 3000)
}


function haltPrizeScrolling(){

	if (prizetimer != null) {
		clearInterval(prizetimer)
		prizetimer = null;
	}
	prizecnt = 0;
}


function getAds(device, ad){
	
	if (!activePrize()){
		$.getJSON("<%= baseurl %>/api/getads/"+device+"/"+ad,null,function(data){
			if (data && data.rtn == undefined) { appendAds(data) } else
			{ console.log("getAds data undefined")}
		});
	}
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
		
		/* This was being used before message to get next ad
		Could be re engaged to not repeat previous ads
		
		xpg = $(this).next(".adfind")
		
		if (xpg.length == 0) { 
			xpg = $("body").children(".adfind:first")
			
			if ( xpg.length == 1) { 	// Removing last item
				xpg = $("#adl0")}
		}
*/
				
		if (!cancelPrize()){		//exit from current prize
		 	manageAd(rm_ad, "exclude")

			$("#adlmess").unbind("swiperight")
			$("#adltext").text("Will Not See This Again")
		
			$(":mobile-pagecontainer").pagecontainer("change",
//			 xpg, {transition: "slide", reverse: true});
				$("#adlmess"), {transition: "slide", reverse: true});
			 beginAdScrolling();		/* This starts at beginning. Might want to get next */
		 }

		})
		
		.swipeleft(function(event) {
			// delete from add list and mark as kept in db
			event.preventDefault()

			if (activePrize()) return;
			
			if (<%= prizemode %>){
				beginPrize($(this))
			} else {
				keepAd($(this))
			}

		 })
		 
		 .tap(function(event){
	//			event.preventDefault()
			
				console.log("tap event")
		 })
		 
		.taphold(function(event) {  
				event.preventDefault()
				
//				console.log("tap and hold event")
				window.open("<%= baseurl %>/coupons/<%= devicetag %>","_blank")
				
				if (!activePrize()){
					beginAdScrolling();
				}
		 })
		 
		 .on("vmousedown", function(event){
			 event.preventDefault()
			 haltAdScrolling()
		 })
		 
		 .on("vmouseup", function(event){
			 event.preventDefault()
			 
			 if (!<%= prizemode %>) {
			 	beginAdScrolling()
				}
		 })
		 
		.on("swipedown", function(event){
			event.preventDefault()
			
			if (activePrize()) return;
			
			loadNextAd()
			beginAdScrolling();
		})
		
		.on("swipeup", function(event) {  	
			event.preventDefault()

			if (activePrize()) return;
			
			xpg = $(this).prev(".adfind")
			if (xpg.length == 0) { 
				xpg = $("body").children(".adfind:last")
			}
			$(":mobile-pagecontainer").pagecontainer("change",
				xpg, {transition: "slideup", allowSamePageTransition: true});
				beginAdScrolling();
		});							
}



function keepAd(keepobj){
	
	$("#adlmess").unbind("swiperight")
	$("#adltext").text("Stored")
	
	$(":mobile-pagecontainer").pagecontainer("change",
		 $("#adlmess"), {transition: "slide"});
	 beginAdScrolling();		/* This starts at beginning. Might want to get next */
	 
	 manageAd(keepobj, "keep")
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
	$.getJSON("<%= baseurl %>/api/"+ action + "/<%= devicetag %>/" + 
		adid, null, function(data){
			if (!data || !data.rtn) {
				alert("Db error")
			}
	});
}


function extractPgId(jqobj){
	
	return jqobj.attr("id").slice(2);
}


function activePrize(){
	
	return(prizeobj != null);
}


function beginPrize(prizesel){
	
//		console.log("prize selected")
	prizeobj = prizesel
	haltAdScrolling()
	
	$("#adlmess").one("swiperight",cancelPrize)
	$("#adltext").text("You Are Playing For")
	$(":mobile-pagecontainer").pagecontainer("change",
		$("#adlmess"), {transition: "slide"});
	
		beginPrizeScrolling();

}


function scrollPrize(){
	var xobj;
	
	console.log("In scrollPrixe cnt : "+prizecnt)

		$("#adltext").text("Swipe Right to Cancel")

		if (prizecnt > 0 && prizecnt % 4 == 0){
			xobj = $("#adlmess")
		} else if (prizecnt % 2 == 0){
			$("#adltext").text("You Are Playing For")
			xobj = $("#adlmess")
		} else {
			xobj = prizeobj
		}

		$(":mobile-pagecontainer").pagecontainer("change",
					xobj, {transition: "flip"});
	++prizecnt;
}


function prizewon(){
//	console.log("In prize won")
	
	if (activePrize()){
		haltPrizeScrolling();
		manageAd(prizeobj, "keep")
		$("#adltext").text("WON")
		$(":mobile-pagecontainer").pagecontainer("change",
					$("#adlmess"), {transition: "slide"});
		prizeobj = null
	
		beginAdScrolling();
	}
}


function cancelPrize(){
	
	if (activePrize()){		//exit from current prize
		haltPrizeScrolling()
		prizeobj = null
		$("#adlmess").unbind("swiperight")
		$("#adlmess2").unbind("swiperight")
		$("#adltext2").text("CANCELLED")
		
		$(":mobile-pagecontainer").pagecontainer("change",
		 $("#adlmess2"), {transition: "slide", reverse: true});
		 beginAdScrolling();
		return true;
	} else {
		return false;
	}
}


function clearads(){

	$.getJSON("<%= baseurl %>/api/clearads/<%= devicetag %>",null,function(data){
		if (data && data.rtn == true) {
			 console.log("ads cleared") 
			 getAds('<%= devicetag %>' , admarker);
	 	} else {
			console.log("clear ads failed")
		}
	});
}


function instructMess(cnt){
	
	console.log("In instructMess cnt : "+cnt)
	
	if (cnt == 0){

	} else if (cnt  == 1) {

	} else {
		return;
	}
	
	++cnt;
	setTimeout("instructMess(" + cnt + ")",2000)
}