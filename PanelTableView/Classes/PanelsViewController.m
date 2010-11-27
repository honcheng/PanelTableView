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

#import "PanelsViewController.h"


@interface PanelsViewController()
- (void)tilePages;
- (void)configurePage:(PanelView*)page forIndex:(int)index;
- (BOOL)isDisplayingPageForIndex:(int)index;
- (PanelView *)panelForPage:(NSInteger)page;
@end

@implementation PanelsViewController
@synthesize scrollView;
@synthesize recycledPages, visiblePages;

#define GAP 10
#define TAG_PAGE 11000

- (void)loadView
{
	[super loadView];
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-1*GAP,0,[self.view bounds].size.width+2*GAP,[self.view bounds].size.height)];
	[self.scrollView setDelegate:self];
	[self.scrollView setShowsHorizontalScrollIndicator:NO];
	[self.scrollView setPagingEnabled:YES];
	[self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.view addSubview:self.scrollView];
	[self.scrollView release];
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*[self numberOfPanels],self.scrollView.frame.size.width)];
	
	self.recycledPages = [NSMutableSet new];
	self.visiblePages = [NSMutableSet new];
	
	[self tilePages];
	
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
	[self.scrollView release];
	[self.recycledPages release];
	[self.visiblePages release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
	PanelView *panelView = [self panelViewAtPage:currentPage];
	[panelView pageDidAppear];
}

- (void)viewWillAppear:(BOOL)animated
{
	PanelView *panelView = [self panelViewAtPage:currentPage];
	[panelView pageWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
	PanelView *panelView = [self panelViewAtPage:currentPage];
	[panelView pageWillDisappear];
}

#pragma mark adding and removing panels

- (void)addPage
{
	//numberOfPages += 1;
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*[self numberOfPanels],self.scrollView.frame.size.width)];
}

- (void)removeCurrentPage
{	
	if (currentPage==[self numberOfPanels] && currentPage!=0)
	{
		// this is the last page
		//numberOfPages -= 1;
		
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelView showPanel:NO animated:YES];
		[self removeContentOfPage:currentPage];
		
		[panelView performSelector:@selector(showPreviousPanel) withObject:nil afterDelay:0.4];
		[self performSelector:@selector(jumpToPreviousPage) withObject:nil afterDelay:0.6];
	}
	else if ([self numberOfPanels]==0)
	{
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelView showPanel:NO animated:YES];
		[self removeContentOfPage:currentPage];
	}
	else 
	{
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelView showPanel:NO animated:YES];
		[self removeContentOfPage:currentPage];
		[self performSelector:@selector(pushNextPage) withObject:nil afterDelay:0.4];
	}
}

- (void)jumpToPreviousPage
{
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*[self numberOfPanels],self.scrollView.frame.size.width)];
}

- (void)pushNextPage
{
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*[self numberOfPanels],self.scrollView.frame.size.width)];
	
	PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
	[panelView showNextPanel];
	[panelView pageWillAppear];
}

- (void)removeContentOfPage:(int)page
{
	
}

#pragma mark scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView_
{
	PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
	[panelView pageWillDisappear];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView_
{
	//NSLog(@"%@", scrollView_);
	[self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	
	if (currentPage!=lastDisplayedPage)
	{
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+currentPage];
		[panelView pageDidAppear];
	}
	
	lastDisplayedPage = currentPage;
}

#pragma mark reuse table views

- (void)tilePages
{
	CGRect visibleBounds = [self.scrollView bounds];
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
	firstNeededPageIndex = MAX(firstNeededPageIndex,0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, [self numberOfPanels]-1);
	
	currentPage = firstNeededPageIndex;
	
	for (PanelView *panel in self.visiblePages)
	{
		if (panel.pageNumber < firstNeededPageIndex || panel.pageNumber > lastNeededPageIndex)
		{
			[self.recycledPages addObject:panel];
			[panel removeFromSuperview];
		}
	}
	[self.visiblePages minusSet:self.recycledPages];
	
	for (int index=firstNeededPageIndex; index<=lastNeededPageIndex; index++)
	{
		if (![self isDisplayingPageForIndex:index])
		{
			PanelView *panel = [self panelForPage:index];
			int x = ([self.view bounds].size.width+2*GAP)*index + GAP;
			CGRect panelFrame = CGRectMake(x,0,[self.view bounds].size.width,[self.view bounds].size.height);
			
			[panel setFrame:panelFrame];
			[panel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
			[panel setDelegate:self];
			[panel setTag:TAG_PAGE+index];
			[panel setPageNumber:index];
			[panel pageWillAppear];

			[self.scrollView addSubview:panel];
			[self.visiblePages addObject:panel];
		}
	}
}

- (BOOL)isDisplayingPageForIndex:(int)index
{
	for (PanelView *page in self.visiblePages)
	{
		if (page.pageNumber==index) return YES;
	}
	return NO;
}

- (void)configurePage:(PanelView*)page forIndex:(int)index
{
	int x = ([self.view bounds].size.width+2*GAP)*index + GAP;
	CGRect pageFrame = CGRectMake(x,0,[self.view bounds].size.width,[self.view bounds].size.height);
	[page setFrame:pageFrame];
	[page setPageNumber:index];
	[page pageWillAppear];
}

- (PanelView*)dequeueReusablePageWithIdentifier:(NSString*)identifier
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.identifier == %@", identifier];
	NSSet *filteredSet =[self.recycledPages filteredSetUsingPredicate:predicate];
	PanelView *page = [filteredSet anyObject];
	if (page)
	{
		[[page retain] autorelease];
		[self.recycledPages removeObject:page];
	}
	return page;
}

#pragma mark panel views

- (PanelView *)panelViewAtPage:(NSInteger)page
{
	PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+page];
	return panelView;
}

- (PanelView *)panelForPage:(NSInteger)page
{
	static NSString *identifier = @"PanelTableView";
	PanelView *panelView = (PanelView*)[self dequeueReusablePageWithIdentifier:identifier];
	if (panelView == nil)
	{
		panelView = [[[PanelView alloc] initWithIdentifier:identifier] autorelease];
	}
	return panelView;
}

- (NSInteger)numberOfPanels
{
	return 0;
}

- (CGFloat)panelView:(PanelView *)panelView heightForRowAtIndexPath:(PanelIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
	static NSString *identity = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:identity];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity] autorelease];
	}
	return cell;
}

- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return 0;
}

- (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
{
	
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	return [super respondsToSelector:aSelector];
}


@end
