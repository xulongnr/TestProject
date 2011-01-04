//
//  RootViewController.h
//  SplitView
//
//  Created by Xu Norman on R.O.C. 99/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
	NSArray *arrayFeeds;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
