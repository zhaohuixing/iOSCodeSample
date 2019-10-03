//
//  Packet.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Packet.h"

@implementation Packet

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        m_Chips = 0;
    }
    
    return self;
}


-(void)Initialize:(int)nTotal
{
    m_Chips = nTotal;
}

-(void)Earn:(int)nChip
{
    m_Chips += nChip;
}

-(BOOL)CanPay:(int)nBill
{
    BOOL bRet = YES;
    if(m_Chips < nBill)
    {
        bRet = NO;
    }
    return bRet;
}

-(int)Pay:(int)nBill
{
    int nPayment = nBill; 
    if(m_Chips < nBill)
    {
        nPayment = m_Chips;
        m_Chips = 0;
    }
    else
    {
        m_Chips -= nBill;
    }
    return nPayment;
}

-(int)Balance
{
    return m_Chips;
}


@end
