//
//  SGBattleFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleFormViewController.h"
#import "SGBattleForm.h"

@interface SGBattleFormViewController ()

@end

@implementation SGBattleFormViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.formController.form = [[SGBattleForm alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end