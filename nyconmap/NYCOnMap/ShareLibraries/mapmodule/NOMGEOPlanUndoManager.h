//
//  NOMGEOPlanUndoManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-03.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMGEOPlanUndoRecord.h"

@interface NOMGEOPlanUndoManager : NSObject

-(NOMGEOPlanUndoRecord*)Popup;
-(void)Push:(NOMGEOPlanUndoRecord*)record;
-(void)Reset;
-(BOOL)CanUndo;

@end
