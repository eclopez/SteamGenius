//
//  SGFiltersFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/14/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGFiltersFormViewController.h"
#import "SGFiltersForm.h"

@interface SGFiltersFormViewController ()

@end

@implementation SGFiltersFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formController.form = [[SGFiltersForm alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Field Methods

- (void)attributeChangedAction {
    SGFiltersForm *form = self.formController.form;
    form.logicalOperator = nil;
    form.value = nil;
    
    self.formController.form = self.formController.form;
    [self.formController.tableView reloadData];
}

- (void)operatorChangedAction {
    SGFiltersForm *form = self.formController.form;
    form.value = nil;
    
    self.formController.form = self.formController.form;
    [self.formController.tableView reloadData];
}

@end