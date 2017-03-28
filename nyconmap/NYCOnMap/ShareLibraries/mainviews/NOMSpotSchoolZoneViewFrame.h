//
//  NOMSpotSchoolZoneViewFrame.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMSpotSchoolZoneViewFrame : UIScrollView<UIScrollViewDelegate>

-(void)UpdateLayout;
-(void)ScrollViewTo:(float)scrollOffsetY;
-(void)RestoreScrollViewDefaultPosition;


-(void)Reset;
-(void)SetAddress:(NSString*)address;
-(void)SetName:(NSString*)name;

-(NSString*)GetAddress;
-(NSString*)GetName;
 
@end
