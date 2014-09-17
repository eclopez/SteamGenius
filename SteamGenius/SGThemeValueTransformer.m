//
//  SGThemeValueTransformer.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/16/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGThemeValueTransformer.h"

@implementation SGThemeValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    NSString *themeFile = [[NSBundle mainBundle] pathForResource:@"SGTheme" ofType:@"plist"];
    NSArray *themes = [NSArray arrayWithContentsOfFile:themeFile];
    
    NSMutableArray *themeList = [[NSMutableArray alloc] init];
    for (id theme in themes) {
        [themeList addObject:[theme objectForKey:@"name"]];
    }
    
    return value ? [themeList objectAtIndex:[value intValue]] : nil;
}

@end
