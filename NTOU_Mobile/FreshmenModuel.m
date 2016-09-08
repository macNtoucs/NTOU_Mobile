//
//  FreshmenModuel.m
//  NTOU_Mobile
//
//  Created by Rick on 2014/9/1.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//


#import "FreshmenModuel.h"
#import "NTOUConstants.h"
#import "FreshmenWebViewController.h"
#import "NTOUModule+Protected.h"

@implementation FreshmenModuel


- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = FreshmenTag;
        self.shortName = @"新生教育週";
        self.longName = @"freshmen";
        self.iconName = @"freshmen";
        
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void)loadModuleHomeController
{
    FreshmenWebViewController *viewcontroller = [[FreshmenWebViewController alloc] init];
    viewcontroller.title = @"新生入學教育週";
    self.moduleHomeController = viewcontroller;
}

- (BOOL)handleNotification:(Notification *)notification shouldOpen:(BOOL)shouldOpen{
    
    
	return YES;
}

@end

