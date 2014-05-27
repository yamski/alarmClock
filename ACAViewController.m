//
//  ACAViewController.m
//  alarmClock
//
//  Created by JOHN YAM on 5/26/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAViewController.h"
#import "ACAalarmLabel.h"

@interface ACAViewController ()

@end

@implementation ACAViewController
{
    int day;
    int hour;
    int min;
    int sec;
    
    ACAalarmLabel * alarmLabel;
    
    NSDate * alarmTime;
    NSDate * now;
    NSDateFormatter * formatter;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        now = [NSDate date];
        
        formatter = [[NSDateFormatter alloc] init];
        
        //[formatter setDateStyle:NSDateFormatterShortStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        [formatter setLocale:<#(NSLocale *)#>];
//        [formatter setTimeZone:<#(NSTimeZone *)#>];
        
        NSString * formattedDate = [formatter stringFromDate:now];
        
        NSLog(@"%@",formattedDate);
        
        
        alarmTime = now;
        
        alarmLabel = [[ACAalarmLabel alloc] initWithFrame:CGRectMake(20, 20, 200, 100)];
        
        alarmLabel.text = [formatter stringFromDate:alarmTime];
        
        [self.view addSubview:alarmLabel];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    NSLog(@"%@", alarmTime);

    
    [self.view addSubview:alarmLabel];
    
    NSLog(@"updating alarm");
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    CGPoint prevLocation = [touch previousLocationInView:self.view];
    
    if (location.y - prevLocation.y > 0) {
        
        NSLog(@"swiping up");
        min = min + 5;
    } else {
        
        NSLog(@"swiping down");
        
        min = min - 5;
    }
    NSLog(@"minutes value is %d",min);
    
    [self updateAlarm];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
