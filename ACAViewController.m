//
//  ACAViewController.m
//  alarmClock
//
//  Created by JOHN YAM on 5/26/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAViewController.h"
#import "ACAalarmLabel.h"
#import "ACAtimeButton.h"

#import "ACAbgLayer.h"
#import "ACAamPM.h"
#import "ACAalarmSwipe.h"



@interface ACAViewController () <ACAalarmSwipeDelegate>

@end

@implementation ACAViewController
{

    ACAtimeButton * alarmLabel;
    ACAamPM * amPM;
    UIButton * alarmToggle;
    
    NSDate * alarmTime;
    NSDate * now;
    NSDateFormatter * formatter;
    NSDateFormatter * amPMFormat;
    
    CGPoint prevLocation;
    CGPoint location;
    
    UIView * menu;
    
    ACAalarmSwipe * timeScroll;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CAGradientLayer *bgLayer = [ACAbgLayer blueGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        now = [NSDate date];
        
        formatter = [[NSDateFormatter alloc] init];

        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setDateFormat:@"h:mm"];
        
        amPMFormat = [[NSDateFormatter alloc] init];
        [amPMFormat setDateFormat:@"a"];
        
        NSString * formattedDate = [formatter stringFromDate:now];
        
        NSLog(@"%@",formattedDate);
        
        
        alarmTime = now;
        alarmLabel = [[ACAtimeButton  alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 130)];

        [alarmLabel setTitle:[formatter stringFromDate:alarmTime] forState:UIControlStateNormal];
        
        [alarmLabel addTarget:self action:@selector(setAlarmTime) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:alarmLabel];
        
        amPM =  [[ACAamPM alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 135, 80, 40)];
        amPM.text = [amPMFormat stringFromDate:alarmTime];
    
        [self.view addSubview:amPM];
        
        menu = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 170)];
        menu.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self.view addSubview:menu];
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    alarmToggle = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60, 40, 40)];
    alarmToggle.backgroundColor = [UIColor redColor];
    alarmToggle.layer.cornerRadius = 20;
    [alarmToggle addTarget:self action:@selector(onOff) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alarmToggle];
}

- (void)setPopUpToggle:(BOOL)popUpToggle
{
    _popUpToggle = popUpToggle;
    
    popUpToggle = !popUpToggle;
}


- (void)setAlarmSettable:(BOOL)alarmSettable
{
    _alarmSettable = alarmSettable;
    
    alarmSettable = !alarmSettable;
}


- (void)setAlarmTime
{
    if (!self.alarmSettable) {
        
        [UIView animateWithDuration:1.5 animations:^{
            
            alarmLabel.backgroundColor = [UIColor colorWithRed:0.898f green:0.996f blue:0.412f alpha:1.0f];
            
            [alarmLabel setTitleColor:[UIColor colorWithRed:0.231f green:0.427f blue:0.506f alpha:1.0f] forState:UIControlStateNormal];
            
            timeScroll = [[ACAalarmSwipe alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            timeScroll.delegate = self;
            
            [self.view addSubview:timeScroll];
            
        } ];
    } else
    {
        [UIView animateWithDuration:1.5 animations:^{
            
            alarmLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
            
            [alarmLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [timeScroll removeFromSuperview];
            
        }];
    }
    
    self.alarmSettable = !self.alarmSettable;
    
}

- (void)popup
{
    NSLog(@"pop up toggle");
    
    if (!self.popUpToggle) {
        [UIView animateWithDuration:0.5 animations:^{
            menu.frame = CGRectMake(0, 170, SCREEN_WIDTH, SCREEN_HEIGHT - 170);
        }];
    } else if (self.popUpToggle)
    {
        [UIView animateWithDuration:0.5 animations:^{
            menu.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 170);
        }];
    }
    
    self.popUpToggle = !self.popUpToggle;

}

- (void)onOff
{
    self.alarmActive = !self.alarmActive;
    
    if (!self.alarmActive) {
        [self alarmSet];
        
        alarmToggle.backgroundColor = [UIColor greenColor];
        
        NSLog(@"alarm is on");
        
    } else
    {
        alarmToggle.backgroundColor = [UIColor redColor];
        NSLog(@"alarm is off");
    };
}

- (void)updateAlarm:(int)hour :(int)min
{
    [alarmLabel removeFromSuperview];
    [amPM removeFromSuperview];
    
    NSCalendar * calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * components = [[NSDateComponents alloc] init];
    
    [components setHour:hour];
    [components setMinute:min];
    
    [formatter setDateFormat:@"h:mm"];
    
    
    alarmTime = [calender dateByAddingComponents:components toDate:now options:0];
    
    [alarmLabel setTitle:[formatter stringFromDate:alarmTime] forState:UIControlStateNormal];
    amPM.text = [amPMFormat stringFromDate:alarmTime];

    [self.view addSubview:alarmLabel];
    [self.view addSubview:amPM];
}


//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch * touch = [touches anyObject];
//    location = [touch locationInView:timeScroll];
//
//    if (location.x - prevLocation.x > 50) {
//        
//        NSLog(@"swiping right");
//        hour = hour + 1;
//    
//        prevLocation = location;
//        
//    } else if (location.x - prevLocation.x < -50) {
//        
//        NSLog(@"swiping left");
//        
//        hour = hour - 1;
//    
//        prevLocation = location;
//    }
//    
//    if (location.y - prevLocation.y > 20) {
//        
//        NSLog(@"swiping up");
//        min = min - 1;
//        
//        prevLocation = location;
//    }
//    
//    if (location.y - prevLocation.y < -20){
//        
//        NSLog(@"swiping down");
//        
//        min = min + 1;
//        
//        prevLocation = location;
//    }
//    
//    [self updateAlarm];
//}
//
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch * touch = [touches anyObject];
//    location = [touch locationInView:timeScroll];
//    prevLocation = location;
//}

- (void) alarmSet
{
    if (self.alarmActive == YES){
    
        UILocalNotification * wakeUp = [[UILocalNotification alloc] init];
        wakeUp.fireDate = alarmTime;
        
        wakeUp.timeZone = [NSTimeZone localTimeZone];
        wakeUp.alertBody = @"Eat your Wheaties";
        wakeUp.repeatInterval = NSDayCalendarUnit;
        wakeUp.repeatCalendar = [NSCalendar currentCalendar];
        wakeUp.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:wakeUp];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
