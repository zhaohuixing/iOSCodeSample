//
//  NOMReadViewController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMDocumentController.h"
#import "INOMCustomMapViewPinItemDelegate.h"

@interface NOMReadViewController : NSObject<INOMCustomMapViewPinItemDelegate>

-(void)RegisterParent:(NOMDocumentController*)controller;
-(void)InitializeReadView:(UIView*)pMainView;
-(void)UpdateReadViewLayout;

//
//INOMCustomMapViewPinItemDelegate methods
//
-(void)OpenNews:(NSString*)newsID with:(BOOL)bCanReport;
-(void)OpenCalenderSupportedNews:(NSString*)newsID with:(BOOL)bCanReport withAddress:(NSString*)address;
-(void)OpenTwitterTweet:(NSString*)newsID;

@end
