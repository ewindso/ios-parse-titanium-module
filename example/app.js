// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

// TODO: write your module tests here
var parsemodule = require('com.elijahwindsor.parsemodule');

parsemodule.initParse({
    appId: 'YOUR APP ID', 
    clientKey: 'YOUR CLIENT KEY'
});

parsemodule.createObject('Cat', {
    'name': 'Vesta Only One', 
    'favoriteFood': 'turkey'
}, function(data) {
    if(data.error) {
        Ti.API.debug(JSON.stringify(data.error));  
        return;   
    }
    
    alert('Object id ' + JSON.stringify(data.object) + ' created!');
});

parsemodule.fetchObject({
    '_className': 'Kitty', 
    '_objectId': 'xviD5Tu127'
}, function(data) {
    var object = data.object;
    
    // now, fetch parent!
    parsemodule.fetchObject(object.parent, function(data) {
       Ti.API.debug('Parent! ' + JSON.stringify(data));
       
       var parent = data.object;
       
       // now fetch all children of this parent
       parsemodule.findObjects('Kitty', [
        { key: 'parent', condition: '==', value: parent }
       ], function(data) {
          alert(JSON.stringify(data)); 
       });
    });
});


// test signup
parsemodule.signupUser({
    username: 'ewindsor2', 
    password: 'asdf'
}, function(data) {
    alert(JSON.stringify(data)); 
});

// test cloud function
parsemodule.callCloudFunction('JoinGame', {
                              gameId: 1
                              }, function(data) {
                              alert(JSON.stringify(data));
                              });

// attempt find (with ACL)
parsemodule.findObjects('Game', [
                                 {key: 'objectId', condition: '==', value: 'vyXjAhqsGy'}
], function(data) {
	Ti.API.debug(JSON.stringify(data));
});
