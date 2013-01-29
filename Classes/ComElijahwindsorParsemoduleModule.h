/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiApp.h"
#import "TiModule.h"
#import "ParseSingleton.h"
#import <Accounts/Accounts.h>
#import <Parse/Parse.h>

@interface ComElijahwindsorParsemoduleModule : TiModule 
{
    NSString *lastFbUrl;  // last-known facebook url
    KrollCallback *fbCallback;
}

@end
