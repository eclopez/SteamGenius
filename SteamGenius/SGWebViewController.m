//
//  SGWebViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 1/5/15.
//  Copyright (c) 2015 Erik Lopez. All rights reserved.
//

#import "SGWebViewController.h"

@interface SGWebViewController ()

@end

@implementation SGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.gofundme.com/evep0k"]];
    [_web loadRequest:request];
    [self.view addSubview:_web];
    
    UIBarButtonItem *open = [[UIBarButtonItem alloc] initWithTitle:@"Open in Safari" style:UIBarButtonItemStylePlain target:self action:@selector(openInSafari)];
    self.navigationItem.rightBarButtonItem = open;
}

#pragma mark - Methods

- (void)openInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gofundme.com/evep0k"]];
}



@end