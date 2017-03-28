//
//  NOMWatchMapAnnotation.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-04-03.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMWatchMapAnnotation : NSObject


@property (nonatomic)NSString*                      m_AnnotationID;
@property (nonatomic)double                         m_Latitude;
@property (nonatomic)double                         m_Longitude;
@property (nonatomic)int16_t                        m_AnnotationType;

@end
