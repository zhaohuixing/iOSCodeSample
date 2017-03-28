//
//  NOMSocialPostManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-21.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSocialPostManager.h"
#import "NOMTwitterPostManager.h"

@interface NOMSocialPostManager ()
{
    NOMTwitterPostManager*      m_TwitterPostManager;
}

@end

@implementation NOMSocialPostManager

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_TwitterPostManager = [[NOMTwitterPostManager alloc] init];
    }
    
    return self;
}

-(void)StartTwitterSharing:(NOMNewsMetaDataRecord*)pNewsMetaData withPost:(NSString*)szPost withImage:(UIImage*)pImage toAccount:(ACAccount*)pAccount
{
    [m_TwitterPostManager StartSharing:pNewsMetaData withPost:szPost withImage:pImage toAccount:pAccount];
}

-(void)StartSpotTwitterSharing:(NOMTrafficSpotRecord*)pSpot toAccount:(ACAccount*)pAccount
{
    [m_TwitterPostManager StartSpotTwitterSharing:pSpot toAccount:pAccount];
}

@end
