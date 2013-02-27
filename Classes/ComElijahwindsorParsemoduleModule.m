/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComElijahwindsorParsemoduleModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComElijahwindsorParsemoduleModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"febf0ea8-3279-4573-abd6-17e72fa89b9a";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.elijahwindsor.parsemodule";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)initParse:(id)args {
	ENSURE_ARG_COUNT(args, 1);
	
	NSDictionary *argsDic = [args objectAtIndex:0];
	
	NSString *appId = [argsDic objectForKey:@"appId"];
	NSString *clientKey = [argsDic objectForKey:@"clientKey"];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps setApplicationId:appId clientKey:clientKey];
}

-(void)createObject:(id)args {
	ENSURE_ARG_COUNT(args, 3);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSString *className = [args objectAtIndex:0];
	NSDictionary *properties = [args objectAtIndex:1];
	KrollCallback *callback = [args objectAtIndex:2];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps createObjectWithClassName:className andProperties:properties andCallback:^(NSDictionary *obj, NSError *error) {
		
		NSDictionary *result;
		
		if(obj != nil) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:obj, @"object", [error userInfo], @"error", nil];
		} else {
			result = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo], @"error", nil];
		}
		
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(void)findObjects:(id)args {
	ENSURE_ARG_COUNT(args, 3);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSString *className = [args objectAtIndex:0];
	NSArray *criteria = [args objectAtIndex:1];
	KrollCallback *callback = [args objectAtIndex:2];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps findObjectsOfClassName:className withCriteria:criteria andCallback:^(NSArray *results, NSError *error) {
		NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:results, @"results", [error userInfo], @"error", nil];
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(void)fetchObject:(id)args {
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSDictionary *obj = [args objectAtIndex:0];
	KrollCallback *callback = [args objectAtIndex:1];
	
	NSString *className = [obj objectForKey:@"_className"];
	NSString *objectId = [obj objectForKey:@"_objectId"];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps fetchObjectOfClassName:className andObjectId:objectId andCallback:^(NSDictionary *obj, NSError *error) {
		NSDictionary *result;
		
		if(obj) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:obj, @"object", [error userInfo], @"error", nil];
		} else {
			result = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo], @"error", nil];
		}

		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(void)updateObject:(id)args {
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	NSDictionary *object = [args objectAtIndex:0];
	KrollCallback *callback = [args objectAtIndex:1];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps updateObject:object withCallback:^(BOOL success, NSError *error) {
		NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(void)deleteObject:(id)args {
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	NSDictionary *object = [args objectAtIndex:0];
	KrollCallback *callback = [args objectAtIndex:1];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps deleteObject:object withCallback:^(BOOL success, NSError *error) {
		NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(void)saveAllObjects:(id)args {
	ENSURE_ARG_COUNT(args, 2);

	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	NSArray *objects = [args objectAtIndex:0];
	KrollCallback *callback = [args objectAtIndex:1];
    
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
    [ps saveAllObjects:objects withCallback:^(BOOL success, NSError *error) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
        [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
    }];
}

#pragma mark -
#pragma mark PFFile
-(void)createFile:(id)args {
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	NSDictionary *fileInfo = [args objectAtIndex:0];
	KrollCallback *callback = [args objectAtIndex:1];
	
	NSString *name = [fileInfo objectForKey:@"name"];
	TiBlob *blob = [fileInfo objectForKey:@"data"];
	NSDictionary *attachmentInfo = [fileInfo objectForKey:@"attachmentInfo"];
		
	NSData *data = [blob data];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps createFileWithName:name andData:data andAttachmentInfo:attachmentInfo withCallback:^(NSDictionary *fileObj, NSError *error) {
		NSDictionary *result;
		
		if(fileObj) {
		   result = [NSDictionary dictionaryWithObjectsAndKeys:fileObj, @"object", [error userInfo], @"error", nil];
		} else {
		   result = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo], @"error", nil];            
		}
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

#pragma mark -
#pragma mark User
-(id)currentUser {
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	
	return [ps currentUser];
}

-(id)refreshUser:(id)args {
	ENSURE_ARG_COUNT(args, 0);
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps refreshCurrentUser];
	
	return [ps currentUser];    
}

-(void)signupUser:(id)args {
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSDictionary *userArgs = [args objectAtIndex:0];
	KrollCallback *callback = [args objectAtIndex:1];
	
	NSString *username = [userArgs objectForKey:@"username"];
	NSString *password = [userArgs objectForKey:@"password"];
	NSString *email = [userArgs objectForKey:@"email"];

	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps signupUserWithUsername:username andPassword:password andEmail:email andCallback:^(NSDictionary *user, NSError *error) {
		NSDictionary *result;
		
		if(user) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:user, @"user", [error userInfo], @"error", nil];
		} else {
			result = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo], @"error", nil];
		}
		
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
	
}

-(void)loginUser:(id)args {
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSDictionary *userArgs = [args objectAtIndex:0];
	KrollCallback *callback = [args objectAtIndex:1];
	
	NSString *username = [userArgs objectForKey:@"username"];
	NSString *password = [userArgs objectForKey:@"password"];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps loginWithUsername:username andPassword:password andCallback:^(NSDictionary *user, NSError *error) {
		
		NSDictionary *result;
		
		if(user) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:user, @"user", [error userInfo], @"error", nil];
		} else {
			result = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo], @"error", nil];
		}
		
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(void)requestPasswordReset:(id)args {
	ENSURE_ARG_COUNT(args, 1);
	
	NSDictionary *userArgs = [args objectAtIndex:0];
	NSString *email = [userArgs objectForKey:@"email"];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps requestPasswordResetForEmail:email];
}

-(void)logout:(id)args {
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps logout];
}

#pragma mark -
#pragma mark PFCloud
-(void)callCloudFunction:(id)args {
	ENSURE_ARG_COUNT(args, 3);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;

	NSString *functionName = [args objectAtIndex:0];
	NSDictionary *parameters = [args objectAtIndex:1];
	KrollCallback *callback = [args objectAtIndex:2];

	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps callCloudFunction:functionName withParameters:parameters andCallback:^(id object, NSError *error) {
		
		NSDictionary *result;
		
		if(object) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:object, @"object", [error userInfo], @"error", nil];
		} else {
			result = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo], @"error", nil];
		}
		
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

#pragma mark -
#pragma mark Facebook
-(void)setupFacebook:(id)args {
	ENSURE_ARG_COUNT(args, 1);

	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSString *facebookAppId = [args objectAtIndex:0];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps setupFacebookWithAppId:facebookAppId];
}

-(void)facebookLogin:(id)args {
	ENSURE_UI_THREAD(facebookLogin, args);
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSDictionary *dic = [args objectAtIndex:0];
	NSArray *permissions = [dic objectForKey:@"permissions"];
	
	if(fbCallback) {
		[fbCallback release];
		fbCallback = nil;
	}
	fbCallback = [[args objectAtIndex:1]retain];

	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps facebookLoginWithPermissions:permissions andCallback:^(id user, NSError *error) {
		NSDictionary *result = nil;
		
		if(user) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:user, @"user", nil];
		} else {
			result = [NSDictionary dictionaryWithObjectsAndKeys:@"FBError", @"error", nil];
		}
		
		// I use [args objectAtIndex:1] incase fbCallback is nulled already
		[selfRef _fireEventToListener:@"completed" withObject:result listener:[args objectAtIndex:1] thisObject:nil];
		
		if(fbCallback) {

			[fbCallback release];
			
			fbCallback = nil;
		}
	}];
}

-(void)facebookLinkWithUser:(id)args {
	ENSURE_UI_THREAD(facebookLinkWithUser, args);
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSDictionary *dic = [args objectAtIndex:0];
    NSDictionary *user = [dic objectForKey:@"user"];
	NSArray *permissions = [dic objectForKey:@"permissions"];
	
	if(fbCallback) {
		[fbCallback release];
		fbCallback = nil;
	}
	fbCallback = [[args objectAtIndex:1]retain];
    
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps facebookLinkWithUser:user andPermissions:permissions andCallback:^(id user, NSError *error) {
        
		NSDictionary *result = nil;
		
		if(user) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:user, @"user", nil];
		} else {
            if(error.code == 208) {
                result = [NSDictionary dictionaryWithObjectsAndKeys:@"AlreadyLinked", @"error", nil];                
            } else {
                NSLog(@"Error code: %i", error.code);
                result = [NSDictionary dictionaryWithObjectsAndKeys:@"FBError", @"error", nil];
            }
		}
		
		// I use [args objectAtIndex:1] incase fbCallback is nulled already
		[selfRef _fireEventToListener:@"completed" withObject:result listener:[args objectAtIndex:1] thisObject:nil];
		
		if(fbCallback) {
            
			[fbCallback release];
			
			fbCallback = nil;
		}
	}];
}

-(void)doFbRequest:(id)args {
	ENSURE_ARG_COUNT(args, 2);

	__block ComElijahwindsorParsemoduleModule *selfRef = self;

	NSString *path = [args objectAtIndex:0];

	KrollCallback *callback = [args objectAtIndex:1];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	
	[ps doFbRequestWithPath:path andCallback:^(id object, NSError *error) {
		NSDictionary *result;
		
		if(object) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:object, @"response", [error userInfo], @"error", nil];
		} else {
			result = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo], @"error", nil];
		}
		
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(id)fbAccessToken {
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];

	return [ps getFbAccessToken];
}

-(void)closeFbSession:(id)args {
    [[ParseSingleton sharedParseSingleton]closeFbSession];
}

-(void)showFacebookDialog:(id)args {
    ENSURE_UI_THREAD(showFacebookDialog, args);
    
    __block ComElijahwindsorParsemoduleModule *selfRef = self;
    
    ENSURE_ARG_COUNT(args, 3);
    
    NSString *dialog = [args objectAtIndex:0];
    NSDictionary *params = [args objectAtIndex:1];
    KrollCallback *callback = [args objectAtIndex:2];
    
    ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
    
    [ps showFacebookDialog:dialog withParams:params andCallback:^(BOOL completed) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:completed], @"completed", nil];

        [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
    }];
}

#pragma mark -
#pragma mark Twitter
-(void)setupTwitter:(id)args {
	ENSURE_ARG_COUNT(args, 1);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	NSDictionary *dic = [args objectAtIndex:0];
	NSString *consumerKey = [dic objectForKey:@"consumerKey"];
	NSString *consumerSecret = [dic objectForKey:@"consumerSecret"];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps setupTwitterWithConsumerKey:consumerKey andConsumerSecret:consumerSecret];
}

-(void)twitterLogin:(id)args {
	ENSURE_UI_THREAD(twitterLogin, args);
	
	ENSURE_ARG_COUNT(args, 1);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;
	
	KrollCallback *callback = [args objectAtIndex:0];
	
	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
   
	[ps twitterLoginWithCallback:^(id user, NSError *error) {
		NSDictionary *result;
		
		if(user) {
			result = [NSDictionary dictionaryWithObjectsAndKeys:user, @"user", [error userInfo], @"error", nil];
		} else {
			result = [NSDictionary dictionaryWithObjectsAndKeys:[error userInfo], @"error", nil];
		}
		
		[selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}
/*    [parseSingleton twitterLoginWithCallback:^(id object, NSError *error) {
 NSLog(@"Info: %@, %@", object, error);
 }];*/

-(void)resumed:(id)note
{
	NSDictionary *launchOptions = [[TiApp app] launchOptions];
	
	if (launchOptions!=nil)
	{
		NSString *urlString = [launchOptions objectForKey:@"url"];

		if (urlString!=nil && [urlString hasPrefix:@"fb"])
		{
			// if we're resuming under the same URL, we need to ignore
			if (lastFbUrl!=nil && [urlString isEqualToString:lastFbUrl])
			{
				return;
			}
			RELEASE_TO_NIL(lastFbUrl);
			lastFbUrl = [urlString copy];
			
			ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
			[ps handleOpenURL:[NSURL URLWithString:lastFbUrl]];
			
			return;
		}
	}
	
	// ignore fbCallback is they resume 1.) from web/fb app without cancel/accept or 2.) after ios6 native-login
	// if they resume without touching a FB button, call it with nil
/*    if(fbCallback) {
		[self _fireEventToListener:@"completed" withObject:nil listener:fbCallback thisObject:nil];
		[fbCallback release];
		
		fbCallback = nil;
	}*/
}

-(void)registerForPush:(id)args {
	ENSURE_ARG_COUNT(args, 3);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;

	NSString *deviceToken = [args objectAtIndex:0];
	NSString *channel = [args objectAtIndex:1];
	KrollCallback *callback = [args objectAtIndex:2];

	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps registerForPushWithDeviceToken:deviceToken andSubscribeToChannel:channel withCallback:^(BOOL success, NSError *error){
	   NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
	   [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(void)unsubscribeFromPush:(id)args {
	ENSURE_ARG_COUNT(args, 2);
	
	__block ComElijahwindsorParsemoduleModule *selfRef = self;

	NSString *channel = [args objectAtIndex:0];
	KrollCallback *callback = [args objectAtIndex:1];

	ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
	[ps unsubscribeFromPushChannel:channel withCallback:^(BOOL success, NSError *error){
	   NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
	   [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
	}];
}

-(id)example:(id)args
{
	// example method
	return @"hello world";
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}
/*
-(id)hasIos6WithFbAccount {
	float iosVersion = [[[UIDevice currentDevice] systemVersion]floatValue];
	
	if(iosVersion >= 6.0) {
		ACAccountStore *store = [[ACAccountStore alloc]init];
		ACAccountType *fbAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
		NSArray *fbAccounts = [store accountsWithAccountType:fbAccountType];

		if(fbAccounts.count > 0) {
			return [NSNumber numberWithBool:YES];
		}
		[store release];
	}
	return [NSNumber numberWithBool:NO];
}*/

-(void)setExampleProp:(id)value
{
	// example property setter
}

@end
