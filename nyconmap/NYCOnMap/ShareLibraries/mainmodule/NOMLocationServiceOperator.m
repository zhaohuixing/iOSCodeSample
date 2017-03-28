//
//  NOMLocationServiceOperator.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMLocationServiceOperator.h"
#import "StringFactory.h"
#import "NOMAppInfo.h"

@interface NOMLocationServiceOperator ()
{
    id<NOMLocationServiceOperatorDelegate>          m_Delegate;
}

@end


@implementation NOMLocationServiceOperator

-(id)initWithDelegate:(id<NOMLocationServiceOperatorDelegate>)delegate
{
    self = [super init];
    
    if(self != nil)
    {
        m_Delegate = delegate;
    }
    
    return self;
}

-(void)ShowLocationServiceIndicator
{
    if([NOMAppInfo IsVersion8] == YES)
    {
        UIAlertView* locationSelector = [[UIAlertView alloc] initWithTitle:nil
                                                                  message:[StringFactory GetString_LocationServiceRequired]
                                                                 delegate:self
                                                        cancelButtonTitle:[StringFactory GetString_Cancel]
                                                        otherButtonTitles:[StringFactory GetString_Enable], nil];
        [locationSelector show];
    }
    else
    {
        UIAlertView* locationSelector = [[UIAlertView alloc] initWithTitle:nil
                                                                   message:[StringFactory GetString_LocationServiceRequired]
                                                                  delegate:self
                                                         cancelButtonTitle:[StringFactory GetString_Close]
                                                         otherButtonTitles:nil];
        [locationSelector show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([NOMAppInfo IsVersion8] == YES)
    {
        if(buttonIndex == 1)
        {
            if(m_Delegate != nil)
            {
                [m_Delegate EnableLocationService];
            }
        }
    }
}

@end
