//
//  ACAalarmSwipe.m
//  alarmClock
//
//  Created by JOHN YAM on 5/27/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAalarmSwipe.h"


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
    UIButton * snooze5;
    UIButton * snooze10;
    UIButton * snooze30;
    UIButton * snooze60;
    
    UIButton * soundsButton;
    UIButton * ringerA;
    UIButton * ringerB;
    UIButton * ringerC;
    UIButton * ringerD;
    
    UIButton * vibrateButton;
    UIButton * vibrateOn;
    UIButton * vibrateOff;
    
    UIButton * volumeButton;
    UISlider * volumeSlider;
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

        
        menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 325)];
        menuView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        menuView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        menuView.contentSize = CGSizeMake(SCREEN_WIDTH,480);
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
        
    }];
    
}

- (void)snoozeOptions
{
    [snoozeButton removeTarget:self action:@selector(snoozeOptions) forControlEvents:UIControlEventTouchUpInside];
    [snoozeButton addTarget:self action:@selector(closeSnooze) forControlEvents:UIControlEventTouchUpInside];
    
    [soundsView removeFromSuperview];
    [volumeView removeFromSuperview];
    [vibrateView removeFromSuperview];
    
    snooze5 = [[UIButton alloc] initWithFrame: CGRectMake(middle - 136, 80, 50, 50)];
    snooze5.layer.cornerRadius = 25;
    snooze5.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [snooze5 setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [snooze5 setTitle:@"5m" forState:UIControlStateNormal];
    snooze5.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    snooze5.alpha = 0;
    [snoozeView addSubview:snooze5];
    
    
    
    snooze60 = [[UIButton alloc] initWithFrame: CGRectMake(middle + 86, 80, 50, 50)];
    snooze60.layer.cornerRadius = 25;
    snooze60.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [snooze60 setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [snooze60 setTitle:@"60m" forState:UIControlStateNormal];
    snooze60.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    snooze60.alpha = 0;
    [snoozeView addSubview:snooze60];
    
    
    //
    snooze10 = [[UIButton alloc] initWithFrame: CGRectMake(middle - 62, 80, 50, 50)];
    snooze10.layer.cornerRadius = 25;
    snooze10.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [snooze10 setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [snooze10 setTitle:@"10m" forState:UIControlStateNormal];
    snooze10.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    snooze10.alpha = 0;
    [snoozeView addSubview:snooze10];
    
    
    snooze30 = [[UIButton alloc] initWithFrame: CGRectMake(middle + 12, 80, 50, 50)];
    snooze30.layer.cornerRadius = 25;
    snooze30.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [snooze30 setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [snooze30 setTitle:@"30m" forState:UIControlStateNormal];
    snooze30.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    snooze30.alpha = 0;
    [snoozeView addSubview:snooze30];
    
    [UIView animateWithDuration:0.5 animations:^{
       
        snoozeView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 305);
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
    
    
    ringerA = [[UIButton alloc] initWithFrame: CGRectMake(middle - 136, 80, 50, 50)];
    ringerA.layer.cornerRadius = 25;
    ringerA.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [ringerA setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [ringerA setTitle:@"A" forState:UIControlStateNormal];
    ringerA.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ringerA.alpha = 0;
    [soundsView addSubview:ringerA];
    
    
    ringerB = [[UIButton alloc] initWithFrame: CGRectMake(middle - 62, 80, 50, 50)];
    ringerB.layer.cornerRadius = 25;
    ringerB.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [ringerB setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [ringerB setTitle:@"B" forState:UIControlStateNormal];
    ringerB.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ringerB.alpha = 0;
    [soundsView addSubview:ringerB];
    
    
    ringerC = [[UIButton alloc] initWithFrame: CGRectMake(middle + 12, 80, 50, 50)];
    ringerC.layer.cornerRadius = 25;
    ringerC.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [ringerC setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [ringerC setTitle:@"C" forState:UIControlStateNormal];
    ringerC.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ringerC.alpha = 0;
    [soundsView addSubview:ringerC];
    
    ringerD = [[UIButton alloc] initWithFrame: CGRectMake(middle + 86, 80, 50, 50)];
    ringerD.layer.cornerRadius = 25;
    ringerD.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [ringerD setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [ringerD setTitle:@"D" forState:UIControlStateNormal];
    ringerD.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ringerD.alpha = 0;
    [soundsView addSubview:ringerD];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        soundsView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 460);
        
        ringerA.alpha = 1;
        ringerB.alpha = 1;
        ringerC.alpha = 1;
        ringerD.alpha = 1;
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
    } completion:^(BOOL finished) {
        
        [ringerA removeFromSuperview];
        [ringerB removeFromSuperview];
        [ringerC removeFromSuperview];
        [ringerD removeFromSuperview];
        
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
        
        volumeView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 305);
    } completion:^(BOOL finished) {
        
        volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake((SCREEN_WIDTH /2) - 110, 120, 220, 2)];
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

- (void)vibrateOptions
{
    [vibrateButton removeTarget:self action:@selector(vibrateOptions) forControlEvents:UIControlEventTouchUpInside];
    [vibrateButton addTarget:self action:@selector(closeVibrate) forControlEvents:UIControlEventTouchUpInside];
    
    [snoozeView removeFromSuperview];
    [soundsView removeFromSuperview];
    [volumeView removeFromSuperview];
    //
    
    vibrateOn = [[UIButton alloc] initWithFrame: CGRectMake(middle - 82, 80, 50, 50)];
    vibrateOn.layer.cornerRadius = 25;
    vibrateOn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [vibrateOn setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [vibrateOn setTitle:@"On" forState:UIControlStateNormal];
    vibrateOn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    vibrateOn.alpha = 0;
    [vibrateView addSubview:vibrateOn];
    
    
    vibrateOff = [[UIButton alloc] initWithFrame: CGRectMake(middle + 32, 80, 50, 50)];
    vibrateOff.layer.cornerRadius = 25;
    vibrateOff.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [vibrateOff setTitleColor:[UIColor colorWithRed:0.431f green:0.835f blue:0.318f alpha:1.0f] forState:UIControlStateNormal];
    [vibrateOff setTitle:@"Off" forState:UIControlStateNormal];
    vibrateOff.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    vibrateOff.alpha = 0;
    [vibrateView addSubview:vibrateOff];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        vibrateView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 305);
        
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
