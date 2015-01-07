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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Class Methods

- (void)showWebView {
    SGWebViewController *web = [[SGWebViewController alloc] initWithWebFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    web.title = @"Donate";
    [self.navigationController pushViewController:web animated:YES];
}


@end
