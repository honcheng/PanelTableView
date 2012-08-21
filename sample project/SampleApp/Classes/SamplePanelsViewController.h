//
//  SamplePanelsViewController.h
//  SampleApp
//
//  Created by honcheng on 11/27/10.
//  Copyright 2010 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelsViewController.h"

@interface SamplePanelsViewController : PanelsViewController
@property (nonatomic, strong) NSMutableArray *panelsArray;
@property (nonatomic, strong) UIBarButtonItem *editItem, *doneItem, *addRemoveItem;
- (void)addTemporaryUI;

@end
