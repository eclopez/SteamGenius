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
            [SGRepository updateBattle:self.battle
                          playerCaster:form.playerCaster
                        opponentCaster:form.opponentCaster
                              opponent:form.opponent
                                  date:form.date
                                points:form.pointSize
                                result:form.result
                            killPoints:form.killPoints
                              scenario:form.scenario
                         controlPoints:form.controlPoints
                 opponentControlPoints:form.opponentControlPoints
                                 event:form.event
                                 notes:form.notes];
        } else {
            [SGRepository initWithPlayerCaster:form.playerCaster
                                opponentCaster:form.opponentCaster
                                      opponent:form.opponent
                                          date:form.date
                                        points:form.pointSize
                                        result:form.result
                                    killPoints:form.killPoints
                                      scenario:form.scenario
                                 controlPoints:form.controlPoints
                         opponentControlPoints:form.opponentControlPoints
                                         event:form.event
                                         notes:form.notes
                                       context:appDelegate.managedObjectContext];
        }
        [appDelegate saveContext];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *validationAlert = [UIAlertController alertControllerWithTitle:@"Form Invalid" message:validationList preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [validationAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [validationAlert addAction:okAction];
        [self presentViewController:validationAlert animated:YES completion:nil];
    }
}

@end