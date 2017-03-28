//
//  INOMSocialServiceInterface.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INOMSocialAccountManagerDelegate <NSObject>

@optional


@end

@protocol INOMTwitterPostTaskDelegate <NSObject>

-(void)PostTaskDone:(id)task result:(BOOL)succed;

@end

@protocol INOMTwitterSearchTaskDelegate <NSObject>

-(void)SearchTaskDone:(id)task result:(BOOL)succed;

@end

@protocol INOMSoicalSearchDelegate <NSObject>

-(void)HandleSearchResult:(id)record;
-(void)HandleSoicalSearchToWatch:(NSArray*)dataArray;

@end

@protocol INOMCachedSoicalNewsContainer <NSObject>

-(id)GetCachedSocialNews:(NSString*)newsID;

@end