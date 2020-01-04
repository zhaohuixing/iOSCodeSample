//
//  GameFileListView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "FrameListView.h"
#import "CustomGlossyButton.h"
#import "BTFile.h"
#import "LocationView.h"
#import "GameFilePreviewView.h"

@interface GameFileListView : FrameListView<CustomGlossyButtonDelegate>
{
    CustomGlossyButton*     m_btnOK;
    CustomGlossyButton*     m_btnCancel;
    GameFilePreviewView*    m_GamePreviewView;
    
    NSArray*                m_FileList;
    int                     m_nSelectedIndex;
    BOOL                    m_bCloseForPurchase;
    
    BOOL                    m_bGameShareMode;
}

-(NSURL*)GetSelectedFile;
-(void)SetGameShareMode:(BOOL)bShare;
@end
