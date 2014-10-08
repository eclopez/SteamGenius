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
    SGScenarioForm *form = self.object ? [[SGScenarioForm alloc] init:self.object] : [[SGScenarioForm alloc] init];
    self.formController.form = form;
    
    UIBarButtonItem *saveScenario = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveScenario)];
    self.navigationItem.rightBarButtonItem = saveScenario;
    
    UIBarButtonItem *cancelScenario = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelScenario)];
    self.navigationItem.leftBarButtonItem = cancelScenario;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Class Methods

- (void)saveScenario {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGScenarioForm *form = self.formController.form;
    
    int validate = 0;
    NSArray *validateFields = @[ @"name" ];
    NSArray *validateFieldNames = @[ @"Name" ];
    NSMutableString *validationList = [[NSMutableString alloc] init];
    
    for (NSString *field in validateFields) {
        if (![form valueForKey:field] || [[form valueForKey:field] isEqual:@""]) {
            [validationList appendString:[NSString stringWithFormat:@"- %@ can't be empty.\n", [validateFieldNames objectAtIndex:[validateFields indexOfObject:field]]]];
            validate++;
        }
    }
    
    if (validate == 0) {
        if (form.scenario) {
            self.object.name = form.name;
        } else {
            [SGRepository initWithScenarioNamed:form.name context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Form invalid" message:validationList delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [validationMessage show];
    }
}

- (void)cancelScenario {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end