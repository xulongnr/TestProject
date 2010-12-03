//
//  DSLabelAppDelegate.h
//  DSLabel
//
//  Created by duansong on 10-10-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSLabelViewController;

@interface DSLabelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DSLabelViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DSLabelViewController *viewController;

@end

