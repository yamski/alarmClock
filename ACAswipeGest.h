//
//  ACAswipeGest.h
//  alarmClock
//
//  Created by JOHN YAM on 6/3/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACAswipeGest : UISwipeGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
