//
//  XmlParser.h
//  RssFun
//
//  Created by Xu Norman on R.O.C. 99/12/8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XmlParser : NSObject {

	NSMutableArray *items;
	
	NSString *currentProperty;
	
	NSMutableDictionary *curItem;
	
    BOOL isSucess;
	
	NSURLConnection *connection;
	
	NSURL *feedurl;
	
	NSMutableData *xmlData;
	
	id  parentDelegate;
	SEL onCompleteCallback;
}

- (id) initWithURL:(NSURL*)url withDelegate:(id)sender onComplete:(SEL)callback;
- (NSArray*)items;
- (BOOL) isSucess;
- (NSData *)dataFromData:(NSData *)data withEncoding:(NSString *)encoding;

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSURL *feedurl;
@property(nonatomic, retain) NSMutableData *xmlData;	
	

@end
