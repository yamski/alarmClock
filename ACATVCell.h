//
//  ACATVCell.h
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ACATVCellDelegate;


@interface ACATVCell : UITableViewCell

@property (nonatomic, assign) id <ACATVCellDelegate> delegate;
@property (nonatomic) UILabel * bgLabel;
@property (nonatomic) UILabel * timesLabel;
@property (nonatomic) UIButton * activateButton;
@property (nonatomic) BOOL alarmActive;
@property (nonatomic) NSInteger index;

@end

@protocol ACATVCellDelegate <NSObject>

-(void)talktoTVC :(NSInteger)num;
//- (void)setSnoozeValues: (NSInteger)num;

@end