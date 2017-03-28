//
//  NOMPostPreActionSelector.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-06.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPostPreActionSelector.h"
#import "StringFactory.h"

@interface NOMPostPreActionSelector ()
{
    id<NOMPostPreActionSelectorDelegate>         m_Delegate;
}

@end

@implementation NOMPostPreActionSelector

-(id)initWithDelegate:(id<NOMPostPreActionSelectorDelegate>)delegate
{
    self = [super init];
    if(self != nil)
    {
        m_Delegate = delegate;
    }
    return self;
}

-(void)ShowTwoPostPreActionOptionSelector
{
    UIAlertView* twoOptionSelector = [[UIAlertView alloc] initWithTitle:[StringFactory GetString_WhatIsNext]
                                                                  message:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil //[StringFactory GetString_Cancel]
                                                        otherButtonTitles:[StringFactory GetString_PostNow], [StringFactory GetString_AddDetail], nil];
    [twoOptionSelector show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate HandlePostNowSelected];
        }
    }
    else if(buttonIndex == 1)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate HandleAddPostDetailSelected];
        }
    }
}

@end
