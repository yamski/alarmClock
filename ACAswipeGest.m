//
//  ACAswipeGest.m
//  alarmClock
//
//  Created by JOHN YAM on 6/3/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAswipeGest.h"
#import "ACATweetVC.h"

@implementation ACAswipeGest

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[ACATweetVC class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
