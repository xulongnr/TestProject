//
//  SplitViewAppDelegate.m
//  SplitView
//
//  Created by Xu Norman on R.O.C. 99/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplitViewAppDelegate.h"


#import "RootViewController.h"
#import "DetailViewController.h"


@implementation SplitViewAppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch.
    
    // Add the split view controller's view to the window and display.
	rootViewController = [[[RootViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
	detailViewController = [[[DetailViewController alloc] init] autorelease];
	splitViewController = [[UISplitViewController alloc] init];
	
	splitViewController.delegate = detailViewController;
	splitViewController.viewControllers = [NSArray arrayWithObjects:rootViewController, detailViewController, nil];
	
    [self.window addSubview:splitViewController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

