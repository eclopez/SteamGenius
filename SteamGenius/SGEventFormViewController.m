//
//  SGEventFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/26/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGEventFormViewController.h"
#import "SGEventForm.h"
#import "SGRepository.h"
#import "AppDelegate.h"

@interface SGEventFormViewController ()

@end

@implementation SGEventFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.object ? @"Edit Event" : @"Add Event";
    SGEventForm *form = self.object ? [[SGEventForm alloc] init:self.object] : [[SGEventForm alloc] init];
    self.formController.form = form;
    
    UIBarButtonItem *saveEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEvent)];
    self.navigationItem.rightBarButtonItem = saveEvent;
    
    UIBarButtonItem *cancelEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEvent)];
    self.navigationItem.leftBarButtonItem = cancelEvent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Class Methods

- (void)saveEvent {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGEventForm *form = self.formController.form;
    
    int validate = 0;
    NSArray *validateFields = @[ @"name", @"date" ];
    NSArray *validateFieldNames = @[ @"Name", @"Date" ];
    NSMutableString *validationList = [[NSMutableString alloc] init];
    
    for (NSString *field in validateFields) {
        if (![form valueForKey:field] || [[form valueForKey:field] isEqual:@""]) {
            [validationList appendString:[NSString stringWithFormat:@"- %@ can't be empty.\n", [validateFieldNames objectAtIndex:[validateFields indexOfObject:field]]]];
            validate++;
        }
    }
    
    if (validate == 0) {
        if (form.event) {
            self.object.name = form.name;
            self.object.location = form.location;
            self.object.date = form.date;
            self.object.isTournament = [NSNumber numberWithBool:form.isTournament];
        } else {
            [SGRepository initWithEventNamed:form.name location:form.location date:form.date isTournament:form.isTournament context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Form invalid" message:validationList delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [validationMessage show];
    }
}

- (void)cancelEvent {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end