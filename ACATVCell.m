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
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.alarmActive = YES;
        self.backgroundColor = [UIColor colorWithRed:0.824f green:0.898f blue:0.855f alpha:1.0f];
        
        self.bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        [self.contentView addSubview:self.bgLabel];
        
        self.timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 230, 0, 200, 100)];

        self.timesLabel.textAlignment = NSTextAlignmentRight;
        self.timesLabel.textColor = [UIColor grayColor];
        self.timesLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:42];
        
        [self.contentView addSubview: self.timesLabel];
        
        
        
        self.activateButton = [[UIButton alloc] initWithFrame: CGRectMake(20, 30, 40, 40)];
        
        self.activateButton.layer.cornerRadius = 20;
        
        self.activateButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        
        [self.activateButton addTarget:self action:@selector(selectedAlarmTime) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.activateButton];
        
        
    }
    return self;
}


- (void) selectedAlarmTime
{
    NSLog(@"method ran");
    
    if (!self.alarmActive) {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.bgLabel.backgroundColor = [UIColor colorWithRed:0.235f green:0.878f blue:0.388f alpha:1.0f];
            
            
        } completion:^(BOOL finished) {
            
            [self activateTime];
            
            self.alarmActive = YES;
            
            NSLog(@"alarm is active");
            
            [self.delegate talktoTVC:1];
            
        }];
    } else {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.bgLabel.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
            
            
        } completion:^(BOOL finished) {
            
            NSLog(@"canceling alarm");
            
            [[ACAalarmData maindata].sortedTimes[self.index] removeObjectForKey:@"Notification"];
            
            NSLog(@"%@",[ACAalarmData maindata].sortedTimes[self.index][@"Notification"]);
            
            self.alarmActive = NO;
          
            [self.delegate talktoTVC:2];
            

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
