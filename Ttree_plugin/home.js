var main  = (function() {
  facebook.onload;
  google.onload;
});

var tabStorageLoginInfo = {};
tabStorageLoginInfo["LoginInfo"] = {};

var facebook = (function() {

  var access_token;

  var tokenFetcher = (function() {
    var clientId = '280839942296040';
    var clientSecret = 'bd70961ffbe432b13d68d6751b070eda';
    var redirectUri = 'https://' + chrome.runtime.id +
                      '.chromiumapp.org/provider_cb';
    var redirectRe = new RegExp(redirectUri + '[#\?](.*)');
    access_token = null;

    return {
      getToken: function(interactive, callback) {
        // In case we already have an access_token cached, simply return it.
        if (access_token) {
          callback(null, access_token);
          return;
        }

        var options = {
          'interactive': interactive,
          // url:'https://graph.facebook.com/oauth/access_token?client_id=' + clientId +
          url:'https://www.facebook.com/dialog/oauth?client_id=' + clientId +
              '&reponse_type=token' +
              '&access_type=online' +
              '&redirect_uri=' + encodeURIComponent(redirectUri) +
              '&scope=email'
        }
        //alert("tttt");
        chrome.identity.launchWebAuthFlow(options, function(redirectUri) {
          if (chrome.runtime.lastError) {
            callback(new Error(chrome.runtime.lastError));
            return;
          }
          // Upon success the response is appended to redirectUri, e.g.
          // https://{app_id}.chromiumapp.org/provider_cb#access_token={value}
          //     &refresh_token={value}
          // or:
          // https://{app_id}.chromiumapp.org/provider_cb#code={value}
          var matches = redirectUri.match(redirectRe);
          if (matches && matches.length > 1)
            handleProviderResponse(parseRedirectFragment(matches[1]));
          else
            callback(new Error('Invalid redirect URI'));
        });

        function parseRedirectFragment(fragment) {
          var pairs = fragment.split(/&/);
          var values = {};

          pairs.forEach(function(pair) {
            var nameval = pair.split(/=/);
            values[nameval[0]] = nameval[1];
          });

          return values;
        }

        function handleProviderResponse(values) {
          if (values.hasOwnProperty('access_token'))
            setAccessToken(values.access_token);
          else if (values.hasOwnProperty('code'))
            exchangeCodeForToken(values.code);
          else callback(new Error('Neither access_token nor code avialable.'));
        }

        function exchangeCodeForToken(code) {
          var xhr = new XMLHttpRequest();
          xhr.open('GET',
                   // 'https://www.facebook.com/dialog/oauth?'+
                   'https://graph.facebook.com/oauth/access_token?' +
                   'client_id=' + clientId +
                   '&client_secret=' + clientSecret +
                   '&redirect_uri=' + redirectUri +
                   '&code=' + code);
          xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
          xhr.setRequestHeader('Accept', 'application/json');
          xhr.onload = function () {
            if (this.status === 200) {
              var response = JSON.parse('"'+this.responseText+'"');
              response = response.substring(0,response.indexOf('&'));
              setAccessToken(response);
              access_token = response;
            }
          };
          xhr.send();
        }

        function setAccessToken(token) {
          access_token = token;
          callback(null, access_token);
        }
      },

      removeCachedToken: function(token_to_remove) {
        if (access_token == token_to_remove)
          access_token = null;
      }
    }
  })();

  function xhrWithAuth(method, url, interactive, callback) {
    var retry = true;
    getToken();

    function getToken() {
      tokenFetcher.getToken(interactive, function(error, token) {
        if (error) {
          callback(error);
          return;
        }
        access_token = token;
        requestStart();
      });
    }

    function requestStart() {
      var xhr = new XMLHttpRequest();
      xhr.open(method, url);
      xhr.setRequestHeader('Authorization', 'Bearer ' + access_token);
      xhr.onload = requestComplete;
      xhr.send();
    }

    function requestComplete() {
      if (this.status != 200 && retry) {
        retry = false;
        tokenFetcher.removeCachedToken(access_token);
        access_token = null;
        getToken();
      } else {
        callback(null, this.status, this.response);
      }
    }
  }

  function getUserInfo(interactive) {
    xhrWithAuth('GET',
                'https://graph.facebook.com/me?'+access_token+'&fields=name,email',
                interactive,
                onUserInfoFetched);
    //alert(access_token);
    //alert("test");
  }

  function onUserInfoFetched(error, status, response) {
    if (!error && status == 200) {
      var user_info = JSON.parse(response);
      //console.log("Got the following user info: " + response);
      //console.log(user_info.name);
      //console.log(user_info);
      tabStorageLoginInfo["LoginInfo"]["provider"] = "facebook";
      tabStorageLoginInfo["LoginInfo"]["access_token"] = access_token;
      tabStorageLoginInfo["LoginInfo"]["user_email"] = user_info.email;
      tabStorageLoginInfo["LoginInfo"]["user_id"] = user_info.id;
      tabStorageLoginInfo["LoginInfo"]["user_name"] = user_info.name;
      //console.log(tabStorageLoginInfo);
      chrome.storage.local.set(tabStorageLoginInfo, function() {
        if (chrome.extension.lastError) {
            //alert('An error occurred: ' + chrome.extension.lastError.message);
        }
        chrome.tabs.getCurrent(function(tab) {
          chrome.tabs.remove(tab.id);
        });
        //alert("save!!!");
      });
      //alert(user_info);
      //chrome.identity.getProfileUserInfo(function(userInfo){ console.log(userInfo); });
    } else {
    }
  }

  function interactiveSignIn() {
    //alert("fuck");
    tokenFetcher.getToken(true, function(error, access_token) {
      if (error) {
        //alert("error");
      } else {
        /*
        alert("test2");
        chrome.storage.local.set({"tab_storage_AT": access_token}, function() {
          if (chrome.extension.lastError) {
              alert('An error occurred: ' + chrome.extension.lastError.message);
          }
          alert("save!!!");
        });
        var x = new XMLHttpRequest();
        x.open('GET', 'https://graph.facebook.com/me?'+access_token+'&fields=name,email');
        x.onload = function() {
             alert(x.response);
             console.log("login user");
        };
        x.send();
        */
        getUserInfo(true);
      }
    });
  }

  return {
    onload: function () {
      //signin_button = document.querySelector('#facebook');
      /*
      $("facebook").click(function() {
        alert("fuck");
        interactiveSignIn();
      })
      */
      $("#facebook").on("click", function(event) {
        //alert("fuck");
        event.preventDefault();
        interactiveSignIn();
        //alert("end");
      })
      //signin_button.onclick = interactiveSignIn;
      //getUserInfo(true);
      // revoke_button = document.querySelector('#revoke');
      // revoke_button.onclick = revokeToken;
      // user_info_div = document.getElementById('user_info');
      // console.log(signin_button, revoke_button, user_info_div);
      //showButton(signin_button);
      // getUserInfo(false);
    }
  };
})();

function googleSignIn() {
  chrome.identity.getAuthToken({
	  interactive: true
	}, function(token) {
	  if (chrome.runtime.lastError) {
	    //alert(chrome.runtime.lastError.message);
	    return;
	  }

    tabStorageLoginInfo["LoginInfo"]["provider"] = "google";
    tabStorageLoginInfo["LoginInfo"]["access_token"] = token;

	  var x = new XMLHttpRequest();
	  x.open('GET', 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=' + token);
	  x.onload = function() {
			//alert(x.response);
      console.log(x.response);
      var data = JSON.parse(x.response);
      tabStorageLoginInfo["LoginInfo"]["user_email"] = data.email;
      tabStorageLoginInfo["LoginInfo"]["user_id"] = data.id;
      tabStorageLoginInfo["LoginInfo"]["user_name"] = data.name;
      console.log(tabStorageLoginInfo);
      chrome.storage.local.set(tabStorageLoginInfo, function() {
        if (chrome.extension.lastError) {
            //alert('An error occurred: ' + chrome.extension.lastError.message);
        }
        //alert("save!!!");
        chrome.tabs.getCurrent(function(tab) {
          chrome.tabs.remove(tab.id);
        });
      });
		};
	  x.send();
	});
}

var google = (function() {
  return {
    onload: function() {
      $("#google").on("click", function(event) {
        event.preventDefault();
        googleSignIn();
      })
    }
  };
})();

$(document).ready(function(){
  facebook.onload();
  google.onload();
})

//window.onload = facebook.onload;

/*
document.addEventListener('load', function() {
  facebook.onload();
});
*/
