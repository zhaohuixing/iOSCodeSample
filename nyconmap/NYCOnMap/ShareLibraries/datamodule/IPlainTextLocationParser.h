//
//  IPlainTextLocationParser.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-10-26.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#ifndef __IPLAINTEXTLOCATIONPARSER_H__
#define __IPLAINTEXTLOCATIONPARSER_H__

@protocol IPlainTextLocationParser <NSObject>

-(void)ParseLocationFromText:(NSString*)text;
-(NSArray*)GetLocationList;

@end


#endif
