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
    
    UISwipeGestureRecognizer * swipeTVC;
    
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
        
        
        // alarm time
        alarmTime = now;
        alarmLabel = [[ACAtimeButton  alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 130)];

        [alarmLabel setTitle:[formatter stringFromDate:alarmTime] forState:UIControlStateNormal];
        
        [alarmLabel addTarget:self action:@selector(setAlarmTime) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:alarmLabel];
        //
        
        amPM =  [[ACAamPM alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 135, 80, 40)];
        amPM.text = [amPMFormat stringFromDate:alarmTime];
    
        [self.view addSubview:amPM];
        
        menu = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 170)];
        menu.backgroundColor = [UIColor colorWithRed:0.890f green:1.000f blue:0.980f alpha:1.0f];
        
        [self.view addSubview:menu];
        
        swipeTVC = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipeTVC.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeTVC];
        
        timeScroll = [[ACAalarmSwipe alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        timeScroll.delegate = self;

        //self.alarmSettable = YES;
        //NSLog(@"the value is %d", self.alarmSettable);
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
    [test addTarget:self action:@selector(savedData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test];
    
    alarmsTVC = [[ACAalarmsTVC alloc] initWithStyle:UITableViewStylePlain];
    alarmsTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:alarmsTVC.view];
    
}

- (void) swipe:(UISwipeGestureRecognizer *)gesture
{
    [self.navigationController pushViewController:alarmsTVC animated:YES];
}

- (void)setPopUpToggle:(BOOL)popUpToggle
{
    _popUpToggle = popUpToggle;
    
    popUpToggle = !popUpToggle;
}


//- (void)setAlarmSettable:(BOOL)alarmSettable
//{
//    _alarmSettable = alarmSettable;
//    
//    alarmSettable = !alarmSettable;
//}



//- (void)alarmSwitchToggle
//{
//
//    self.alarmSettable = !self.alarmSettable;
//}



- (void)setAlarmTime
{
    //[self alarmSwitchToggle];
    
        swipeTVC.enabled = NO;
        [alarmLabel addTarget:self action:@selector(savedData) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view insertSubview:timeScroll belowSubview:alarmLabel];
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        alarmLabel.backgroundColor = [UIColor colorWithRed:0.898f green:0.996f blue:0.412f alpha:1.0f];
        
        [alarmLabel setTitleColor:[UIColor colorWithRed:0.231f green:0.427f blue:0.506f alpha:1.0f] forState:UIControlStateNormal];
        
    } completion:nil];
    
}

- (void)popup
{
    NSLog(@"pop up toggle");
    
    
    if (!self.popUpToggle) {
        self.popUpToggle = !self.popUpToggle;
        
        [UIView animateWithDuration:0.5 animations:^{
            menu.frame = CGRectMake(0, 170, SCREEN_WIDTH, SCREEN_HEIGHT - 170);
            
            UIButton * saveOptions = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 40)];
            saveOptions.backgroundColor = [UIColor clearColor];
            [saveOptions setTitle:@"Save" forState:UIControlStateNormal];
            saveOptions.titleLabel.textColor = [UIColor blueColor];
            
            [saveOptions addTarget:self action:@selector(popup) forControlEvents:UIControlEventTouchUpInside];
            [menu addSubview:saveOptions];
            
        } completion:^(BOOL finished) {
            nil;
        }];
    } else
    {
         self.popUpToggle = !self.popUpToggle;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            menu.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 170);
            
        }completion:^(BOOL finished) {
            nil;
        }];
    }
    
}

//- (void)onOff
//{
//    self.alarmActive = !self.alarmActive;
//    
//    if (!self.alarmActive) {
//        [self alarmSet];
//        
//        alarmToggle.backgroundColor = [UIColor greenColor];
//        
//        NSLog(@"alarm is on");
//        
//    } else
//    {
//        alarmToggle.backgroundColor = [UIColor redColor];
//        NSLog(@"alarm is off");
//    };
//}

- (void)updateAlarm:(int)hour :(int)min
{
//    [alarmLabel removeFromSuperview];
//    [amPM removeFromSuperview];
    
    NSCalendar * calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * components = [[NSDateComponents alloc] init];
    
    [components setHour:hour];
    [components setMinute:min];
    
    [formatter setDateFormat:@"h:mm"];
    
    alarmTime = [calender dateByAddingComponents:components toDate:now options:0];
    
    [alarmLabel setTitle:[formatter stringFromDate:alarmTime] forState:UIControlStateNormal];
    amPM.text = [amPMFormat stringFromDate:alarmTime];

//    [self.view addSubview:alarmLabel];
//    [self.view addSubview:amPM];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    prevLocation = [touch locationInView:self.view];

}

- (void) savedData
{
    [alarmLabel addTarget:self action:@selector(setAlarmTime) forControlEvents:UIControlEventTouchUpInside];

    
    [[ACAalarmData maindata].alarmList addObject:alarmTime];
    
    [alarmsTVC.tableView reloadData];
    
    NSLog(@"%@ has been saved", [ACAalarmData maindata].alarmList);
    
    
    NSString * formattedTime = [formatter stringFromDate:alarmTime];
    
    [[ACAalarmData maindata].formattedAlarm addObject:formattedTime];
    

    NSLog(@"%@ has been formatted", [ACAalarmData maindata].formattedAlarm);
    
    
    /////
    
    [timeScroll removeFromSuperview];
    
    swipeTVC.enabled = YES;
    
    [alarmLabel addTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        alarmLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        
        [alarmLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
//        timeScroll.alpha = 0;
        
    } completion:nil];
    
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
