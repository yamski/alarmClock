//
//  ACAalarmsTVC.h
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACATVCell.h"

@protocol ACAalarmsTVCDelegate;


@interface ACAalarmsTVC : UITableViewController

@property (nonatomic) id <ACAalarmsTVCDelegate> delegate;


@end

@protocol ACAalarmsTVCDelegate <NSObject>

//- (void)statusColor: (NSInteger)num;

- (void)checkActiveAlarms;
@end

