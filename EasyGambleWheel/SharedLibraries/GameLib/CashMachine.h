//
//  CashMachine.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
@import UIKit;

@interface CashMachine : NSObject
{
@private
    CGImageRef                  m_ImageNumber;
}

-(void)SetMyCurrentMoney:(int)nChips;
-(void)Draw:(CGContextRef)context at:(CGRect)rect;
@end
