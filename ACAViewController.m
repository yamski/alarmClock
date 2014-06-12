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
#import "ACATVCell.h"

#import <AudioToolbox/AudioServices.h>

@interface ACAViewController () <ACAalarmSwipeDelegate, UIGestureRecognizerDelegate, ACAalarmsTVCDelegate>

@end

@implementation ACAViewController
{
    ACAalarmsTVC * alarmsTVC;
    ACATweetVC * tweetVC;
    ACAtimeButton * alarmLabel;
    
    UIButton * alarmToggle;
    
    NSDate * alarmTimeNoDay;
    NSDate * alarmTime;
    NSDate * nowNoSecs;
    NSDateFormatter * formatter;
    NSDateFormatter * amPMFormat;
    
    NSCalendar * calendar;
    NSDateComponents * components;
    
    CGPoint prevLocation;
    CGPoint location;
    
    UIView * menu;
    UIView * alarmBG;
    
    ACAalarmSwipe * timeScroll;
    
    ACAmainButtons * options;
    
    float currentVal;
    
    UISwipeGestureRecognizer * swipeTVC;
    
    //
    int volumeSetting;
    
    
    
    //
    
    
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self loadListItems];
        
        //////////////////////
        //////////////////////
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        
        NSLog(@"These are the scheduled notifications%@", eventArray);
        
        //////////////////////
        ///////////////////////
        
        currentVal = [UIScreen mainScreen].brightness;
        
        CAGradientLayer *bgLayer = [ACAbgLayer blueGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        ///
        NSDate * now = [NSDate date];
        calendar = [NSCalendar currentCalendar];
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents * noSecs = [calendar components:flags fromDate:now];
        nowNoSecs = [calendar dateFromComponents:noSecs];
        //
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"h:mm  a"];
        
        alarmLabel = [[ACAtimeButton  alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 130)];
        [alarmLabel setTitle:[formatter stringFromDate:nowNoSecs] forState:UIControlStateNormal];
        [alarmLabel addTarget:self action:@selector(setAlarmTime) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:alarmLabel];
        
        //
        
        menu = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 170)];
        menu.backgroundColor = [UIColor colorWithRed:0.890f green:1.000f blue:0.980f alpha:1.0f];
        
        [self.view addSubview:menu];
        ///
        ////
        swipeTVC = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        swipeTVC.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeTVC];
        
        timeScroll = [[ACAalarmSwipe alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        timeScroll.delegate = self;
        
        alarmsTVC = [[ACAalarmsTVC alloc] initWithStyle:UITableViewStylePlain];
        alarmsTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        alarmsTVC.delegate = self;
        
        [self.view addSubview:alarmsTVC.view];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.alarmStatus = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 20, SCREEN_HEIGHT - 60, 40, 40)];
    self.alarmStatus.layer.cornerRadius = 20;
    self.alarmStatus.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.alarmStatus.alpha = 0;
    
    [self.view addSubview:self.alarmStatus];
    
}

///////
///////
- (void)archiveData
{
    NSString *path = [self listArchivePath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[ACAalarmData maindata].sortedTimes];
    [data writeToFile:path options:NSDataWritingAtomic error:nil];
}

- (NSString *)listArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingPathComponent:@"list.data"];
}

- (void)loadListItems
{
    NSString *path = [self listArchivePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [ACAalarmData maindata].sortedTimes = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
}

/////
/////

- (void) swipeLeft:(UISwipeGestureRecognizer *)gesture
{
    [alarmsTVC.tableView reloadData];
    
    [self.navigationController pushViewController:alarmsTVC animated:YES];
}


- (void)setAlarmTime
{
    swipeTVC.enabled = NO;
    
    [alarmLabel addTarget:self action:@selector(savedData) forControlEvents:UIControlEventTouchUpInside];

    [self.view insertSubview:timeScroll belowSubview:alarmLabel];
    
    ///

    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        alarmLabel.backgroundColor = [UIColor colorWithRed:0.898f green:0.996f blue:0.412f alpha:1.0f];
        
        [alarmLabel setTitleColor:[UIColor colorWithRed:0.231f green:0.427f blue:0.506f alpha:1.0f] forState:UIControlStateNormal];
        
        self.alarmStatus.alpha = 1;
        
    } completion:^(BOOL finished) {
        nil;
    }];
}


- (void)updateAlarm:(NSTimeInterval)interval
{
    alarmTime = [nowNoSecs dateByAddingTimeInterval:interval];
    
    [alarmLabel setTitle:[formatter stringFromDate:alarmTime] forState:UIControlStateNormal];
    
    int flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents* hrMinComp = [calendar components:flags fromDate:alarmTime];
    
    alarmTimeNoDay = [calendar dateFromComponents:hrMinComp];
    
}


- (void) savedData
{
    
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
    
    self.alarmStatus.backgroundColor = [UIColor greenColor];

    // LOCAL NOTIFICATIONS
    
    NSString * alarmName = [formatter stringFromDate:alarmTime];
    
    UILocalNotification * wakeUp = [[UILocalNotification alloc] init];
    
    wakeUp.fireDate = alarmTime;
    wakeUp.timeZone = [NSTimeZone localTimeZone];
    wakeUp.alertBody = @"It's time to wake up!";
    wakeUp.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:wakeUp];
    
    
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
    
    NSLog(@"this is the alarmtime WHEN I HIT SAVE: %@",[formatter stringFromDate:alarmTime]);
    
    NSLog(@"notification: %@",wakeUp);
    
    [self archiveData];

}

- (void)statusColor: (NSInteger)num
{
    NSLog(@"status button color should change");
    
    if (num == 1) {
        
        self.alarmStatus.backgroundColor = [UIColor greenColor];
        
    } else {
        
        self.alarmStatus.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    }
    
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


- (void)showAlarmView
{
    alarmBG = [[UIView alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alarmBG.backgroundColor = [UIColor colorWithRed:0.937f green:0.863f blue:0.129f alpha:1.0f];
    [self.view addSubview:alarmBG];
    
    UILabel * alarmBGText = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 200)];
    alarmBGText.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    alarmBGText.backgroundColor = [UIColor clearColor];
    
    alarmBGText.text = @"It's about that time!";
    alarmBGText.textAlignment = NSTextAlignmentCenter;
    alarmBGText.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28];
    alarmBGText.textColor = [UIColor colorWithRed:0.525f green:0.486f blue:0.075f alpha:1.0f];
    
    [alarmBG addSubview:alarmBGText];
    
    UIButton * dismissNotif = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 20, SCREEN_HEIGHT - 60, 40, 40)];
    dismissNotif.layer.cornerRadius = 20;
    dismissNotif.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    [dismissNotif addTarget:self action:@selector(removeAlarmBG) forControlEvents:UIControlEventTouchUpInside];

    [alarmBG addSubview:dismissNotif];
    
    ////
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"song"
                                         ofType:@"mp3"]];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [self.player play];
    
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

- (void) removeAlarmBG
{
    [UIView animateWithDuration:1.0 animations:^{
        
        alarmBG.alpha = 0;
        
    } completion:^(BOOL finished) {
        [alarmBG removeFromSuperview];
        
        [self.player stop];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
