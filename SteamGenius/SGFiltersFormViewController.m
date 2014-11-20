//
//  SGFiltersFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 10/14/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGFiltersFormViewController.h"
#import "AppDelegate.h"
#import "SGFiltersForm.h"
#import "SGRepository.h"

#define kFilterDefaultsName @"filterDefaults"

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

#pragma mark Class Methods

- (IBAction)saveFilter:(id)sender {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGFiltersForm *form = self.formController.form;
    
    int validate = 0;
    NSArray *validateFields = @[ @"attribute", @"operation", @"attributeValue" ];
    NSArray *validateFieldNames = @[ @"Attribute", @"Operator", @"Value" ];
    
    NSMutableString *validationList = [[NSMutableString alloc] init];
    for (NSString *field in validateFields) {
        if (![form valueForKey:field] || [[form valueForKey:field] isEqual:@""]) {
            [validationList appendString:[NSString stringWithFormat:@"- %@ can't be empty.\n", [validateFieldNames objectAtIndex:[validateFields indexOfObject:field]]]];
            validate++;
        }
    }
    
    if (validate == 0) {
        NSString *predicateDescription = [NSString stringWithFormat:@"%@ %@ %@", form.attributeFieldDescription, form.operationFieldDescription, form.attributeValueFieldDescription];
        NSString *predicateString = [NSString stringWithFormat:@"%@ %@ %@", @"%K", form.operation, @"%@"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString, form.attribute, form.attributeValue];
    
        [SGRepository initWithDisplayText:predicateDescription predicate:predicate context:[appDelegate managedObjectContext]];
        [appDelegate saveContext];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *validationMessage = [UIAlertController alertControllerWithTitle:@"Form invalid" message:validationList preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [validationMessage dismissViewControllerAnimated:YES completion:nil];
        }];
        [validationMessage addAction:okAction];
        [self presentViewController:validationMessage animated:YES completion:nil];
    }
}

#pragma mark - Field Methods

- (void)attributeChangedAction {
    SGFiltersForm *form = self.formController.form;
    form.operation = nil;
    form.attributeValue = nil;
    
    [self reloadForm];
}

- (void)operationChangedAction {
    [self reloadForm];
}

- (void)reloadForm {
    self.formController.form = self.formController.form;
    [self.formController.tableView reloadData];
}

@end