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
#import "ACAbgLayer.h"

@interface ACATweetVC () <UITextViewDelegate>

@end

@implementation ACATweetVC
{
    UITextView * messageBox;
 
    int boxWidth;
    int boxHeight;
    int alarmIndex;
    
    NSNumber * maxSnooze;
    NSString * message;
    UILabel * time;
    UILabel * warning;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        maxSnooze = 0;
        
        CAGradientLayer *bgLayer = [ACAbgLayer greenGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        boxWidth = SCREEN_WIDTH - 20;
        boxHeight = SCREEN_HEIGHT / 2.75;
        messageBox = [[UITextView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH /2) - (boxWidth/2) , 30, boxWidth, boxHeight)];
        
        messageBox.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
        [messageBox setFont:[UIFont systemFontOfSize:17]];
        messageBox.textColor = GRAY;
        messageBox.delegate = self;
        
        [self.view addSubview:messageBox];
        
        
        warning = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH /2) - (boxWidth/2) , 30, boxWidth, boxHeight)];
        warning.backgroundColor = GOLD;
        warning.textColor = GRAY;
        warning.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
        warning.textAlignment = NSTextAlignmentCenter;
        
        
        time = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH /2) - (boxWidth/2) , boxHeight + 50, boxWidth, 60)];
        time.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        time.textAlignment = NSTextAlignmentCenter;
        time.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:55];
        [self.view addSubview:time];
        
     
        UILabel * selectSnooze = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - 100, SCREEN_HEIGHT / 1.65 , 200, 50)];
        
        selectSnooze.text = @"Select Snooze Count";
        selectSnooze.textAlignment = NSTextAlignmentCenter;
        selectSnooze.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22];
        selectSnooze.textColor = GRAY;
        [self.view addSubview:selectSnooze];
        

        UIButton * snooze2 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) - 25, (SCREEN_HEIGHT / 1.65) + 50, 50, 50)];
        snooze2.layer.cornerRadius = 25;
        snooze2.layer.borderColor = GRAY.CGColor;
        snooze2.layer.borderWidth = .9f;
        [snooze2 setTitle:@"3X" forState:UIControlStateNormal];
        snooze2.titleLabel.font = [UIFont systemFontOfSize:17];
        [snooze2 setTitleColor:GRAY forState:UIControlStateNormal];
        snooze2.tag = 3;
        
        [snooze2 addTarget:self action:@selector(setSnoozeCount:) forControlEvents:UIControlEventTouchUpInside];
        [snooze2 addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:snooze2];
    
        //
        
        UIButton * snooze1 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) - 125, (SCREEN_HEIGHT / 1.65) + 50, 50, 50)];
        snooze1.layer.cornerRadius = 25;
        snooze1.layer.borderColor = GRAY.CGColor;
        snooze1.layer.borderWidth = .9f;
        [snooze1 setTitle:@"1X" forState:UIControlStateNormal];
        snooze1.titleLabel.font = [UIFont systemFontOfSize:17];
        [snooze1 setTitleColor:GRAY forState:UIControlStateNormal];
        snooze1.tag = 1;
        
        [snooze1 addTarget:self action:@selector(setSnoozeCount:) forControlEvents:UIControlEventTouchUpInside];
        [snooze1 addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:snooze1];

        //
        UIButton * snooze3 = [[UIButton alloc] initWithFrame: CGRectMake((SCREEN_WIDTH / 2) + 75, (SCREEN_HEIGHT / 1.65) + 50, 50, 50)];
        snooze3.layer.cornerRadius = 25;
        snooze3.layer.borderColor = GRAY.CGColor;
        snooze3.layer.borderWidth = .9f;
        [snooze3 setTitle:@"5X" forState:UIControlStateNormal];
        snooze3.titleLabel.font = [UIFont systemFontOfSize:17];
        [snooze3 setTitleColor:GRAY forState:UIControlStateNormal];
        snooze3.tag = 5;
        
        [snooze3 addTarget:self action:@selector(setSnoozeCount:) forControlEvents:UIControlEventTouchUpInside];
        [snooze3 addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:snooze3];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 1)];
        line.backgroundColor = GRAY;
        [self.view addSubview:line];
        

        UIButton * cancelTweet = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - 140, SCREEN_HEIGHT - 55, 120, 50)];
        [cancelTweet setTitle:@"Cancel Tweet" forState:UIControlStateNormal];
        [cancelTweet setTitleColor:GRAY forState:UIControlStateNormal];
        cancelTweet.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelTweet addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelTweet];
        
        
        UIButton * sendTweet = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH / 2) + 20, SCREEN_HEIGHT - 55, 120, 50)];
        [sendTweet setTitle:@"Schedule Tweet" forState:UIControlStateNormal];
        [sendTweet setTitleColor:GRAY forState:UIControlStateNormal];
        sendTweet.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [sendTweet addTarget:self action:@selector(saveTweet) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendTweet];
        

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

- (void)buttonHighlight: (UIButton *)sender
{
    UIButton * fill = [[UIButton alloc]init];
    
    fill.frame = sender.frame;
    fill.layer.cornerRadius = sender.layer.cornerRadius;
    
    fill.backgroundColor = GOLD;
    
    fill.alpha = 0.7;
    
    [self.view addSubview:fill];
    
    [UIView animateWithDuration:1.0 animations:^{
        
         fill.alpha = 0;

    } completion:^(BOOL finished) {
       
        [fill removeFromSuperview];
    
    }];
}

- (void)getAlarmIndex: (int)num
{
    alarmIndex = num;
    
    time.text = [ACAalarmData maindata].sortedTimes[num][@"NSString"];
}


- (void)setSnoozeCount: (UIButton *)sender
{
    maxSnooze = [NSNumber numberWithInt: sender.tag];
    
    NSLog(@"set snooze count method ran %@", maxSnooze);
    

}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveTweet
{
    if (maxSnooze == 0){
        
        warning.alpha = 0.8;
        warning.text = @"Enter a snooze count";
        [self.view addSubview:warning];
        
        [UIView animateWithDuration:3.0 animations:^{
            warning.alpha = 0;
        }completion:^(BOOL finished) {
            [warning removeFromSuperview];
        }];
        return;
        
    } else if (messageBox.text.length == 0) {
        warning.alpha = 0.8;
        warning.text = @"Please include a message";
        [self.view addSubview:warning];
        
        [UIView animateWithDuration:3.0 animations:^{
            warning.alpha = 0;
        }completion:^(BOOL finished) {
            [warning removeFromSuperview];
        }];
        
        return;
        
    } else if (messageBox.text.length > 140) {
        warning.alpha = 1;
        warning.text = @"You're over 140 characters!";
        [self.view addSubview:warning];
        
        [UIView animateWithDuration:6.0 animations:^{
            warning.alpha = 0;
        }completion:^(BOOL finished) {
            [warning removeFromSuperview];
        }];
        
        return;
    }
 
    message = messageBox.text;
    messageBox.text = @"";
    
    NSMutableDictionary * tweet = [@{
                                     @"SnoozeCount": maxSnooze,
                                     @"Message": message
                                     } mutableCopy];
    
    [[ACAalarmData maindata].alarmList[alarmIndex] setObject:tweet forKey:@"Tweet"];
    
    warning.alpha = 1;
    warning.text = @"Message Saved!";
    [self.view addSubview:warning];
    
    [UIView animateWithDuration:3.0 animations:^{
        
        warning.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [warning removeFromSuperview];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

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
