//
//  BlogRssParser.h
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BlogRss;

@protocol BlogRssParserDelegate;

@interface BlogRssParser : NSObject {
	BlogRss * _currentItem;
	NSMutableString * _currentItemValue;
	NSMutableArray * _rssItems;
	id<BlogRssParserDelegate> _delegate;
	NSOperationQueue *_retrieverQueue;
	NSString *_textEncodingName;
	NSString *_urlRss;
}


@property(nonatomic, retain) BlogRss * currentItem;
@property(nonatomic, retain) NSMutableString * currentItemValue;
@property(readonly) NSMutableArray * rssItems;

@property(nonatomic, assign) id<BlogRssParserDelegate> delegate;
@property(nonatomic, retain) NSOperationQueue *retrieverQueue;
@property(nonatomic, retain) NSString *urlRss;

- (void)startProcess;


@end

@protocol BlogRssParserDelegate <NSObject>

-(void)processCompleted;
-(void)processHasErrors;

@end
