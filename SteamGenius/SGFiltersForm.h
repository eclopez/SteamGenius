//
//  SGFiltersForm.h
//  SteamGenius
//
//  Created by Erik Lopez on 10/14/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "AppDelegate.h"

@interface SGFiltersForm : NSObject <FXForm>

@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic) NSDictionary *logicalOperators;

@property (strong, nonatomic) NSString *attribute;
@property (strong, nonatomic) NSString *operation;
@property (strong, nonatomic) id value;

@end