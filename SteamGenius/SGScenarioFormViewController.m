//
//  SGScenarioFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGScenarioFormViewController.h"
#import "SGScenarioForm.h"
#import "SGRepository.h"
#import "AppDelegate.h"

@interface SGScenarioFormViewController ()

@end

@implementation SGScenarioFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.object ? @"Edit Scenario" : @"Add Scenario";
    SGScenarioForm *form = [[SGScenarioForm alloc] init];
    [form setScenario:self.object];
    self.formController.form = form;
    
    UIBarButtonItem *saveScenario = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveScenario)];
    self.navigationItem.rightBarButtonItem = saveScenario;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class Methods

- (void)saveScenario {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGScenarioForm *form = self.formController.form;
    if (form.name) {
        if (form.scenario) {
            self.object.name = form.name;
        } else {
            [SGRepository initWithScenarioNamed:form.name context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Form invalid" message:@"Name cannot be blank!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [validationMessage show];
    }
}

@end