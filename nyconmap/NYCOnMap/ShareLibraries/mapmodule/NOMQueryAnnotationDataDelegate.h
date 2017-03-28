//
//  NOMQueryAnnotationDataDelegate.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2014-03-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NOMQueryAnnotationDataDelegate <NSObject>

@optional
-(void)QueryAnnontationDataChanged:(id)data;

@end
