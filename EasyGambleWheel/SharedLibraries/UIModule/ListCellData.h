//
//  ListCellData.h
//  testscollview
//
//  Created by Zhaohui Xing on 10-12-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ListConstants.h"

@interface ListCellDataInt : NSObject<ListCellDataTemplate, ListCellDataIntegerTemplate> 
{
	int					m_nData;
}

@property (nonatomic)int					m_nData;

-(enLISTCELLDATATYPE)GetDataType; 
-(void)Destroy;
-(int)GetData;  

@end

@interface ListCellDataFloat : NSObject<ListCellDataTemplate, ListCellDataFloatTemplate> 
{
	float					m_fData;
}

@property (nonatomic)float					m_fData;

-(enLISTCELLDATATYPE)GetDataType; 
-(void)Destroy;
-(float)GetData;  

@end

@interface ListCellDataString : NSObject<ListCellDataTemplate, ListCellDataStringTemplate> 
{
	NSString*					m_sData;
}

@property (nonatomic, retain)NSString*		m_sData;

-(enLISTCELLDATATYPE)GetDataType; 
-(void)Destroy;
-(NSString*)GetData;  

@end

@interface ListCellDataObject : NSObject<ListCellDataTemplate, ListCellDataObjectTemplate> 
{
	id					m_objData;
}

@property (nonatomic, retain)id		m_objData;

-(enLISTCELLDATATYPE)GetDataType; 
-(void)Destroy;
-(id)GetData;  

@end
