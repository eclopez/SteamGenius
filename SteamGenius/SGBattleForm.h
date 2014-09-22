//
//  SGBattleForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 9/20/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "Model.h"
#import "Caster.h"

@interface SGBattleForm : NSObject <FXForm>

@property (nonatomic, strong) Caster *playerCaster;
@property (nonatomic, copy) Caster *opponentCaster;
//@property (nonatomic, copy) Opponent *opponent;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSNumber *points;
//@property (nonatomic, copy) Result *result;
@property (nonatomic, copy) NSNumber *killPoints;
//@property (nonatomic, copy) Scenario *scenario;
@property (nonatomic, copy) NSNumber *controlPoints;
//@property (nonatomic, copy) Event *event;

@end