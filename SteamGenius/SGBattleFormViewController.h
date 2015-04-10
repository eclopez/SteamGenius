//
//  SGBattleFormViewController.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "Battle.h"
#import "FXForms.h"

@interface SGBattleFormViewController : FXFormViewController <FXFormFieldViewController>

@property (strong, nonatomic) Battle *battle;

@end