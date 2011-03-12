    //
//  SamplePanelsViewControllerForiPad.m
//  SampleApp
//
//  Created by honcheng on 3/12/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import "SamplePanelsViewControllerForiPad.h"


@implementation SamplePanelsViewControllerForiPad

#pragma mark sizes

- (CGRect)scrollViewFrame
{
	return CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height);
}

- (int)numberOfVisiblePanels
{
	return 2;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
