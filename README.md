iOS Parse.com Module for Appcelerator Titanium
===========================================
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
		{key: 'status', condition: '==', value: 'live'}
	], function(data) {  ... });


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