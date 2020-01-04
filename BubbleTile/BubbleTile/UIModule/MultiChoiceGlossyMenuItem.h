//
//  MultiChoiceGlossyMenuItem.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GlossyMenuItem.h"

@interface MultiChoiceGlossyMenuItem : GlossyMenuItem 
{
	NSMutableArray*					m_NormalImages;
	NSMutableArray*					m_HighLightImages;
	int								m_nActiveChoice;
}

-(id)initWithMeueID:(int)nID withFrame:(CGRect)frame withContainer:(id<MenuHolderTemplate>)p; 
-(void)RegisterMenuImages:(NSString*)image1 withHigLight:(NSString*)image2;
-(void)SetActiveChoice:(int)index;
-(int)GetActiveChoice;

@end
