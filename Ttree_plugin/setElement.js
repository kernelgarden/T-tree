function setTabInfo(tab_url, tab_title) {
	var list = document.createElement("li");
	var node = document.createTextNode(tab_url);
	list.appendChild(node);

	var element = document.getElementById('target');
	alert(element);
	element.appendChild(list);
};

function click(e) {
	var tab_length = 0;
	var app_url = null;

	chrome.storage.local.get("tab_length", function(items) { tab_length = items.tab_length });

	for (var i = 0; i < tab_length; i++) {
		chrome.storage.local.get(i.toString(), function(items) { app_url = items[i].url });
		chrome.tabs.create({url: app_url}, function(tab) {
			targetId = tab.id;
		});
	}
}

var tab_length = 0;

document.addEventListener('DOMContentLoaded', function() {
	chrome.storage.local.get("tab_length", function(items) {
		tab_length = items.tab_length;
		var tab_arr = [];

		for (var i = 0; i < tab_length; i++) {
			tab_arr.push(i.toString());
		}
		//console.log(tab_arr);
		chrome.storage.local.get(tab_arr, function(items) {
			//console.log(items);
			for (var j = 0; ; j++) {
				tab = items[j];
				if (!tab)
					break;
				//console.log(tab);
				var list = document.createElement("li");
				var node = document.createTextNode(tab.title + " >>> " + tab.url);
				list.appendChild(node);

				var element = document.getElementById("tree");
				element.appendChild(list);
			}
		});
	});
});
