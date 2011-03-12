/**
 * Copyright (c) 2009 Muh Hon Cheng
 * Created by honcheng on 11/27/10.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2010	Muh Hon Cheng
 * @version
 * 
 */

#import <UIKit/UIKit.h>
#import "PanelIndexPath.h"

@protocol PanelViewDelegate
- (NSInteger)panelView:(id)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section;
- (UITableViewCell *)panelView:(id)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath;
- (void)panelView:(id)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath;
- (CGFloat)panelView:(id)panelView heightForRowAtIndexPath:(PanelIndexPath *)indexPath;
- (BOOL)respondsToSelector:(SEL)selector;
- (NSInteger)numberOfSectionsInPanelView:(id)panelView;
- (NSString*)panelView:(id)panelView titleForHeaderInSection:(NSInteger)section;
@end

@interface PanelView : UIView <UITableViewDelegate, UITableViewDataSource>{
	int pageNumber;
	UITableView *tableView;
	id<PanelViewDelegate> delegate;
	NSString *identifier;
}

@property (nonatomic, assign) int pageNumber;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id<PanelViewDelegate> delegate;
@property (nonatomic, retain) NSString *identifier;

- (id)initWithIdentifier:(NSString*)_identifier;
- (void)reset;
- (void)pageWillAppear;
- (void)pageDidAppear;
- (void)pageWillDisappear;
- (CGAffineTransform)transformForOrientation;
- (void)showPanel:(BOOL)show animated:(BOOL)animated;

#pragma mark offset save/restore
- (void)saveTableviewOffset;
- (void)restoreTableviewOffset;
- (void)removeTableviewOffset;

#pragma mark add and remove panels
- (void)addPanelWithAnimation:(BOOL)animate;
- (void)removePanelWithAnimation:(BOOL)animate;

- (void)showNextPanel;
- (void)showPreviousPanel;



@end
