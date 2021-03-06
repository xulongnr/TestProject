//
//  RssFunViewController.m
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/15/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RssFunViewController.h"
#import "BlogRssParser.h"
#import "BlogRss.h";
#import "RssFunAppDelegate.h"
#import "FeedListViewController.h"

@implementation RssFunViewController

@synthesize rssParser;
@synthesize tableView = _tableView;
@synthesize appDelegate;
@synthesize rssURL;

-(void)barButtonsInit{
    refreshButton = [[UIBarButtonItem alloc]
					initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
					target:self action:@selector(reloadRss)];
	refreshButton.enabled = NO;
	self.navigationItem.rightBarButtonItem = refreshButton;
	
	UIBarButtonItem *feedsButton = [[UIBarButtonItem alloc]
									initWithTitle:@"选择订阅" style:UIBarButtonItemStylePlain
									target:self action:@selector(barBtnTapped:)];
	feedsButton.enabled = YES;
	self.navigationItem.leftBarButtonItem = feedsButton;
	
	[feedsButton release];
}

-(void)barBtnTapped:(id) sender {
	if ([_popover isPopoverVisible]) {
		[_popover dismissPopoverAnimated:YES];
	
	} else {

	FeedListViewController *flv = [[FeedListViewController alloc] init];
	flv.delegate = self;
	_popover = [[UIPopoverController alloc] initWithContentViewController:flv];
	[flv release];
	[_popover presentPopoverFromBarButtonItem:sender 
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
	}
}

-(void)setRssURL:(NSString *)newRssURL {
	if (rssURL != newRssURL) {
		[rssURL release];
		rssURL = [newRssURL retain];
		
		NSLog(@"setting rss to %@", newRssURL);
		
		[self configureView];
	}
	
	if (_popover != nil) {
		[_popover dismissPopoverAnimated:YES];
	}
}

-(void)configureView {
		
	[[self rssParser] setUrlRss:rssURL];
	[[self rssParser] startProcess];
}

-(void)feedSelectd:(NSString *)rssUrl {
	
	NSLog(@"feedSelected called");
	[self setRssURL:rssUrl];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[self setTitle:@"新闻索引"];
	[self barButtonsInit];
	rssParser = [[BlogRssParser alloc] init];
	self.rssParser.delegate = self;
	
	// set rss to weiphone by default
	self.rssURL = @"http://news.weiphone.com/rss.xml";
	
	NSLog(@"view Did Load");
	
	//[self configureView];
}
	
-(void)reloadRss{
	[self toggleBarButtons:NO];
	[[self rssParser] startProcess];
}

-(void)toggleBarButtons:(BOOL)newState{
	refreshButton.enabled = newState;
}

//Delegate method for blog parser will get fired when the process is completed
- (void)processCompleted{
	//reload the table view
	[self toggleBarButtons:YES];
	[[self tableView] reloadData];
}

-(void)processHasErrors{
	//Might be due to Internet
	UIAlertView *alert = [[UIAlertView alloc] 
			initWithTitle:@"世考新闻" message:@"尊敬的用户，我们十分抱歉的告诉您，因为您的账户余额不足，所以无权限继续访问，谢谢！"
			 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
	[alert show];	
	[alert release];
	[self toggleBarButtons:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[[self rssParser]rssItems]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"rssItemCell"];
	if(nil == cell){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"rssItemCell"]autorelease];
	}
	cell.textLabel.text = [[[[self rssParser]rssItems]objectAtIndex:indexPath.row]title];
	cell.detailTextLabel.text = [[[[self rssParser]rssItems]objectAtIndex:indexPath.row]description];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self appDelegate] setCurrentlySelectedBlogItem:[[[self rssParser]rssItems]objectAtIndex:indexPath.row]];
	[self.appDelegate loadNewsDetails];
}



#pragma mark -
#pragma mark Rotate view support


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	
	BOOL IsiPad = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		IsiPad = YES;
	}
#endif
	
	if (IsiPad) {
		return YES;
	} else {
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	}
	
}


- (void)dealloc {
	[refreshButton release];
	[appDelegate release];
	[_tableView release];
	[rssParser release];
	[_popover release];
    [super dealloc];
}

@end
