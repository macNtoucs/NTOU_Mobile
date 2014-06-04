//
//  LibraryModule.m
//  NTOU_Mobile
//
//  Created by Rick on 2014/4/16.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//
#import "ScheduleModule.h"
#import "switchController.h"
#import "NTOUModule+Protected.h"
#import "NTOUConstants.h"
#import "LibraryModule.h"

@implementation LibraryModule


- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = LibrariesTag;
        self.shortName = @"圖書館";
        self.longName = @"Libraries";
        self.iconName = @"libraries";
        
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void)loadModuleHomeController
{
    switchController *viewcontroller = [[switchController alloc] init];
    viewcontroller.title = @"圖書館";
    self.moduleHomeController = viewcontroller;
}

- (BOOL)handleNotification:(Notification *)notification shouldOpen:(BOOL)shouldOpen{
    if(shouldOpen) {
        [(switchController *)self.moduleHomeController ChangeDisplayView];
	}
    
	return YES;
}

@end
