//
//  GameFileSaveView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FrameListView.h"
#import "CustomGlossyButton.h"
#import "BTFile.h"
#import "LocationView.h"
#import "SwitchIconCell.h"
#import "DualTextCell.h"
#import "SimpleTextEditor.h"

@interface GameFileSaveView : FrameListView<CustomGlossyButtonDelegate> 
{
    CustomGlossyButton*     m_btnOK;
    CustomGlossyButton*     m_btnCancel;
    CustomGlossyButton*     m_btnShare;

    BOOL                    m_bNewGame;
    
    LocationView*           m_MapView;
    NSTimer*                m_Timer;
    SwitchIconCell*         m_UserLocationUI;

    SimpleTextEditor*       m_TextEditor;
    DualTextCell*           m_ActiveEditingCell;
}

-(void)HandleGameData;
-(void)OnTextEditingDone;

@end
