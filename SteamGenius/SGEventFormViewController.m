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
    SGEventForm *form = [[SGEventForm alloc] init];
    [form setEvent:self.object];
    self.formController.form = form;
    
    UIBarButtonItem *saveEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEvent)];
    self.navigationItem.rightBarButtonItem = saveEvent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Class Methods

- (void)saveEvent {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGEventForm *form = self.formController.form;
    if (form.name) {
        if (form.event) {
            self.object.name = form.name;
            self.object.location = form.location;
            self.object.date = form.date;
            self.object.isTournament = [NSNumber numberWithBool:form.isTournament];
        } else {
            [SGRepository initWithEventNamed:form.name location:form.location date:form.date isTournament:form.isTournament context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Form invalid" message:@"Name cannot be blank!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [validationMessage show];
    }
}

@end