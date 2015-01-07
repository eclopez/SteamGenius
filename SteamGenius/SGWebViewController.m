//
//  SGWebViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 1/5/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "SGWebViewController.h"

@interface SGWebViewController ()

@end

@implementation SGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning - Change height to reflect actual height
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 320.f, 480.f)];
    NSLog(@"%f", self.view.bounds.size.width);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.gofundme.com/evep0k"]];
    [web loadRequest:request];
    [self.view addSubview:web];
    
    UIBarButtonItem *open = [[UIBarButtonItem alloc] initWithTitle:@"Open in Safari" style:UIBarButtonItemStylePlain target:self action:@selector(openInSafari)];
    self.navigationItem.rightBarButtonItem = open;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods

- (void)openInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gofundme.com/evep0k"]];
}



@end