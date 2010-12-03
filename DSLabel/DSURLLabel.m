//
//  DSURLLabel.m
//  urltextview
//
//  Created by duansong on 10-10-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DSURLLabel.h"


@implementation DSURLLabel

@synthesize urlString	= _urlString;
@synthesize urlLabel	= _urlLabel;
@synthesize delegate	= _delegate;


#pragma mark -
#pragma mark init method

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		_urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		_urlLabel.backgroundColor = [UIColor clearColor];
		_urlLabel.textColor = [UIColor blueColor];
		[self addSubview:_urlLabel];
		[_urlLabel release];
    }
    return self;
}


#pragma mark -
#pragma mark touch event method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_delegate && [(NSObject *)_delegate respondsToSelector:@selector(urlTouchesBegan:)]) {
		[_delegate urlTouchesBegan:self];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_delegate && [(NSObject *)_delegate respondsToSelector:@selector(urlTouchesEnd:)]) {
		[_delegate urlTouchesEnd:self];
	}
}


#pragma mark -
#pragma mark dealloc memory method

- (void)dealloc {
	[_urlString			release];
	[_urlLabel			release];
	_urlString			= nil;
	_urlLabel			= nil;
    [super dealloc];
}


@end
