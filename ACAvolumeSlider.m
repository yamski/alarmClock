//
//  ACAvolumeSlider.m
//  alarmClock
//
//  Created by JOHN YAM on 6/13/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAvolumeSlider.h"

@implementation ACAvolumeSlider

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -10, -15);
    return CGRectContainsPoint(bounds, point);
}

@end
