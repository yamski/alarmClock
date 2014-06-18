//
//  ACAoptionsButton.m
//  alarmClock
//
//  Created by JOHN YAM on 6/18/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAoptionsButton.h"

@implementation ACAoptionsButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.layer.cornerRadius = 25;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.9f;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitle:@"5m" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.alpha = 0;
        
    }
    return self;

}

@end
