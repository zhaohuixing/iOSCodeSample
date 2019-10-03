//
//  PlayerBalanceView.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-05.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerBalanceView : UIView
{
@private
    CGImageRef                  m_ImageNumber;
}

-(void)SetMyCurrentMoney:(int)nChips;

@end
