//
//  ACATVCell.m
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACATVCell.h"
#import "ACAalarmData.h"
#import "MOVE.h"

@implementation ACATVCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.allowSwipe = YES;
        self.alarmActive = YES;
        self.backgroundColor = [UIColor colorWithRed:0.824f green:0.898f blue:0.855f alpha:1.0f];
        
        self.timesButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 270, 0, 270, 125)];
        self.timesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.timesButton.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
        self.timesButton.titleLabel.textColor = [UIColor grayColor];
        self.timesButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
        
        [self.timesButton addTarget:self action:@selector(activateTime) forControlEvents:UIControlEventTouchUpInside];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timesButton];
        
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCell:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.timesButton addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCell:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.timesButton addGestureRecognizer:swipeRight];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -130, 0, 130, 125)];
        self.deleteButton.backgroundColor = [UIColor colorWithRed:0.729f green:0.373f blue:0.349f alpha:1.0f];
        [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        
        [self.deleteButton addTarget:self action:@selector(pressingDelete) forControlEvents:UIControlEventTouchUpInside];
        
        [self selectedAlarmTime];
       
    }
    return self;
}



- (void) swipeCell:(UISwipeGestureRecognizer *)gesture
{
    if(gesture.direction == 2 && self.allowSwipe == YES) {
        
        [MOVE animateView:self.timesButton properties:@{@"x": @-80, @"duration": @0.3}];
        [self.contentView addSubview:self.deleteButton];
    }
    if(gesture.direction == 1 && self.allowSwipe == YES){
        
        [MOVE animateView:self.timesButton properties:@{@"x": @50, @"duration": @0.3}];
        [self.deleteButton removeFromSuperview];
    }
}


- (void) selectedAlarmTime
{
    if (self.alarmActive == YES) {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.timesButton.backgroundColor = [UIColor colorWithRed:0.235f green:0.878f blue:0.388f alpha:1.0f];
            
        } completion:^(BOOL finished) {
            self.alarmActive = NO;
            self.allowSwipe = NO;
        }];
    } else {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.timesButton.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
            
        } completion:^(BOOL finished) {
            self.alarmActive = YES;
            self.allowSwipe = YES;
        }];
    }
}

- (void)pressingDelete
{
    [self.delegate deleteCell: self];
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
    NSDate * now = [NSDate date];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    NSCalendarUnit units = NSDayCalendarUnit;
    
    components = [calendar components:units fromDate:now];
    
    NSInteger currentDay = [components day] - 1;
    
    NSLog(@"current day of the month is %d", currentDay);
    
    //
    
    NSDate * alarmTime = [ACAalarmData maindata].alarmList[self.index][@"NSDateNoDay"];
    NSDateComponents * alarmComponents = [[NSDateComponents alloc] init];
    [alarmComponents setDay:currentDay];
 
    NSDate * newAlarmTime = [calendar dateByAddingComponents:alarmComponents toDate:alarmTime options:0];
   
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"d h:mm a"];
    
    NSLog(@"new alarm time is %@",[formatter stringFromDate:newAlarmTime]);
   
    NSDate * completeAlarmTime;
    
    if ([newAlarmTime compare: now] != NSOrderedAscending) {
    
        NSDateComponents *oneDay = [[NSDateComponents alloc] init];
        [oneDay setDay: 1];
        
        completeAlarmTime = [calendar dateByAddingComponents:oneDay toDate:newAlarmTime options:0];
        
    } else {
        completeAlarmTime = newAlarmTime;
    }

         NSLog(@"complete alarm time is %@",[formatter stringFromDate:completeAlarmTime]);
    
    NSLog(@"%@", [ACAalarmData maindata].sortedTimes);
    
//    UILocalNotification * wakeUp = [[UILocalNotification alloc] init];
//    
//    wakeUp.fireDate = newAlarmTime;
//    wakeUp.timeZone = [NSTimeZone localTimeZone];
//    wakeUp.alertBody = @"It's time to wake up!";
//    wakeUp.soundName = UILocalNotificationDefaultSoundName;

//    [[UIApplication sharedApplication] scheduleLocalNotification:wakeUp];
    
}

@end
