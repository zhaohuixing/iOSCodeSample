//
//  NOMPostLocationSelector.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPostLocationSelector.h"
#import "StringFactory.h"

@interface NOMPostLocationSelector ()
{
    id<NOMPostLocationSelectorDelegate>         m_Delegate;
}

@end

@implementation NOMPostLocationSelector

-(id)initWithDelegate:(id<NOMPostLocationSelectorDelegate>)delegate
{
    self = [super init];
    if(self != nil)
    {
        m_Delegate = delegate;
    }
    return self;
}

-(void)ShowThreeLocationsOptionSelector
{
    UIAlertView* threeOptionSelector = [[UIAlertView alloc] initWithTitle:[StringFactory GetString_LocationForPosting]
                                                                  message:nil
                                                                 delegate:self
                                                        cancelButtonTitle:[StringFactory GetString_Cancel]
                                                        otherButtonTitles:[StringFactory GetString_CurrentLocation], [StringFactory GetString_PinOnMap], [StringFactory GetString_InputLocationAddress],                                  nil];
    [threeOptionSelector show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate HandlePostLocationSelectorCancelButtonClicked];
        }
    }
    else if(buttonIndex == 1)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate HandlePostLocationSelectorCurrentLocationSelected];
        }
    }
    else if(buttonIndex == 2)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate HandlePostLocationSelectorPinOnMapSelected];
        }
    }
    else if(buttonIndex == 3)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate HandlePostLocationSelectorInputLocationAddressSelected];
        }
    }
}

@end
