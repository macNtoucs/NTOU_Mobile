//
//  SipPhoneModule.m
//  NTOU_Mobile
//
//  Created by Lab414 on 2016/7/27.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipPhoneModule.h"
#import "NTOUConstants.h"
#import "NTOUModule+Protected.h"
#import "TestViewController.h"


@implementation SipPhoneModule

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = SipPhoneTag;
        self.shortName = @"校內電話";
        self.longName = @"Sip Phone";
        self.iconName = @"sipphone";
    }
    return self;
}

- (void)loadModuleHomeController
{
    TestViewController * test = [[[TestViewController alloc]init]autorelease];
    self.moduleHomeController = test;
}

- (void)dealloc {
    [super dealloc];
}

@end
