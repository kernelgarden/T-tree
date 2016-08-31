var targetWindow = null;
var tabsInfo = [];
var appUrl = chrome.extension.getURL('home.html');
var targetId = null;
var counter = 0;
var count;
var email;

function isEmpty(obj) {
    for(var prop in obj) {
        if(obj.hasOwnProperty(prop))
            return false;
    }

    return true && JSON.stringify(obj) === JSON.stringify({});
}

function start(tab) {
	counter = 0;

	chrome.storage.local.get("LoginInfo", function(item) {
		if (!isEmpty(item)) {
			chrome.windows.getCurrent(getWindows).then(function(col) {
			});
		} else {
			chrome.tabs.create({url: appUrl}, function(tab) {
				targetId = tab.id;
			});
		}
	});
/*
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
			if (token != undefined) {
				chrome.windows.getCurrent(getWindows).then(function(col) {
				});
			}
		};
	  x.send();
	});
*/
	/*
	chrome.tabs.create({url: appUrl}, function(tab) {
		targetId = tab.id;
	});
	*/
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
		return function(item) {
			return callback(item);
		}
		/*
		return function(userInfo) {
			return callback(userInfo);
		}
		*/
	}

	chrome.storage.local.get("LoginInfo", callbackClosure(function(item) {
		//alert(JSON.stringify(item));
		userProfile.email = item["LoginInfo"]["user_email"];
		userProfile.id = item["LoginInfo"]["user_id"];
		userProfile.provider = item["LoginInfo"]["provider"];
		asyncFlag = true;
	}));

/*
	chrome.identity.getProfileUserInfo( callbackClosure( function(userInfo) {
		//alert(JSON.stringify(userInfo.email));
		userProfile.email = userInfo.email;
		asyncFlag = true;
	}));
*/

	function wait(){
	  if (!asyncFlag){
	    setTimeout(wait,100);
	  } else {
			jsonObj.pages = pages;
			jsonObj["user_email"] = userProfile.email;
			jsonObj["provider"] = userProfile.provider;

			//alert("email: " + jsonObj["user_email"]);

			for (var i = 0; i < numWindows; i++) {
				var win = windows[i];

				var numTabs = win.tabs.length;

				for (var j = 0; j < numTabs; j++) {
					var tab = win.tabs[j];
          /*
					var dataObj = {}

					count = counter.toString();
					dataObj[count] = {}
					dataObj[count]["url"] = tab.url;
					dataObj[count]["title"] = tab.title;
					counter++;
          */

          if (tab.url.includes("tab-storage.com")) {
            continue;
          }
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
          //if (!tab.url.includes("tab-storage.com")) {
					  chrome.tabs.remove(tab.id);
          //}
				}
			}
			//alert(JSON.stringify(jsonObj));
			$.ajax({
		            type : "POST",
		            //url : "http://tab-storage.com/api/page/new",
                url : "http://develop.tab-storage.com/api/page/new",
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

function onClickHandler(info, tab) {
	chrome.storage.local.remove("LoginInfo");
}

chrome.contextMenus.onClicked.addListener(onClickHandler);

chrome.runtime.onInstalled.addListener(function() {
	chrome.contextMenus.create({"title": "Tab Storage", "contexts": ["browser_action"],
															"id": "root"});

	chrome.contextMenus.create({"title": "Logout", "contexts": ["browser_action"],
															"parentId": "root", "id": "logout"});
})

chrome.runtime.onStartup.addListener(function() {
  chrome.tabs.create({url: "http://develop.tab-storage.com/"}, function(tab) {
    targetId = tab.id;
  });
})

chrome.commands.onCommand.addListener(function(command) {
  if (command === "open_tab_storage")
    chrome.tabs.create({url: "http://develop.tab-storage.com/"}, function(tab) {
      targetId = tab.id;
    });
  else if (command === "store_all_tab")
    chrome.tabs.getCurrent(start);
});
