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

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveFilter:(id)sender {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGFiltersForm *form = self.formController.form;
    
    int validate = 0;
    NSArray *validateFields;
    NSArray *validateFieldNames;
    
    if ([[form valueForKey:@"operation"] isEqual:@"=nil"] || [[form valueForKey:@"operation"] isEqual:@"!=nil"]) {
        validateFields = @[ @"attribute", @"operation" ];
        validateFieldNames = @[ @"Attribute", @"Operator" ];
    } else {
        validateFields = @[ @"attribute", @"operation", @"attributeValue" ];
        validateFieldNames = @[ @"Attribute", @"Operator", @"Value" ];
    }
    
    NSMutableString *validationList = [[NSMutableString alloc] init];
    for (NSString *field in validateFields) {
        if (![form valueForKey:field] || [[form valueForKey:field] isEqual:@""]) {
            [validationList appendString:[NSString stringWithFormat:@"- %@ can't be empty.\n", [validateFieldNames objectAtIndex:[validateFields indexOfObject:field]]]];
            validate++;
        }
    }
    
    if (validate == 0) {
        NSString *predicateDescription = [NSString stringWithFormat:@"%@ %@ %@", form.attributeFieldDescription, form.operationFieldDescription, form.attributeValueFieldDescription];
        NSPredicate *predicate;
        if ([form.attribute isEqualToString:@"date"]) {
            form.attributeValue = [self normalizedDate:form.attributeValue];
        }
        if (([form.attribute isEqual:@"points"] || [form.attribute isEqual:@"killPoints"] || [form.attribute isEqual:@"controlPoints"])
            && (![form.operation isEqualToString:@"=nil"] && ![form.operation isEqualToString:@"!=nil"])) {
            NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ %@ $VALUE", form.attribute, form.operation]];
            predicate = [predicateTemplate predicateWithSubstitutionVariables:@{@"VALUE": [NSNumber numberWithInteger:[form.attributeValue integerValue]]}];
        }
        else if ([form.operation isEqualToString:@"=nil"] || [form.operation isEqualToString:@"!=nil"]) {
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ %@", @"%K", form.operation], form.attribute];
        } else {
            NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ %@ $VALUE", form.attribute, form.operation]];
            predicate = [predicateTemplate predicateWithSubstitutionVariables:@{@"VALUE": form.attributeValue}];
        }
    
        [SGRepository initWithDisplayText:predicateDescription predicate:predicate context:[appDelegate managedObjectContext]];
        [appDelegate saveContext];
        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Utilities

- (NSDate *)normalizedDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    [dateComponents setNanosecond:0];
    return [calendar dateFromComponents:dateComponents];
}

@end