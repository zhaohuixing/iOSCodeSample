//
//  XZBaseSchedule.m
//
#import "XZBaseSchedule.h"
#import "NSDate+XZCareBase.h"
#import "XZBaseActivity.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseSchedule

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        //self.activities = [dictionary objectForKey:@"activities"];
        NSArray* activityRepresentations = [dictionary objectForKey:@"activities"];
        NSMutableArray* tempActivityList = [[NSMutableArray alloc] init];
        if(activityRepresentations == nil || activityRepresentations.count <= 0)
        {
#ifdef DEBUG
            NSAssert(NO, @"XZBaseSchedule initWithDictionaryRepresentation: The activity representation list does not have any data!\n");
#endif
        }
        else
        {
            for(NSDictionary* actRep in activityRepresentations)
            {
                if(actRep)
                {
                    XZBaseActivity* pActivity = (XZBaseActivity*)[XZBaseClassFactory  CreateSimpleBaseClassFromRepresentation:actRep];
                    if(pActivity)
                    {
                        [tempActivityList addObject:pActivity];
                    }
                    else
                    {
#ifdef DEBUG
                        NSAssert(NO, @"XZBaseSchedule initWithDictionaryRepresentation: failed to create activity object from representation data!\n");
#endif
                    }
                }
                else
                {
#ifdef DEBUG
                    NSAssert(NO, @"XZBaseSchedule initWithDictionaryRepresentation: activity representation object invalid!\n");
#endif
                }
            }
            if(tempActivityList.count <= 0)
            {
#ifdef DEBUG
                NSAssert(NO, @"XZBaseSchedule initWithDictionaryRepresentation: failed to load activity list from representation data list!\n");
#endif
            }
            else
            {
                self.activities = [NSArray arrayWithArray:tempActivityList];
            }
        }
        
        self.cronTrigger = [dictionary objectForKey:@"cronTrigger"];
        self.endsOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"endsOn"]];
        self.expires = [dictionary objectForKey:@"expires"];
        self.label = [dictionary objectForKey:@"label"];
        self.scheduleType = [dictionary objectForKey:@"scheduleType"];
        self.startsOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"startsOn"]];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    //self.activities = [dictionary objectForKey:@"activities"];
    NSArray* activityRepresentations = [dictionary objectForKey:@"activities"];
    NSMutableArray* tempActivityList = [[NSMutableArray alloc] init];
    if(activityRepresentations == nil || activityRepresentations.count <= 0)
    {
#ifdef DEBUG
        NSAssert(NO, @"XZBaseSchedule initializeFromDictionaryRepresentation: The activity representation list does not have any data!\n");
#endif
    }
    else
    {
        for(NSDictionary* actRep in activityRepresentations)
        {
            if(actRep)
            {
                XZBaseActivity* pActivity = (XZBaseActivity*)[XZBaseClassFactory  CreateSimpleBaseClassFromRepresentation:actRep];
                if(pActivity)
                {
                    [tempActivityList addObject:pActivity];
                }
                else
                {
#ifdef DEBUG
                    NSAssert(NO, @"XZBaseSchedule initializeFromDictionaryRepresentation: failed to create activity object from representation data!\n");
#endif
                }
            }
            else
            {
#ifdef DEBUG
                NSAssert(NO, @"XZBaseSchedule initializeFromDictionaryRepresentation: activity representation object invalid!\n");
#endif
            }
        }
        if(tempActivityList.count <= 0)
        {
#ifdef DEBUG
            NSAssert(NO, @"XZBaseSchedule initializeFromDictionaryRepresentation: failed to load activity list from representation data list!\n");
#endif
        }
        else
        {
            self.activities = [NSArray arrayWithArray:tempActivityList];
        }
    }
    
    
    self.cronTrigger = [dictionary objectForKey:@"cronTrigger"];
    self.endsOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"endsOn"]];
    self.expires = [dictionary objectForKey:@"expires"];
    self.label = [dictionary objectForKey:@"label"];
    self.scheduleType = [dictionary objectForKey:@"scheduleType"];
    self.startsOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"startsOn"]];
}


- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    //[dict setObjectIfNotNil:self.activities forKey:@"activities"];
    if(self.activities != nil && 0 < self.activities.count)
    {
        NSMutableArray* tempActivityList = [[NSMutableArray alloc] init];
        for(XZBaseActivity* pActivity in self.activities)
        {
            if(pActivity != nil)
            {
                NSDictionary* pRepresentation = [pActivity dictionaryRepresentation];
                [tempActivityList addObject:pRepresentation];
            }
        }
        if(0 < tempActivityList.count)
        {
            [dict setObjectIfNotNil:tempActivityList forKey:@"activities"];
        }
    }
    
    [dict setObjectIfNotNil:self.cronTrigger forKey:@"cronTrigger"];
    [dict setObjectIfNotNil:[self.endsOn ISO8601String] forKey:@"endsOn"];
    [dict setObjectIfNotNil:self.expires forKey:@"expires"];
    [dict setObjectIfNotNil:self.label forKey:@"label"];
    [dict setObjectIfNotNil:self.scheduleType forKey:@"scheduleType"];
    [dict setObjectIfNotNil:[self.startsOn ISO8601String] forKey:@"startsOn"];

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
    NSLog(@"XZBaseSchedule DebugLog cronTrigger:%@\n", self.cronTrigger);
    NSLog(@"XZBaseSchedule DebugLog startsOn:%@\n", [self.startsOn ISO8601String]);
    NSLog(@"XZBaseSchedule DebugLog endsOn:%@\n", [self.endsOn ISO8601String]);
    NSLog(@"XZBaseSchedule DebugLog expires:%@\n", self.expires);
    NSLog(@"XZBaseSchedule DebugLog label:%@\n", self.label);
    NSLog(@"XZBaseSchedule DebugLog scheduleType:%@\n", self.scheduleType);

    NSLog(@"XZBaseSchedule DebugLog activities *************begin*************\n");
    if(self.activities == nil || self.activities.count <= 0)
    {
        NSLog(@"XZBaseSchedule DebugLog activities is null or no object\n");
    }
    else
    {
        for(XZBaseActivity* activity in self.activities)
        {
            if(activity != nil)
            {
                [activity DebugLog];
            }
        }
    }
    NSLog(@"XZBaseSchedule DebugLog activities **************end**************\n");
    
}
#endif

@end
