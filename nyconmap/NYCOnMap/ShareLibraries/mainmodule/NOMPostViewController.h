//
//  NOMPostViewController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-17.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "IPostViewController.h"
#import "NOMDocumentController.h"

@interface NOMPostViewController : NSObject<IPostViewController>

-(void)RegisterParent:(NOMDocumentController*)controller;
-(void)InitializePostView:(UIView*)pMainView;
-(void)UpdatePostViewLayout;
-(void)CreatePostingNewsDetail:(int16_t)nNewsCategory withSubCategory:(int16_t)nNewsSubCategory withThirdCategory:(int16_t)nNewsThirdCategory;
-(void)SetPostingViewReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span;

@end
