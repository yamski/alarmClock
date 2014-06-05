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
#import "ACATweetVC.h"

#import "ACAalarmData.h"

@interface ACAViewController () <ACAalarmSwipeDelegate, UIGestureRecognizerDelegate>

@end

@implementation ACAViewController
{
    ACAalarmsTVC * alarmsTVC;
    ACATweetVC * tweetVC;
    ACAtimeButton * alarmLabel;
    
    ACAamPM * amPM;
    UIButton * alarmToggle;
    
    NSDate * alarmTimeNoDay;
    NSDate * alarmTime;
    NSDate * now;
    NSDateFormatter * formatter;
    NSDateFormatter * amPMFormat;
    
    NSCalendar * calendar;
    NSDateComponents * components;
    
    CGPoint prevLocation;
    CGPoint location;
    
    UIView * menu;
    
    ACAalarmSwipe * timeScroll;
    
    ACAmainButtons * options;
    
    float currentVal;
    
    UISwipeGestureRecognizer * swipeTVC;
    UISwipeGestureRecognizer * swipeTweet;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        currentVal = [UIScreen mainScreen].brightness;
        
        CAGradientLayer *bgLayer = [ACAbgLayer blueGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        
        
        calendar = [NSCalendar currentCalendar];
        now = [NSDate date];
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"h:mm"];
        
        amPMFormat = [[NSDateFormatter alloc] init];
        [amPMFormat setDateFormat:@"a"];
        
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
        ///
        ////
        swipeTVC = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        swipeTVC.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeTVC];
        
        swipeTweet = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        swipeTweet.direction = UISwipeGestureRecognizerDirectionRight;
        
        swipeTweet.delegate = self;
        
        [self.view addGestureRecognizer:swipeTweet];
        
        timeScroll = [[ACAalarmSwipe alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        timeScroll.delegate = self;
        
        alarmsTVC = [[ACAalarmsTVC alloc] initWithStyle:UITableViewStylePlain];
        alarmsTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:alarmsTVC.view];
        
//        self.alarmStatus = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 20, SCREEN_HEIGHT - 60, 40, 40)];
//        self.alarmStatus.layer.cornerRadius = 20;
//        self.alarmStatus.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
//        
//        [self.view addSubview:self.alarmStatus];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    int buttonWidth = 80;
//    
//    options = [[ACAmainButtons alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (buttonWidth/2), SCREEN_HEIGHT - 50, buttonWidth, 40)];
//    [options setTitle:@"Options" forState:UIControlStateNormal];
//    [options addTarget:self action:@selector(popup) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:options];
//    
//    
//    alarmToggle = [[ACAmainButtons alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (buttonWidth/2) - (buttonWidth + 20), SCREEN_HEIGHT - 50, buttonWidth, 40)];
//    [alarmToggle setTitle:@"Alarm Off" forState:UIControlStateNormal];
//    [alarmToggle addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:alarmToggle];
//    
//    
//    ACAmainButtons * test = [[ACAmainButtons alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (buttonWidth/2) + (buttonWidth + 20), SCREEN_HEIGHT - 50, buttonWidth, 40)];
//    [test setTitle:@"Test" forState:UIControlStateNormal];
//    [test addTarget:self action:@selector(savedData) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:test];
//    

}


- (void) swipeLeft:(UISwipeGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.5 animations:^{
        alarmsTVC.view.frame = CGRectMake(0, 0,  SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void) swipeRight:(UISwipeGestureRecognizer *)gesture
{
    if(!tweetVC.view.superview)
    {
        tweetVC = [[ACATweetVC alloc]init];
        tweetVC.view.frame = CGRectMake(0-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:tweetVC.view];
        
        [UIView animateWithDuration:0.5 animations:^{
            tweetVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}


- (void)setAlarmTime
{
    swipeTVC.enabled = NO;
    
    swipeTweet.enabled = NO;
    
    [alarmLabel addTarget:self action:@selector(savedData) forControlEvents:UIControlEventTouchUpInside];

    [self.view insertSubview:timeScroll belowSubview:alarmLabel];
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        alarmLabel.backgroundColor = [UIColor colorWithRed:0.898f green:0.996f blue:0.412f alpha:1.0f];
        
        [alarmLabel setTitleColor:[UIColor colorWithRed:0.231f green:0.427f blue:0.506f alpha:1.0f] forState:UIControlStateNormal];
        
    } completion:nil];
}

//- (void)popup
//{
//    if (!self.popUpToggle) {
//        self.popUpToggle = !self.popUpToggle;
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            menu.frame = CGRectMake(0, 170, SCREEN_WIDTH, SCREEN_HEIGHT - 170);
//            
//            UIButton * saveOptions = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 40)];
//            saveOptions.backgroundColor = [UIColor clearColor];
//            [saveOptions setTitle:@"Save" forState:UIControlStateNormal];
//            saveOptions.titleLabel.textColor = [UIColor blueColor];
//            
//            [saveOptions addTarget:self action:@selector(popup) forControlEvents:UIControlEventTouchUpInside];
//            [menu addSubview:saveOptions];
//            
//        } completion:nil];
//    } else
//    {
//         self.popUpToggle = !self.popUpToggle;
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            menu.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 170);
//            
//        }completion:nil];
//    }
//}


- (void)updateAlarm:(NSTimeInterval)interval
{
    [formatter setDateFormat:@"h:mm  a"];
    
    alarmTime = [NSDate dateWithTimeIntervalSinceNow:interval];
  
    [alarmLabel setTitle:[formatter stringFromDate:alarmTime] forState:UIControlStateNormal];
    amPM.text = [amPMFormat stringFromDate:alarmTime];
    
    
    int flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents* hrMinComp = [calendar components:flags fromDate:alarmTime];
    
    alarmTimeNoDay = [calendar dateFromComponents:hrMinComp];
    
}


- (void) savedData
{
    swipeTweet.enabled = YES;
    
    [alarmLabel removeTarget:self action:@selector(savedData) forControlEvents:UIControlEventTouchUpInside];
    [alarmLabel addTarget:self action:@selector(setAlarmTime) forControlEvents:UIControlEventTouchUpInside];

    [timeScroll removeFromSuperview];
    
    swipeTVC.enabled = YES;
    
    // animating yellow label
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        alarmLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        
        [alarmLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } completion:nil];
    ///
    
    self.alarmStatus.backgroundColor = [UIColor colorWithRed:0.235f green:0.878f blue:0.388f alpha:1.0f];

    // LOCAL NOTIFICATIONS
    UILocalNotification * wakeUp = [[UILocalNotification alloc] init];
    
    wakeUp.fireDate = alarmTime;
    wakeUp.timeZone = [NSTimeZone localTimeZone];
    wakeUp.alertBody = @"It's time to wake up!";
    wakeUp.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:wakeUp];
    
    //[[UIApplication sharedApplication] cancelLocalNotification:wakeUp];
    
    // CREATING DICTIONARY AND ADDING TO ARRAY
    
    NSString * formattedTime = [formatter stringFromDate:alarmTimeNoDay];

    NSMutableDictionary * timeKey = [@{
               @"NSDate": alarmTime,
               @"NSDateNoDay": alarmTimeNoDay,
               @"NSString": formattedTime,
               @"Notification": wakeUp,
               } mutableCopy];
    
    [[ACAalarmData maindata].alarmList addObject:timeKey];
    
    NSSortDescriptor *sortByDateAscending = [NSSortDescriptor sortDescriptorWithKey:@"NSDateNoDay" ascending:YES];
    NSMutableArray *descriptors = [[NSMutableArray  arrayWithObject:sortByDateAscending] mutableCopy];
    
    [ACAalarmData maindata].sortedTimes = [[[ACAalarmData maindata].alarmList sortedArrayUsingDescriptors:descriptors] mutableCopy];
    
    [alarmsTVC.tableView reloadData];

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
    
    if (location.y - prevLocation.y > 5) {

        currentVal = currentVal - .05;
       
        [[UIScreen mainScreen] setBrightness: currentVal];
        
        prevLocation = location;
    }
    
    if (location.y - prevLocation.y < - 5){
        
        currentVal = currentVal + .05;
        
        [[UIScreen mainScreen] setBrightness:currentVal];
        
        prevLocation = location;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
