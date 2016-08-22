var targetWindow = null;
var tabsInfo = [];
var appUrl = chrome.extension.getURL('home.html');
var targetId = null;
var counter = 0;
var count;
var email;

function start(tab) {
	counter = 0;

	chrome.identity.getAuthToken({
	  interactive: true
	}, function(token) {
	  if (chrome.runtime.lastError) {
	    alert(chrome.runtime.lastError.message);
	    return;
	  }
	  var x = new XMLHttpRequest();
	  x.open('GET', 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=' + token);
	  x.onload = function() {
			//alert(x.response);
		};
	  x.send();
	});
	/*
	chrome.tabs.create({url: appUrl}, function(tab) {
		targetId = tab.id;
	});
	*/
	chrome.windows.getCurrent(getWindows).then(function(col) {
	});
}

function getWindows(window) {
	targetWindow = window;
	chrome.tabs.getAllInWindow(targetWindow.id, getTabs);
}

function getTabs(tabs) {
	chrome.windows.getAll({"populate" : true}, processTabs);
}

function processTabs(windows) {
	var numWindows = windows.length;
	var jsonObj = {};
	var pages = [];
	var userProfile = {};
	var asyncFlag = false;

	function callbackClosure(callback) {
		return function(userInfo) {
			return callback(userInfo);
		}
	}

	chrome.identity.getProfileUserInfo( callbackClosure( function(userInfo) {
		//alert(JSON.stringify(userInfo.email));
		userProfile.email = JSON.stringify(userInfo.email);
		asyncFlag = true;
	}));

	function wait(){
	  if (!asyncFlag){
	    setTimeout(wait,100);
	  } else {
			jsonObj.pages = pages;
			jsonObj["user_email"] = userProfile.email;

			//alert("email: " + jsonObj["user_email"]);

			for (var i = 0; i < numWindows; i++) {
				var win = windows[i];

				var numTabs = win.tabs.length;

				for (var j = 0; j < numTabs; j++) {
					var tab = win.tabs[j];
					var dataObj = {}

					count = counter.toString();
					dataObj[count] = {}
					dataObj[count]["url"] = tab.url;
					dataObj[count]["title"] = tab.title;
					counter++;

					var pageData = {
						"url": tab.url,
						"title": tab.title
					};

					jsonObj.pages.push(pageData);
					/*
					chrome.storage.local.set(dataObj, function() {
						if (chrome.extension.lastError) {
		            alert('An error occurred: ' + chrome.extension.lastError.message);
		        }
					});
					chrome.storage.local.set({"tab_length": counter}, function() {
						if (chrome.extension.lastError) {
							alert('An error occurred: ' + chrome.extension.lastError.message);
						}
					});
					*/
					chrome.tabs.remove(tab.id);
				}
			}
			//alert(JSON.stringify(jsonObj));
			$.ajax({
		            type : "POST",
		            url : "http://52.78.83.129:3000/api/page/new",
		            contentType: "application/json; charset=UTF-8",
		            cache : false,
								crossDomain:true,
		            data : JSON.stringify(jsonObj),
								async:false,
		            success:function(data){
									//alert("success");
		            },
		           error: function(jxhr){
		               //alert("fail");
		           }
		      });
	  }
	}
	wait();
}

// listen for our browerAction to be clicked
chrome.browserAction.onClicked.addListener(start);
