//
//  RssFunViewController.h
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/15/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogRssParser.h"
#import "FeedListViewController.h"

@class BlogRssParser;
@class BlogRss;
@class RssFunAppDelegate;

@interface RssFunViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,
													BlogRssParserDelegate,FeedSelectDelegate> {
	BlogRssParser * _rssParser;
	UITableView * _tableView;
	RssFunAppDelegate * _appDelegate;
	UIToolbar * _toolbar;
	UIPopoverController * _popover;
	NSString * rssURL;
}

@property (nonatomic,retain) IBOutlet BlogRssParser * rssParser;
@property (nonatomic,retain) IBOutlet UITableView * tableView;
@property (nonatomic,retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic,retain) IBOutlet RssFunAppDelegate * appDelegate;
@property (nonatomic,retain) NSString *rssURL;

-(void)toggleToolBarButtons:(BOOL)newState;

@end

