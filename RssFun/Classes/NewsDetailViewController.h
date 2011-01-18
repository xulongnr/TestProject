//
//  NewsDetailViewController.h
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RssFunAppDelegate;

@interface NewsDetailViewController : UIViewController <UIActionSheetDelegate>{
	RssFunAppDelegate * appDelegate;
	UITextView        * titleTextView;
	UIBarButtonItem   * openLinkButton;
}

@property (nonatomic, retain) IBOutlet RssFunAppDelegate * appDelegate;
@property (nonatomic, retain) IBOutlet UITextView * titleTextView;

@end
