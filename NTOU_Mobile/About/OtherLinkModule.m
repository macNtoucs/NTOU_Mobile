//
//  OtherLinkModule.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2017/4/6.
//  Copyright © 2017年 NTOUcs_MAC. All rights reserved.
//

#import "OtherLinkModule.h"

@implementation OtherLinkModule

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = @"OtherLink";
        self.shortName = @"其他連結";
        self.longName = @"otherlink";
        self.iconName = @"otherlink";
    }
    return self;
}

- (void)loadModuleHomeController
{
    [self setModuleHomeController:[[UIStoryboard storyboardWithName:@"OtherLink" bundle:nil] instantiateInitialViewController]];
}


@end
