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
    
   // _alarmList = [@[@"2:30", @"5:30", @"12:30", @"4:30", @"10:45"] mutableCopy];
    return _alarmList;
}

- (NSMutableArray *)sortedTimes{
    if (_sortedTimes == nil) {
        _sortedTimes = [@[] mutableCopy];
    }
    return _sortedTimes;
}
@end
