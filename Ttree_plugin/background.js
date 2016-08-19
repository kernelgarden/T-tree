var targetWindow = null;
var tabsInfo = [];
var appUrl = chrome.extension.getURL('home.html');
var targetId = null;
var counter = 0;
var count;

function start(tab) {
	counter = 0;
	chrome.tabs.create({url: appUrl}, function(tab) {
		targetId = tab.id;
	});
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

	for (var i = 0; i < numWindows; i++) {
		var win = windows[i];

		var numTabs = win.tabs.length;

/*
		// get all tabs in the current window
		captureWindowTabs(win.id, function(dataArray) {
    	for(var i = 0; i < dataArray.length; ++i) {
        //alert(dataArray[i].dataUrl); // log to the background page or popup
				var str = i.toString() + "img";
				var dat = {};
				dat[str] = {};
				dat[str]["img"] = dataArray[i].dataUrl;
				//alert(dataArray.length);
				chrome.storage.local.set(dat, function() {});
    	}
			alert(dataArray.length);
		});
*/

		for (var j = 0; j < numTabs; j++) {
			var tab = win.tabs[j];
			var dataObj = {}

			count = counter.toString();
			dataObj[count] = {}
			dataObj[count]["url"] = tab.url;
			dataObj[count]["title"] = tab.title;
			counter++;

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
			chrome.tabs.remove(tab.id);
		}
	}
}

/*
function captureWindowTabs(windowId, callbackWithDataUrlArray) {
  var dataUrlArray = [];

  // get all tabs in the window
  chrome.windows.get(windowId, {populate:true}, function(windowObj) {
    var tabArray = windowObj.tabs;

    // find the tab selected at first
    for(var i = 0; i < tabArray.length; ++i) {
      if(tabArray[i].active) {
        var currentTab = tabArray[i];
        	break;
      }
    }

  	// recursive function that captures the tab and switches to the next
    var photoTab = function(i) {
      chrome.tabs.update(tabArray[i].id, {active:true}, function() {
        chrome.tabs.captureVisibleTab(windowId, {format:"png"}, function(dataUrl) {
          // add data URL to array
          dataUrlArray.push({tabId:tabArray[i].id, dataUrl:dataUrl});

          // switch to the next tab if there is one
          if(tabArray[i+1] != undefined) {
						//if (i != 0) {
							chrome.tabs.remove(tabArray[i].id);
						//}
            photoTab(i+1);
          } else {
            // if no more tabs, return to the original tab and fire callback
            chrome.tabs.update(currentTab.id, {active:true}, function() {
              callbackWithDataUrlArray(dataUrlArray);
            });
          }
        });
      });
    }
    photoTab(0);
  });
}
*/



// listen for our browerAction to be clicked
chrome.browserAction.onClicked.addListener(start);
