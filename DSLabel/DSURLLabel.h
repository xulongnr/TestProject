//
//  DSURLLabel.h
//  urltextview
//
//  Created by duansong on 10-10-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSURLLabelDelegate;

@interface DSURLLabel : UIView {
	NSString					*_urlString;
	UILabel						*_urlLabel;
	id<DSURLLabelDelegate>		_delegate;
}

@property (nonatomic, retain) NSString					*urlString;
@property (nonatomic, retain) UILabel					*urlLabel;
@property (nonatomic, assign) id<DSURLLabelDelegate>	delegate;

@end


@protocol DSURLLabelDelegate

@optional

- (void)urlTouchesBegan:(DSURLLabel *)urlLabel;
- (void)urlTouchesEnd:(DSURLLabel *)urlLabel;


@end

