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
#import "ACAmainButtons.h"
#import "ACAalarmsTVC.h"

#import "ACAalarmData.h"



@interface ACAViewController () <ACAalarmSwipeDelegate>

@end

@implementation ACAViewController
{
    ACAalarmsTVC * alarmsTVC;
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
    
    ACAmainButtons * options;
    
    float currentVal;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        currentVal = [UIScreen mainScreen].brightness;
        
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
        menu.backgroundColor = [UIColor colorWithRed:0.890f green:1.000f blue:0.980f alpha:1.0f];
        
        [self.view addSubview:menu];
        
        UISwipeGestureRecognizer * swipeTVC = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:nil];
        swipeTVC.direction = UISwipeGestureRecognizerDirectionLeft;
        [swipeTVC addTarget:self action:@selector(swipe:)];
        [self.view addGestureRecognizer:swipeTVC];
        
        
        [[ACAalarmData maindata].alarmList addObject:@"added object"];
        
        NSLog(@"my singleton contatins: %@",[ACAalarmData maindata].alarmList);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int buttonWidth = 80;
    
    options = [[ACAmainButtons alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (buttonWidth/2), SCREEN_HEIGHT - 50, buttonWidth, 40)];
    [options setTitle:@"Options" forState:UIControlStateNormal];
    [options addTarget:self action:@selector(popup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:options];
    
    
    alarmToggle = [[ACAmainButtons alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (buttonWidth/2) - (buttonWidth + 20), SCREEN_HEIGHT - 50, buttonWidth, 40)];
    [alarmToggle setTitle:@"Alarm Off" forState:UIControlStateNormal];
    [alarmToggle addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alarmToggle];
    
    
    ACAmainButtons * test = [[ACAmainButtons alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (buttonWidth/2) + (buttonWidth + 20), SCREEN_HEIGHT - 50, buttonWidth, 40)];
    [test setTitle:@"Test" forState:UIControlStateNormal];
    [test addTarget:self action:@selector(showTable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test];
    
    alarmsTVC = [[ACAalarmsTVC alloc] initWithStyle:UITableViewStylePlain];
    alarmsTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:alarmsTVC.view];
    
    
}

- (void) swipe:(UISwipeGestureRecognizer *)gesture
{
    NSLog(@"%@",gesture);
    
    NSLog(@"%d", (int)gesture.direction);
    
    [self showTable];
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

//- (void)alarmSwitchToggle
//{
//
//    self.alarmSettable = !self.alarmSettable;
//}

- (void)showTable
{
    [self.navigationController pushViewController:alarmsTVC animated:YES];
    
//    [UIView animateWithDuration:.25 animations:^{
//        alarmsTVC.view.frame = CGRectMake(10, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } ];
    
}

- (void)setAlarmTime
{
    //[self alarmSwitchToggle];
    
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
            
            UIButton * saveOptions = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 40)];
            saveOptions.backgroundColor = [UIColor clearColor];
            [saveOptions setTitle:@"Save" forState:UIControlStateNormal];
            saveOptions.titleLabel.textColor = [UIColor blueColor];
            
            [saveOptions addTarget:self action:@selector(popup) forControlEvents:UIControlEventTouchUpInside];
            [menu addSubview:saveOptions];
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    prevLocation = [touch locationInView:self.view];

}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    location = [touch locationInView:self.view];

    
    if (location.y - prevLocation.y > 10) {
        
        NSLog(@"swiping down");
        
        currentVal = currentVal - .05;
       
        [[UIScreen mainScreen] setBrightness: currentVal];
        
       // currentVal = [UIScreen mainScreen].brightness;
        
        NSLog(@"%f",[UIScreen mainScreen].brightness);
        
        prevLocation = location;
    }
    
    if (location.y - prevLocation.y < - 10){
        
        NSLog(@"swiping up");
        
        currentVal = currentVal + .05;
        
        [[UIScreen mainScreen] setBrightness:currentVal];
        
        //currentVal = [UIScreen mainScreen].brightness;
         NSLog(@"%f",[UIScreen mainScreen].brightness);
        
        prevLocation = location;
     
    }
}

- (void) alarmSet
{
    if (self.alarmActive == YES){
    
        UILocalNotification * wakeUp = [[UILocalNotification alloc] init];
        wakeUp.fireDate = alarmTime;
        
        wakeUp.timeZone = [NSTimeZone localTimeZone];
        wakeUp.alertBody = @"Eat your Wheaties";
        wakeUp.repeatInterval = NSDayCalendarUnit;
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
