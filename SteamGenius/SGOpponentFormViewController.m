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
    SGOpponentForm *form = [[SGOpponentForm alloc] init];
    [form setOpponent:self.object];
    self.formController.form = form;
    
    UIBarButtonItem *saveOpponent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveOpponent)];
    self.navigationItem.rightBarButtonItem = saveOpponent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class Methods

- (void)saveOpponent {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGOpponentForm *form = self.formController.form;
    if (form.name) {
        if (form.opponent) {
            self.object.name = form.name;
        } else {
            [SGRepository initWithOpponentNamed:form.name context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Form invalid" message:@"Name cannot be blank!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [validationMessage show];
    }
}

@end