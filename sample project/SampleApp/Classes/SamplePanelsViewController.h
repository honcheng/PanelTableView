//
//  SamplePanelsViewController.h
//  SampleApp
//
//  Created by honcheng on 11/27/10.
//  Copyright 2010 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelsViewController.h"

@interface SamplePanelsViewController : PanelsViewController {
	NSMutableArray *panelsArray;
	UIBarButtonItem *editItem, *doneItem, *addRemoveItem;
}

@property (nonatomic, retain) NSMutableArray *panelsArray;

- (void)addTemporaryUI;

@end
