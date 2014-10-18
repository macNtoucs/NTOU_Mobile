//
//  UIKit+NTOUAdditions.h
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NTOUConstants.h"
#import "NTOUUIConstants.h"

#pragma mark - UIKit Additon Function Prototypes
CGRect CGRectNormalizeRectInRect(CGRect subRect, CGRect parentRect);
NSString* NSStringFromUIImageOrientation(UIImageOrientation orientation);

#pragma mark - Category Definitions
@interface NSString (NTOUUIAdditions)

- (NSInteger)lengthOfLineWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end

@interface UIColor (NTOUUIAdditions)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

@interface UIImageView (NTOUUIAdditions)

+ (UIImageView *)accessoryViewWithNTOUType:(NTOUAccessoryViewType)type;
+ (UIImageView *)accessoryViewForInternalURL:(NSString *)url;

@end

@interface UIView (NTOUUIAdditions)

- (void)removeAllSubviews;

@end

@interface UITableViewCell (NTOUUIAdditions)

- (void)applyStandardFonts;
- (void)addAccessoryImage:(UIImage *)image;

@end

@interface UITableView (NTOUUIAdditions)

- (void)applyStandardColors;
- (void)applyStandardCellHeight;
+ (UIView *)groupedSectionHeaderWithTitle:(NSString *)title;
+ (UIView *)groupedSectionHeaderWithTitle2:(NSString *)beforeBlack andOther:(NSString *)laterGray;
+ (UIView *)groupedSectionHeaderWithTitle3:(NSString *)beforeGray andOther:(NSString *)laterBlack;
+ (UIView *)ungroupedSectionHeaderWithTitle:(NSString *)title;

@end

@interface UIActionSheet (NTOUUIAdditions)

- (void)showFromAppDelegate; // i don't like this name but can't think of a better one

@end
