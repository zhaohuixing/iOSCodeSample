//
//  XZBaseResourceList.m
//

#import "XZBaseResourceList.h"
#import "NSDate+XZCareBase.h"
#import "XZBaseSchedule.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseResourceList

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (int64_t)totalValue
{
	return [self.total longLongValue];
}

- (void)setTotalValue:(int64_t)value_
{
	self.total = [NSNumber numberWithLongLong:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        //self.items = [dictionary objectForKey:@"items"];
        NSArray* scheduleRepresentations = [dictionary objectForKey:@"items"];
        NSMutableArray* tempScheduleList = [[NSMutableArray alloc] init];
        if(scheduleRepresentations == nil || scheduleRepresentations.count <= 0)
        {
#ifdef DEBUG
            NSAssert(NO, @"XZBaseResourceList initWithDictionaryRepresentation: The schedule representation list does not have any data!\n");
#endif
        }
        else
        {
            for(NSDictionary* schedRep in scheduleRepresentations)
            {
                if(schedRep)
                {
                    XZBaseSchedule* pSchedule = (XZBaseSchedule*)[XZBaseClassFactory  CreateSimpleBaseClassFromRepresentation:schedRep];
                    if(pSchedule)
                    {
                        [tempScheduleList addObject:pSchedule];
                    }
                    else
                    {
#ifdef DEBUG
                        NSAssert(NO, @"XZBaseResourceList initWithDictionaryRepresentation: failed to create schedule object from representation data!\n");
#endif
                    }
                }
                else
                {
#ifdef DEBUG
                    NSAssert(NO, @"XZBaseResourceList initWithDictionaryRepresentation: schedule representation object invalid!\n");
#endif
                }
            }
            if(tempScheduleList.count <= 0)
            {
#ifdef DEBUG
                NSAssert(NO, @"XZBaseResourceList initWithDictionaryRepresentation: failed to load schedule list from representation data list!\n");
#endif
            }
            else
            {
                self.items = [NSArray arrayWithArray:tempScheduleList];
            }
        }
        
        self.total = [dictionary objectForKey:@"total"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    //self.items = [dictionary objectForKey:@"items"];
    NSArray* scheduleRepresentations = [dictionary objectForKey:@"items"];
    NSMutableArray* tempScheduleList = [[NSMutableArray alloc] init];
    if(scheduleRepresentations == nil || scheduleRepresentations.count <= 0)
    {
#ifdef DEBUG
        NSAssert(NO, @"XZBaseResourceList initializeFromDictionaryRepresentation: The schedule representation list does not have any data!\n");
#endif
    }
    else
    {
        for(NSDictionary* schedRep in scheduleRepresentations)
        {
            if(schedRep)
            {
                XZBaseSchedule* pSchedule = (XZBaseSchedule*)[XZBaseClassFactory  CreateSimpleBaseClassFromRepresentation:schedRep];
                if(pSchedule)
                {
                    [tempScheduleList addObject:pSchedule];
                }
                else
                {
#ifdef DEBUG
                    NSAssert(NO, @"XZBaseResourceList initializeFromDictionaryRepresentation: failed to create schedule object from representation data!\n");
#endif
                }
            }
            else
            {
#ifdef DEBUG
                NSAssert(NO, @"XZBaseResourceList initializeFromDictionaryRepresentation: schedule representation object invalid!\n");
#endif
            }
        }
        if(tempScheduleList.count <= 0)
        {
#ifdef DEBUG
            NSAssert(NO, @"XZBaseResourceList initializeFromDictionaryRepresentation: failed to load schedule list from representation data list!\n");
#endif
        }
        else
        {
            self.items = [NSArray arrayWithArray:tempScheduleList];
        }
    }
    
    self.total = [dictionary objectForKey:@"total"];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];

    //[dict setObjectIfNotNil:self.items forKey:@"items"];
    if(self.items != nil && 0 < self.items.count)
    {
        NSMutableArray* tempScheduleList = [[NSMutableArray alloc] init];
        for(XZBaseSchedule* pSchedule in self.items)
        {
            if(pSchedule != nil)
            {
                NSDictionary* pRepresentation = [pSchedule dictionaryRepresentation];
                [tempScheduleList addObject:pRepresentation];
            }
        }
        if(0 < tempScheduleList.count)
        {
            [dict setObjectIfNotNil:tempScheduleList forKey:@"items"];
        }
    }
    
    [dict setObjectIfNotNil:self.total forKey:@"total"];

	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.

	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access

#ifdef DEBUG
- (void)DebugLog
{
    [super DebugLog];
    NSLog(@"XZBaseResourceList DebugLog total:%lli\n", [self.total longLongValue]);
    NSLog(@"XZBaseResourceList DebugLog items *************begin*************\n");
    if(self.items == nil || self.items.count <= 0)
    {
        NSLog(@"XZBaseResourceList DebugLog items is null or no object\n");
    }
    else
    {
        for(XZBaseSchedule* schedule in self.items)
        {
            if(schedule != nil)
            {
                [schedule DebugLog];
            }
        }
    }
    NSLog(@"XZBaseResourceList DebugLog items **************end**************\n");
}
#endif

@end
