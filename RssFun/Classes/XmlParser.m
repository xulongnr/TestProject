//
//  XmlParser.m
//  RssFun
//
//  Created by Xu Norman on R.O.C. 99/12/8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XmlParser.h"


@implementation XmlParser

@synthesize connection;
@synthesize feedurl;
@synthesize xmlData;

- (id) initWithURL:(NSURL*)url  withDelegate:(id)sender onComplete:(SEL)callback {
	parentDelegate = [sender retain];
	onCompleteCallback = callback;	
	
	items = [[NSMutableArray alloc] init];
	
	currentProperty = nil;
	curItem = nil;
	
	self.feedurl =[url retain];
	
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	[request setURL:self.feedurl];
	[request setHTTPMethod:@"GET"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	
	NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.connection = con;
	[con release];
	
	
	NSMutableData *data = [[NSMutableData alloc] init];
	self.xmlData = data;
	[data release];
	
	return self;
}


#pragma mark NSURLConnection Delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//NSLog(@”Did Receive Response with name: %@”, [response textEncodingName]);
    
	
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//NSLog(@"did receive data! %@ with length: %i", [[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding]autorelease], [data length]);
	
    //[xmlData appendData:[self dataFromData:data withEncoding:[myResponce textEncodingName]]];
	[xmlData appendData:data];
	//if ([[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]canBeConvertedToEncoding:NSUTF8StringEncoding]) {
	// NSLog(@"yes, it can!");
	//}
	
}

- (NSData *)dataFromData:(NSData *)data withEncoding:(NSString *)encoding
{
	NSStringEncoding nsEncoding = NSUTF8StringEncoding;
	if (encoding) {
		CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)encoding);
		if (cfEncoding != kCFStringEncodingInvalidId) {
			nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
		}
	}
	NSString *formattedString = [[[NSString alloc]initWithData:data encoding:nsEncoding]autorelease];
	NSLog(formattedString);
	return [[formattedString dataUsingEncoding:nsEncoding]retain];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection 
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	// returning nil prevents the response from being cached
	return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error {
	
	
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection {
	
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData :self.xmlData ];
	
	[parser setDelegate:self];	
	
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	BOOL success = [parser parse];
	
	if(!success){
		NSLog(@"parser xmlData Error!!!");	
	}
	
	isSucess = success;	
	
	
}

- (BOOL) isSucess
{
	return isSucess;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	NSString *element = [elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([element isEqualToString:@"item"]) {
		curItem = [[NSMutableDictionary alloc] init];
		
	}
	else if(curItem != nil) {
		currentProperty = [[[NSString alloc] initWithString:element] retain];
		
		NSLog(currentProperty);
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSString *element = [elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if(curItem != nil && [element isEqualToString:@"item"]) {
		[items addObject:curItem];
		[curItem release];
		curItem = nil;
		
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSString *stringValue = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSString *element = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	// Skip over blank elements.
	if (stringValue == nil || [stringValue isEqual:@""]) {
		return;
	}
	
	
	if (element != nil && [element length] > 0) {
		
		//NSLog(@"%@=%@",element,stringValue);
		
		
		if (1) {
			if ([curItem objectForKey:element] != nil) {
				// If we're adding categories, we can safely add a comma.  Otherwise, we don't, and append the string data.
				if ([element isEqual:@"category"]) {
					[curItem setObject:[NSString stringWithFormat:@"%@, %@", [curItem objectForKey:element], stringValue]
								forKey:element];
				} else {
					[curItem setObject:[NSString stringWithFormat:@"%@%@", [curItem objectForKey:element], stringValue]
								forKey:element];
					
					
				}
			} else {
				[curItem setObject:stringValue forKey:element];
			}
		} else {
			
		}
	}	
	
	if(curItem != nil && currentProperty != nil && string != nil) 
	{
		//	[curItem setObject:stringValue forKey:element];
		[currentProperty release];
	    currentProperty = nil;
	}
	
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"RssParser: Started document.");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	
	if ([parentDelegate respondsToSelector:onCompleteCallback]) {
		[parentDelegate performSelector:onCompleteCallback withObject:self];
	}
	NSLog(@"RssParser: end document.");
}

- (NSArray*)items {
	return items;
}

- (void)dealloc {
	[super dealloc];
	
	[feedurl release];
	feedurl = nil;
	
	[xmlData release];
	xmlData = nil;
	
	[connection release];
	connection =nil;
	
	[parentDelegate release];
	parentDelegate =nil;
}

@end
