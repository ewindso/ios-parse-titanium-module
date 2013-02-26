iOS Parse.com Module for Appcelerator Titanium
===========================================

Feel free to download com.elijahwindsor.parsemodule.iphone-1.0.zip to use it as-is without compiling.  However, you'll still need to clone this repository somewhere, and change a line in module.xcconfig (as shown below).

To compile, clone the repository, and edit module.xcconfig and change -F"/Users/ewindsor/Documents/Titanium Studio Workspace/parsemodule" to the fulle path of where you have cloned the repository.

Make sure your tiapp.xml has this: 

	<module platform="iphone">com.elijahwindsor.parsemodule</module>

To Initialize
--------------
	var parse = require('com.elijahwindsor.parsemodule');
	parse.initParse({
		appId: 'YOUR PARSE APP ID', 
		clientKey: 'YOUR PARSE CLIENT KEY'
	});


Create a new object in the class of 'Game':
-----------

    parse.createObject('Game', {
    	name: 'My first game', 
    	level: 1
    }, function(data) {
       if(data.error) {
       		// error happened
       } else {
       		// use data.object -- it is just plain JSON
       }       
    });

Update an object: 
-----------
	
	// NOTE: obj must have been retrieved from parse module (and later modified).
    parse.updateObject(obj, function(data) { 
      if(data.error) {

      } else {
     		// worked!
      } 
    });

Find an object: 
-----------

I think this is pretty cool.  You can pass in an array of conditions in which to find them.  For example: 

	// specifying _User targets the 'User' class in Parse.  If you want to specify your own class, no need for the _.
	parse.findObjects('_User', [
		{key: 'email', condition: '==', value: 'someemail@someemail.com'}
	], function(data) {
		if(data.error) {
			// error, probably with connection
			return;
		}

		if(data.results.length > 0) { // found some results!

		}
	});

You can also do multiple conditions:

	parse.findObjects('Game', [
		{key: 'level', condition: '>=', value: 1}, 
		{key: 'level', condition: '<=', value: 5}, 
		{key: 'status', condition: '==', value: 'live'},
		{key: 'position', condition: 'orderby', value: 'asc'}
	], function(data) {  ... });

Save All Objects
------------
	// for example, this one starts with findObjects
	parse.findObjects('Test', [], function(data) {
	  var objectArray = data.results; 
	
	  // assuming there are at least 2 objects in the array
	  objectArray[0].key = 'Another value';
	  objectArray[1].key = 'Yet another value';
	  
	  // now you can save them all at the same time here
	  parse.saveAllObjects(objectArray, function(data) {
	    if(data.success) { // yay!
	
	    }
	  });
	}); 

Signup User
------------
	parse.signupUser({
		email: 'EMAIL ADDRESS', 
		password: 'PASSWORD', 
		username: 'USERNAME'
	}, function(data) {
        if(data.error) {

		} else {
			// use data.user
		}			              
	});

Login User
------------
	parse.loginUser({
		username: username, 
		password: password
	}, function(data) {
		if(data.error) {
			...
		}
	});

Current User
------------
	parse.currentUser will refer to the current user, and null if there's not one.

	Also, you can use parse.refreshUser() to ensure parse.currentUser contains the latest user info.


Request Password Reset
------------
	parse.requestPasswordReset({
		email: 'some@email.com'
	}); 

	A user with this email is assumed to exist.  You can check before making this call by using 

	parse.findObjects('_User', [
		{key: 'email', condition: '==', value: 'some@email.com'}
	], function(data) {
		if(data.results && data.results.length > 0) { // the user exists

		}
	});


Upload a File
------------
Files need to be attached to an object.  Please make sure to pass in an object that you retrieved from the parse module when making the assignment.  

    parse.createFile({
      name: 'FILENAME'
      data: 'DATA', // can be imageview.image, for example
      attachmentInfo: {
        object: objectToAttachTo,  // this will have been retrieved from parse module, and can be parse.currentUser  
        key: 'KEY'  // the file will be referenced by this key inside of objectToAttachTo
      }
    }, function(data) {
    	if(data.error) { ... }
    });

Facebook
------------

	parse.setupFacebook('FACEBOOK APP ID');

	parse.facebookLogin({
	  permissions: ['email']  // see Parse / Facebook docs for more information on iOS 6 implementations for permissions
	}, function(data) {
	  if(data.user) {
	  	...
	  }
	});
	
Facebook Link with Existing User
------------

	parse.facebookLinkWithUser({ 
		user: parse.currentUser,   // most likely will pass in currentUser
		permissions: ['email']  
	}, function(data) { 
		if(data.user) { // OK!  we're linked
			
		} else {
			if(data.error == 'AlreadyLinked') {
				// this means that the FB account they're trying to link to is already linked with another account, so no-can-do
			} else {
				// general error
			}
		}
	});

Facebook Dialog
------------

	parse.showFacebookDialog('apprequests', {
		to: '1112311,32423423', // comma separated facebook ids
		message: "Check out this app"   // required
	}, function(response) {
		if(response.completed) { // they've sent the apprequests

		} else {  // they hit "cancel" or the "X"

		}
	});
} 


Twitter
------------
	parse.setupTwitter({
		consumerKey: 'CONSUMER KEY', 
		consumerSecret: 'CONSUMER SECRET'
	});

	parse.twitterLogin(function(data) {
		if(data.user) {
			...
		}
	});
	
Cloud Code:
------------
	parse.callCloudFunction('FUNCTION NAME', {
		PARAM1: 'VALUE1'  // your parameters here	
	}, function(result) {
		if(result.error) { // errror }
		else {
			// use result.object
		}
	});
	
	
Push Notifications:
------------
For more info on Parse Push Notifications at setting up SSL push certificates : [https://parse.com/tutorials/ios-push-notifications](https://parse.com/tutorials/ios-push-notifications)

To register for push notifications unique token should be retrieved from the device.
	
	Ti.Network.registerForPushNotifications({
		callback: function pushCallback(e)
		{},
		success: function pushSuccess(e)
		{
			deviceToken = e.deviceToken;
			parse.registerForPush(deviceToken, 'sampleChannel', function(data) {
				// output some data to check for success / errors
				// alert(data);
			});
		},
		error: function pushError(e)
		{
			// If unable to get deviceToken check for errors here
			// alert('Error!: '+JSON.stringify(e));
		},
		types: [
			Ti.Network.NOTIFICATION_TYPE_BADGE,
			Ti.Network.NOTIFICATION_TYPE_ALERT,
			Ti.Network.NOTIFICATION_TYPE_SOUND
		]
	});
	

Unsubscribing from channel:
	
	parse.unsubscribeFromPush('sampleChannel', function(data) {
		// alert(data);
	});

