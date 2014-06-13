//
//  ACAalarmData.h
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACAalarmData : NSObject

+ (ACAalarmData *)maindata;

@property (nonatomic) NSMutableArray * alarmList;
@property (nonatomic) NSMutableArray * sortedTimes;

@end
