#PanelTableView for iOS
Creates a UIViewController with multiple UITableView in a UIScrollView

Features
--------
* recycle views efficiently
* save/restore table offsets for different panels
* delegate and datasource similar to that of UITableView
* PanelIndexPath behaves like IndexPath, but with an additional parameter, page

Instructions
------------
1) Drag required files to your XCode Project

    PanelIndexPath.h & PanelIndexPath.m
    PanelView.h & PanelView.m
    PanelsViewController.h & PanelsViewController.m
	
2) Create a UIViewController that subclasses PanelsViewController

3) PanelsViewController contains a set of delegate/datasource methods that should be overridden in the subclass

Specifies the number of panels to create, similar to numberOfSectionsInTableView:

    - (NSInteger)numberOfPanels


Specifies the number of rows in a particular page, at a particular section, similar to tableView:numberOfRowsInSection:

    - (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section


Similar to  tableView:cellForRowAtIndexPath:

    - (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath


Create the panel. to create custom panels, subclass PanelView

    - (PanelView *)panelForPage:(NSInteger)page


 Similar to tableView:didSelectRowAtIndexPath:
 
    - (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath


Contact
-------
[honcheng.com](http://honcheng.com)  
[@honcheng](http://twitter.com/honcheng)

