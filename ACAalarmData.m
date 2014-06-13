//
//  ACAalarmData.m
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAalarmData.h"

@implementation ACAalarmData

+ (ACAalarmData *)maindata
{
    static  dispatch_once_t create;
    static ACAalarmData * alarmData = nil;
    
    dispatch_once(&create, ^{
        alarmData = [[ACAalarmData alloc] init];
    });
    
    return alarmData;
}


-(NSMutableArray *)alarmList
{
    if (_alarmList == nil) {
        _alarmList = [@[] mutableCopy];
    }
    
    NSSortDescriptor *sortByDateAscending = [NSSortDescriptor sortDescriptorWithKey:@"NSDateNoDay" ascending:YES];
    NSMutableArray *descriptors = [[NSMutableArray  arrayWithObject:sortByDateAscending] mutableCopy];
    
    _alarmList = [[_alarmList sortedArrayUsingDescriptors:descriptors] mutableCopy];
    
    return _alarmList;
}

- (NSMutableArray *)sortedTimes{
    
    return [self.alarmList copy];
}

@end

