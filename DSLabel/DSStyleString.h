//
//  DSStyleString.h
//  urltextview
//
//  Created by duansong on 10-10-9.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DSStyleString : NSObject {
	NSString		*_string;
	BOOL			_isUrl;
}

@property (nonatomic, copy)		NSString	*string;
@property (nonatomic, assign)	BOOL		isUrl;

@end
