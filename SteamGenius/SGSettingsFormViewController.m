//
//  SGSettingsFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/15/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGSettingsFormViewController.h"
#import "SGSettingsForm.h"

@interface SGSettingsFormViewController ()

@end

@implementation SGSettingsFormViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.formController.form = [[SGSettingsForm alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
