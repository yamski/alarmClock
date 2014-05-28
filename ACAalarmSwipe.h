//
//  ACAalarmSwipe.h
//  alarmClock
//
//  Created by JOHN YAM on 5/27/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACAalarmSwipeDelegate;

@interface ACAalarmSwipe : UIView

@property (nonatomic, assign) id <ACAalarmSwipeDelegate> delegate;

@end


@protocol ACAalarmSwipeDelegate <NSObject>

@required

- (void)updateAlarm:(int)hour :(int)min;

@end


