//
//  GameUtiltyObjects.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@import UIKit;

@interface CPinActionLevel : NSObject
{
    int     m_nFastCycle;
    int     m_nMediumCycle;
    int     m_nSlowCycle;
    int     m_nSlowAngle;
    int     m_nVibCycle;
    BOOL    m_bClockwise;
};

@property (nonatomic)int    m_nFastCycle;
@property (nonatomic)int    m_nMediumCycle;
@property (nonatomic)int    m_nSlowCycle;
@property (nonatomic)int    m_nSlowAngle;
@property (nonatomic)int    m_nVibCycle;
@property (nonatomic)BOOL   m_bClockwise;

-(id)initLevel:(CGPoint)pt1 withPoint2:(CGPoint)pt2 withTime:(float)time;
-(id)initRandomLevel;

@end


@interface CLuckScope : NSObject 
{
@private
	int m_nStartAngle;
	int m_nEndAngle;
}

- (id)initScope:(int)startAngle withEnd:(int)endAngle;
- (BOOL)InScope:(int)angle;
- (int)GetSweepAngle;

@end


@interface GameUitltyHelper : NSObject 
{
}

+(int)GetGameLuckNumberThreshold:(int)nType;
+(int)GetGameBetPledgeThreshold:(int)nType;
+(int)CreateRandomNumber;
+(int)CreateRandomNumberWithSeed:(int)nSeed;
+(int)GetInAppPurchaseChips:(int)index;
+(NSString*)GetInAppPurchaseID:(int)index;
@end