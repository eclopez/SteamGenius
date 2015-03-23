//
//  SGDisplayTableViewCell.h
//  SteamGenius
//
//  Created by Erik Lopez on 12/22/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

@import UIKit;
#import "FXForms.h"

@interface SGDisplayTableViewCell : UITableViewCell <FXFormFieldCell>

@property (strong, nonatomic) FXFormField *field;
@property (assign, nonatomic) BOOL nullValue;

@end
