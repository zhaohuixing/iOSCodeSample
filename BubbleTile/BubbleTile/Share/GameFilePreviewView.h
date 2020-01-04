//
//  GameFilePreviewView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FrameListView.h"
#import "BTFile.h"
#import "LocationView.h"
#import "DualTextCell.h"
#import "CustomGlossyButton.h"

@interface GameFilePreviewView : FrameListView<CustomGlossyButtonDelegate> 
{
    LocationView*           m_MapView;
    BTFile*                 m_OpenFile;
    CustomGlossyButton*     m_btnShare;
}

-(void)OpenFile:(NSURL*)file;

@end
