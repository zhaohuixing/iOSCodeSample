//
//  ReviewPrivacyView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-09-07.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGlossyButton.h"

@interface ReviewPrivacyView : UIView<CustomGlossyButtonDelegate>
{
@private
    UITextView*                 m_ContentView;
    
    CustomGlossyButton*         m_CloseButton;
}

-(void)OpenView:(BOOL)bAnimated;
-(void)CloseView:(BOOL)bAnimated;
-(void)OnButtonClick:(int)nButtonID;
-(void)ForceCloseView;
@end
