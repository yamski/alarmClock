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
        self.backgroundColor = [UIColor colorWithRed:0.824f green:0.898f blue:0.855f alpha:1.0f];
        
        self.timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 270, 0, 270, 125)];
        self.timesLabel.textAlignment = NSTextAlignmentCenter;
        self.timesLabel.backgroundColor = [UIColor colorWithRed:0.898f green:0.996f blue:0.412f alpha:1.0f];
        self.timesLabel.textColor = [UIColor grayColor];
        self.timesLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:70];
        [self.contentView addSubview:self.timesLabel];
        
        
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCell:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCell:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
       
    }
    return self;
}
- (void) swipeCell:(UISwipeGestureRecognizer *)gesture
{
    if(gesture.direction == 2){
        
        [MOVE animateView:self.timesLabel properties:@{@"x": @-80, @"duration": @0.3}];
        
        NSLog(@"%f",self.timesLabel.frame.origin.x);
    }
    
    if(gesture.direction == 1){
        
        [MOVE animateView:self.timesLabel properties:@{@"x": @50, @"duration": @0.3}];
        NSLog(@"%f",self.timesLabel.frame.origin.x);
        
    }
    
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
