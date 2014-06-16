//
//  ACATweetVC.m
//  alarmClock
//
//  Created by JOHN YAM on 6/2/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACATweetVC.h"
#import "ACAalarmData.h"
#import "ACAalarmsTVC.h"

@interface ACATweetVC () <UITextViewDelegate>

@end

@implementation ACATweetVC
{
    UITextView * messageBox;
 
    int boxWidth;
    int boxHeight;
    
    NSNumber * maxSnooze;
    NSString * message;
    
    int alarmIndex;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        maxSnooze = 0;
        
        self.view.backgroundColor = [UIColor colorWithRed:0.906f green:0.980f blue:0.937f alpha:1.0f];        
        boxWidth = SCREEN_WIDTH - 20;
        boxHeight = 230;
        messageBox = [[UITextView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH /2) - (boxWidth/2) , 30, boxWidth, boxHeight)];
        messageBox.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        messageBox.delegate = self;
        [self.view addSubview:messageBox];
        

        UIButton * snooze2 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) - 25, boxHeight + 85, 50, 50)];
        snooze2.layer.cornerRadius = 25;
        snooze2.backgroundColor = [UIColor colorWithRed:0.325f green:0.369f blue:0.353f alpha:1.0f];
        [snooze2 setTitle:@"3X" forState:UIControlStateNormal];
        [snooze2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        snooze2.tag = 3;
        
        [snooze2 addTarget:self action:@selector(setSnoozeCount:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:snooze2];
        
        //
        
        UIButton * snooze1 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) - 125, boxHeight + 85, 50, 50)];
        snooze1.layer.cornerRadius = 25;
        snooze1.backgroundColor = [UIColor colorWithRed:0.325f green:0.369f blue:0.353f alpha:1.0f];
        [snooze1 setTitle:@"1X" forState:UIControlStateNormal];
        [snooze1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        snooze1.tag = 1;
        
        [snooze1 addTarget:self action:@selector(setSnoozeCount:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:snooze1];
        
        //
        UIButton * snooze3 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) + 75, boxHeight + 85, 50, 50)];
        snooze3.layer.cornerRadius = 25;
        snooze3.backgroundColor = [UIColor colorWithRed:0.325f green:0.369f blue:0.353f alpha:1.0f];
        [snooze3 setTitle:@"5X" forState:UIControlStateNormal];
        [snooze3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        snooze3.tag = 5;
        
        [snooze3 addTarget:self action:@selector(setSnoozeCount:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:snooze3];
        
        
        UIButton * sendTweet = [[UIButton alloc]initWithFrame:CGRectMake(10, boxHeight + 180, boxWidth, 50)];
        sendTweet.backgroundColor = [UIColor colorWithRed:0.855f green:0.796f blue:0.235f alpha:1.0f];
        [sendTweet setTitle:@"Send Tweet" forState:UIControlStateNormal];
        [sendTweet setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [sendTweet addTarget:self action:@selector(saveTweet) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendTweet];
        
        
        UIButton * sendPush = [[UIButton alloc]initWithFrame:CGRectMake(10, boxHeight + 180 + 60, boxWidth, 50)];
        sendPush.backgroundColor = [UIColor colorWithRed:0.855f green:0.796f blue:0.235f alpha:1.0f];
        [sendPush setTitle:@"Send Notification" forState:UIControlStateNormal];
        [sendPush setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:sendPush];
        

        UISwipeGestureRecognizer * rightGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        rightGest.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightGest];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)getAlarmIndex: (int)num
{
    alarmIndex = num;
}


- (void)setSnoozeCount: (UIButton *)sender
{
    maxSnooze = [NSNumber numberWithInt: sender.tag];
    
    NSLog(@"set snooze count method ran");
}


- (void)saveTweet
{
    if (maxSnooze == 0){
        return;
    }
    
    message = messageBox.text;
    messageBox.text = @"";
    
    NSMutableDictionary * tweet = [@{
                                     @"SnoozeCount": maxSnooze,
                                     @"Message": message
                                     
                                     } mutableCopy];
    
    [[ACAalarmData maindata].alarmList[alarmIndex] setObject:tweet forKey:@"Tweet"];
    
    
    NSLog(@"tweet was saved");
    NSLog(@"heres the tweet info: %@", tweet);
}




- (void)swipeRight:gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissKeyboard {
    [messageBox resignFirstResponder];
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
