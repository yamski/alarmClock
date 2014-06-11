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
    UITextView * tweetText;
 
    
    int boxWidth;
    int boxHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor colorWithRed:0.906f green:0.980f blue:0.937f alpha:1.0f];        
        boxWidth = SCREEN_WIDTH - 20;
        boxHeight = 230;
        
        tweetText = [[UITextView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH /2) - (boxWidth/2) , 30, boxWidth, boxHeight)];
        tweetText.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        tweetText.delegate = self;
        [self.view addSubview:tweetText];
        
//        UIButton * alarms = [[UIButton alloc]initWithFrame:CGRectMake(10, boxHeight + 50, boxWidth, 40)];
//        alarms.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
//        [alarms setTitle:@"Alarms" forState:UIControlStateNormal];
//        [self.view addSubview:alarms];
        
        
      
//        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, boxHeight + 40, boxWidth, 130)];
//        scrollView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
//        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        scrollView.contentSize = CGSizeMake(70,SCREEN_WIDTH);
//        [self.view addSubview:scrollView];
//        
//        int numAlarms = (int)[[ACAalarmData maindata].sortedTimes count];
//     
//        for (int i = 0; i < numAlarms; i++) {
//            
//            UIButton * alarms = [[UIButton alloc]initWithFrame:CGRectMake(10,10 + (i * 70), SCREEN_WIDTH - 40, 60)];
//            
//            alarms.backgroundColor = [UIColor colorWithRed:0.882f green:0.824f blue:0.098f alpha:0.8f];
//            
//            [alarms setTitle:[[ACAalarmData maindata].sortedTimes[i] objectForKey:@"NSString"] forState:UIControlStateNormal];
//            
//            [scrollView addSubview:alarms];
//        }
        

        UIButton * snooze2 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) - 25, boxHeight + 85, 50, 50)];
        
        snooze2.layer.cornerRadius = 25;
        
        snooze2.backgroundColor = [UIColor colorWithRed:0.325f green:0.369f blue:0.353f alpha:1.0f];
        
        [snooze2 setTitle:@"3X" forState:UIControlStateNormal];
        
        [snooze2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.view addSubview:snooze2];
        
        //
        
        UIButton * snooze1 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) - 125, boxHeight + 85, 50, 50)];
        
        snooze1.layer.cornerRadius = 25;
        
        snooze1.backgroundColor = [UIColor colorWithRed:0.325f green:0.369f blue:0.353f alpha:1.0f];
        
        [snooze1 setTitle:@"1X" forState:UIControlStateNormal];
        
        [snooze1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.view addSubview:snooze1];
        
        //
        UIButton * snooze3 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) + 75, boxHeight + 85, 50, 50)];
        
        snooze3.layer.cornerRadius = 25;
        
        snooze3.backgroundColor = [UIColor colorWithRed:0.325f green:0.369f blue:0.353f alpha:1.0f];
        
        [snooze3 setTitle:@"5X" forState:UIControlStateNormal];
        
        [snooze3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.view addSubview:snooze3];
        
        
        
        
        UIButton * sendTweet = [[UIButton alloc]initWithFrame:CGRectMake(10, boxHeight + 180, boxWidth, 50)];
        sendTweet.backgroundColor = [UIColor colorWithRed:0.855f green:0.796f blue:0.235f alpha:1.0f];

        [sendTweet setTitle:@"Sent Tweet" forState:UIControlStateNormal];
        [sendTweet setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:sendTweet];
        
        
        UIButton * sendPush = [[UIButton alloc]initWithFrame:CGRectMake(10, boxHeight + 180 + 60, boxWidth, 50)];
        sendPush.backgroundColor = [UIColor colorWithRed:0.855f green:0.796f blue:0.235f alpha:1.0f];
        
        [sendPush setTitle:@"Sent Notification" forState:UIControlStateNormal];
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


- (void)swipeRight:gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissKeyboard {
    [tweetText resignFirstResponder];
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
