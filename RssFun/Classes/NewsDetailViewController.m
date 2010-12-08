//
//  NewsDetailViewController.m
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "RssFunAppDelegate.h"
#import "BlogRss.h";

@implementation NewsDetailViewController

@synthesize appDelegate = _appDelegate;
@synthesize titleTextView = _titleTextView;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize toolbar = _toolbar;
@synthesize image = _image;

-(void)viewDidLoad{
	[super viewDidLoad];
	[self setTitle:@"世考科技 新闻阅读"];
	 
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemAction
									  target:self action:@selector(openWebLink)];
	NSArray *items = [NSArray arrayWithObjects: actionButton,  nil];
	[self.toolbar setItems:items animated:NO];
	[actionButton release];
}

-(void)openWebLink{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to open current item in browser?"
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromToolbar:_toolbar];
	[actionSheet release];	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[self appDelegate] currentlySelectedBlogItem]linkUrl]]];
	}
}

- (void)setLabelPositon {
	
	CGRect imageRect = self.image.frame;
	imageRect.origin.y = imageRect.size.height;
	imageRect.size.height = 16;
	[_titleCompanyLabel setFrame:imageRect];
	
	CGRect txtRect = CGRectMake(0, 0, _image.frame.origin.x, _image.frame.size.height+20);
	[_titleTextView setFrame:txtRect];
	[_titleTextView setFont:[UIFont boldSystemFontOfSize:35]];
	//[_titleTextView setTextAlignment:UITextAlignmentCenter];
	
	txtRect = CGRectMake(0, txtRect.size.height, _appDelegate.window.frame.size.width, 
						 _appDelegate.window.frame.size.height - txtRect.size.height); 
	[_descriptionTextView setFrame:txtRect];
	[_descriptionTextView setFont:[UIFont systemFontOfSize:20]];	
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	// Set default image name
	[[self image] setImage:[UIImage imageNamed:@"SicoTech.jpg"]];
	
	self.titleTextView.text = [[[self appDelegate] currentlySelectedBlogItem]title];
	self.descriptionTextView.text = [[[self appDelegate] currentlySelectedBlogItem]description];
	
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
	[_appDelegate release];
    [super dealloc];
}


@end
