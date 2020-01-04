//
//  ShuffleSuite.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexObject : NSObject 
{
    int         m_nIndex;
}

-(id)InitWithIndex:(int)nIndex;
-(int)GetIndex;

@end


@interface ShuffleSuite : NSObject 
{
    NSMutableArray*     m_IndexList;
    NSMutableArray*     m_TempList;
    int                 m_nCount;
}

-(id)initWithBase:(int)nCount;
-(int)GetValue:(int)nIndex;

@end
