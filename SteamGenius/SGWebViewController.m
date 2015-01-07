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

- (instancetype)initWithWebFrame:(CGRect)webFrame {
    self = [super init];
    if (self) {
        _web = [[WKWebView alloc] initWithFrame:webFrame];\
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.gofundme.com/evep0k"]];
    [_web loadRequest:request];
    [self.view addSubview:_web];
    
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