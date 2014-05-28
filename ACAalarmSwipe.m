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
   
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
