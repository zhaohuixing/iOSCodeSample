// 
//  APCMedicationLozenge.m 
//  APCAppCore 
// 
// Copyright (c) 2015, Apple Inc. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
 
#import "XZBaseMedicationLozenge.h"
#import "XZBaseMedicationWeeklySchedule.h"
#import "XZBaseMedicationDosageTaken.h"

@implementation XZBaseMedicationLozenge

+ (instancetype) lozengeWithSchedule: (XZBaseMedicationWeeklySchedule *) schedule
                        dayOfTheWeek: (NSNumber *) zeroBasedDayOfTheWeek
                    maxNumberOfDoses: (NSNumber *) maxNumberOfDoses
{
    id result = [[self alloc] initWithSchedule: schedule
                                  dayOfTheWeek: zeroBasedDayOfTheWeek
                              maxNumberOfDoses: maxNumberOfDoses];

    return result;
}

- (id) initWithSchedule: (XZBaseMedicationWeeklySchedule *) schedule
           dayOfTheWeek: (NSNumber *) zeroBasedDayOfTheWeek
       maxNumberOfDoses: (NSNumber *) maxNumberOfDoses
{
    self = [super init];

    if (self)
    {
        self.schedule = schedule;
        self.zeroBasedDayOfTheWeek = zeroBasedDayOfTheWeek;
        self.dosesTakenSoFar = 0;
        self.maxNumberOfDoses = maxNumberOfDoses;
    }

    return self;
}

- (XZBaseMedicationDosageTaken *) takeDoseNowAndSave
{
    XZBaseMedicationDosageTaken *dosageTaken = [XZBaseMedicationDosageTaken dosageTakenNowForSchedule: self.schedule];

    self.dosesTakenSoFar = @(self.dosesTakenSoFar.integerValue + 1);

    [dosageTaken save];

    return dosageTaken;
}

- (NSString *) description
{
    NSString *result = [NSString stringWithFormat: @"Lozenge { color: %@, dayOfWeek: %@, dosesSoFar: %d, maxDoses: %d, isComplete: %@ }",
                        self.schedule.color,
                        self.zeroBasedDayOfTheWeek,
                        self.dosesTakenSoFar.intValue,
                        self.maxNumberOfDoses.intValue,
                        self.isComplete ? @"YES" : @"NO"
                        ];

    return result;
}

@end







