//
//  ACATVCell.m
//  alarmClock
//
//  Created by JOHN YAM on 5/29/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACATVCell.h"
#import "ACAalarmData.h"

@implementation ACATVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 125)];
        self.timesLabel.textAlignment = NSTextAlignmentLeft;
        //self.timesLabel.backgroundColor = [UIColor blueColor];
        self.timesLabel.textColor = [UIColor grayColor];
        self.timesLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
        [self.contentView addSubview:self.timesLabel];
       
    }
    return self;
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
