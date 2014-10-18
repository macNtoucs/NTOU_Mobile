//
//  NTOUSpringboard.h
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTOUSpringboard;
@class IconGrid;
@class NTOUModule;

@protocol NTOUSpringboardDelegate <NSObject>

@optional

- (void)springboard:(NTOUSpringboard *)springboard didPushModuleForTag:(NSString *)moduleTag;
- (void)springboard:(NTOUSpringboard *)springboard willPushModule:(NTOUModule*)module;
- (void)springboard:(NTOUSpringboard *)springboard didPushModule:(NTOUModule*)module;

- (void)springboard:(NTOUSpringboard *)springboard willPopModule:(NTOUModule*)module;
- (void)springboard:(NTOUSpringboard *)springboard didPopModule:(NTOUModule*)module;

@end

@interface NTOUSpringboard : UIViewController < UINavigationControllerDelegate> {
	id<NTOUSpringboardDelegate> delegate;
    NSArray *primaryModules;
    IconGrid *grid;
    
	NSTimer *checkBannerTimer;
	
    NSMutableDictionary *bannerInfo;
}

@property (nonatomic, assign) id<NTOUSpringboardDelegate> delegate;
@property (nonatomic, retain) IconGrid *grid;
@property (nonatomic, retain) NSArray *primaryModules;

- (void)pushModuleWithTag:(NSString*)tag;
@end

@interface SpringboardIcon : UIButton {
    NSString *moduleTag;
    NSString *badgeValue;
}

@property (nonatomic, retain) NSString *moduleTag;
@property (nonatomic, retain) NSString *badgeValue;

@end
