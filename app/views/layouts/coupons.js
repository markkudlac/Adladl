
var device="mark"

$(document).ready(function(){
	console.log("coupons document ready")
	
	initAjax();
	
	loadCoupons();
})


function loadCoupons(){
	
	$.getJSON('<%= baseurl %>' + "/api/get_kept_coupons/"+device, null,
			function(data){popListView(data, "CO")});
	
	$.getJSON('<%= baseurl %>' + "/api/get_kept_ads/"+device, null,
			function(data){popListView(data, "AD")});
}


function popListView(data, adtype){
	var curpage_id;
	
	if (data == undefined || data.rtn != undefined) {
		alert("DB error");
		return;
	}
	
	curpage_id = $(":mobile-pagecontainer").pagecontainer("getActivePage").attr("id")
	
	for (i=0; i<data.length; i++){
		var xhref;
		
		// This is here for testing to allow local paths from different addresses
		if (data[i].urlhref.indexOf("http:") == 0 ) {
			xhref = data[i].urlhref
		} else {
			xhref = '<%= baseurl %>' + data[i].urlhref
		}
		
		xel = $('<li id="'+adtype+data[i].id+'"><div class="coupon">'+
				'<a target="_blank" href="' + xhref +
				'"><img src="' + '<%= baseurl %>' + data[i].urlimg + '"/></a></div></li>')

		xlist = $("#"+adtype+"list")
		xlist.append(xel);
		
		if (curpage_id.indexOf(adtype) >= 0) {
			xlist.listview("refresh");
		}
	}
	
}