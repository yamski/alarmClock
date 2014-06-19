//
//  ACAalarmSwipe.m
//  alarmClock
//
//  Created by JOHN YAM on 5/27/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAalarmSwipe.h"
#import "ACAvolumeSlider.h"
#import "ACAoptionsButton.h"



@implementation ACAalarmSwipe
{
    CGPoint prevLocation;
    CGPoint location;
    
    int hour;
    int min;
    
    UIScrollView * menuView;
    
    NSTimeInterval timeInterval;
    
    int middle;
    
    UIView * snoozeView;
    UIView * soundsView;
    UIView * volumeView;
    UIView * vibrateView;
    
    UIButton * snoozeButton;
    ACAoptionsButton * snooze5;
    ACAoptionsButton * snooze10;
    ACAoptionsButton * snooze30;
    ACAoptionsButton * snooze60;
    
    UIButton * soundsButton;
    ACAoptionsButton * ringerA;
    ACAoptionsButton * ringerB;
    ACAoptionsButton * ringerC;
    ACAoptionsButton * ringerD;
    UIButton * stopSoundButton;
    
    UIButton * vibrateButton;
    ACAoptionsButton * vibrateOn;
    ACAoptionsButton * vibrateOff;
    
    UIButton * volumeButton;
    ACAvolumeSlider * volumeSlider;
    
    float volumeValue;
    int snoozeValue;
    int vibrateIsOn;
    int songChoice;
    
    NSMutableDictionary * alarmOptions;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        timeInterval = 0;
        
        middle = SCREEN_WIDTH / 2;
        
        self.options = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 20, SCREEN_HEIGHT - 60, 40, 40)];
        self.options.backgroundColor = [UIColor lightGrayColor];
        self.options.alpha = 0;
        self.options.layer.cornerRadius = 20;
        [self.options addTarget:self action:@selector(optionsMenu) forControlEvents:UIControlEventTouchUpInside];
        [self buttonAppear];

        
        menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 3.5 , SCREEN_WIDTH, SCREEN_HEIGHT / 1.75)];
        menuView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        menuView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        menuView.contentSize = CGSizeMake(SCREEN_WIDTH,340);
        menuView.alpha = 0;
        
        //
        
        snoozeView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 80)];
        snoozeView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.1];
        [menuView addSubview:snoozeView];
        
        //
        
        snoozeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [snoozeButton setTitle:@"Snooze" forState:UIControlStateNormal];
        snoozeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:26];
        [snoozeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        snoozeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [snoozeButton addTarget:self action:@selector(snoozeOptions) forControlEvents:UIControlEventTouchUpInside];
        [snoozeView addSubview:snoozeButton];
        
        //
        
        soundsView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, 80)];
        soundsView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.1];
        
        [menuView addSubview:soundsView];
        //
        soundsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [soundsButton setTitle:@"Sound" forState:UIControlStateNormal];
        soundsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:26];
        [soundsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        soundsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [soundsButton addTarget:self action:@selector(soundOptions) forControlEvents:UIControlEventTouchUpInside];
        [soundsView addSubview:soundsButton];
        
        //
        
        volumeView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, 80)];
        volumeView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.1];
        
        [menuView addSubview:volumeView];
        
        //
        volumeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [volumeButton setTitle:@"Volume" forState:UIControlStateNormal];
        volumeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:26];
        [volumeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        volumeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [volumeButton addTarget:self action:@selector(volumeOptions) forControlEvents:UIControlEventTouchUpInside];
        [volumeView addSubview:volumeButton];
        
        //
        
        vibrateView = [[UIView alloc] initWithFrame:CGRectMake(0, 275, SCREEN_WIDTH, 80)];
        vibrateView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.1];

        [menuView addSubview:vibrateView];
        //
        vibrateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [vibrateButton setTitle:@"Vibrate" forState:UIControlStateNormal];
        vibrateButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:26];
        [vibrateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        vibrateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [vibrateButton addTarget:self action:@selector(vibrateOptions) forControlEvents:UIControlEventTouchUpInside];
        [vibrateView addSubview:vibrateButton];
        
        //// default values
     
        snoozeValue = 10;
        songChoice= 0;
        vibrateIsOn = 1;
        volumeValue = 0.7;
        
        
    }
    return self;
}

- (void)buttonAppear
{
    [UIView animateWithDuration:1.5 animations:^{
        
        [self addSubview:self.options];
        self.options.alpha = 1;
    } ];
}

- (void) sendAlarmOptions
{
    alarmOptions = [@{
                       @"Snooze": [NSNumber numberWithInt:snoozeValue],
                       @"Song": [NSNumber numberWithInt:songChoice],
                       @"Vibrate": [NSNumber numberWithInt:vibrateIsOn],
                       @"Volume": [NSNumber numberWithFloat: volumeValue],
                       } mutableCopy];
    
    [self.delegate updateAlarmOptions: alarmOptions];
}

- (void)optionsMenu
{
    [self.options removeTarget:self action:@selector(optionsMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.options addTarget:self action:@selector(removeMenu) forControlEvents:UIControlEventTouchUpInside];
    
   [self addSubview:menuView];
    
    
    [UIView animateWithDuration:0.5 animations:^{
       
        //[self insertSubview:menuView aboveSubview:self];
        
        menuView.alpha = 1;
    }];
    
    
    
}

- (void)removeMenu
{
    [self.options removeTarget:self action:@selector(removeMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.options addTarget:self action:@selector(optionsMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        menuView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
         [menuView removeFromSuperview];
        
        [self sendAlarmOptions];
        
    }];
    
}

- (void)snoozeOptions
{
    [snoozeButton removeTarget:self action:@selector(snoozeOptions) forControlEvents:UIControlEventTouchUpInside];
    [snoozeButton addTarget:self action:@selector(closeSnooze) forControlEvents:UIControlEventTouchUpInside];
    
    [soundsView removeFromSuperview];
    [volumeView removeFromSuperview];
    [vibrateView removeFromSuperview];
    
    snooze5 = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle - 136, 80, 50, 50)];
    [snooze5 setTitle:@"5m" forState:UIControlStateNormal];
    snooze5.tag = (5 * 60);
    [snooze5 addTarget:self action:@selector(snoozeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [snooze5 addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [snoozeView addSubview:snooze5];
    
    
    
    snooze60 = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle + 86, 80, 50, 50)];
    [snooze60 setTitle:@"60m" forState:UIControlStateNormal];
    snooze60.tag = (60 * 60);
    [snooze60 addTarget:self action:@selector(snoozeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [snooze60 addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [snoozeView addSubview:snooze60];
    
    //
    snooze10 = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle - 62, 80, 50, 50)];
    [snooze10 setTitle:@"10m" forState:UIControlStateNormal];
    snooze10.tag = (10 * 60);
    [snooze10 addTarget:self action:@selector(snoozeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [snooze10 addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [snoozeView addSubview:snooze10];
    
    
    snooze30 = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle + 12, 80, 50, 50)];
    [snooze30 setTitle:@"30m" forState:UIControlStateNormal];
    snooze30.tag = (30 * 60);
    [snooze30 addTarget:self action:@selector(snoozeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [snooze30 addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [snoozeView addSubview:snooze30];
    
    
    [UIView animateWithDuration:0.5 animations:^{
       
        snoozeView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 320);
        snooze5.alpha = 1;
        snooze60.alpha = 1;
        snooze10.alpha = 1;
        snooze30.alpha = 1;
       
    }];

}

- (void)closeSnooze
{
    [snoozeButton removeTarget:self action:@selector(closeSnooze) forControlEvents:UIControlEventTouchUpInside];
    [snoozeButton addTarget:self action:@selector(snoozeOptions) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        snoozeView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 80);
        
        snooze5.alpha = 0;
        snooze10.alpha = 0;
        snooze30.alpha = 0;
        snooze60.alpha = 0;
        
        soundsView.alpha = 1;
        soundsButton.alpha = 1;
        volumeView.alpha = 1;
        vibrateView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [snooze5 removeFromSuperview];
        [snooze10 removeFromSuperview];
        [snooze30 removeFromSuperview];
        [snooze60 removeFromSuperview];
        
        [menuView addSubview:soundsView];
        [soundsView addSubview:soundsButton];
        
        [menuView addSubview:volumeView];
        [menuView addSubview:vibrateView];
        
    }];
}

- (void)soundOptions
{
    [soundsButton removeTarget:self action:@selector(soundOptions) forControlEvents:UIControlEventTouchUpInside];
    [soundsButton addTarget:self action:@selector(closeSounds) forControlEvents:UIControlEventTouchUpInside];
    
    [snoozeView removeFromSuperview];
    [volumeView removeFromSuperview];
    [vibrateView removeFromSuperview];
    
    
    ringerA = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle - 136, 80, 50, 50)];
    [ringerA setTitle:@"A" forState:UIControlStateNormal];
    ringerA.tag = 0;
    [ringerA addTarget:self action:@selector(selectSong:) forControlEvents:UIControlEventTouchUpInside];
    [ringerA addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [soundsView addSubview:ringerA];
    
    
    ringerB = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle - 62, 80, 50, 50)];
    [ringerB setTitle:@"B" forState:UIControlStateNormal];
    ringerB.tag = 1;
    [ringerB addTarget:self action:@selector(selectSong:) forControlEvents:UIControlEventTouchUpInside];
    [ringerB addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [soundsView addSubview:ringerB];
    
    
    ringerC = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle + 12, 80, 50, 50)];
    [ringerC setTitle:@"C" forState:UIControlStateNormal];
    ringerC.tag = 2;
    [ringerC addTarget:self action:@selector(selectSong:) forControlEvents:UIControlEventTouchUpInside];
    [ringerC addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [soundsView addSubview:ringerC];
    
    ringerD = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle + 86, 80, 50, 50)];
    [ringerD setTitle:@"D" forState:UIControlStateNormal];
    ringerD.tag = 3;
    [ringerD addTarget:self action:@selector(selectSong:) forControlEvents:UIControlEventTouchUpInside];
    [ringerD addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [soundsView addSubview:ringerD];
    
    stopSoundButton = [[UIButton alloc]initWithFrame:CGRectMake(middle - 25, 170, 50, 50)];
    stopSoundButton.layer.cornerRadius = 25;
    stopSoundButton.layer.borderWidth = 1.0f;
    stopSoundButton.layer.borderColor = GRAY.CGColor;
    [stopSoundButton setTitleColor:GRAY forState:UIControlStateNormal];
    [stopSoundButton setTitle:@"X" forState:UIControlStateNormal];
    stopSoundButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45];
  
    stopSoundButton.alpha = 0;
    [stopSoundButton addTarget:self action:@selector(stopSamplePlay) forControlEvents:UIControlEventTouchUpInside];
    [stopSoundButton addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [soundsView addSubview:stopSoundButton];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        soundsView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 320);
        
        ringerA.alpha = 1;
        ringerB.alpha = 1;
        ringerC.alpha = 1;
        ringerD.alpha = 1;
        stopSoundButton.alpha = 1;
    }];
    
}

- (void)closeSounds
{
    [soundsButton removeTarget:self action:@selector(closeSounds) forControlEvents:UIControlEventTouchUpInside];
    [soundsButton addTarget:self action:@selector(soundOptions) forControlEvents:UIControlEventTouchUpInside];
    
    snoozeView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        soundsView.frame = CGRectMake(0, 105, SCREEN_WIDTH, 80);
        
        snoozeView.alpha = 1;
        
        ringerA.alpha = 0;
        ringerB.alpha = 0;
        ringerC.alpha = 0;
        ringerD.alpha = 0;
        stopSoundButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [ringerA removeFromSuperview];
        [ringerB removeFromSuperview];
        [ringerC removeFromSuperview];
        [ringerD removeFromSuperview];
        [stopSoundButton removeFromSuperview];
        
        [menuView addSubview:snoozeView];
        [menuView addSubview:volumeView];
        [menuView addSubview:vibrateView];
    }];
    
}

- (void)volumeOptions
{

    [volumeButton removeTarget:self action:@selector(volumeOptions) forControlEvents:UIControlEventTouchUpInside];
    [volumeButton addTarget:self action:@selector(closeVolume) forControlEvents:UIControlEventTouchUpInside];
    
    [snoozeView removeFromSuperview];
    [soundsView removeFromSuperview];
    [vibrateView removeFromSuperview];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        volumeView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 320);
    } completion:^(BOOL finished) {
        
        volumeSlider = [[ACAvolumeSlider alloc]initWithFrame:CGRectMake((SCREEN_WIDTH /2) - 110, 120, 220, 2)];
        volumeSlider.minimumValue = 0.0;
        volumeSlider.maximumValue = 1.0;
        volumeSlider.value = .5;
        [volumeSlider addTarget:self action:@selector(volumeControl) forControlEvents:UIControlEventValueChanged];
        
        [volumeView addSubview:volumeSlider];
        
    }];
}

- (void)closeVolume
{
    [volumeButton removeTarget:self action:@selector(closeVolume) forControlEvents:UIControlEventTouchUpInside];
    [volumeButton addTarget:self action:@selector(volumeOptions) forControlEvents:UIControlEventTouchUpInside];
    
    [volumeSlider removeFromSuperview];
  
    
    [UIView animateWithDuration:0.5 animations:^{
        
        volumeView.frame = CGRectMake(0, 190, SCREEN_WIDTH, 80);
       
    } completion:^(BOOL finished) {
        
        [menuView addSubview:snoozeView];
        [menuView addSubview:soundsView];
        [menuView addSubview:vibrateView];
        
    }];
    
}

- (void) volumeControl
{
    volumeValue = [volumeSlider value];
}

- (void)vibrateOptions
{
    [vibrateButton removeTarget:self action:@selector(vibrateOptions) forControlEvents:UIControlEventTouchUpInside];
    [vibrateButton addTarget:self action:@selector(closeVibrate) forControlEvents:UIControlEventTouchUpInside];
    
    [snoozeView removeFromSuperview];
    [soundsView removeFromSuperview];
    [volumeView removeFromSuperview];
    //
    
    vibrateOn = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle - 82, 80, 50, 50)];
    [vibrateOn setTitle:@"On" forState:UIControlStateNormal];
    vibrateOn.tag = 1;
    [vibrateOn addTarget:self action:@selector(setVibrate:) forControlEvents:UIControlEventTouchUpInside];
    [vibrateOn addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [vibrateView addSubview:vibrateOn];
    
    
    vibrateOff = [[ACAoptionsButton alloc] initWithFrame: CGRectMake(middle + 32, 80, 50, 50)];
    [vibrateOff setTitle:@"Off" forState:UIControlStateNormal];
    vibrateOff.tag = 0;
    [vibrateOff addTarget:self action:@selector(setVibrate:) forControlEvents:UIControlEventTouchUpInside];
    [vibrateOff addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [vibrateView addSubview:vibrateOff];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        vibrateView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 320);
        
        vibrateOn.alpha = 1;
        vibrateOff.alpha = 1;
    }];
}

- (void)closeVibrate
{
    [vibrateButton removeTarget:self action:@selector(closeVibrate) forControlEvents:UIControlEventTouchUpInside];
    [vibrateButton addTarget:self action:@selector(vibrateOptions) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        vibrateView.frame = CGRectMake(0, 275, SCREEN_WIDTH, 80);
        
        vibrateOn.alpha = 0;
        vibrateOff.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [vibrateOn removeFromSuperview];
        [vibrateOff removeFromSuperview];
        
        [menuView addSubview:snoozeView];
        [menuView addSubview:soundsView];
        [menuView addSubview:volumeView];
        
    }];

}

- (void)setVibrate: (UIButton *)sender
{
    vibrateIsOn = sender.tag;
}

- (void)snoozeSelect: (UIButton *)sender
{
    snoozeValue = sender.tag;
    
}

- (void)selectSong: (UIButton *)sender
{
    songChoice = sender.tag;
    
    [self.delegate playSample:songChoice];
}

- (void)stopSamplePlay
{
    [self.delegate stopSound];
}

- (void)buttonHighlight: (UIButton *)sender
{
    UIButton * fill = [[UIButton alloc]init];
    
    fill.frame = sender.frame;
    fill.layer.cornerRadius = sender.layer.cornerRadius;
    fill.layer.borderColor = GRAY.CGColor;
    fill.layer.borderWidth = sender.layer.borderWidth;
    fill.backgroundColor = GRAY;
    fill.alpha = 0.7;
    
    UIView *parentView = [(UIView *)sender superview];
    
    [parentView addSubview:fill];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        fill.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [fill removeFromSuperview];
        
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    location = [touch locationInView:self];
    
    
    if (location.x - prevLocation.x > 50) {
        
        timeInterval = timeInterval + 3600.0;
        
        prevLocation = location;
        
    } else if (location.x - prevLocation.x < -50) {
        
        timeInterval = timeInterval - 3600.0;
        
        prevLocation = location;
    }
    
    if (location.y - prevLocation.y > 20) {
        
        timeInterval = timeInterval - 60.0;
        
        prevLocation = location;
    }
    
    if (location.y - prevLocation.y < -20){
        
        timeInterval = timeInterval + 60.0;
      
        prevLocation = location;
    }
    
    
    if(timeInterval < 0) timeInterval = (60 * 60 * 24) + timeInterval;
    if(timeInterval > (60 * 60 * 24)) timeInterval = timeInterval - (60 * 60 * 24);
    
   [self.delegate updateAlarm:timeInterval];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    location = [touch locationInView:self];
    prevLocation = location;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
