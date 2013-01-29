//
//  ParseSingleton.h
//  parsemodule
//
//  Created by Elijah Windsor on 12/10/12.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseSingleton : NSObject

typedef void (^CallbackBlock)(id object, NSError *error);
typedef void (^CallbackBlockWithExtra)(id extra, id object, NSError *error);

+(ParseSingleton *)sharedParseSingleton;
-(void)setApplicationId:(NSString *)appId clientKey:(NSString *)clientKey;

// PFObject
-(void)createObjectWithClassName:(NSString *)className andProperties:(NSDictionary *)properties andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock;
-(void)fetchObjectOfClassName:(NSString *)className andObjectId:(NSString *)objectId andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock;
-(void)findObjectsOfClassName:(NSString *)className withCriteria:(NSArray *)criteria andCallback:(void(^)(NSArray *, NSError *))callbackBlock;
-(void)updateObjectWithClassName:(NSString *)className andObjectId:(NSString *)objectId andProperties:(NSDictionary *)properties andCallback:(void(^)(BOOL, NSError *))callbackBlock;
-(void)updateObject:(NSDictionary *)object withCallback:(void(^)(BOOL, NSError *))callbackBlock;
-(void)deleteObjectWithClassName:(NSString *)className andObjectId:(NSString *)objectId andCallback:(void(^)(BOOL, NSError *))callbackBlock;
-(void)deleteObject:(NSDictionary *)object withCallback:(void(^)(BOOL, NSError *))callbackBlock;

// PFFile
-(void)createFileWithName:(NSString *)name andData:(NSData *)data andAttachmentInfo:(NSDictionary *)attachmentInfo withCallback:(void(^)(NSDictionary *, NSError *))callbackBlock;

// PFUser
-(void)signupUserWithUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock;
-(void)signupUserWithUsername:(NSString *)username andPassword:(NSString *)password andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock;
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andCallback:(void(^)(NSDictionary *, NSError *))callbackBlock;
-(NSDictionary *)currentUser;
-(void)refreshCurrentUser;
-(void)logout;

// PFCloud
-(void)callCloudFunction:(NSString *)functionName withParameters:(NSDictionary *)parameters andCallback:(void(^)(id object, NSError *error))callbackBlock;

// PFFacebookUtils
-(void)setupFacebookWithAppId:(NSString *)appId;
-(void)facebookLoginWithPermissions:(NSArray *)permissions andCallback:(CallbackBlock)callbackBlock;
-(void)doFbRequestWithPath:(NSString *)path andCallback:(CallbackBlock)callbackBlock;
-(void)handleOpenURL:(NSURL *)url;
-(NSString *)getFbAccessToken;
-(void)showFacebookDialog:(NSString *)dialog withParams:(NSDictionary *)params;

// PFTwitterUtils
-(void)setupTwitterWithConsumerKey:(NSString *)consumerKey andConsumerSecret:(NSString *)consumerSecret;
-(void)twitterLoginWithCallback:(CallbackBlock)callbackBlock;
-(void)twitterApiWithUrlString:(NSString *)urlString andMethod:(NSString *)method andData:(NSDictionary *)data withCallback:(CallbackBlockWithExtra)callbackBlock;

@end
