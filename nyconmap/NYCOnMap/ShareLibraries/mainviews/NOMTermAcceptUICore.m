//
//  NOMTermAcceptUICore.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMTermAcceptUICore.h"
#import "NOMAppInfo.h"
#import "StringFactory.h"
#import "NOMAppInfo.h"
#import "NOMTimeHelper.h"
#import "NOMGUILayout.h"
#import "NOMTermAcceptView.h"

@interface NOMTermAcceptUICore ()
{
    UITextView*                 m_ContentView;
    
    NSString*                   m_TermOfUseContents;
    NSString*                   m_PrivacyContents;
}

@end

@implementation NOMTermAcceptUICore

+(float)GetDefaultEdge
{
    if([NOMAppInfo IsDeviceIPad])
        return 25;
    else
        return 15;
}

-(void)InitializeSubViews
{
    float size = [NOMTermAcceptUICore GetDefaultEdge];
    
    float sx = size;
    float sy = size;

    float h = self.frame.size.height - 2*size;
    float w = self.frame.size.width - 2*size;
    CGRect rect = CGRectMake(sx, sy, w, h);
    m_ContentView = [[UITextView alloc] initWithFrame:rect];
    [m_ContentView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [m_ContentView setEditable:NO];
    m_ContentView.scrollEnabled = YES;
    m_ContentView.backgroundColor = [UIColor whiteColor];
    m_ContentView.font = [UIFont systemFontOfSize:16];
    [self addSubview:m_ContentView];
    
}


-(void)InitializeContent
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"termofuser" ofType:@"txt"];
    NSError *err = nil;
    m_TermOfUseContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    if (m_TermOfUseContents == nil)
    {
        NSLog(@"Error reading %@: %@", filePath, err);
        m_TermOfUseContents = @"";
    }
   
    filePath = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"txt"];
    err = nil;
    m_PrivacyContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    if (m_PrivacyContents == nil)
    {
        NSLog(@"Error reading %@: %@", filePath, err);
        m_PrivacyContents = @"";
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self InitializeSubViews];
        [self InitializeContent];
    }
    return self;
}

-(void)UpdateLayout
{
    float size = [NOMTermAcceptUICore GetDefaultEdge];
    
    float sx = size;
    float sy = size;
    
    float h = self.frame.size.height - 2*size;
    float w = self.frame.size.width - 2*size;
    CGRect rect = CGRectMake(sx, sy, w, h);
    [m_ContentView setFrame:rect];
}

-(void)OpenPrivacyView
{
    [m_ContentView setText:m_PrivacyContents];
}

-(void)OpenTermOfUseView
{
    [m_ContentView setText:m_TermOfUseContents];
}


@end
