//
//  ACAalarmSwipe.m
//  alarmClock
//
//  Created by JOHN YAM on 5/27/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAalarmSwipe.h"
#import "ACATableView.h"

@implementation ACAalarmSwipe
{
    CGPoint prevLocation;
    CGPoint location;
    
    int hour;
    int min;
    
    ACATableView * menu;
   
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.options = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 20, SCREEN_HEIGHT - 60, 40, 40)];
        self.options.backgroundColor = [UIColor lightGrayColor];
        self.options.alpha = 0;
        self.options.layer.cornerRadius = 20;
        [self.options addTarget:self action:@selector(optionsMenu) forControlEvents:UIControlEventTouchUpInside];
        
        [self buttonAppear];
        
        menu = [[ACATableView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT - 170)];
     
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
    [self addSubview:menu];
    
    [self.options addTarget:self action:@selector(removeMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeMenu
{
    [menu removeFromSuperview];
    
    [self.options addTarget:self action:@selector(optionsMenu) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    location = [touch locationInView:self];
    
    if (location.x - prevLocation.x > 50) {
        
        NSLog(@"swiping right");
        hour = hour + 1;
        
        prevLocation = location;
        
    } else if (location.x - prevLocation.x < -50) {
        
        NSLog(@"swiping left");
        
        hour = hour - 1;
        
        prevLocation = location;
    }
    
    if (location.y - prevLocation.y > 20) {
        
        NSLog(@"swiping up");
        min = min - 1;
        
        prevLocation = location;
    }
    
    if (location.y - prevLocation.y < -20){
        
        NSLog(@"swiping down");
        
        min = min + 1;
        
        prevLocation = location;
    }
    
    [self.delegate updateAlarm:hour :min];
    
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
