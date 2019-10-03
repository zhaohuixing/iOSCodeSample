//
//  GambleBet.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GambleBet.h"


@implementation GambleBet


-(id)initWithBet:(int)nBet
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        m_nBet = nBet;
    }
    
    return self;
}

-(void)SetBet:(int)nBet
{
    m_nBet = nBet;
}

-(int)GetBet
{
    return m_nBet;
}

@end
