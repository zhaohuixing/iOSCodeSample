//
//  NOMSpotSchoolZoneContentView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSpotSchoolZoneContentView.h"
#import "CDropdownListBox.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"


@interface NOMSpotSchoolZoneContentView ()
{
    UILabel*                                    m_NameLabel;
    UITextField*                                m_NameEditor;
    
    UILabel*                                    m_AddressLabel;
    UITextField*                                m_AddressEditor;
    
    NSString*                                   m_Address;
    NSString*                                   m_Name;
}

-(void)HideKeyboard;

@end

@implementation NOMSpotSchoolZoneContentView

#define DEFAULT_SCHOOLZONEUI_WIDTH_IPHONE         300
#define DEFAULT_SCHOOLZONEUI_WIDTH_IPAD           500

+(float)GetDefaultEdge
{
    if([NOMAppInfo IsDeviceIPad])
        return 20;
    else
        return 10;
}

+(float)GetElemntWidth
{
    if([NOMAppInfo IsDeviceIPad] == YES)
        return DEFAULT_SCHOOLZONEUI_WIDTH_IPAD;
    else
        return DEFAULT_SCHOOLZONEUI_WIDTH_IPHONE;
}

+(float)GetElemntHeight
{
    return [NOMGUILayout GetDefaultTextEditorButtonHeight];
}

-(float)GetContentViewHeight
{
    float bRet = 0.0;
    
    float edge = [NOMSpotSchoolZoneContentView GetDefaultEdge];
    float h = [NOMSpotSchoolZoneContentView GetElemntHeight];
    
    bRet = h*3 + edge*3;
    
    return bRet;
}

#define DEFAULT_SCHOOLZONEUI_ITEMLABEL_WIDTH_IPHONE         80
#define DEFAULT_SCHOOLZONEUI_ITEMLABEL_WIDTH_IPAD           120
+(float)GetDefaultItemLabelWidth
{
    if([NOMAppInfo IsDeviceIPad])
    {
        return DEFAULT_SCHOOLZONEUI_ITEMLABEL_WIDTH_IPAD;
    }
    else
    {
        return DEFAULT_SCHOOLZONEUI_ITEMLABEL_WIDTH_IPHONE;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([NOMAppInfo IsDeviceIPad])
    {
        return;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self HideKeyboard];
    if([NOMAppInfo IsDeviceIPad])
    {
        return;
    }
}


-(void)InitializeUIElements
{
    float w = [NOMSpotSchoolZoneContentView GetElemntWidth];
    float xedge = (self.frame.size.width - w)*0.5;
    float yedge = [NOMSpotSchoolZoneContentView GetDefaultEdge];
    
    
    float sx = xedge;
    float sy = yedge;
    float textHeight = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    
    CGRect rect;// = CGRectMake(sx, sy, w, textHeight);
   
    w = [NOMSpotSchoolZoneContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
   
    m_NameLabel = [[UILabel alloc] initWithFrame:rect];
    m_NameLabel.backgroundColor = [UIColor clearColor];
    [m_NameLabel setTextColor:[UIColor blackColor]];
    m_NameLabel.highlightedTextColor = [UIColor grayColor];
    [m_NameLabel setTextAlignment:NSTextAlignmentRight];
    m_NameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_NameLabel.adjustsFontSizeToFitWidth = YES;
    m_NameLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [m_NameLabel setText:[StringFactory GetString_Name]];
    [self addSubview:m_NameLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_NameEditor = [[UITextField alloc] initWithFrame:rect];
    m_NameEditor.borderStyle = UITextBorderStyleRoundedRect;
    m_NameEditor.textColor = [UIColor blackColor];
    m_NameEditor.font = [UIFont systemFontOfSize:textHeight*0.6];
    m_NameEditor.placeholder = @"<Name>";
    m_NameEditor.backgroundColor = [UIColor whiteColor];
    m_NameEditor.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_NameEditor.keyboardType = UIKeyboardTypeEmailAddress;
    m_NameEditor.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_NameEditor.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_NameEditor.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_NameEditor.delegate = self;
    [self addSubview:m_NameEditor];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotSchoolZoneContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_AddressLabel = [[UILabel alloc] initWithFrame:rect];
    m_AddressLabel.backgroundColor = [UIColor clearColor];
    [m_AddressLabel setTextColor:[UIColor blackColor]];
    m_AddressLabel.highlightedTextColor = [UIColor grayColor];
    [m_AddressLabel setTextAlignment:NSTextAlignmentRight];
    m_AddressLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_AddressLabel.adjustsFontSizeToFitWidth = YES;
    m_AddressLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [m_AddressLabel setText:[StringFactory GetString_Address]];
    [self addSubview:m_AddressLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_AddressEditor = [[UITextField alloc] initWithFrame:rect];
    m_AddressEditor.borderStyle = UITextBorderStyleRoundedRect;
    m_AddressEditor.textColor = [UIColor blackColor];
    m_AddressEditor.font = [UIFont systemFontOfSize:textHeight*0.6];
    m_AddressEditor.placeholder = @"<Address>";
    m_AddressEditor.backgroundColor = [UIColor whiteColor];
    m_AddressEditor.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_AddressEditor.keyboardType = UIKeyboardTypeEmailAddress;
    m_AddressEditor.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_AddressEditor.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_AddressEditor.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_AddressEditor.delegate = self;
    [self addSubview:m_AddressEditor];
}


-(void)InitializeControls
{
    [self InitializeUIElements];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self InitializeControls];
        
        m_Address = nil;
        m_Name = nil;
    }
    return self;
}

-(void)CloseDropdownList
{
    [self HideKeyboard];
}

-(void)HideKeyboard
{
    if(m_NameEditor != nil)
        [m_NameEditor resignFirstResponder];
    if(m_AddressEditor != nil)
        [m_AddressEditor resignFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self CloseDropdownList];
    [super touchesEnded:touches withEvent:event];
}

-(void)UpdateLayout
{
    [self CloseDropdownList];
    
    float w = [NOMSpotSchoolZoneContentView GetElemntWidth];
    float xedge = (self.frame.size.width - w)*0.5;
    float yedge = [NOMSpotSchoolZoneContentView GetDefaultEdge];
    
    
    float sx = xedge;
    float sy = yedge;
    float textHeight = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    
    CGRect rect;// = CGRectMake(sx, sy, w, textHeight);
    
    w = [NOMSpotSchoolZoneContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    
    [m_NameLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_NameEditor setFrame:rect];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotSchoolZoneContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_AddressLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_AddressEditor setFrame:rect];
}


-(void)Reset
{
    m_Address = nil;
    m_Name = nil;
    
    [m_NameEditor setText:@""];
    [m_AddressEditor setText:@""];
}

-(void)SetAddress:(NSString*)address
{
    if(m_Address != nil && 0 < m_Address.length)
    {
        m_Address = nil;
    }
    if(address != nil && 0 < address.length)
    {
        m_Address = [address copy];
        [m_AddressEditor setText:m_Address];
    }
    else
    {
        [m_AddressEditor setText:@""];
    }
}

-(void)SetName:(NSString*)name
{
    if(m_Name != nil && 0 < m_Name.length)
    {
        m_Name = nil;
    }
    if(name != nil && 0 < name.length)
    {
        m_Name = [name copy];
        [m_NameEditor setText:m_Name];
    }
    else
    {
        [m_NameEditor setText:@""];
    }
}

-(NSString*)GetAddress
{
    m_Address = m_AddressEditor.text;
    return m_Address;
}

-(NSString*)GetName
{
    m_Name = m_NameEditor.text;
    return m_Name;
}

@end
