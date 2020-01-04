//
//  GridCell.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-10.
//  Copyright 2011 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GridCell : NSObject 
{
    CGPoint         m_Center;
}

@property (nonatomic, readonly) CGPoint _m_Center;

-(id)init;
-(id)initWithX:(float)x withY:(float)y;
-(id)initWithPoint:(CGPoint)pt;
-(void)SetCenter:(CGPoint)pt;
-(void)SetCenter:(float)x withY:(float)y;
@end
