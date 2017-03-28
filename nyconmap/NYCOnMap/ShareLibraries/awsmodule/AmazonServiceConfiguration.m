//
//  AmazonServiceConfiguration.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-05-24.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "AmazonServiceConfiguration.h"
#import "NOMSystemConstants.h"

static int  g_NOMDBSystemType = NOM_DBSYSTYPE_INVALID;

@implementation AmazonServiceConfiguration

+(void)SetNOMDBSystemType:(int)nDBType
{
    g_NOMDBSystemType = nDBType;
}

+(int)GetNOMDBSystemType
{
    return g_NOMDBSystemType;
}

+(BOOL)IsNOMUsingSimpleDB
{
    BOOL bRet = (g_NOMDBSystemType == NOM_DBSYSTYPE_SIMPLEDB);
    return bRet;
}

+(BOOL)IsNOMDBSystemInvalid
{
    BOOL bRet = (g_NOMDBSystemType == NOM_DBSYSTYPE_INVALID);
    return bRet;
}

@end
