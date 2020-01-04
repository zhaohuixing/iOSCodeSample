//
//  LocationView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomGlossyButton.h"
#import "MapFrameView.h"

@interface LocationView : UIView<CustomGlossyButtonDelegate> 
{
    MapFrameView*           m_MapView;

    CustomGlossyButton*     m_btnShowMe;
    CustomGlossyButton*     m_btnShowAll;
    CustomGlossyButton*     m_btnMapStardard;
    CustomGlossyButton*     m_btnMapSatellite;
    CustomGlossyButton*     m_btnMapHybird;
    
    int                     m_nIndexOfMe;
}

-(void)OpenView;
-(void)CloseView;
-(void)UpdateViewLayout;
-(void)AddMapAnnotation:(UIImage*)icon withTitle:(NSString*)title withText:(NSString*)text withLatitude:(float)fLatitude withLongitude:(float)fLongitude isMaster:(BOOL)bMaster isMe:(BOOL)bMe;
-(void)ResetMap;
-(int)GetMapLocations;

-(void)HideMeAndAllButtons;
-(void)ShowAll;
-(void)ShowMe;

@end
