//
//  SGOpponentFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/25/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGOpponentFormViewController.h"
#import "SGOpponentForm.h"
#import "SGRepository.h"
#import "AppDelegate.h"

@interface SGOpponentFormViewController ()

@end

@implementation SGOpponentFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.object ? @"Edit Opponent" : @"Add Opponent";
    SGOpponentForm *form = self.object ? [[SGOpponentForm alloc] init:self.object] : [[SGOpponentForm alloc] init];
    self.formController.form = form;
    
    UIBarButtonItem *saveOpponent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveOpponent)];
    self.navigationItem.rightBarButtonItem = saveOpponent;
    
    UIBarButtonItem *cancelOpponent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelOpponent)];
    self.navigationItem.leftBarButtonItem = cancelOpponent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Class Methods

- (void)saveOpponent {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGOpponentForm *form = self.formController.form;
    
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
        if (form.opponent) {
            [SGRepository updateOpponent:self.object name:form.name];
        } else {
            [SGRepository initWithOpponentNamed:form.name context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *validationAlert = [UIAlertController alertControllerWithTitle:@"Form Invalid" message:validationList preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [validationAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [validationAlert addAction:okAction];
        [self presentViewController:validationAlert animated:YES completion:nil];
    }
}

- (void)cancelOpponent {
    [self.navigationController popViewControllerAnimated:YES];
}

@end