//
//  FeedListViewController.h
//  RssFun
//
//  Created by Xu Norman on R.O.C. 99/12/13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RssFunViewController;

@protocol FeedSelectDelegate
-(void) feedSelectd:(NSString *)rssUrl;
@end

@interface FeedListViewController : UITableViewController {

	RssFunViewController	 * rssViewController;
	UINavigationController   * _navigationController;
	id<FeedSelectDelegate> delegate;
	NSArray *feedList;
}

@property (nonatomic, retain) IBOutlet RssFunViewController *rssViewController;
@property (nonatomic, retain) NSArray *feedList;
@property (nonatomic, assign) id<FeedSelectDelegate> delegate;

@end
