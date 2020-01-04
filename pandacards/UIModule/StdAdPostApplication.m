//
//  StdAdPostApplication.m
//  XXXXXXXX
//
//  Created by Zhaohui Xing on 11-10-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StdAdPostApplication.h"
#import "StdAdPostAppDelegate.h"
#import "ApplicationConfigure.h"

@implementation StdAdPostApplication

/*- (id)init
{
    self = [super init];
    if(self)
    {
        [self setStatusBarHidden:YES];
    }
    return self;
}*/

- (BOOL)openURL:(NSURL*)url
{
    NSString* sScheme = [url scheme];
    //???????????????????????????
    NSLog(@"openURL sScheme:%@", sScheme);
    NSString* str = [url absoluteString];
    NSLog(@"openURL absolute string:%@", str);
    if([sScheme rangeOfString:@"fbauth"].location != NSNotFound || [sScheme isEqualToString:@"fbauth2"] || [str rangeOfString:@"facebook.com"].location != NSNotFound ||  [str rangeOfString:@"facebook"].location != NSNotFound ||[str rangeOfString:@"fb"].location != NSNotFound || [sScheme rangeOfString:@"fb"].location != NSNotFound || [sScheme rangeOfString:@"facebook"].location != NSNotFound)
        return [super openURL:url];
    
    //?????????????????????????????
    //if([sScheme isEqualToString:@"http"] || [sScheme isEqualToString:@"https"] || [sScheme isEqualToString:@"http://"] || [sScheme isEqualToString:@"https://"])
    if([ApplicationConfigure CanLaunchHouseAd] == NO)
    {
        if([self.delegate isKindOfClass:[StdAdPostAppDelegate class]] == YES)
        {
            [self.delegate performSelector:@selector(HandleAdRequest:) withObject:url];
        }
        //????
        NSLog(@"Block Http");
        return YES;
    }
    else
    {
        [ApplicationConfigure DisableLaunchHouseAd];
    }
    return [super openURL:url];
}

@end
