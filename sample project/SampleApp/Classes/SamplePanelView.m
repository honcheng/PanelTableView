//
//  SamplePanelView.m
//  SampleApp
//
//  Created by honcheng on 11/27/10.
//  Copyright 2010 honcheng. All rights reserved.
//

#import "SamplePanelView.h"


@implementation SamplePanelView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self.tableView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
