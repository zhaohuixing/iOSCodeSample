//
//  OptionItemTableRowController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-03-30.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import "OptionItemTableRowController.h"

@interface OptionItemTableRowController ()

//@property (weak, nonatomic) IBOutlet WKInterfaceLabel *m_OptionLabel; weak point lead setText call crash /access violation probabaly
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *m_OptionLabel;

@end


@implementation OptionItemTableRowController

-(void)SetOptionLabel:(NSString*)text
{
    [self.m_OptionLabel setText:text];
}

@end
