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

#import "STTwitter.h"

@interface ACAViewController () <ACAalarmSwipeDelegate, UIGestureRecognizerDelegate, ACAalarmsTVCDelegate>

@end

@implementation ACAViewController
{
    ACAalarmsTVC * alarmsTVC;
    ACATweetVC * tweetVC;
    ACAtimeButton * alarmLabel;
    
    UIButton * alarmToggle;
    
    NSDate * currentDate;
    NSDate * alarmTimeNoDay;
    NSDate * alarmTime;
    NSDate * nowNoSecs;
    NSDateFormatter * formatter;
    NSDateFormatter * amPMFormat;
    
    NSCalendar * calendar;
    NSDateComponents * components;
    NSDateComponents * noSecs;
    
    unsigned int flags;
    
    CGPoint prevLocation;
    CGPoint location;
    
    UIView * menu;
    UIView * alarmBG;
    
    ACAalarmSwipe * timeScroll;
    ACAmainButtons * options;
    
    float currentVal;
    
    UISwipeGestureRecognizer * swipeTVC;
    
    // dict that store everything for each alarm
    NSMutableDictionary * timeKey;
    NSMutableDictionary * alarmOptions;
    
    // menu vars
    NSMutableArray * songChoices;
    NSMutableArray * snoozeNotifications;
    UILocalNotification * currentNotification;
    
    int index;
    int snoozeCounter;
   
    STTwitterAPI * twitter;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       [self loadListItems];

        
        index = 0;

        //////////////////////
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        NSLog(@"These are the scheduled notifications%@", eventArray);
        ///////////////////////
        
        songChoices = [@[@"xylophone_tone.mp3", @"bells.mp3", @"cutebells.mp3", @"kbwhistle.mp3"] mutableCopy];
        
        snoozeCounter = 0;
        
        alarmOptions = [@{
                          @"Snooze": [NSNumber numberWithInt:(10 * 60)],
                          @"Song": [NSNumber numberWithInt:0],
                          @"Vibrate": [NSNumber numberWithInt:1],
                          @"Volume": [NSNumber numberWithFloat: 0.7],
                          } mutableCopy];
        //////
        
        snoozeNotifications = [@[] mutableCopy];
        ///////
        
        twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
        [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
            
            NSLog(@"success %@", username);
            
        } errorBlock:^(NSError *error) {
            
            NSLog(@"%@", error.userInfo);
        }];

        /////////

        currentVal = [UIScreen mainScreen].brightness;
        
        CAGradientLayer *bgLayer = [ACAbgLayer blueGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        calendar = [NSCalendar currentCalendar];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"h:mm  a"];

        
        currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"ss"];
        int currentTimeSeconds = [dateFormatter stringFromDate:currentDate].intValue;
        
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:60 - currentTimeSeconds];
        NSTimer *updateTimer = [[NSTimer alloc] initWithFireDate:fireDate
                                                        interval:60
                                                          target:self
                                                        selector:@selector(updateClock)
                                                        userInfo:nil
                                                         repeats:YES];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:updateTimer forMode:NSDefaultRunLoopMode];
        
        flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit;
        noSecs = [calendar components:flags fromDate:currentDate];
        nowNoSecs = [calendar dateFromComponents:noSecs];
        alarmTime = nowNoSecs;
       
        ////

        alarmLabel = [[ACAtimeButton  alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 130)];
        [alarmLabel setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
        [alarmLabel addTarget:self action:@selector(setAlarmTime) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:alarmLabel];
        
        menu = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 170)];
        menu.backgroundColor = [UIColor colorWithRed:0.890f green:1.000f blue:0.980f alpha:1.0f];
        [self.view addSubview:menu];

        swipeTVC = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        swipeTVC.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeTVC];
        
        timeScroll = [[ACAalarmSwipe alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        timeScroll.delegate = self;
        
        alarmsTVC = [[ACAalarmsTVC alloc] initWithStyle:UITableViewStylePlain];

        alarmsTVC.delegate = self;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.alarmStatus = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 20, SCREEN_HEIGHT - 60, 40, 40)];
    self.alarmStatus.layer.cornerRadius = 20;
    self.alarmStatus.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.alarmStatus.alpha = 1;
    [self.view addSubview:self.alarmStatus];
    
    [self checkActiveAlarms];
}

- (void)updateClock
{
    currentDate = [NSDate date];
    [alarmLabel setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
    
    //flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit;

    noSecs = [calendar components:flags fromDate:currentDate];
    nowNoSecs = [calendar dateFromComponents:noSecs];
    alarmTime = nowNoSecs;
    
    NSLog(@"current date %@", currentDate);
    NSLog(@"Now No Seconds %@", nowNoSecs);
    NSLog(@"ALARM TIME %@", alarmTime);
}

- (void)archiveData
{
    NSString *path = [self listArchivePath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[ACAalarmData maindata].alarmList];
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
        [ACAalarmData maindata].alarmList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
}

- (void)checkActiveAlarms
{
    UIApplication * alarmApp = [UIApplication sharedApplication];
    NSArray *notificationsList = [alarmApp scheduledLocalNotifications];
    
    if (notificationsList.count) {
        self.alarmStatus.backgroundColor = [UIColor colorWithRed:0.235f green:0.878f blue:0.388f alpha:1.0f];
    } else {
        self.alarmStatus.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    }
}

- (void)playSample: (int)num
{
    NSURL * url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], songChoices[num]]];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.currentTime = 0;
    [self.player play];
}

- (void)stopSound
{
    [self.player stop];
}

- (void) swipeLeft:(UISwipeGestureRecognizer *)gesture
{
    [alarmsTVC.tableView reloadData];
    [self.navigationController pushViewController:alarmsTVC animated:YES];
}


- (void)setAlarmTime
{
    //[self updateAlarm:0];
    
    // disabled to not interfere with swiping hrs/mins
    swipeTVC.enabled = NO;
    [alarmLabel addTarget:self action:@selector(savedData) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:timeScroll belowSubview:alarmLabel];

    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        alarmLabel.backgroundColor = GOLD;
        [alarmLabel setTitleColor:GRAY forState:UIControlStateNormal];
        self.alarmStatus.alpha = 1;
        
    } completion:^(BOOL finished) {
        nil;
    }];
}


- (void)updateAlarm:(NSTimeInterval)interval
{
    alarmTime = [nowNoSecs dateByAddingTimeInterval:interval];
    [alarmLabel setTitle:[formatter stringFromDate:alarmTime] forState:UIControlStateNormal];
}


- (void) savedData
{
    if (alarmTime == nowNoSecs) {
        return;
    }
    
    [alarmLabel removeTarget:self action:@selector(savedData) forControlEvents:UIControlEventTouchUpInside];
    [alarmLabel addTarget:self action:@selector(setAlarmTime) forControlEvents:UIControlEventTouchUpInside];

    [timeScroll removeFromSuperview];
    
    swipeTVC.enabled = YES;
    ///
    
    int hrMin = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents* hrMinComp = [calendar components:hrMin fromDate:alarmTime];
    alarmTimeNoDay = [calendar dateFromComponents:hrMinComp];
    
    
    // animating yellow label
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        alarmLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        [alarmLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } completion:nil];

    /////////////////////////
    /////////////////////////
    self.alarmStatus.backgroundColor = [UIColor greenColor];
    /////////////////////////
    /////////////////////////
    
    // LOCAL NOTIFICATIONS
    UILocalNotification * wakeUp = [[UILocalNotification alloc] init];
    
    wakeUp.fireDate = alarmTime;
    wakeUp.timeZone = [NSTimeZone localTimeZone];
    wakeUp.alertBody = @"It's time to wake up!";
    wakeUp.soundName = songChoices[[alarmOptions[@"Song"]intValue]];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:wakeUp];
    
    
    // CREATING DICTIONARY AND ADDING TO ARRAY
    NSString * formattedTime = [formatter stringFromDate:alarmTimeNoDay];

    timeKey = [@{
               @"NSDate": alarmTime,
               @"NSDateNoDay": alarmTimeNoDay,
               @"NSString": formattedTime,
               @"Notification": wakeUp,
               @"Options": alarmOptions
               } mutableCopy];
    
    [self addAlarmOptions];
    
    [[ACAalarmData maindata].alarmList addObject:timeKey];
    
    [alarmsTVC.tableView reloadData];
    
    
    NSLog(@"HERES THAT TIMEKEY: %@ ",timeKey);
    
    [self archiveData];
    
    [alarmLabel setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
}


// this updates the alarm options if user accesses menu. User doesn't press save yet.
- (void)updateAlarmOptions: (NSMutableDictionary *)dict
{
    NSLog(@"update alarm options ran");
    alarmOptions = dict;
}


// this is called when user saves alarm time. Saves in the dictionary object of the alarm.
- (void)addAlarmOptions
{
    [timeKey setObject:alarmOptions forKey:@"Options"];
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


- (void)showAlarmView:(UILocalNotification *)notification
{
    
    currentNotification = notification;
    
    alarmBG = [[UIView alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alarmBG.backgroundColor = [UIColor colorWithRed:0.937f green:0.863f blue:0.129f alpha:1.0f];
    [self.view addSubview:alarmBG];
    
    
    UILabel * currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 130)];
    //NSDate * currentDate = [NSDate date];
    currentTimeLabel.text = [formatter stringFromDate:currentDate];
    currentTimeLabel.backgroundColor = [UIColor clearColor];
    currentTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45];
    currentTimeLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.textAlignment = NSTextAlignmentCenter;
   
    [alarmBG addSubview:currentTimeLabel];
    
    
    UILabel * alarmBGText = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 200)];
    alarmBGText.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    alarmBGText.backgroundColor = [UIColor clearColor];
    alarmBGText.text = @"It's about that time!";
    alarmBGText.textAlignment = NSTextAlignmentCenter;
    alarmBGText.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:35];
    alarmBGText.textColor = [UIColor colorWithRed:0.525f green:0.486f blue:0.075f alpha:1.0f];
    
    [alarmBG addSubview:alarmBGText];
    
    UIButton * dismissNotif = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 125, 275, 100, 100)];
    dismissNotif.layer.cornerRadius = 20;
    dismissNotif.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [dismissNotif setTitle:@"Dismiss" forState:UIControlStateNormal];;
    dismissNotif.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    [dismissNotif addTarget:self action:@selector(removeAlarmBG) forControlEvents:UIControlEventTouchUpInside];

    [alarmBG addSubview:dismissNotif];
    
    
    UIButton * snoozeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 25, 275, 100, 100)];
    snoozeButton.layer.cornerRadius = 20;
    snoozeButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [snoozeButton setTitle:@"Snooze" forState:UIControlStateNormal];
    snoozeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    [snoozeButton addTarget:self action:@selector(addingSnooze) forControlEvents:UIControlEventTouchUpInside];
    
    [alarmBG addSubview:snoozeButton];
    
    index = [self getIndex];

    NSURL * url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], currentNotification.soundName]];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.currentTime = 0;
    self.player.numberOfLoops = -1;
    self.player.volume = [[ACAalarmData maindata].sortedTimes[index][@"Options"][@"Volume"] floatValue];
    [self.player play];
    
    NSLog(@"this is the volume %f",self.player.volume);
    
    if ([[ACAalarmData maindata].sortedTimes[index][@"Options"][@"Vibrate"] intValue] == 1) {
       
        if (self.player.playing) {
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
    } else {
        return;
    }
}


- (int)getIndex
{
    for (NSDictionary * alarmInfo in [ACAalarmData maindata].sortedTimes) {
        
        if ([alarmInfo[@"Notification"] isEqual:currentNotification] || [alarmInfo[@"SnoozeNotification"] isEqual:currentNotification])
        {
            // this is the alarmInfo we want
            
            index = [[ACAalarmData maindata].sortedTimes indexOfObject:alarmInfo];
        }
    }
    return index;
}


// runs when user hits snooze
- (void)addingSnooze
{
    index = [self getIndex];
    
    NSDictionary * snoozeOptions;
    
    snoozeOptions = [ACAalarmData maindata].sortedTimes[index][@"Options"];

    NSLog(@"this is the index: %d", index);
    NSLog(@"%@", snoozeOptions);
  
    [self removeAlarmBG];

    
   // NSDate * current = [NSDate date];
   // unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents * noSeconds = [calendar components:flags fromDate:currentDate];
    NSDate * currentNoSecs = [calendar dateFromComponents:noSeconds];
    
    
    NSDate * snoozeDate = [NSDate dateWithTimeInterval: [snoozeOptions[@"Snooze"] intValue] sinceDate: currentNoSecs];
    UILocalNotification * snoozeNoti= [[UILocalNotification alloc] init];
    snoozeNoti.fireDate = snoozeDate;
    snoozeNoti.timeZone = [NSTimeZone localTimeZone];
    snoozeNoti.alertBody = @"It's time to wake up!";
    snoozeNoti.soundName = songChoices[[snoozeOptions[@"Song"] intValue]];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:snoozeNoti];

    
    [[ACAalarmData maindata].alarmList[index] setObject:snoozeNoti forKey:@"SnoozeNotification"];
    
    NSLog(@"here is the new snooze %@", snoozeNoti);
    
    
    if ([ACAalarmData maindata].sortedTimes[index][@"Tweet"]) {
        
        snoozeCounter += 1;
        
        if (snoozeCounter > [[ACAalarmData maindata].sortedTimes[index][@"Tweet"][@"SnoozeCount"] intValue])
        {
            [self sendTweet:index];
        }
    }
}


- (void)sendTweet: (int)num
{
 
    NSString * str = [ACAalarmData maindata].sortedTimes[num][@"Tweet"][@"Message"];
    
    [twitter postStatusUpdate:str inReplyToStatusID:nil latitude:nil longitude:nil placeID:nil displayCoordinates:nil trimUser:nil successBlock:^(NSDictionary *status) {
        
        NSLog(@"%@",status);
        
    } errorBlock:^(NSError *error) {
        
        NSLog(@"this is the error: %@",error.userInfo);
        
    }];
}

- (void)removeAlarmBG
{
    index = [self getIndex];
    
    [[ACAalarmData maindata].alarmList[index] removeObjectForKey: @"Notification"];
    
  
    [UIView animateWithDuration:1.0 animations:^{
        
        alarmBG.alpha = 0;
        
    } completion:^(BOOL finished) {
        [alarmBG removeFromSuperview];
        [self.player stop];
    }];
    
    [self checkActiveAlarms];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
