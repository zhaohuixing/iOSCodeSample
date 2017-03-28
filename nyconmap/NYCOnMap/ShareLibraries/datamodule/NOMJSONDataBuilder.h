//
//  NOMJSONDataBuilder.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-07.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMJSONDataBuilder : NSObject
{
@private
    NSMutableDictionary*        m_DataSet;
}

-(void)Add:(NSString*)szKey withObject:(id)object;
-(NSData*)CreateJSONData;
-(NSString*)GetJSONString;

@end
