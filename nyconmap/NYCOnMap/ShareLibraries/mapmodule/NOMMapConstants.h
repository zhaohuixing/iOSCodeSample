//
//  NOMMapConstants.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#ifndef __NOMMAPCCONSTANTS_H__
#define __NOMMAPCCONSTANTS_H__

#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS log2(MKMapSizeWorld.width/256.0)
#define MAX_MKMAPVIEW_ZOOM          10.0 //20.0
#define MIN_MKMAPOBJECT_ZOOM        0.12 //0.2

#define KML_TAG_POINT           @"point"
#define KML_TAG_LINE            @"line"

#define KML_TAG_MARKPOINT       @"mark_point"
#define KML_TAG_MARKLINE        @"mark_line"
#define KML_TAG_MARKROUTE       @"mark_route"
#define KML_TAG_MARKPOLY        @"mark_poly"
#define KML_TAG_MARKRECT        @"mark_rect"


#define MAP_PLAN_LINE_DEFAULT_WIDTH         20
#define MAP_PLAN_ROUTE_DEFAULT_WIDTH        3

#define MAP_PLAN_LINE_COLOR     [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
#define MAP_PLAN_ROUTE_COLOR    [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0]

#define MAP_PLAN_LINE_ID        @"plan_line"
#define MAP_PLAN_ROUTE_ID       @"plan_route"
#define MAP_PLAN_POLY_ID        @"plan_poly"
#define MAP_PLAN_RECT_ID        @"plan_rect"

#define NOM_MAP_ANNOTATIONTYPE_NONE                 -1
#define NOM_MAP_ANNOTATIONTYPE_PLANMARKER           0
#define NOM_MAP_ANNOTATIONTYPE_JUSTMYLOCATION       1
#define NOM_MAP_ANNOTATIONTYPE_MYLOCATION           2
#define NOM_MAP_ANNOTATIONTYPE_PINLOCATION          3
#define NOM_MAP_ANNOTATIONTYPE_QUERYPIN             4
#define NOM_MAP_ANNOTATIONTYPE_TRAFFICSPOTPIN       5
#define NOM_MAP_ANNOTATIONTYPE_ALERTPIN             6
#define NOM_MAP_ANNOTATIONTYPE_REFERENCEPIN         7

#define DEFAULT_APP_COVER_LINE_DASH_LENGHT      60
#define DEFAULT_APP_COVER_LINE_DASH_GAP         30
#define DEFAULT_APP_COVER_LINE_WIDTH            20

#endif
