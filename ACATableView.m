//
//  ACATableView.m
//  alarmClock
//
//  Created by JOHN YAM on 5/31/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACATableView.h"

@implementation ACATableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsZero;
        
        self.rowHeight = 100;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  5;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
