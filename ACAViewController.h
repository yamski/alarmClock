//
//  ACAViewController.h
//  alarmClock
//
//  Created by JOHN YAM on 5/26/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ACAViewController : UIViewController 


@property (nonatomic) BOOL popUpToggle;
@property (nonatomic) BOOL alarmSettable;
@property (nonatomic) UIButton * alarmStatus;
@property (nonatomic) AVAudioPlayer * player;

- (void)showAlarmView;
- (void)archiveData;
- (void)addAlarmOptions: (NSMutableDictionary *)dict;
@end
