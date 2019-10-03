//
//  Packet.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Packet : NSObject
{
    int         m_Chips;
}

-(void)Initialize:(int)nTotal;
-(void)Earn:(int)nChip;
-(BOOL)CanPay:(int)nBill;
-(int)Pay:(int)nBill;
-(int)Balance;

@end
