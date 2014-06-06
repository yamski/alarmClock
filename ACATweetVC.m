//
//  ACATweetVC.m
//  alarmClock
//
//  Created by JOHN YAM on 6/2/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACATweetVC.h"
#import "ACATableView.h"
#import "ACAalarmData.h"

@interface ACATweetVC () <UITextViewDelegate>

@end

@implementation ACATweetVC
{
    UITextView * tweetText;
    ACATableView * alarmTable;
    
    int boxWidth;
    int boxHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor colorWithRed:0.204f green:0.282f blue:0.369f alpha:1.0f];
        
        boxWidth = SCREEN_WIDTH - 20;
        boxHeight = SCREEN_HEIGHT / 3;
        
        tweetText = [[UITextView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH /2) - (boxWidth/2) , 30, boxWidth, boxHeight)];
        tweetText.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        tweetText.delegate = self;
        [self.view addSubview:tweetText];
        
//        UIButton * alarms = [[UIButton alloc]initWithFrame:CGRectMake(10, boxHeight + 50, boxWidth, 40)];
//        alarms.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
//        [alarms setTitle:@"Alarms" forState:UIControlStateNormal];
//        [self.view addSubview:alarms];
        
//        ACAcollectionVC * tweetTimes = [[ACAcollectionVC alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
//        tweetTimes.view.frame = CGRectMake(10, boxHeight + 70, boxWidth, 70);
//        
//        [self.view addSubview:tweetTimes.view];
        
      
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, boxHeight + 40, boxWidth, 130)];
        scrollView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        scrollView.contentSize = CGSizeMake(70,SCREEN_WIDTH);
        [self.view addSubview:scrollView];
        
        int numAlarms = (int)[[ACAalarmData maindata].sortedTimes count];
     
        for (int i = 0; i < numAlarms; i++) {
            
            UIButton * alarms = [[UIButton alloc]initWithFrame:CGRectMake(10,10 + (i * 70), SCREEN_WIDTH - 40, 60)];
            
            alarms.backgroundColor = [UIColor colorWithRed:0.882f green:0.824f blue:0.098f alpha:0.8f];
            
            [alarms setTitle:[[ACAalarmData maindata].sortedTimes[i] objectForKey:@"NSString"] forState:UIControlStateNormal];
            
            [scrollView addSubview:alarms];
        }
        
        UIButton * sendTweet = [[UIButton alloc]initWithFrame:CGRectMake(10, boxHeight + 180, boxWidth, 50)];
        sendTweet.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        [sendTweet setTitle:@"Sent Tweet" forState:UIControlStateNormal];
        [self.view addSubview:sendTweet];
        
        UISwipeGestureRecognizer * leftGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        leftGest.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:leftGest];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)swipeLeft:gesture
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0 - SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
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
