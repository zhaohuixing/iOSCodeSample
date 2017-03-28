//
//  AlertViewController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-04-06.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import "AlertViewController.h"


@interface AlertViewController()

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *m_AlertMesaage;

@end


@implementation AlertViewController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    if(context != nil && [context isKindOfClass:[NSString class]] == YES)
    {
        [self.m_AlertMesaage setText:(NSString *)context];
    }
        
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



