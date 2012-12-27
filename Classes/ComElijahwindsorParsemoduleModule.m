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

#pragma mark -
#pragma mark User
-(id)currentUser {
    ParseSingleton *ps = [ParseSingleton sharedParseSingleton];
    
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

-(void)setExampleProp:(id)value
{
	// example property setter
}

@end
