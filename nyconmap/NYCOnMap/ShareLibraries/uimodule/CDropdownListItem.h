//
//  CDropdownListItem.h
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDropdownListDelegate.h"

@interface CDropdownListItem : UIView
{
@private
    BOOL                                m_bSelected;
    BOOL                                m_bSelectable;

    UILabel*                            m_Title;
    
    CGImageRef                          m_Icon;
    BOOL                                m_bCenter;
    
    CGGradientRef                       m_Gradient;
    CGColorSpaceRef                     m_Colorspace;

    int                                 m_nItemID;
    
    id<IDropdownListDelegate>           m_Delegate;
}

-(void)RegisterDelegate:(id<IDropdownListDelegate>)delegate;
-(void)SetSelectState:(BOOL)bSelected;
-(BOOL)IsSelected;
-(void)ResetSelectState;
-(BOOL)IsSelectable;
-(void)SetSelectable:(BOOL)bSelectable;
-(void)SetLabel:(NSString*)text;
-(void)SetItemID:(int)nItemID;
-(int)GetItemID;
-(void)SetText:(NSString*)text;
-(NSString*)GetText;

@end
