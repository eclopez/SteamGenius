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

@property (strong, nonatomic) NSArray *attributes;
@property (strong, nonatomic) NSArray *attributeNames;

@property (strong, nonatomic) NSString *attribute;
@property (strong, nonatomic) NSString *logicalOperator;
@property (strong, nonatomic) id value;

@end