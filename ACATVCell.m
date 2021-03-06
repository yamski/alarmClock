//
//  ACATVCell.m
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACATVCell.h"
#import "ACAalarmData.h"
#import "MOVE.h"

@implementation ACATVCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.allowSwipe = YES;
        self.alarmActive = YES;
        self.backgroundColor = [UIColor colorWithRed:0.824f green:0.898f blue:0.855f alpha:1.0f];
        
        self.timesButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 270, 0, 270, 125)];
        self.timesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.timesButton.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
        self.timesButton.titleLabel.textColor = [UIColor grayColor];
        self.timesButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:70];
        
        [self.timesButton addTarget:self action:@selector(selectedAlarmTime) forControlEvents:UIControlEventTouchUpInside];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timesButton];
        
        
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCell:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCell:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -130, 0, 130, 125)];
        self.deleteButton.backgroundColor = [UIColor colorWithRed:0.729f green:0.373f blue:0.349f alpha:1.0f];
        [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        
        [self.deleteButton addTarget:self action:@selector(pressingDelete) forControlEvents:UIControlEventTouchUpInside];
        
        [self selectedAlarmTime];
       
    }
    return self;
}



- (void) swipeCell:(UISwipeGestureRecognizer *)gesture
{
    
    if(gesture.direction == 2 && self.allowSwipe == YES) {
        
        [MOVE animateView:self.timesButton properties:@{@"x": @-80, @"duration": @0.3}];
        
        [self.contentView addSubview:self.deleteButton];
        
        
    }
    
    if(gesture.direction == 1 && self.allowSwipe == YES){
        
        [MOVE animateView:self.timesButton properties:@{@"x": @50, @"duration": @0.3}];
        
        [self.deleteButton removeFromSuperview];
  
    }
    
}

//- (void)setAlarmActive:(BOOL)alarmActive
//{
//    _alarmActive = alarmActive;
//    
//    _alarmActive = YES;
//
//}


- (void) selectedAlarmTime
{
    if (self.alarmActive == YES) {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.timesButton.backgroundColor = [UIColor colorWithRed:0.235f green:0.878f blue:0.388f alpha:1.0f];
            
        } completion:^(BOOL finished) {
            self.alarmActive = NO;
            self.allowSwipe = NO;
        }];
    } else {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.timesButton.backgroundColor = [UIColor colorWithRed:0.212f green:0.392f blue:0.475f alpha:1.0f];
            
        } completion:^(BOOL finished) {
            self.alarmActive = YES;
            self.allowSwipe = YES;
        }];
    }
}

- (void)pressingDelete
{
    NSLog(@"pressing delete button");
    [self.delegate deleteCell: self];
    
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
