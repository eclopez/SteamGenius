//
//  SGDismissSegue.m
//  SteamGenius
//
//  Created by Erik Lopez on 9/12/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import "SGDismissSegue.h"

@implementation SGDismissSegue

- (void)perform {
    UIViewController *source = self.sourceViewController;
    [source.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
