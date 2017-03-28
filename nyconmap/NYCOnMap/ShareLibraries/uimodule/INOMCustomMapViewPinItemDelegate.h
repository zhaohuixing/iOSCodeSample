//
//  INOMCustomMapViewPinItemDelegate.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INOMCustomMapViewPinItemDelegate <NSObject>

-(void)OpenNews:(NSString*)newsID with:(BOOL)bCanReport;
-(void)OpenCalenderSupportedNews:(NSString*)newsID with:(BOOL)bCanReport withAddress:(NSString*)address;
-(void)OpenTwitterTweet:(NSString*)newsID;

@end
