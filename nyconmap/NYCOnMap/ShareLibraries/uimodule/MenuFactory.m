//
//  MenuFactory.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-11.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "MenuFactory.h"
#import "PopupMenuContainerView.h"
#import "PopupMenu.h"
#import "PopupMenuItem.h"
#import "StringFactory.h"
#import "ImageLoader.h"
#import "NOMAppInfo.h"
#import "NOMAppConstants.h"
#import "NOMSystemConstants.h"
#import "DrawHelper2.h"

#define IPHONE_SMALL_LABEL_FONT_SIZE        12

@implementation MenuFactory

+(void)CreateSearchPublicTransitItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
/*    int nItemCount = 3;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_PUBLICTRANSITMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_DELAY_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_PASSENGERSTUCK_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_ALL]];
    [menu AddMenuItem:pItem];*/
}

+(void)CreateSearchDrivingConditionItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 5;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_JAM_ID];
    CGImageRef imageSrc = [ImageLoader LoadImageWithName:@"jambtn200.png"];
    CGImageRef imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_CRASH_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"crashbtn200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_POLICE_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"policebtn200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_CONSTRUCTION_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"constbtn200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ROADCLOSURE_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"roadclosebtn200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_BROKENTRAFFICLIGHT_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"brokenlight200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_STALLEDCAR_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"stallcar200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR]];
    [menu AddMenuItem:pItem];
   
    

    //????????????????????????????????????????????
    //????????????????????????????????????????????
    //????????????????????????????????????????????
    //?????????????????????????????????????????????
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_FOG_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"fogpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_DANGEROUSCONDITION_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"dangerpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_RAIN_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"rainpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ICE_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"icepin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_WIND_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"windpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_LANECLOSURE_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"lanepin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_SLIPROADCLOSURE_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"sliproadpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_DETOUR_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"detourpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR]];
    [menu AddMenuItem:pItem];
    
    //????????????????????????????????????????????
    //????????????????????????????????????????????
    //????????????????????????????????????????????
    //????????????????????????????????????????????
    //????????????????????????????????????????????
    
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ALL]];
    [menu AddMenuItem:pItem];
}

+(void)CreateSearchTrafficItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 3;
 
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_ITEM_PUBLICTRANSIT_ID];
    [pItem SetLabel:[StringFactory GetString_NewsTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC subCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateSearchPublicTransitItemSubView:pItem withParent:menu withConroller:controller];
    
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_ITEM_DRIVINGCONDITION_ID];
    [pItem SetLabel:[StringFactory GetString_NewsTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC subCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateSearchDrivingConditionItemSubView:pItem withParent:menu withConroller:controller];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TRAFFICMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_All]];
    [menu AddMenuItem:pItem];
    
}

+(void)CreateShowTaxiSharingInformationItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 3;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SEARCHMENU_TAXISHAREMENU_TAXISHAREMENU_ID];
    [item SetChildMenu:menu];
 
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_DRIVER_ID];
    [pItem SetLabel:[StringFactory GetString_TaxiAvailableByDriver]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_PASSENGER_ID];
    [pItem SetLabel:[StringFactory GetString_TaxiPassengerAvailable]];
    [menu AddMenuItem:pItem];

    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_Both]];
    [menu AddMenuItem:pItem];
}

+(void)CreateSearchRootMenu:(PopupMenuContainerView*)controller
{
    int nItemCount = 2;
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [controller SetRootMenu:menu];
    [menu RegisterParent:nil withController:controller];
    [menu RegisterMenuID:GUIID_SEARCHMENU_ROOTMENU_ID];

    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_ITEM_TRAFFIC_ID];
    [pItem SetLabel:[StringFactory GetString_Traffic]];
    [menu AddMenuItem:pItem];
    if([NOMAppInfo IsSimpleSearchMode] == NO)
        [MenuFactory CreateSearchTrafficItemSubView:pItem withParent:menu withConroller:controller];

    //Add spot menu item, 2013-11-23
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_MAPTYPEMENU_ITEM_SPOTS_ID];
    [pItem SetLabel:[StringFactory GetString_Spot]];
    [MenuFactory CreateShowTrafficSpotItemSubView:pItem withParent:menu withConroller:controller];
    [menu AddMenuItem:pItem];

    //Add taxi menu item, 2015-01-08
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SEARCHMENU_ITEM_TAXISHARING_ID];
    [pItem SetLabel:[StringFactory GetString_TaxiInfo]];
    [menu AddMenuItem:pItem];
    if([NOMAppInfo IsSimpleSearchMode] == NO)
        [MenuFactory CreateShowTaxiSharingInformationItemSubView:pItem withParent:menu withConroller:controller];
    
    [controller SetCurrentMenu:menu];
    [controller OpenMenu:menu];
}

 
+(void)CreateSearchMenu:(UIView *)parentView withController:(MainMenuController *)controller inArchor:(CGPoint)pt withPoistion:(float)ratio
{
    float w = [PopupMenuContainerView GetContainerViewWidth];
    float h = [PopupMenuContainerView GetContainerViewMaxHeight];
    float sx = pt.x - w*ratio;
    float sy = pt.y - h;
    CGRect rect =CGRectMake(sx, sy, w, h);
    PopupMenuContainerView* menu = [[PopupMenuContainerView alloc] initWithFrame:rect];
    [menu Register:GUIID_SEARCHMENU_ID withArchor:CGPointMake(w*ratio, h) withController:controller];
    [parentView addSubview:menu];
    [controller AddMenu:menu];
    [MenuFactory CreateSearchRootMenu:menu];
    [menu UpdateLayout];
}


+(void)CreatePostPublicTransitItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 4;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    //[pItem RegisterControllers:controller];
    //[pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_DELAY_ID];
    //[pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY]];
    //[menu AddMenuItem:pItem];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_BUS_DELAY_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_TRAIN_DELAY_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_FLIGHT_DELAY_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_PASSENGERSTUCK_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK]];
    [menu AddMenuItem:pItem];
}

+(void)CreatePostDrivingConditionItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 5;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_JAM_ID];
    CGImageRef imageSrc = [ImageLoader LoadImageWithName:@"jambtn200.png"];
    CGImageRef imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_CRASH_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"crashbtn200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_POLICE_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"policebtn200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_CONSTRUCTION_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"constbtn200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ROADCLOSURE_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"roadclosebtn200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_BROKENTRAFFICLIGHT_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"brokenlight200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_STALLEDCAR_ID];
    imageSrc = [ImageLoader LoadImageWithName:@"stallcar200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_FOG_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"fogpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_DANGEROUSCONDITION_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"dangerpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_RAIN_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"rainpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ICE_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"icepin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_WIND_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"windpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_LANECLOSURE_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"lanepin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_SLIPROADCLOSURE_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"sliproadpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    if([NOMAppInfo IsDeviceIPhone] == YES)
        [pItem SetLabeLFontSize:IPHONE_SMALL_LABEL_FONT_SIZE];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_DETOUR_ID];
    imageIcon = [ImageLoader LoadImageWithName:@"detourpin.png"];
    [pItem SetImage:imageIcon inCenter:NO];
    [pItem SetLabel:[StringFactory GetString_TrafficTypeTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION withType:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR]];
    [menu AddMenuItem:pItem];
}


+(void)CreatePostTrafficItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 2;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_ITEM_PUBLICTRANSIT_ID];
    [pItem SetLabel:[StringFactory GetString_NewsTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC subCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreatePostPublicTransitItemSubView:pItem withParent:menu withConroller:controller];
  
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TRAFFICMENU_ITEM_DRIVINGCONDITION_ID];
    [pItem SetLabel:[StringFactory GetString_NewsTitle:NOM_NEWSCATEGORY_LOCALTRAFFIC subCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreatePostDrivingConditionItemSubView:pItem withParent:menu withConroller:controller];
}

+(void)CreateMarkEnforcementCameraItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 2;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_PHOTORADARMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_PHOTORADARMENU_ITEM_REDLIGHTCAMERA_ID];
    [pItem SetLabel:[StringFactory GetString_PhotoRadar]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_PHOTORADARMENU_ITEM_SPEEDCAMERA_ID];
    [pItem SetLabel:[StringFactory GetString_SpeedCamera]];
    [menu AddMenuItem:pItem];
}

+(void)CreateMarkTrafficSpotItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 5;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_PHOTORADAR_ID];
    [pItem SetLabel:[StringFactory GetString_EnforcementRadar]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateMarkEnforcementCameraItemSubView:pItem withParent:menu withConroller:controller];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_SCHOOLZONE_ID];
    [pItem SetLabel:[StringFactory GetString_SchoolZone]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_PLAYGROUND_ID];
    [pItem SetLabel:[StringFactory GetString_Playground]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_PARKINGGROUND_ID];
    [pItem SetLabel:[StringFactory GetString_ParkingGround]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_GASSTATION_ID];
    [pItem SetLabel:[StringFactory GetString_GasStation]];
    [menu AddMenuItem:pItem];
}

+(void)CreateMarkTaxiShareItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 2;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_POSTMENU_TAXISHAREMENU_TAXISHAREMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_DRIVER_ID];
    [pItem SetLabel:[StringFactory GetString_TaxiAvailableByDriver]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_PASSENGER_ID];
    [pItem SetLabel:[StringFactory GetString_TaxiPassengerAvailable]];
    [menu AddMenuItem:pItem];
}


+(void)CreatePostRootMenu:(PopupMenuContainerView*)controller
{
    int nItemCount = 4;
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [controller SetRootMenu:menu];
    [menu RegisterParent:nil withController:controller];
    [menu RegisterMenuID:GUIID_POSTMENU_ROOTMENU_ID];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_ITEM_TRAFFIC_ID];
    [pItem SetLabel:[StringFactory GetString_Traffic]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreatePostTrafficItemSubView:pItem withParent:menu withConroller:controller];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_ITEM_MARKSPOT_ID ];
    [pItem SetLabel:[StringFactory GetString_MarkSpot]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateMarkTrafficSpotItemSubView:pItem withParent:menu withConroller:controller];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_POSTMENU_ITEM_TAXISHARING_ID];
    [pItem SetLabel:[StringFactory GetString_TaxiInfo]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateMarkTaxiShareItemSubView:pItem withParent:menu withConroller:controller];
    
    [controller SetCurrentMenu:menu];
    [controller OpenMenu:menu];
}

 
+(void)CreatePostMenu:(UIView *)parentView withController:(MainMenuController *)controller inArchor:(CGPoint)pt withPoistion:(float)ratio
{
    float w = [PopupMenuContainerView GetContainerViewWidth];
    float h = [PopupMenuContainerView GetContainerViewMaxHeight];
    float sx = pt.x - w*ratio;
    float sy = pt.y - h;
    CGRect rect =CGRectMake(sx, sy, w, h);
    PopupMenuContainerView* menu = [[PopupMenuContainerView alloc] initWithFrame:rect];
    [menu Register:GUIID_POSTMENU_ID withArchor:CGPointMake(w*ratio, h) withController:controller];
    [parentView addSubview:menu];
    [controller AddMenu:menu];
    [MenuFactory CreatePostRootMenu:menu];
    [menu UpdateLayout];
}


+(void)CreateConfigurationItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 2;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_CONFIGURATIONMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CONFIGURATIONMENU_ITEM_QUERYCONFIGURATION_ID];
    [pItem SetLabel:[StringFactory GetString_QueryConfiguration]];
    [menu AddMenuItem:pItem];
    
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CONFIGURATIONMENU_ITEM_USERCONFIGURATION_ID];
    [pItem SetLabel:[StringFactory GetString_UserConfiguration]];
    [menu AddMenuItem:pItem];
}

+(void)CreateShowEnforcementCameraItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 3;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_PHOTORADARMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_PHOTORADARMENU_ITEM_REDLIGHTCAMERA_ID];
    [pItem SetLabel:[StringFactory GetString_PhotoRadar]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_PHOTORADARMENU_ITEM_SPEEDCAMERA_ID];
    [pItem SetLabel:[StringFactory GetString_SpeedCamera]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_PHOTORADARMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_All]];
    [menu AddMenuItem:pItem];
    
}

+(void)CreateShowSpeedLimitSpotItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 4;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ITEM_PHOTORADAR_ID];
    [pItem SetLabel:[StringFactory GetString_EnforcementRadar]];
    //[pItem SetLineNumber:2];
    [menu AddMenuItem:pItem];
    //[MenuFactory CreateShowEnforcementCameraItemSubView:pItem withParent:menu withConroller:controller];
  
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ITEM_SCHOOLZONE_ID];
    [pItem SetLabel:[StringFactory GetString_SchoolZone]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ITEM_PLAYGROUND_ID];
    [pItem SetLabel:[StringFactory GetString_Playground]];
    [menu AddMenuItem:pItem];
    
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_All]];
    [menu AddMenuItem:pItem];
}

+(void)CreateShowTrafficSpotItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 3;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_ITEM_SPEEDLIMIT_ID];
    [pItem SetLabel:[StringFactory GetString_SpeedLimit]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateShowSpeedLimitSpotItemSubView:pItem withParent:menu withConroller:controller];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_ITEM_PARKINGGROUND_ID];
    [pItem SetLabel:[StringFactory GetString_ParkingGround]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_ITEM_GASSTATION_ID];
    [pItem SetLabel:[StringFactory GetString_GasStation]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_All]];
    [menu AddMenuItem:pItem];
    
}

/*
+(void)CreateShowSpotsItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 1;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_SHOWSPOTMENU_ITEM_TRAFFICSPOTMENU_ID];
    [pItem SetLabel:[StringFactory GetString_TrafficSpot]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateShowTrafficSpotItemSubView:pItem withParent:menu withConroller:controller];
    
} */

+(void)CreateMapTypeItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 4;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_MAPTYPEMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_MAPTYPEMENU_ITEM_MAPSTANDARD_ID];
    
    [pItem SetLabel:@""];//[StringFactory GetString_MapStandard]];
    CGImageRef imageSrc = [ImageLoader LoadImageWithName:@"std200.png"];
    CGImageRef imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:YES];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_MAPTYPEMENU_ITEM_MAPSATELLITE_ID];
    [pItem SetLabel:@""]; //[StringFactory GetString_MapSatellite]];
    imageSrc = [ImageLoader LoadImageWithName:@"satellite200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    [pItem SetImage:imageIcon inCenter:YES];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_MAPTYPEMENU_ITEM_MAPHYBIRD_ID];
    [pItem SetLabel:@""];//[StringFactory GetString_MapHybird]];
    imageSrc = [ImageLoader LoadImageWithName:@"hybird200.png"];
    imageIcon = [DrawHelper2 CloneImage:imageSrc withFlip:YES];
    //CGImageRelease(imageSrc);
    [pItem SetImage:imageIcon inCenter:YES];
    //CGImageRelease(imageSrc);
    [menu AddMenuItem:pItem];
/*
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_MAPTYPEMENU_ITEM_SPOTS_ID];
    [pItem SetLabel:[StringFactory GetString_Spot]];
//    [MenuFactory CreateShowSpotsItemSubView:pItem withParent:menu withConroller:controller];
    [menu AddMenuItem:pItem];
*/
}

+(void)CreateClearTaxiItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 3;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_CLEARTAXIMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_CLEARTAXIMENU_ITEM_TAXIDRIVER_ID];
    [pItem SetLabel:[StringFactory GetString_Taxi]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_CLEARTAXIMENU_ITEM_TAXIPASSENGER_ID];
    [pItem SetLabel:[StringFactory GetString_Passenger]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_CLEARTAXIMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_All]];
    [menu AddMenuItem:pItem];
}

+(void)CreateClearMapItemSubView:(PopupMenuItem*)item withParent:(PopupMenu*)parent withConroller:(PopupMenuContainerView*)controller
{
    int nItemCount = 3;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [menu RegisterParent:parent withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_ID];
    [item SetChildMenu:menu];
    
    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_TRAFFIC_ID];
    [pItem SetLabel:[StringFactory GetString_Traffic]];
    [menu AddMenuItem:pItem];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_SPOT_ID];
    [pItem SetLabel:[StringFactory GetString_Spot]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_TAXI_ID];
    [pItem SetLabel:[StringFactory GetString_TaxiInfo]];
    [menu AddMenuItem:pItem];
    //[MenuFactory CreateClearTaxiItemSubView:pItem withParent:menu withConroller:controller];
    
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_ALL_ID];
    [pItem SetLabel:[StringFactory GetString_All]];
    [menu AddMenuItem:pItem];
}

+(void)CreateSettingRootMenu:(PopupMenuContainerView*)controller
{
    int nItemCount = 6;
    
    float h = [PopupMenuContainerView GetMenuItemHeight] * nItemCount;
    float w = [PopupMenuContainerView GetMenuItemWidth];
    float sx = [PopupMenuContainerView GetCornerSize];
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, w, h);
    PopupMenu* menu = [[PopupMenu alloc] initWithFrame:rect];
    [controller AddMenu:menu];
    [controller SetRootMenu:menu];
    [menu RegisterParent:nil withController:controller];
    [menu RegisterMenuID:GUIID_SETTINGMENU_ROOTMENU_ID];

    h = [PopupMenuContainerView GetMenuItemHeight];
    rect = CGRectMake(0, 0, w, h);
    PopupMenuItem* pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_ITEM_MAPTYPE_ID];
    [pItem SetLabel:[StringFactory GetString_MapType]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateMapTypeItemSubView:pItem withParent:menu withConroller:controller];
/*
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_ITEM_CONFIGURATION_ID];
    [pItem SetLabel:[StringFactory GetString_Configuration]];
    [menu AddMenuItem:pItem];
//    [MenuFactory CreateConfigurationItemSubView:pItem withParent:menu withConroller:controller];
*/
/*
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_ITEM_TWITTERSETTING_ID];
    [pItem SetLabel:[StringFactory GetString_TwitterSetting]];
    [menu AddMenuItem:pItem];
*/ 
/*
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_ITEM_RELOAD_ID];
    [pItem SetLabel:[StringFactory GetString_Reload]];
    [menu AddMenuItem:pItem];
*/
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_ITEM_CLEARMAP_ID];
    [pItem SetLabel:[StringFactory GetString_ClearMap]];
    [menu AddMenuItem:pItem];
    [MenuFactory CreateClearMapItemSubView:pItem withParent:menu withConroller:controller];
    
    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_ITEM_SHOWMYLOCATION_ID];
    [pItem SetLabel:[StringFactory GetString_MyLocation]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_ITEM_OPENPRIVACYVIEW_ID];
    [pItem SetLabel:[StringFactory GetString_Privacy]];
    [menu AddMenuItem:pItem];

    pItem = [[PopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterControllers:controller];
    [pItem RegisterMenuID:GUIID_SETTINGMENU_ITEM_OPENTERMSOFUSEVIEW_ID];
    [pItem SetLabel:[StringFactory GetString_TermOfUse]];
    [menu AddMenuItem:pItem];
}


+(void)CreateSettingMenu:(UIView *)parentView withController:(MainMenuController *)controller inArchor:(CGPoint)pt withPoistion:(float)ratio
{
    float w = [PopupMenuContainerView GetContainerViewWidth];
    float h = [PopupMenuContainerView GetContainerViewMaxHeight];
    float sx = pt.x - w*ratio;
    float sy = pt.y - h;
    CGRect rect =CGRectMake(sx, sy, w, h);
    PopupMenuContainerView* menu = [[PopupMenuContainerView alloc] initWithFrame:rect];
    [menu Register:GUIID_SETTINGMENU_ID withArchor:CGPointMake(w*ratio, h) withController:controller];
    [parentView addSubview:menu];
    [controller AddMenu:menu];
    [MenuFactory CreateSettingRootMenu:menu];
    [menu UpdateLayout];
}


@end
