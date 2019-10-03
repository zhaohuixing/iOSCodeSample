//
//  ClockObject.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-23.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClockObject : NSObject 
{
	float			m_fRadius;
	//CGImageRef		m_Image;
	int				m_nTimerStep;
	int				m_nGameTimeLength;
	CGImageRef		m_Label;
	NSString*		m_szLabel;

}

-(void)loadLabel;
-(void)reset;
-(BOOL)onTimerEvent;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;

@end
