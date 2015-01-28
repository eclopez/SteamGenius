//
//  SGSettingsFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsFormViewController.h"
#import "SGSettingsForm.h"
#import "SGWebViewController.h"

#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD  UIUserInterfaceIdiomPad

@interface SGSettingsFormViewController ()

@end

@implementation SGSettingsFormViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.formController.form = [[SGSettingsForm alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Class Methods

- (void)showWebView {
    SGWebViewController *web = [[SGWebViewController alloc] initWithWebFrame:self.view.frame];
    web.title = @"Donate";
    [self.navigationController pushViewController:web animated:YES];
}


@end
