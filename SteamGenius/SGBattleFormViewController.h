//
//  SGBattleFormViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "FXForms.h"
#import "Battle.h"

@interface SGBattleFormViewController : FXFormViewController <FXFormFieldViewController>

@property (strong, nonatomic) Battle *battle;

@end