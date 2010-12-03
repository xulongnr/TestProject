//
//  DSLabelViewController.m
//  DSLabel
//
//  Created by duansong on 10-10-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DSLabelViewController.h"

@implementation DSLabelViewController


#pragma mark -
#pragma mark about view method

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *sourceString = @"放大书 法家离开 拮抗剂jfkdshttp://www.baidu.com fjasldkfj 记录卡发蜡空手道解放路可发生地拉菲克就jkflasdjlk http://www.google.com http://news.163.com/special/hainanbaoyu/#p=6I falsdjlkasdjflk发电量三间房fhasdfkjhadsfkjhasdkjfhkajsfh发觉到拉萨解放路侃大山解放路卡 http://www.google.com.hk/search?hl=zh-CN&source=hp&biw=1280&bih=662&q=苏州&aq=f&aqi=&aql=&oq=&gs_rfai=";
	DSURLView *urlView = [[DSURLView alloc] init];
	urlView.frameWidth = 300;
	urlView.frameOriginX = 10;
	urlView.frameOriginY = 10;
	urlView.sourceText = sourceString;
	urlView.delegate = self;
	[urlView layoutURLViewWithElements:[urlView splitStringByUrl:sourceString]];
	urlView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:urlView];
	[urlView release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
}


#pragma mark -
#pragma mark DSURLViewDelegate method

- (void)urlWasClicked:(DSURLView *)urlView urlString:(NSString *)urlString {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:urlString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark dealloc memory method

- (void)dealloc {
    [super dealloc];
}

@end
