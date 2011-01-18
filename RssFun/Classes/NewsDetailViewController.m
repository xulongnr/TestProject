//
//  NewsDetailViewController.m
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "RssFunAppDelegate.h"
#import "BlogRss.h"

@implementation NewsDetailViewController

@synthesize appDelegate;
@synthesize titleTextView;


-(void)viewDidLoad{
	[super viewDidLoad];
	[self setTitle:@"新闻阅读"];
	 
    openLinkButton = [[UIBarButtonItem alloc]
					initWithBarButtonSystemItem:UIBarButtonSystemItemAction
					target:self action:@selector(openWebLink)];
	
	self.navigationItem.rightBarButtonItem = openLinkButton;
}

-(void)openWebLink{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								initWithTitle:@"Do you want to open current item in browser?"
								delegate:self cancelButtonTitle:@"Cancel" 
								destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromBarButtonItem:openLinkButton animated:YES];
	[actionSheet release];	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[self appDelegate] currentlySelectedBlogItem]linkUrl]]];
	}
}

- (void)setLabelPositon {
	
	CGRect txtRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	[titleTextView setFrame:txtRect];
	[titleTextView setFont:[UIFont systemFontOfSize:23]];
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	NSMutableString * textString = [[NSMutableString alloc] init];
	[textString appendString:[[[self appDelegate] currentlySelectedBlogItem] title]];
	[textString appendString:@"\n-------------------------------------------------\n"];
	[textString appendString:[[[self appDelegate] currentlySelectedBlogItem] description]];
	 
	self.titleTextView.text = textString;
	
	[self setLabelPositon];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self setLabelPositon];
}

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
	[openLinkButton release];
    [super dealloc];
}


@end
