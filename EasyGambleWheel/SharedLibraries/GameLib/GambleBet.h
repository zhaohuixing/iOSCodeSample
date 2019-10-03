//
//  GambleBet.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GambleBet : NSObject 
{
    int            m_nBet;
}

-(id)initWithBet:(int)nBet;
-(void)SetBet:(int)nBet;
-(int)GetBet;

@end
