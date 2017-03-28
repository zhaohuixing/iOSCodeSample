//
//  NOMSpotPhotoRadarContentView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-24.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSpotPhotoRadarContentView.h"
#import "CDropdownListBox.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"

#define PHOTORADARUI_COMBOBOX_ID_CAMERATYPE        1
#define PHOTORADARUI_COMBOBOX_ID_CAMERADIRECTION   2
#define PHOTORADARUI_COMBOBOX_ID_SPEEDCAMERATYPE   3

@interface NOMSpotPhotoRadarContentView ()
{
    CDropdownListBox*                           m_CameraType;
    
    UILabel*                                    m_DirectionLabel;
    CDropdownListBox*                           m_DirectionType;
    
    UILabel*                                    m_FineLabel;
    UITextField*                                m_FineEditor;
    
    UILabel*                                    m_AddressLabel;
    UITextField*                                m_AddressEditor;
    
    UILabel*                                    m_CameraSubTypeLabel;
    CDropdownListBox*                           m_CameraSubType;
    
    int16_t                                     m_nCameraType;
    int16_t                                     m_nDirection;
    int16_t                                     m_nDeviceType;      //For Speed camera type: Fixed camera,
    //or mobile camera/police car/speedtrap
    NSString*                                   m_Address;
    double                                      m_dFine;
    
}

-(void)OnSelectedListItemChange:(CDropdownListBox*)edit;
-(void)CloseDropdownList;
-(void)HideKeyboard;

@end


@implementation NOMSpotPhotoRadarContentView

#define DEFAULT_PHOTORADARUIELEMENTWIDTH_IPHONE         300
#define DEFAULT_PHOTORADARUIELEMENTWIDTH_IPAD           500

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
        return DEFAULT_PHOTORADARUIELEMENTWIDTH_IPAD;
    else
        return DEFAULT_PHOTORADARUIELEMENTWIDTH_IPHONE;
}

+(float)GetElemntHeight
{
    return [NOMGUILayout GetDefaultTextEditorButtonHeight];
}

-(float)GetContentViewHeight
{
    float bRet = 0.0;
    
    float edge = [NOMSpotPhotoRadarContentView GetDefaultEdge];
    float h = [NOMSpotPhotoRadarContentView GetElemntHeight];
    
    bRet = h*8 + edge*9;
    
    return bRet;
}

#define DEFAULT_PHOTORADARUI_ITEMLABEL_WIDTH_IPHONE         80
#define DEFAULT_PHOTORADARUI_ITEMLABEL_WIDTH_IPAD           120
+(float)GetDefaultItemLabelWidth
{
    if([NOMAppInfo IsDeviceIPad])
    {
        return DEFAULT_PHOTORADARUI_ITEMLABEL_WIDTH_IPAD;
    }
    else
    {
        return DEFAULT_PHOTORADARUI_ITEMLABEL_WIDTH_IPHONE;
    }
}

-(void)InitializeCameraTypeDropdownList
{
    CDropdownListBox* pCameraText = [self GetCameraTypeControl];
    if(pCameraText == nil)
        return;
    
    [pCameraText RegisterCtrlID:PHOTORADARUI_COMBOBOX_ID_CAMERATYPE];
    float h = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    CGRect rect = CGRectMake(0, 0, pCameraText.frame.size.width, h);
    CDropdownListContainer* pListBox = [[CDropdownListContainer alloc] initWithFrame:rect];
    [self addSubview:pListBox];
    [pCameraText RegisterDropdownList:pListBox];
    CDropdownListItem* pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA];
    [pItem SetText:[StringFactory GetString_PhotoRadar]];
    [pItem RegisterDelegate:pCameraText];
    [pListBox AddItem:pItem];
    pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_PHOTORADAR_TYPE_SPEEDCAMERA];
    [pItem SetText:[StringFactory GetString_SpeedCamera]];
    [pItem RegisterDelegate:pCameraText];
    [pListBox AddItem:pItem];
    float sx = self.frame.origin.x + pCameraText.frame.origin.x;
    float sy = self.frame.origin.y + pCameraText.frame.origin.y;
    [pCameraText SetOriginInContainer:sx withY:sy];
    [pCameraText SetLabel:[StringFactory GetString_PhotoRadar]];
    [pCameraText SetSelectedItem:NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA];
    [pCameraText UpdateLayout];
}

-(void)InitializeCameraDirectionDropdownList
{
    CDropdownListBox* pDirectText = [self GetCameraDirectionControl];
    
    [pDirectText RegisterCtrlID:PHOTORADARUI_COMBOBOX_ID_CAMERADIRECTION];
    float h = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    CGRect rect = CGRectMake(0, 0, pDirectText.frame.size.width, h);
    CDropdownListContainer* pListBox = [[CDropdownListContainer alloc] initWithFrame:rect];
    [self addSubview:pListBox];
    [pDirectText RegisterDropdownList:pListBox];
    
    CDropdownListItem* pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_PHOTORADAR_DIRECTION_NONE];
    [pItem SetText:[StringFactory GetString_TrafficDirectFullString:NOM_PHOTORADAR_DIRECTION_NONE]];
    [pItem RegisterDelegate:pDirectText];
    [pListBox AddItem:pItem];
    
    pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_PHOTORADAR_DIRECTION_NB];
    [pItem SetText:[StringFactory GetString_TrafficDirectFullString:NOM_PHOTORADAR_DIRECTION_NB]];
    [pItem RegisterDelegate:pDirectText];
    [pListBox AddItem:pItem];
    
    pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_PHOTORADAR_DIRECTION_SB];
    [pItem SetText:[StringFactory GetString_TrafficDirectFullString:NOM_PHOTORADAR_DIRECTION_SB]];
    [pItem RegisterDelegate:pDirectText];
    [pListBox AddItem:pItem];
    
    pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_PHOTORADAR_DIRECTION_EB];
    [pItem SetText:[StringFactory GetString_TrafficDirectFullString:NOM_PHOTORADAR_DIRECTION_EB]];
    [pItem RegisterDelegate:pDirectText];
    [pListBox AddItem:pItem];
    
    pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_PHOTORADAR_DIRECTION_WB];
    [pItem SetText:[StringFactory GetString_TrafficDirectFullString:NOM_PHOTORADAR_DIRECTION_WB]];
    [pItem RegisterDelegate:pDirectText];
    [pListBox AddItem:pItem];
    
    float sx = self.frame.origin.x + pDirectText.frame.origin.x;
    float sy = self.frame.origin.y + pDirectText.frame.origin.y;
    [pDirectText SetOriginInContainer:sx withY:sy];
    [pDirectText SetLabel:[StringFactory GetString_TrafficDirectFullString:NOM_PHOTORADAR_DIRECTION_NONE]];
    [pDirectText SetSelectedItem:NOM_PHOTORADAR_DIRECTION_NONE];
    [pDirectText UpdateLayout];
}

-(void)InitializeCameraSubTypeDropdownList
{
    CDropdownListBox* pTypeText = [self GetCameraSubTypeControl];
    if(pTypeText == nil)
        return;
    
    [pTypeText RegisterCtrlID:PHOTORADARUI_COMBOBOX_ID_SPEEDCAMERATYPE];
    float h = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    CGRect rect = CGRectMake(0, 0, pTypeText.frame.size.width, h);
    CDropdownListContainer* pListBox = [[CDropdownListContainer alloc] initWithFrame:rect];
    [self addSubview:pListBox];
    [pTypeText RegisterDropdownList:pListBox];
    CDropdownListItem* pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_SPEEDCAMERA_TYPE_FIXED];
    [pItem SetText:[StringFactory GetString_FixedType]];
    [pItem RegisterDelegate:pTypeText];
    [pListBox AddItem:pItem];
    pItem = [[CDropdownListItem alloc] initWithFrame:rect];
    [pItem SetItemID:NOM_SPEEDCAMERA_TYPE_MOBILORSPEEDTRAP];
    NSString* szText = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_MobileType], [StringFactory GetString_SpeedTrap], [StringFactory GetString_PoliceCar]];
    [pItem SetText:szText];
    [pItem RegisterDelegate:pTypeText];
    [pListBox AddItem:pItem];
    float sx = self.frame.origin.x + pTypeText.frame.origin.x;
    float sy = self.frame.origin.y + pTypeText.frame.origin.y;
    [pTypeText SetOriginInContainer:sx withY:sy];
    [pTypeText SetLabel:[StringFactory GetString_FixedType]];
    [pTypeText SetSelectedItem:NOM_SPEEDCAMERA_TYPE_FIXED];
    [pTypeText UpdateLayout];
}

-(void)InitializeUIElements
{
    float w = [NOMSpotPhotoRadarContentView GetElemntWidth];
    float xedge = (self.frame.size.width - w)*0.5;
    float yedge = [NOMSpotPhotoRadarContentView GetDefaultEdge];
    
    
    float sx = xedge;
    float sy = yedge;
    float textHeight = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    
    CGRect rect = CGRectMake(sx, sy, w, textHeight);
    m_CameraType = [[CDropdownListBox alloc] initWithFrame:rect];
    [self addSubview:m_CameraType];
    
    
    sy += textHeight + yedge;
    w = [NOMSpotPhotoRadarContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_DirectionLabel = [[UILabel alloc] initWithFrame:rect];
    m_DirectionLabel.backgroundColor = [UIColor clearColor];
    [m_DirectionLabel setTextColor:[UIColor whiteColor]];
    m_DirectionLabel.highlightedTextColor = [UIColor grayColor];
    [m_DirectionLabel setTextAlignment:NSTextAlignmentRight];
    m_DirectionLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_DirectionLabel.adjustsFontSizeToFitWidth = YES;
    m_DirectionLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [m_DirectionLabel setText:[StringFactory GetString_Direction]];
    [self addSubview:m_DirectionLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_DirectionType = [[CDropdownListBox alloc] initWithFrame:rect];
    [self addSubview:m_DirectionType];

    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotPhotoRadarContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_FineLabel = [[UILabel alloc] initWithFrame:rect];
    m_FineLabel.backgroundColor = [UIColor clearColor];
    [m_FineLabel setTextColor:[UIColor whiteColor]];
    m_FineLabel.highlightedTextColor = [UIColor grayColor];
    [m_FineLabel setTextAlignment:NSTextAlignmentRight];
    m_FineLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_FineLabel.adjustsFontSizeToFitWidth = YES;
    m_FineLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    NSString* szFineLabel = [NSString stringWithFormat:@"%@ (%@)", [StringFactory GetString_Fine], [StringFactory GetString_DollarSign]];
    [m_FineLabel setText:szFineLabel];
    [self addSubview:m_FineLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_FineEditor = [[UITextField alloc] initWithFrame:rect];
    m_FineEditor.borderStyle = UITextBorderStyleRoundedRect;
    m_FineEditor.textColor = [UIColor blackColor];
    m_FineEditor.font = [UIFont systemFontOfSize:textHeight*0.6];
    m_FineEditor.placeholder = @"<Fine>";
    m_FineEditor.backgroundColor = [UIColor whiteColor];
    m_FineEditor.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_FineEditor.keyboardType = UIKeyboardTypeDecimalPad;
    m_FineEditor.keyboardAppearance = UIKeyboardAppearanceDefault;
    m_FineEditor.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_FineEditor.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_FineEditor.delegate = self;
    [self addSubview:m_FineEditor];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotPhotoRadarContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_AddressLabel = [[UILabel alloc] initWithFrame:rect];
    m_AddressLabel.backgroundColor = [UIColor clearColor];
    [m_AddressLabel setTextColor:[UIColor whiteColor]];
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
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotPhotoRadarContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_CameraSubTypeLabel = [[UILabel alloc] initWithFrame:rect];
    m_CameraSubTypeLabel.backgroundColor = [UIColor clearColor];
    [m_CameraSubTypeLabel setTextColor:[UIColor whiteColor]];
    m_CameraSubTypeLabel.highlightedTextColor = [UIColor grayColor];
    [m_CameraSubTypeLabel setTextAlignment:NSTextAlignmentRight];
    m_CameraSubTypeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_CameraSubTypeLabel.adjustsFontSizeToFitWidth = YES;
    m_CameraSubTypeLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [m_CameraSubTypeLabel setText:[StringFactory GetString_Type]];
    [self addSubview:m_CameraSubTypeLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_CameraSubType = [[CDropdownListBox alloc] initWithFrame:rect];
    [self addSubview:m_CameraSubType];

}

-(void)InitializeControls
{
    [self InitializeUIElements];
    [self InitializeCameraTypeDropdownList];
    [self InitializeCameraDirectionDropdownList];
    [self InitializeCameraSubTypeDropdownList];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self InitializeControls];
    }
    return self;
}

-(CDropdownListBox*)GetCameraTypeControl
{
    return m_CameraType;
}

-(CDropdownListBox*)GetCameraDirectionControl
{
    return m_DirectionType;
}

-(CDropdownListBox*)GetCameraSubTypeControl
{
    return m_CameraSubType;
}

-(void)Internal_CloseDropdownList
{
    if(m_CameraType != nil)
    {
        [m_CameraType CloseDropdownList];
    }
    if(m_DirectionType != nil)
    {
        [m_DirectionType CloseDropdownList];
    }
    if(m_CameraSubType != nil)
    {
        [m_CameraSubType CloseDropdownList];
    }
}

-(void)UpdateCameraSubType
{
    if(m_nCameraType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
    {
        if(m_CameraSubType != nil)
        {
            m_CameraSubType.hidden = NO;
        }
        if(m_CameraSubTypeLabel != nil)
        {
            m_CameraSubTypeLabel.hidden = NO;
        }
        
        if(m_nDeviceType <= NOM_SPEEDCAMERA_TYPE_FIXED)
        {
            [m_CameraSubType SetLabel:[StringFactory GetString_FixedType]];
        }
        else
        {
            NSString* szText = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_MobileType], [StringFactory GetString_SpeedTrap], [StringFactory GetString_PoliceCar]];
            [m_CameraSubType SetLabel:szText];
        }
    }
    else
    {
        if(m_CameraSubType != nil)
        {
            [m_CameraSubType CloseDropdownList];
            m_CameraSubType.hidden = YES;
        }
        if(m_CameraSubTypeLabel != nil)
        {
            m_CameraSubTypeLabel.hidden = YES;
        }
    }
}

-(void)UpdateContent
{
    if(m_nCameraType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
    {
        [m_CameraType SetLabel:[StringFactory GetString_SpeedCamera]];
        [m_CameraType SetSelectedItem:m_nCameraType];
    }
    else
    {
        m_nCameraType = NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA;
        [m_CameraType SetLabel:[StringFactory GetString_PhotoRadar]];
        [m_CameraType SetSelectedItem:m_nCameraType];
    }
    [self UpdateCameraSubType];
    
    [m_DirectionType SetLabel:[StringFactory GetString_TrafficDirectFullString:m_nDirection]];
    [m_DirectionType SetSelectedItem:m_nDirection];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self Internal_CloseDropdownList];
    
    if([NOMAppInfo IsDeviceIPad])
    {
        return;
    }
    
    if(self.frame.size.height < self.frame.size.width)
    {
        if(m_AddressEditor == textField)
        {
            if([self.superview respondsToSelector:@selector(ScrollViewTo:)] == YES)
            {
                SEL sel = @selector(ScrollViewTo:);
                float y = m_AddressEditor.frame.origin.y;
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self.superview methodSignatureForSelector:sel]];
                [inv setSelector:sel];
                [inv setTarget:self.superview];
                [inv setArgument:&y atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
                [inv invoke];
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self HideKeyboard];
    if([NOMAppInfo IsDeviceIPad])
    {
        return;
    }
    if(self.frame.size.height < self.frame.size.width)
    {
        if(m_AddressEditor == textField)
        {
            if([self.superview respondsToSelector:@selector(RestoreScrollViewDefaultPosition)] == YES)
            {
                [self.superview performSelector:@selector(RestoreScrollViewDefaultPosition)];
            }
        }
    }
}

-(void)OnSelectedListItemChange:(CDropdownListBox*)edit
{
    if(m_CameraType == edit)
    {
        m_nCameraType = [m_CameraType GetSelectedItem];
        [self UpdateCameraSubType];
    }
    if(m_DirectionType == edit)
    {
        m_nDirection = [m_DirectionType GetSelectedItem];
    }
    if(m_CameraSubType == edit)
    {
        m_nDeviceType = [m_CameraSubType GetSelectedItem];
    }
    if(edit != nil)
        [edit CloseDropdownList];
}

-(void)CloseDropdownList
{
    [self HideKeyboard];
    [self Internal_CloseDropdownList];
}

-(void)HideKeyboard
{
    if(m_FineEditor != nil)
        [m_FineEditor resignFirstResponder];
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

    float w = [NOMSpotPhotoRadarContentView GetElemntWidth];
    float xedge = (self.frame.size.width - w)*0.5;
    float yedge = [NOMSpotPhotoRadarContentView GetDefaultEdge];
    
    
    float sx = xedge;
    float sy = yedge;
    float textHeight = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    
    CGRect rect = CGRectMake(sx, sy, w, textHeight);
    [m_CameraType setFrame:rect];
    float offsetx = self.frame.origin.x + m_CameraType.frame.origin.x;
    float offsety = self.frame.origin.y + m_CameraType.frame.origin.y;
    [m_CameraType SetOriginInContainer:offsetx withY:offsety];
    [m_CameraType UpdateLayout];
    
    sy += textHeight + yedge;
    w = [NOMSpotPhotoRadarContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_DirectionLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_DirectionType setFrame:rect];
    offsetx = self.frame.origin.x + m_DirectionType.frame.origin.x;
    offsety = self.frame.origin.y + m_DirectionType.frame.origin.y;
    [m_DirectionType SetOriginInContainer:offsetx withY:offsety];
    [m_DirectionType UpdateLayout];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotPhotoRadarContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_FineLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_FineEditor setFrame:rect];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotPhotoRadarContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_AddressLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_AddressEditor setFrame:rect];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotPhotoRadarContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_CameraSubTypeLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_CameraSubType setFrame:rect];
    offsetx = self.frame.origin.x + m_CameraSubType.frame.origin.x;
    offsety = self.frame.origin.y + m_CameraSubType.frame.origin.y;
    [m_CameraSubType SetOriginInContainer:offsetx withY:offsety];
    [m_CameraSubType UpdateLayout];
}

-(void)Reset
{
    m_dFine = 0.0;
    m_nCameraType = -1;
    m_nDirection = -1;
    m_nDeviceType = -1;
    if(m_Address != nil)
    {
        m_Address = nil;
    }
    [m_CameraType SetLabel:@""];
    [m_CameraType SetSelectedItem:m_nCameraType];
    
    [m_DirectionType SetLabel:[StringFactory GetString_TrafficDirectFullString:NOM_PHOTORADAR_DIRECTION_NONE]];
    [m_DirectionType SetSelectedItem:NOM_PHOTORADAR_DIRECTION_NONE];
    
    [m_FineEditor setText:@""];
    [m_AddressEditor setText:@""];
    
    [m_CameraSubType SetLabel:[StringFactory GetString_FixedType]];
    [m_CameraSubType SetSelectedItem:NOM_SPEEDCAMERA_TYPE_FIXED];
}

-(void)SetType:(int16_t)nType
{
    m_nCameraType = nType;
    
    if(m_nCameraType < NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA)
        m_nCameraType = NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA;
    
    [self UpdateContent];
}

-(void)SetDirection:(int16_t)nDir
{
    m_nDirection = nDir;
    
    if(m_nDirection < NOM_PHOTORADAR_DIRECTION_NONE)
        m_nDirection = NOM_PHOTORADAR_DIRECTION_NONE;
    
    [self UpdateContent];
}

-(void)SetSpeedCameraDeviceType:(int16_t)nType
{
    m_nDeviceType = nType;
    if(m_nDeviceType < NOM_SPEEDCAMERA_TYPE_FIXED)
        m_nDeviceType = NOM_SPEEDCAMERA_TYPE_FIXED;
    
    [self UpdateContent];
}

-(void)SetAddress:(NSString*)address
{
    m_Address = [address copy];
    [m_AddressEditor setText:m_Address];
}

-(void)SetFine:(double)dPrice
{
    m_dFine = dPrice;
    if(m_dFine <= 0.0)
    {
        [m_FineEditor setText:@""];
    }
    else
    {
        [m_FineEditor setText:[NSString stringWithFormat:@"%f", m_dFine]];
    }
}

-(int16_t)GetType
{
    return m_nCameraType;
}

-(int16_t)GetDirection
{
    return m_nDirection;
}

-(int16_t)GetSpeedCameraDeviceType
{
    return m_nDeviceType;
}

-(NSString*)GetAddress
{
    m_Address = m_AddressEditor.text;
    return m_Address;
}

-(double)GetFine
{
    if(m_FineEditor.text == nil || m_FineEditor.text.length <= 0)
    {
        m_dFine = 0.0;
    }
    else
    {
        m_dFine = [m_FineEditor.text doubleValue];
    }
    return m_dFine;
}

@end
