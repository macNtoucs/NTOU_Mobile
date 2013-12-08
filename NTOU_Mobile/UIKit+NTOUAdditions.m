//
//  UIKit+NTOUAdditions.m
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "UIKit+NTOUAdditions.h"

#import "AppDelegate.h"

CGRect CGRectNormalizeRectInRect(CGRect subRect, CGRect parentRect)
{
    CGRect normalizedRect = CGRectMake(subRect.origin.x / CGRectGetMaxX(parentRect),
                                       subRect.origin.y / CGRectGetMaxY(parentRect),
                                       subRect.size.width / CGRectGetWidth(parentRect),
                                       subRect.size.height / CGRectGetHeight(parentRect));
    
    return normalizedRect;
}

NSString* NSStringFromUIImageOrientation(UIImageOrientation orientation)
{
    switch (orientation) {
        case UIImageOrientationDown:
            return [NSString stringWithFormat:@"%@ [%d]", @"UIImageOrientationDown", UIImageOrientationDown];
        case UIImageOrientationDownMirrored:
            return [NSString stringWithFormat:@"%@ [%d]", @"UIImageOrientationDownMirrored", UIImageOrientationDownMirrored];
        case UIImageOrientationLeft:
            return [NSString stringWithFormat:@"%@ [%d]", @"UIImageOrientationLeft", UIImageOrientationLeft];
        case UIImageOrientationLeftMirrored:
            return [NSString stringWithFormat:@"%@ [%d]", @"UIImageOrientationLeftMirrored", UIImageOrientationLeftMirrored];
        case UIImageOrientationUp:
            return [NSString stringWithFormat:@"%@ [%d]", @"UIImageOrientationUp", UIImageOrientationUp];
        case UIImageOrientationUpMirrored:
            return [NSString stringWithFormat:@"%@ [%d]", @"UIImageOrientationUpMirrored", UIImageOrientationUpMirrored];
        case UIImageOrientationRight:
            return [NSString stringWithFormat:@"%@ [%d]", @"UIImageOrientationRight", UIImageOrientationRight];
        case UIImageOrientationRightMirrored:
            return [NSString stringWithFormat:@"%@ [%d]", @"UIImageOrientationRightMirrored", UIImageOrientationRightMirrored];
    }
}


@implementation NSString (NTOUUIAdditions)

- (NSInteger)lengthOfLineWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    NSMutableString *mutableString = [NSMutableString string];
    NSArray *lines = [self componentsSeparatedByString:@"\n"];
    if (lines.count > 0) {
        NSString *line = [lines objectAtIndex:0];
        NSArray *words = [line componentsSeparatedByString:@" "];
        NSInteger count = words.count;
        if (count > 0) {
            NSInteger index = 0;
            [mutableString appendString:[words objectAtIndex:index]];
            CGSize fullSize = [mutableString sizeWithFont:font];
            index++;
            while (index < count && fullSize.width < size.width) {
                [mutableString appendString:[NSString stringWithFormat:@" %@", [words objectAtIndex:index]]];
                fullSize = [mutableString sizeWithFont:font];
                index++;
            }
        }
    }
    return [mutableString length];
}

@end

@implementation UIColor (NTOUUIAdditions)

// snagged from http://arstechnica.com/apple/guides/2009/02/iphone-development-accessing-uicolor-components.ars
// color must be either of the format @"0099FF" or @"#0099FF" or @"0x0099FF"
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 - 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X and # if they appear
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end

@implementation UIImageView (NTOUUIAdditions)

+ (UIImageView *)accessoryViewWithNTOUType:(NTOUAccessoryViewType)type {
    NSString *imageName = nil;
    NSString *highlightedImageName = nil;
    
    switch (type) {
        case NTOUAccessoryViewEmail:
            imageName = NTOUImageNameEmail;
            highlightedImageName = NTOUImageNameEmailHighlight;
            break;
        case NTOUAccessoryViewMap:
            imageName = NTOUImageNameMap;
            highlightedImageName = NTOUImageNameMapHighlight;
            break;
        case NTOUAccessoryViewPeople:
            imageName = NTOUImageNamePeople;
            highlightedImageName = NTOUImageNamePeopleHighlight;
            break;
        case NTOUAccessoryViewPhone:
            imageName = NTOUImageNamePhone;
            highlightedImageName = NTOUImageNamePhoneHighlight;
            break;
        case NTOUAccessoryViewExternal:
            imageName = NTOUImageNameExternal;
            highlightedImageName = NTOUImageNameExternalHighlight;
            break;
		case NTOUAccessoryViewEmergency:
			imageName = NTOUImageNameEmergency;
			highlightedImageName = NTOUImageNameEmergencyHighlight;
			break;
        case NTOUAccessoryViewSecure:
            imageName = NTOUImageNameSecure;
            highlightedImageName = NTOUImageNameSecureHighlight;
            break;
        case NTOUAccessoryViewCalendar:
            imageName = NTOUImageNameCalendar;
            highlightedImageName = NTOUImageNameCalendarHighlight;
            break;
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:image highlightedImage:highlightedImage];
    return [accessoryView autorelease];
}

+ (UIImageView *)accessoryViewForInternalURL:(NSString *)url {
	// we should really check for whether this url fits our internal scheme
	NSArray *pathComponents = [url pathComponents];
	if (pathComponents.count > 1) {
		NSString *localPath = [pathComponents objectAtIndex:1];
		if ([localPath isEqualToString:CampusMapTag]) {
			return [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewMap];
		} else if ([localPath isEqualToString:DirectoryTag]) {
			return [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewPeople];
		} else if ([localPath isEqualToString:EmergencyTag]) {
			return [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewEmergency];
		}
	}
	return nil;
}

@end

@implementation UIView (NTOUUIAdditions)

- (void)removeAllSubviews {
    for (UIView *aView in self.subviews) {
        [aView removeFromSuperview];
    }
}

@end

@implementation UITableViewCell (NTOUUIAdditions)

- (void)applyStandardFonts {
	self.textLabel.font = [UIFont fontWithName:BOLD_FONT size:CELL_STANDARD_FONT_SIZE];
	self.textLabel.textColor = CELL_STANDARD_FONT_COLOR;
    
	if (self.detailTextLabel != nil) {
		self.detailTextLabel.font = [UIFont fontWithName:STANDARD_FONT size:CELL_DETAIL_FONT_SIZE];
		self.detailTextLabel.textColor = CELL_DETAIL_FONT_COLOR;
	}
}


- (void)addAccessoryImage:(UIImage *)image {
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	self.accessoryView = imageView;
	[imageView release];
}

@end

@implementation UITableView (NTOUUIAdditions)

- (void)applyStandardColors {
	self.backgroundColor = [UIColor clearColor]; // allows background to show through
    self.backgroundView = nil;
	self.separatorColor = TABLE_SEPARATOR_COLOR;
}

- (void)applyStandardCellHeight {
	self.rowHeight = CELL_TWO_LINE_HEIGHT;
}

+ (UIView *)groupedSectionHeaderWithTitle:(NSString *)title {
	UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
	CGSize size = [title sizeWithFont:font];
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(19.0, 7.0, appFrame.size.width - 19.0, size.height)];
	
	label.text = title;
	label.textColor = GROUPED_SECTION_FONT_COLOR;
	label.font = font;
	label.backgroundColor = [UIColor clearColor];
	
	UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, GROUPED_SECTION_HEADER_HEIGHT)] autorelease];
	labelContainer.backgroundColor = [UIColor clearColor];
	
	[labelContainer addSubview:label];
	[label release];
	
	return labelContainer;
}

+ (UIView *)groupedSectionHeaderWithTitle2:(NSString *)beforeBlack andOther:(NSString *)laterGray
{
	UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
	CGSize size = [beforeBlack sizeWithFont:font];
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 7.0, appFrame.size.width/2 - 10.0, size.height)];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(165.0, 7.0, appFrame.size.width/2 - 15.0, size.height)];
    
	label1.text = beforeBlack;
	label1.textColor = GROUPED_SECTION_FONT_COLOR;
	label1.font = font;
	label1.backgroundColor = [UIColor clearColor];
	
    label2.text = laterGray;
    label2.textColor = [UIColor grayColor];
    label2.font = font;
    label2.backgroundColor = [UIColor clearColor];
    
	UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, GROUPED_SECTION_HEADER_HEIGHT)] autorelease];
	labelContainer.backgroundColor = [UIColor clearColor];
	
	[labelContainer addSubview:label1];
    [labelContainer addSubview:label2];
	[label1 release];
	[label2 release];
    
	return labelContainer;
}

+ (UIView *)groupedSectionHeaderWithTitle3:(NSString *)beforeGray andOther:(NSString *)laterBlack
{
	UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
	CGSize size = [beforeGray sizeWithFont:font];
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(22.0, 7.0, appFrame.size.width/2 - 22.0, size.height)];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(155.0, 7.0, appFrame.size.width/2 - 5.0, size.height)];
    
	label1.text = beforeGray;
	label1.textColor = [UIColor grayColor];
	label1.font = font;
	label1.backgroundColor = [UIColor clearColor];
	
    label2.text = laterBlack;
    label2.textColor = GROUPED_SECTION_FONT_COLOR;
    label2.font = font;
    label2.backgroundColor = [UIColor clearColor];
    
	UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, GROUPED_SECTION_HEADER_HEIGHT)] autorelease];
	labelContainer.backgroundColor = [UIColor clearColor];
	
	[labelContainer addSubview:label1];
    [labelContainer addSubview:label2];
	[label1 release];
	[label2 release];
    
	return labelContainer;
}

+ (UIView *)ungroupedSectionHeaderWithTitle:(NSString *)title {
	UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
	CGSize size = [title sizeWithFont:font];
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, appFrame.size.width - 20.0, size.height)];
	
	label.text = title;
	label.textColor = UNGROUPED_SECTION_FONT_COLOR;
	label.font = font;
	label.backgroundColor = [UIColor clearColor];
	
	UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, UNGROUPED_SECTION_HEADER_HEIGHT)] autorelease];
	labelContainer.backgroundColor = UNGROUPED_SECTION_BACKGROUND_COLOR;
	
	[labelContainer addSubview:label];
	[label release];
	
	return labelContainer;
}

@end

@implementation UIActionSheet (NTOUUIAdditions)
- (void)showFromAppDelegate {
    NTOU_MobileAppDelegate *appDelegate = NTOUAppDelegate();
    [self showInView:appDelegate.rootNavigationController.view];
}
@end



