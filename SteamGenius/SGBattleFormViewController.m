//
//  SGBattleFormViewController.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGBattleFormViewController.h"
#import "SGBattleForm.h"
#import "AppDelegate.h"
#import "SGRepository.h"

@interface SGBattleFormViewController ()

@end

@implementation SGBattleFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.battle ? @"Edit Battle" : @"Add Battle";
    SGBattleForm *form = self.battle ? [[SGBattleForm alloc] init:self.battle] : [[SGBattleForm alloc] init];
    self.formController.form = form;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Class Methods

- (IBAction)saveBattle:(id)sender {
    [self.tableView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SGBattleForm *form = self.formController.form;
    
    int validate = 0;
    NSArray *validateFields = @[ @"playerCaster",
                                 @"opponentCaster",
                                 @"date",
                                 @"pointSize",
                                 @"result" ];
    NSArray *validateFieldNames = @[ @"Player caster",
                                     @"Opponent caster",
                                     @"Date",
                                     @"Point size",
                                     @"Result" ];
    NSMutableString *validationList = [[NSMutableString alloc] init];
    
    for (NSString *field in validateFields) {
        if (![form valueForKey:field] || [[form valueForKey:field] isEqual:@""]) {
            [validationList appendString:[NSString stringWithFormat:@"- %@ can't be empty.\n", [validateFieldNames objectAtIndex:[validateFields indexOfObject:field]]]];
            validate++;
        }
    }
    
    if (validate == 0) {
        if (self.battle) {
            self.battle.playerCaster = form.playerCaster;
            self.battle.opponentCaster = form.opponentCaster;
            self.battle.opponent = form.opponent;
            self.battle.date = [self normalizedDate:form.date];
            self.battle.points = form.pointSize;
            self.battle.result = form.result;
            self.battle.killPoints = form.killPoints;
            self.battle.scenario = form.scenario;
            self.battle.controlPoints = form.controlPoints;
            self.battle.event = form.event;
            self.battle.notes = form.notes;
        } else {
            [SGRepository initWithPlayerCaster:form.playerCaster opponentCaster:form.opponentCaster opponent:form.opponent date:form.date points:form.pointSize result:form.result killPoints:form.killPoints scenario:form.scenario controlPoints:form.controlPoints event:form.event notes:form.notes context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Form invalid" message:validationList delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [validationMessage show];
    }
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