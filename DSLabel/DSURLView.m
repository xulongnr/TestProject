//
//  DSURLView.m
//  urltextview
//
//  Created by duansong on 10-10-9.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DSURLView.h"
#import "DSStyleString.h"

#define FontSize		15.0f
#define LineBreakMode	UILineBreakModeCharacterWrap


@implementation DSURLView

@synthesize sourceText			= _sourceText;
@synthesize frameWidth			= _frameWidth;
@synthesize frameOriginX		= _frameOriginX;
@synthesize frameOriginY		= _frameOriginY;
@synthesize delegate			= _delegate;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
    }
    return self;
}

#pragma mark -
#pragma mark custom methods

- (NSMutableArray *)splitStringByUrl:(NSString *)source {
	[source retain];
	
	NSMutableArray *elementsArray = [[[NSMutableArray alloc] init] autorelease];
	NSInteger index = 0;
	while (index < source.length) {
		NSRange searchRange = NSMakeRange(index, source.length - index);
		NSRange startRange = [source rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
		if (startRange.location == NSNotFound) {
			DSStyleString *currentElement = [[DSStyleString alloc] init];
			currentElement.isUrl = NO;
			currentElement.string = [source substringWithRange:searchRange];
			[elementsArray addObject:currentElement];
			break;
		}else {
			NSRange beforeRange = NSMakeRange(searchRange.location, startRange.location - searchRange.location);
			if (beforeRange.length) {
				DSStyleString *beforeElement = [[DSStyleString alloc] init];
				beforeElement.isUrl = NO;
				beforeElement.string = [source substringWithRange:beforeRange];
				[elementsArray addObject:beforeElement];
			}
			
			NSRange searchRange = NSMakeRange(startRange.location, source.length - startRange.location);
			NSRange endRange = [source rangeOfString:@" " options:NSCaseInsensitiveSearch range:searchRange];
			if (endRange.location == NSNotFound) {
				DSStyleString *urlElement = [[DSStyleString alloc] init];
				urlElement.isUrl = YES;
				urlElement.string = [source substringWithRange:searchRange];
				[elementsArray addObject:urlElement];
				break;
			}else {
				NSRange urlRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
				DSStyleString *urlElement = [[DSStyleString alloc] init];
				urlElement.isUrl = YES;
				urlElement.string = [source substringWithRange:urlRange];
				[elementsArray addObject:urlElement];
				index = endRange.location;
			}
		}
	}
	
	[source release];
	return elementsArray;
}

- (void)layoutURLViewWithElements:(NSMutableArray *)elements {
	[elements retain];
	NSInteger count = [elements count];
	if (count == 0) return;
	BOOL haveHttp = NO;
	for (DSStyleString *styleString in elements) {
		if (styleString.isUrl == YES) {
			haveHttp = YES;
			break;
		}
	}
	
	if (haveHttp == YES) {
		for (int i = 0; i < count; i ++) {
			DSStyleString *styleString = (DSStyleString *)[elements objectAtIndex:i];
			NSArray *existSubViews = [self subviews];
			if ([existSubViews count] > 0) {
				UIView *lastSubView = [existSubViews lastObject];
				NSString *forwardSourceString = nil;
				NSString *lastLineStringOfForwardSourceString = nil;
				NSInteger lastLineStringWidthOfForwardSourceString = 0;
				NSInteger leaveWidth = 0;
				CGFloat originX = 0;
				CGFloat originY = 0;
				CGFloat width = 0;
				CGFloat height = 0;
				CGFloat characterHeight = [self getHeightWithFontSize:FontSize];
				
				if ([[lastSubView class] isSubclassOfClass:[UILabel class]]) {
					forwardSourceString = [(UILabel *)lastSubView text];
				}else if ([[lastSubView class] isSubclassOfClass:[DSURLLabel class]]) {
					forwardSourceString = [[(DSURLLabel *)lastSubView urlLabel] text];
				}	
				
				CGSize forwardSourceStringSize = [self sizeForString:forwardSourceString];
				lastLineStringOfForwardSourceString = [forwardSourceString substringFromIndex:[self findStartIndexOfLastLineText:forwardSourceString]];
				CGSize lastLineStringOfForwardSourceStringSize = [self sizeForString:lastLineStringOfForwardSourceString];
				lastLineStringWidthOfForwardSourceString = lastLineStringOfForwardSourceStringSize.width;
				if (forwardSourceStringSize.height > characterHeight) {
					leaveWidth = _frameWidth - lastLineStringOfForwardSourceStringSize.width;
				}else {
					leaveWidth = _frameWidth - lastSubView.frame.origin.x - lastSubView.frame.size.width;
				}
				
				NSMutableArray *splitedSubStringByLimitWidthArray = [[NSMutableArray alloc] init];
				[splitedSubStringByLimitWidthArray addObjectsFromArray:[self splitStringBylimitWidth:leaveWidth source:styleString.string]];
				
				if ([splitedSubStringByLimitWidthArray count] == 1) {
					if (_needNewLine) {
						originX = 0;
						originY = lastSubView.frame.origin.y + lastSubView.frame.size.height;
					}else {
						if (forwardSourceStringSize.height > characterHeight) {
							originX = lastLineStringOfForwardSourceStringSize.width;
						}else {
							originX = lastSubView.frame.origin.x + lastSubView.frame.size.width;
						}
						originY = lastSubView.frame.origin.y + lastSubView.frame.size.height - characterHeight;
					}
					
					CGSize newLabelSize = [self sizeForString:styleString.string];
					width = newLabelSize.width;
					height = newLabelSize.height;
					
					if (styleString.isUrl == YES) {
						DSURLLabel *urlLabel = [[DSURLLabel alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
						urlLabel.backgroundColor = [UIColor clearColor];
						urlLabel.urlString = styleString.string;
						urlLabel.urlLabel.text = styleString.string;
						urlLabel.urlLabel.numberOfLines = 0;
						urlLabel.urlLabel.lineBreakMode = LineBreakMode;
						urlLabel.urlLabel.font = [UIFont systemFontOfSize:FontSize];
						urlLabel.delegate = self;
						[self addSubview:urlLabel];
						[urlLabel release];
					}else {
						UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
						textLabel.numberOfLines = 0;
						textLabel.lineBreakMode = LineBreakMode;
						textLabel.font = [UIFont systemFontOfSize:FontSize];
						textLabel.backgroundColor = [UIColor clearColor];
						textLabel.text = styleString.string;
						[self addSubview:textLabel];
						[textLabel release];
					}
					
				}else if ([splitedSubStringByLimitWidthArray count] == 2) {
					for(int i = 0; i < 2; i++) {
						NSString *currentSubString = [splitedSubStringByLimitWidthArray objectAtIndex:i];
						CGSize newLabelSize = [self sizeForString:currentSubString];
						if (i == 0) {
							if (forwardSourceStringSize.height > characterHeight) {
								originX = lastLineStringOfForwardSourceStringSize.width;
							}else {
								originX = lastSubView.frame.origin.x + lastSubView.frame.size.width;
							}
							originY = lastSubView.frame.origin.y + lastSubView.frame.size.height - characterHeight;
							width = _frameWidth - originX;
						}else if (i == 1) {
							originX = 0;
							originY = lastSubView.frame.origin.y + lastSubView.frame.size.height;
							width = newLabelSize.width;
							
						}
						height = newLabelSize.height;
						
						
						if (styleString.isUrl == YES) {
							DSURLLabel *urlLabel = [[DSURLLabel alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
							urlLabel.backgroundColor = [UIColor clearColor];
							urlLabel.urlString = styleString.string;
							urlLabel.urlLabel.text = currentSubString;
							urlLabel.urlLabel.font = [UIFont systemFontOfSize:FontSize];
							urlLabel.urlLabel.lineBreakMode = LineBreakMode;
							if (i == 0) {
								urlLabel.urlLabel.numberOfLines = 1;
							}else if (i == 1) {
								urlLabel.urlLabel.numberOfLines = 0;
							}
							urlLabel.delegate = self;
							[self addSubview:urlLabel];
							[urlLabel release];
						}else {
							UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
							textLabel.backgroundColor = [UIColor clearColor];
							textLabel.font = [UIFont systemFontOfSize:FontSize];
							textLabel.lineBreakMode = LineBreakMode;
							if (i == 0) {
								textLabel.numberOfLines = 1;
							}else if (i == 1) {
								textLabel.numberOfLines = 0;
							}
							textLabel.text = currentSubString;
							[self addSubview:textLabel];
							[textLabel release];
						}
					}
				}
				
				[splitedSubStringByLimitWidthArray release];
				
			}else {
				CGSize newLabelSize = [self sizeForString:styleString.string];
				if (styleString.isUrl == YES) {
					DSURLLabel *urlLabel = [[DSURLLabel alloc] initWithFrame:CGRectMake(0, 0, newLabelSize.width, newLabelSize.height)];
					urlLabel.backgroundColor = [UIColor clearColor];
					urlLabel.urlLabel.font = [UIFont systemFontOfSize:FontSize];
					urlLabel.urlLabel.numberOfLines = 0;
					urlLabel.urlLabel.lineBreakMode = LineBreakMode;
					urlLabel.urlString = styleString.string;
					urlLabel.urlLabel.text = styleString.string;
					urlLabel.delegate = self;
					[self addSubview:urlLabel];
					[urlLabel release];
				}else {
					UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, newLabelSize.width, newLabelSize.height)];
					label.backgroundColor = [UIColor clearColor];
					label.text = styleString.string;
					label.font = [UIFont systemFontOfSize:FontSize];
					label.numberOfLines = 0;
					label.lineBreakMode = LineBreakMode;
					[self addSubview:label];
					[label release];
				}
			}
		}
	}else {
		DSStyleString *styleString = [elements objectAtIndex:0];
		CGSize textSize = [self sizeForString:styleString.string];
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
		textLabel.numberOfLines = 0;
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.lineBreakMode = LineBreakMode;
		textLabel.text = _sourceText;
		textLabel.font = [UIFont systemFontOfSize:FontSize];
		[self addSubview:textLabel];
		[textLabel release];
	}
	[self setFrame];
	[elements release];
}

- (void)setFrame {
	UIView *lastSubView = (UIView *)[[self subviews] lastObject];
	CGFloat heigh = lastSubView.frame.origin.y + lastSubView.frame.size.height;
	self.frame = CGRectMake(_frameOriginX, _frameOriginY , _frameWidth, heigh);
}

- (NSInteger)findStartIndexOfLastLineText:(NSString *)source {
	[source retain];
	CGSize sourceTextSize = [self sizeForString:source];
	NSInteger lines = sourceTextSize.height / [self getHeightWithFontSize:FontSize];
	NSInteger startIndex = 0;
	if (lines > 1) {
		NSInteger length = [source length];
		for (int i = length; i > 0; i --) {
			CGSize textSize = [self sizeForString:[source substringToIndex:i]];
			if (textSize.height < sourceTextSize.height) {
				startIndex = i;
				break;
			}
		}
	}
	[source release];
	return startIndex;
}

- (NSMutableArray *)splitStringBylimitWidth:(CGFloat)width source:(NSString *)source {
	[source retain];
	NSMutableArray *subStrings = [[[NSMutableArray alloc] init] autorelease];
	NSInteger length = [source length];
	for (int i = length; i > 0; i--) {
		CGSize textSize = [self sizeForString:[source substringToIndex:i]];
		if (textSize.width <= width && i == length) {
			[subStrings addObject:source];
			_needNewLine = NO;
			break;
		}
		if ((textSize.width < width) && (textSize.height == [self getHeightWithFontSize:FontSize])) {
			[subStrings addObject:[source substringToIndex:i]];
			[subStrings addObject:[source substringFromIndex:i]];
			break;
		}
		if (i == 1) {
			[subStrings addObject:source];
			_needNewLine = YES;
			break;
		}
	}
	[source release];
	return subStrings;
}

- (CGSize)sizeForString:(NSString *)string {
	CGSize textSize = [string sizeWithFont:[UIFont systemFontOfSize:FontSize] constrainedToSize:CGSizeMake(_frameWidth, 10000.0f) lineBreakMode:LineBreakMode];
	return textSize;
}

- (CGFloat)getHeightWithFontSize:(CGFloat)fontSize {
	NSString *character = @" ";
	CGSize characterSize = [self sizeForString:character];
	return characterSize.height;
}

- (void)setUrlLabelTextColorWithUrlString:(NSString *)url color:(UIColor *)color {
	NSArray *subViews = [self subviews];
	for (UIView *subView in subViews) {
		if ([[subView class] isSubclassOfClass:[DSURLLabel class]]) {
			if ([((DSURLLabel *)subView).urlString isEqualToString:url]) {
				((DSURLLabel *)subView).urlLabel.textColor = color;
			}
		}
	}
}


#pragma mark -
#pragma mark DSURLLabelDelegate methods

- (void)urlTouchesBegan:(DSURLLabel *)urlLabel {
	[self setUrlLabelTextColorWithUrlString:urlLabel.urlString color:[UIColor redColor]];
}

- (void)urlTouchesEnd:(DSURLLabel *)urlLabel {
	[self setUrlLabelTextColorWithUrlString:urlLabel.urlString color:[UIColor blueColor]];
	if (_delegate && [(NSObject *)_delegate respondsToSelector:@selector(urlWasClicked:urlString:)]) {
		[_delegate urlWasClicked:self urlString:urlLabel.urlString];
	}
}


#pragma mark -
#pragma mark dealloc memory methods

- (void)dealloc {
	[_sourceText	release];
	_sourceText		= nil;
    [super dealloc];
}


@end
