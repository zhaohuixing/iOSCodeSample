//
//  NOMLocationServiceOperator.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NOMLocationServiceOperatorDelegate <NSObject>

@optional

-(void)EnableLocationService;

@end

@interface NOMLocationServiceOperator : NSObject<UIAlertViewDelegate>

-(id)initWithDelegate:(id<NOMLocationServiceOperatorDelegate>)delegate;
-(void)ShowLocationServiceIndicator;

@end
