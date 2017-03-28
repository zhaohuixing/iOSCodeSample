//
//  NOMPostPreActionSelector.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-06.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NOMPostPreActionSelectorDelegate <NSObject>

@optional

//-(void)HandlePostPreActionSelectorCancelButtonClicked;
-(void)HandlePostNowSelected;
-(void)HandleAddPostDetailSelected;

@end

@interface NOMPostPreActionSelector : NSObject<UIAlertViewDelegate>

-(id)initWithDelegate:(id<NOMPostPreActionSelectorDelegate>)delegate;
-(void)ShowTwoPostPreActionOptionSelector;

@end
