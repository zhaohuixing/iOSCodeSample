//
//  InAppPurchaseSelectionView.h
//  XXXXXXXXX
//
//  Created by Zhaohui Xing on 12-11-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "FrameListView.h"
#import "CustomGlossyButton.h"

@class ApplicationMainView;

@interface InAppPurchaseSelectionView: FrameListView<CustomGlossyButtonDelegate>
{
@private
    CustomGlossyButton*         m_btnOK;
    CustomGlossyButton*         m_btnCancel;
    
    ApplicationMainView*         m_Parent;
    int                         m_nSelectedItem;
}

-(void)SetParent:(ApplicationMainView*)parent;
@end
