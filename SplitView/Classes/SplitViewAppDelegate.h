//
//  SplitViewAppDelegate.h
//  SplitView
//
//  Created by Xu Norman on R.O.C. 99/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RootViewController;
@class DetailViewController;

@interface SplitViewAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    RootViewController *rootViewController;
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
