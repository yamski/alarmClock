//
//  ACATVCell.m
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACATVCell.h"
#import "ACAalarmData.h"

@implementation ACATVCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.allowSwipe = YES;
        self.alarmActive = YES;
        self.backgroundColor = [UIColor colorWithRed:0.824f green:0.898f blue:0.855f alpha:1.0f];
        
        self.timesButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 240, 0, 240, 125)];
        //self.timesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
        self.timesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        //self.timesButton.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
        self.timesButton.titleLabel.textColor = [UIColor grayColor];
        self.timesButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
        
        
        self.activateButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH - 240, 125)];
        self.activateButton.backgroundColor = [UIColor colorWithRed:0.898f green:0.996f blue:0.412f alpha:1.0f];
        
        [self.activateButton addTarget:self action:@selector(selectedAlarmTime) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.activateButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timesButton];
        
        
        
      // [self selectedAlarmTime];
       
    }
    return self;
}


- (void) selectedAlarmTime
{
    if (!self.alarmActive) {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.timesButton.backgroundColor = [UIColor colorWithRed:0.235f green:0.878f blue:0.388f alpha:1.0f];
            
        } completion:^(BOOL finished) {
            
            [self activateTime];
            
            self.alarmActive = YES;
            self.allowSwipe = NO;
            
            NSLog(@"alarm is active");
            
        }];
    } else {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.timesButton.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
            
        } completion:^(BOOL finished) {
            
            NSLog(@"canceling alarm");
//            
//            UILocalNotification * canceledNotification = [ACAalarmData maindata].sortedTimes[self.index][@"Notification"];
//            [[UIApplication sharedApplication] cancelLocalNotification:canceledNotification];
            
            
            [[ACAalarmData maindata].sortedTimes[self.index] removeObjectForKey:@"Notification"];
            
            NSLog(@"%@",[ACAalarmData maindata].sortedTimes[self.index][@"Notification"]);
            
            
            self.alarmActive = NO;
            self.allowSwipe = YES;
        }];
    }
}



- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    [self setNeedsDisplay];
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) activateTime
{
    NSLog(@"activating alarm");
    NSDate * alarmTime = [ACAalarmData maindata].sortedTimes[self.index][@"NSDateNoDay"];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    NSCalendarUnit units = NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    components = [calendar components:units fromDate:alarmTime];
    
    NSInteger hrs = [components hour];
    NSInteger mins = [components minute];
    
    
    NSDate * now = [NSDate date];
    NSDateComponents * nowComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [nowComponents setHour:hrs];
    [nowComponents setMinute:mins];
    
    
    NSDate * newAlarmTime = [calendar dateFromComponents:nowComponents];

    ///
//    NSLog(@"activating alarm");
//    
//    NSDate * now = [NSDate date];
//    
//    NSCalendar * calendar = [NSCalendar currentCalendar];
//    NSDateComponents * components = [[NSDateComponents alloc] init];
//    NSCalendarUnit units = NSDayCalendarUnit;
//    
//    components = [calendar components:units fromDate:now];
//    
//    NSInteger currentDay = [components day] - 1;
//    
//    NSLog(@"current day of the month is %d", currentDay);
//    
//    //
//    
//    NSDate * alarmTime = [ACAalarmData maindata].sortedTimes[self.index][@"NSDateNoDay"];
//    
//    
//    NSDateComponents * alarmComponents = [[NSDateComponents alloc] init];
//    [alarmComponents setDay:currentDay];
// 
//    NSDate * newAlarmTime = [calendar dateByAddingComponents:alarmComponents toDate:alarmTime options:0];
   
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"d h:mm a"];
    
    NSLog(@"original alarm time is %@", [formatter stringFromDate:alarmTime]);
    
    NSLog(@"new alarm time is %@",[formatter stringFromDate:newAlarmTime]);
    
   
    NSDate * completeAlarmTime;

    if ([newAlarmTime compare: now] != NSOrderedDescending) {
    
        NSDateComponents *oneDay = [[NSDateComponents alloc] init];
        [oneDay setDay: 1];
        
        completeAlarmTime = [calendar dateByAddingComponents:oneDay toDate:newAlarmTime options:0];
        
    } else {
        completeAlarmTime = newAlarmTime;
    }

    
    NSLog(@"complete alarm time is %@",[formatter stringFromDate:completeAlarmTime]);
    
    //
    UILocalNotification * wakeUp = [[UILocalNotification alloc] init];
    wakeUp.fireDate = completeAlarmTime;
    wakeUp.timeZone = [NSTimeZone localTimeZone];
    wakeUp.alertBody = @"It's time to wake up!";
    wakeUp.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:wakeUp];
    
    [[ACAalarmData maindata].sortedTimes[self.index]setObject:wakeUp forKey:@"Notification"];
    
    NSLog(@"HERE ARE ALL OF YOUR DICTIONARIES:%@", [ACAalarmData maindata].sortedTimes);
    
}

@end
