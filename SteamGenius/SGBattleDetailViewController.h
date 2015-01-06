//
//  SGBattleDetailViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 12/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "FXForms.h"
#import "SGBattleDetailForm.h"
#import "Battle.h"

@interface SGBattleDetailViewController : FXFormViewController <FXFormFieldViewController>

@property (strong, nonatomic) SGBattleDetailForm *form;
@property (strong, nonatomic) Battle *battle;

@end