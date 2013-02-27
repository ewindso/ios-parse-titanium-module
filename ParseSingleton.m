//
//  ParseSingleton.m
//  parsemodule
//
//  Created by Elijah Windsor on 12/10/12.
//
//

#import "ParseSingleton.h"

@implementation ParseSingleton

@synthesize facebook;
@synthesize fbDialogCallback;

static ParseSingleton *sharedSingleton;

+(ParseSingleton *)sharedParseSingleton {
    if(!sharedSingleton) {
        sharedSingleton = [[ParseSingleton alloc]init];
    }
    
    return sharedSingleton;
}

-(void)setApplicationId:(NSString *)appId clientKey:(NSString *)clientKey {
    [Parse setApplicationId:appId clientKey:clientKey];
    
    // TEST
/*    PFObject *game = [PFObject objectWithClassName:@"TestGame"];
    [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFObject *move = [PFObject objectWithClassName:@"Move"];
       
        [move saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            PFRelation *relation = [game relationforKey:@"moves"];
            [relation addObject:move];
            
            [game save];
        }];
    }];*/
}


-(void)createObjectWithClassName:(NSString *)className andProperties:(NSDictionary *)properties andCallback:(void(^)(NSDictionary *obj, NSError *))callbackBlock  {
    
    PFObject *obj = [PFObject objectWithClassName:className];

    // check if we need to create PFObjects for some of the properties
    NSMutableDictionary *finalProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    NSArray *keys = [finalProperties allKeys];
    
    for(NSInteger i = 0; i < [keys count]; i++) {
        id obj = [finalProperties objectForKey:[keys objectAtIndex:i]];
        
/*        if([obj isKindOfClass:[NSDictionary class]]) {
            // check if it needs to be a PFObject
            NSString *className = [obj objectForKey:@"_className"];
            NSString *objectId = [obj objectForKey:@"_objectId"];
            
            if(className && objectId) { // let's make it a PFObject
                PFObject *pfObj = [PFObject objectWithoutDataWithClassName:className objectId:objectId];
                
                [finalProperties setValue:pfObj forKey:[keys objectAtIndex:i]];  // assign it
            }
        }*/
        
        [finalProperties setValue:[self convertToPFObjectIfNeededWithObject:obj] forKey:[keys objectAtIndex:i]];
    }
    
    [obj setValuesForKeysWithDictionary:finalProperties];
    
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(succeeded) { // callback with objectId
            callbackBlock([self convertPFObjectToNSDictionary:obj], error);
        } else {
            callbackBlock(nil, error);
        }
    }];
}

-(id)convertToPFObjectIfNeededWithObject:(id)obj {
    if([obj isKindOfClass:[NSDictionary class]]) {
        // check if it needs to be a PFObject
        NSString *className = [obj objectForKey:@"_className"];
        NSString *objectId = [obj objectForKey:@"_objectId"];
        
        if(className && objectId) { // let's make it a PFObject
            PFObject *pfObj = [PFObject objectWithoutDataWithClassName:className objectId:objectId];

            // go through and assign keys
            NSArray *keys = [obj allKeys];
            NSEnumerator *e = [keys objectEnumerator];
            id key;
            
            while (key = [e nextObject]) {
                id curValue = [obj objectForKey:key];
                
                if([key isEqualToString:@"_className"] ||
                   [key isEqualToString:@"_objectId"] ||
                   [key isEqualToString:@"_createdAt"] ||
                   [key isEqualToString:@"_updatedAt"]) {
                    continue;
                }
                
                // ignore ACL as we don't have a format set up to conver to JS yet
                if([curValue isKindOfClass:[NSString class]] ||
                   [curValue isKindOfClass:[NSNumber class]] ||
                   [curValue isKindOfClass:[NSArray class]]) {
                    
                    [pfObj setObject:curValue forKey:key];
                } else if([curValue isKindOfClass:[NSDictionary class]]) {
                    NSString *className = [curValue objectForKey:@"_className"];
                    
                    if(className) { // it's a type of PFObject
                        if([className isEqualToString:@"_File"]) { // ignore PFFiles, as we can't recreate them
                            continue;
                        }
                        [pfObj setObject:[self convertToPFObjectIfNeededWithObject:curValue] forKey:key];
                    } else { // just an NSDictionary
                        [pfObj setObject:curValue forKey:key];
                    }
                }
            }
            return pfObj;
        }
    }
    
    return obj;
}

-(void)fetchObjectOfClassName:(NSString *)className andObjectId:(NSString *)objectId andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock; {
    PFObject *obj = [PFObject objectWithoutDataWithClassName:className objectId:objectId];
    
    [obj fetchIfNeededInBackgroundWithBlock:^(PFObject *pfObject, NSError *error) {
        
        NSDictionary *dic = nil;
        
        if(pfObject) {
            dic = [self convertPFObjectToNSDictionary:pfObject];
        }
        
        callbackBlock(dic, error);
    }];
}

-(void)findObjectsOfClassName:(NSString *)className withCriteria:(NSArray *)criteria andCallback:(void(^)(NSArray *, NSError *))callbackBlock {
    
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    for(NSInteger i = 0; i < [criteria count]; i++) {
        NSDictionary *dic = [criteria objectAtIndex:i];
        
        NSString *key = [dic objectForKey:@"key"];
        NSString *condition = [dic objectForKey:@"condition"];
        
        // if it should be a PFObject, let it be so in query
        id value = [self convertToPFObjectIfNeededWithObject:[dic objectForKey:@"value"]];
        
        if([condition isEqualToString:@"=="]) {
            [query whereKey:key equalTo:value];
        } else if([condition isEqualToString:@">"]) {
            [query whereKey:key greaterThan:value];
        } else if([condition isEqualToString:@">="]) {
            [query whereKey:key greaterThanOrEqualTo:value];
        } else if([condition isEqualToString:@"<"]) {
            [query whereKey:key lessThan:value];
        } else if([condition isEqualToString:@"<="]) {
            [query whereKey:key lessThanOrEqualTo:value];
        } else if([condition isEqualToString:@"!="]) {
            [query whereKey:key notEqualTo:value];
        } else if([condition isEqualToString:@"in"]) {
            [query whereKey:key containedIn:value];
        } else if([condition isEqualToString:@"not in"]) {
            [query whereKey:key notContainedIn:value];
        } else if([condition isEqualToString:@"orderby"] && [value isEqualToString:@"asc"]) {
            [query orderByAscending:key];
        } else if([condition isEqualToString:@"orderby"] && [value isEqualToString:@"desc"]) {
            [query orderByDescending:key];
        }
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // convert PFObjects to NSDictionaries
        NSMutableArray *responseArray = [NSMutableArray arrayWithCapacity:[objects count]];
        
        for(NSInteger i = 0; i < [objects count]; i++) {

            PFObject *curObj = [objects objectAtIndex:i];
            NSDictionary *dic = [self convertPFObjectToNSDictionary:curObj];
            
            [responseArray setObject:dic atIndexedSubscript:i];
        }
        
        callbackBlock(responseArray, error);
    }];
}

-(NSDictionary *)convertPFObjectToNSDictionary:(PFObject *)curObj {
    NSArray *keys = [curObj allKeys];
    NSEnumerator *e = [keys objectEnumerator];
    id object;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    while (object = [e nextObject]) {
        id curValue = [curObj objectForKey:object];
        
        // ignore ACL as we don't have a format set up to conver to JS yet
        if([curValue isKindOfClass:[PFACL class]]) {
            continue;
        }
        
        if([curValue isKindOfClass:[PFFile class]]) {
            PFFile *curFile = curValue;
            
            curValue = [NSDictionary dictionaryWithObjectsAndKeys:curFile.name, @"name", curFile.url, @"url", @"_File", @"_className", nil];
        } else if([curValue isKindOfClass:[PFObject class]]) {
            PFObject *curPFObj = curValue;
            
            NSString *className = [curPFObj className];
            NSString *objectId = [curPFObj objectId];
            
            curValue = [NSDictionary dictionaryWithObjectsAndKeys:className, @"_className", objectId, @"_objectId", nil];
        }
        
        [dict setValue:curValue forKey:object];
    }
    // assign id
    [dict setValue:curObj.objectId forKey:@"_objectId"];
    
    // remember className
    [dict setValue:curObj.className forKey:@"_className"];
    
    // assign createdAt, updatedAt
    [dict setValue:curObj.createdAt forKey:@"_createdAt"];
    [dict setValue:curObj.updatedAt forKey:@"_updatedAt"];
    
    return [dict autorelease];
}


-(NSDictionary *)convertPFFileToNSDictionary:(PFFile *)curFile {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    // assign id
    [dict setValue:curFile.name forKey:@"name"];
    [dict setValue:curFile.url forKey:@"url"];
    
    // remember className
    [dict setValue:@"File" forKey:@"_className"];
    
    return [dict autorelease];
}

-(void)updateObject:(NSDictionary *)object withCallback:(void(^)(BOOL, NSError *))callbackBlock {    
    PFObject *obj = [self convertToPFObjectIfNeededWithObject:object];
    
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];

}

-(void)deleteObjectWithClassName:(NSString *)className andObjectId:(NSString *)objectId andCallback:(void(^)(BOOL, NSError *))callbackBlock {
    
    PFObject *obj = [PFObject objectWithoutDataWithClassName:className objectId:objectId];
    
    [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];
}

-(void)deleteObject:(NSDictionary *)object withCallback:(void(^)(BOOL, NSError *))callbackBlock {
    NSMutableDictionary *newObj = [NSMutableDictionary dictionaryWithDictionary:object];
    
    NSString *className = [newObj objectForKey:@"_className"];
    NSString *objectId = [newObj objectForKey:@"_objectId"];
    
    [newObj removeObjectForKey:@"_className"];
    [newObj removeObjectForKey:@"_objectId"];

    [self deleteObjectWithClassName:className andObjectId:objectId andCallback:callbackBlock];
}

-(void)saveAllObjects:(NSArray *)objects withCallback:(void(^)(BOOL, NSError *))callbackBlock {
    NSMutableArray *objectArray = [[NSMutableArray alloc]init];
    
    for(NSInteger i = 0; i < [objects count]; i++) {
        PFObject *curObject = [self convertToPFObjectIfNeededWithObject:[objects objectAtIndex:i]];
        [objectArray addObject:curObject];
    }
    
    [PFObject saveAllInBackground:objectArray block:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
        
        [objectArray release];
    }];
}

#pragma mark -
#pragma mark PFFile
-(void)createFileWithName:(NSString *)name andData:(NSData *)data andAttachmentInfo:(NSDictionary *)attachmentInfo withCallback:(void(^)(NSDictionary *, NSError *))callbackBlock {
    PFFile *fileObj = [PFFile fileWithName:name data:data];
    
    [fileObj saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(success) {
            // use attachment info to attach to PFObject
            NSDictionary *attachToDic = [attachmentInfo objectForKey:@"object"];
            NSString *attachForKey = [attachmentInfo objectForKey:@"key"];

            PFObject *attachToObj = [PFObject objectWithoutDataWithClassName:[attachToDic objectForKey:@"_className"] objectId:[attachToDic objectForKey:@"_objectId"]];
            [attachToObj setValue:fileObj forKey:attachForKey];
            
            [attachToObj saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                if(success) {
                    callbackBlock([self convertPFObjectToNSDictionary:attachToObj], error);
                } else {
                    callbackBlock(nil, error);
                }
            }];
        } else {
            callbackBlock(nil, error);
        }
    }];
}


#pragma mark -
#pragma mark PFUser
-(void)signupUserWithUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock {
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    
    if(email) {
        user.email = email;
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(success) {
            callbackBlock([self convertPFObjectToNSDictionary:user], error);
        } else {
            callbackBlock(nil, error);
        }
    }];
}
-(void)signupUserWithUsername:(NSString *)username andPassword:(NSString *)password andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock {
    
    [self signupUserWithUsername:username andPassword:password andEmail:nil andCallback:callbackBlock];
}
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock {
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if(user) {
            callbackBlock([self convertPFObjectToNSDictionary:user], error);
        } else {
            callbackBlock(nil, error);
        }
    }];
}
-(void)requestPasswordResetForEmail:(NSString *)email {
    [PFUser requestPasswordResetForEmail:email];
}

-(void)logout {
    [PFUser logOut];
}

-(NSDictionary *)currentUser {
    if([PFUser currentUser] == nil) {
        return nil;
    }
    
    return [self convertPFObjectToNSDictionary:[PFUser currentUser]];
}

-(void)refreshCurrentUser {
    [[PFUser currentUser]refresh];
}

#pragma mark -
#pragma mark PFCloud
-(void)callCloudFunction:(NSString *)functionName withParameters:(NSDictionary *)parameters andCallback:(void(^)(id object, NSError *error))callbackBlock {
    
    //TODO: not yet implemented in Parse SDK!
    // convert JSON to PFObjects if need-be
/*    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray *keys = [finalParameters allKeys];
    
    for(NSInteger i = 0; i < [keys count]; i++) {
        id obj = [finalParameters objectForKey:[keys objectAtIndex:i]];
        
        [finalParameters setValue:[self convertToPFObjectIfNeededWithObject:obj] forKey:[keys objectAtIndex:i]];
    }*/

    [PFCloud callFunctionInBackground:functionName withParameters:parameters block:^(id object, NSError *error) {
        
        if([object isKindOfClass:[PFObject class]]) {
            object = [self convertPFObjectToNSDictionary:object];
        }
        callbackBlock(object, error);
    }];
}

#pragma mark -
#pragma mark PFFacebookUtils
-(void)setupFacebookWithAppId:(NSString *)appId {
    [PFFacebookUtils initializeWithApplicationId:appId];
}

-(void)facebookLoginWithPermissions:(NSArray *)permissions andCallback:(CallbackBlock)callbackBlock {
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {

        if(error) {
            callbackBlock(nil, error);
        } else {
            if (!user) {
                callbackBlock(nil, nil);
                return;
            }
            
            NSDictionary *userDic = [self convertPFObjectToNSDictionary:user];
            
            if(user.isNew) {
                callbackBlock(userDic, nil);
            } else {
                callbackBlock(userDic, nil);
            }
        }
        
    }];
}

-(void)facebookLinkWithUser:(NSDictionary *)user andPermissions:(NSArray *)permissions andCallback:(CallbackBlock)callbackBlock {
    
    PFUser *curUser = [self convertToPFObjectIfNeededWithObject:user];
    
    [PFFacebookUtils linkUser:curUser permissions:permissions block:^(BOOL succeeded, NSError *error) {
        
        if(error) {
            callbackBlock(nil, error);
        } else {
            if (!user) {
                callbackBlock(nil, nil);
                return;
            }
            NSDictionary *userDic = [self convertPFObjectToNSDictionary:[PFUser currentUser]];
            
            callbackBlock(userDic, nil);
        }
    }];
}

-(void)doFbRequestWithPath:(NSString *)path andCallback:(CallbackBlock)callbackBlock {
    NSLog(@"Going to do it");
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:path];
    NSLog(@"About to start with path: %@", path);
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Hey there");
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
            callbackBlock(userData, nil);
        } else {
            callbackBlock(nil, error);
        }
    }];
    NSLog(@"It started");
}

-(void)handleOpenURL:(NSURL *)url {
    [PFFacebookUtils handleOpenURL:url];
}

-(NSString *)getFbAccessToken {
    PF_FBSession *session = [PFFacebookUtils session];

    return session.accessToken;
}

-(void)closeFbSession {
    [[PFFacebookUtils session]closeAndClearTokenInformation];
}

-(void)showFacebookDialog:(NSString *)dialog withParams:(NSDictionary *)params andCallback:(SimpleCallbackBlock)callbackBlock {
    PF_FBSession *session = [PFFacebookUtils session];
    
    facebook = [[PF_Facebook alloc] initWithAppId:session.appID
                                                   andDelegate:nil];
    
    fbDialogCallback = [callbackBlock copy];
    
    // Store the Facebook session information
    facebook.accessToken = session.accessToken;
    facebook.expirationDate = session.expirationDate;
    
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [finalParams setObject:session.appID forKey:@"appid"];
    
    [facebook dialog:dialog andParams:finalParams andDelegate:self];    
}

#pragma mark -
#pragma mark PFTwitterUtils
-(void)setupTwitterWithConsumerKey:(NSString *)consumerKey andConsumerSecret:(NSString *)consumerSecret {
    
    [PFTwitterUtils initializeWithConsumerKey:consumerKey consumerSecret:consumerSecret];
}

-(void)twitterLoginWithCallback:(CallbackBlock)callbackBlock {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if(error) {
            callbackBlock(nil, error);
        } else {
            if (!user) {
                callbackBlock(nil, nil);
                return;
            }
            
            NSDictionary *userDic = [self convertPFObjectToNSDictionary:user];
            
            if(user.isNew) {
                callbackBlock(userDic, nil);
            } else {
                callbackBlock(userDic, nil);
            }
        }
    }];
}

-(void)twitterApiWithUrlString:(NSString *)urlString andMethod:(NSString *)method andData:(NSDictionary *)data withCallback:(CallbackBlockWithExtra)callbackBlock {
    
    if(data && [[method uppercaseString] isEqualToString:@"GET"]) {
        // go through nsdictionary
        NSArray *keys = [data allKeys];
        
        for(NSInteger i = 0; i < [keys count]; i++) {
            NSString *curKey = [keys objectAtIndex:i];
            NSString *curVal = [data objectForKey:curKey];
            
            NSString *appendPrefix = @"&";
            
            if(i == 0) {
                appendPrefix = @"?";
            }
            
            urlString = [NSString stringWithFormat:@"%@%@%@=%@", urlString, appendPrefix, curKey, curVal];
        }
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    
    [[PFTwitterUtils twitter] signRequest:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        NSString *dataString = [NSString stringWithUTF8String:[data bytes]];
        
        callbackBlock(response, dataString, error);
    }];
}

- (void)registerForPushWithDeviceToken:(NSString *)deviceToken andSubscribeToChannel:(NSString *)channel withCallback:(void(^)(BOOL, NSError *))callbackBlock {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation addUniqueObject:channel forKey:@"channels"];
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];
}

- (void)unsubscribeFromPushChannel:(NSString *)channel withCallback:(void(^)(BOOL, NSError *))callbackBlock {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation removeObject:channel forKey:@"channels"];
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];
}

#pragma mark PF_FBDialogDelegate methods
- (void)dialogCompleteWithUrl:(NSURL *)url {
    BOOL completed = YES;

    // Fix for FB-bug where they hit the Cancel button, but it still says "did complete"
    if([url.absoluteString rangeOfString:@"request"].location == NSNotFound) {
        completed = NO;
    }
    
    if(fbDialogCallback) {
        fbDialogCallback(completed);
    }
    [fbDialogCallback release];
    [facebook release];
}

- (void)dialogDidNotComplete:(PF_FBDialog *)dialog {
    if(fbDialogCallback) {
        fbDialogCallback(false);
    }
    [fbDialogCallback release];
    [facebook release];
}

@end
