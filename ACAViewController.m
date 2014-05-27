//
//  ACAViewController.m
//  alarmClock
//
//  Created by JOHN YAM on 5/26/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAViewController.h"
#import "ACAalarmLabel.h"

#import "ACAbgLayer.h"


@interface ACAViewController ()

@end

@implementation ACAViewController
{
    int day;
    int hour;
    int min;
    int sec;
    
    ACAalarmLabel * alarmLabel;
    UIButton * alarmToggle;
    
    NSDate * alarmTime;
    NSDate * now;
    NSDateFormatter * formatter;
    
    
    CGPoint prevLocation;
    CGPoint location;
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
        
        //[formatter setDateStyle:NSDateFormatterShortStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        [formatter setLocale:<#(NSLocale *)#>];
//        [formatter setTimeZone:<#(NSTimeZone *)#>];
        
        NSString * formattedDate = [formatter stringFromDate:now];
        
        NSLog(@"%@",formattedDate);
        
        
        alarmTime = now;
        
        alarmLabel = [[ACAalarmLabel alloc] initWithFrame:CGRectMake(20, 20, 300, 150)];
        
        alarmLabel.text = [formatter stringFromDate:alarmTime];
        
        [self.view addSubview:alarmLabel];

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

- (void)updateAlarm
{
    [alarmLabel removeFromSuperview];
    
    NSCalendar * calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * components = [[NSDateComponents alloc] init];
    
    [components setHour:hour];
    [components setMinute:min];
    
    alarmTime = [calender dateByAddingComponents:components toDate:now options:0];
    
    alarmLabel.text = [formatter stringFromDate:alarmTime];

    [self.view addSubview:alarmLabel];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    location = [touch locationInView:self.view];
//    CGPoint prevLocation = [touch previousLocationInView:self.view];

    if (location.x - prevLocation.x > 50) {
        
        NSLog(@"swiping right");
        hour = hour + 1;
        
        prevLocation = location;
        
    } else if (location.x - prevLocation.x + 10 < -50) {
        
        NSLog(@"swiping left");
        
        hour = hour - 1;
        
        prevLocation = location;
    }
    
    
    if (location.y - prevLocation.y > 20) {
        
        NSLog(@"swiping up");
        min = min - 1;
        
        prevLocation = location;
    }
    
    if (location.y - prevLocation.y < -20){
        
        NSLog(@"swiping down");
        
        min = min + 1;
        
        prevLocation = location;
    }
    
  
    [self updateAlarm];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    location = [touch locationInView:self.view];
    prevLocation = location;
}

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
