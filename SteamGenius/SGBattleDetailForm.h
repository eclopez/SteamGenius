//
//  SGBattleDetailForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 12/21/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "Battle.h"
#import "Caster.h"

@interface SGBattleDetailForm : NSObject <FXForm>

@property (strong, nonatomic) Battle *battle;
@property (nonatomic, strong) Caster *playerCaster;
@property (nonatomic, strong) Caster *opponentCaster;
@property (strong, nonatomic) Opponent *opponent;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *points;
@property (nonatomic, strong) Result *result;

- (id)init:(Battle *)battle;

@end
