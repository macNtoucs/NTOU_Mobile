//
//  NTOUSpringboard.m
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUSpringboard.h"
#import "IconGrid.h"
#import "AppDelegate.h"
#import "NTOUModule.h"
#import "BadgeLabel.h"
#import "NTOUNotification.h"
@interface NTOUSpringboard ()
- (void)internalInit;
- (void)showModuleForIcon:(id)sender;
- (void)showModuleForBanner;
- (void)checkForFeaturedModule;
- (void)displayBannerImage;

@end

#define BANNER_CONTROL_TAG 9966

@implementation NTOUSpringboard
@synthesize grid, primaryModules, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        [self internalInit];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        [self internalInit];
    }
    
    return self;
}

- (void)internalInit
{
    /* Do Nothing */
}

- (void)showModuleForIcon:(id)sender {
    SpringboardIcon *icon = (SpringboardIcon *)sender;
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showModuleForTag:icon.moduleTag];
}

- (void)showModuleForBanner {
    NSString *bannerURL = [bannerInfo objectForKey:@"url"];
	if (bannerURL) {
		NSURL *url = [NSURL URLWithString:bannerURL];
		if ([[UIApplication sharedApplication] canOpenURL:url]) {
			[[UIApplication sharedApplication] openURL:url];
		}
	}
}


- (void)displayBannerImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *bannerFile = [documentPath stringByAppendingPathComponent:@"banner"];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:bannerFile]) {
		UIImage *image = [[UIImage imageWithContentsOfFile:bannerFile] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
        if (!image) return;
        
        CGFloat bannerWidth = [[bannerInfo objectForKey:@"width"] floatValue];
        if (!bannerWidth)  bannerWidth = self.view.frame.size.width;
        CGFloat bannerHeight = [[bannerInfo objectForKey:@"height"] floatValue];
        if (!bannerHeight) bannerHeight = 72;
        
		UIButton *bannerButton = (UIButton *)[self.view viewWithTag:BANNER_CONTROL_TAG];
        if (bannerButton) {
            [bannerButton removeFromSuperview];
        }
        bannerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bannerButton.frame = CGRectMake(0, self.view.frame.size.height - bannerHeight, bannerWidth, bannerHeight);
        bannerButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        bannerButton.tag = BANNER_CONTROL_TAG;
        [bannerButton setImage:image forState:UIControlStateNormal];
        [bannerButton addTarget:self action:@selector(showModuleForBanner) forControlEvents:UIControlEventTouchUpInside];
        
		[self.view addSubview:bannerButton];
        
        // will trigger a relayout of grid if the frame is different
        CGRect newGridFrame = grid.frame;
        newGridFrame.size.height = self.view.frame.size.height - bannerButton.frame.size.height;
        grid.frame = newGridFrame;
	}
}
- (void)pushModuleWithTag:(NSString *)tag
{
     for (NTOUModule *module in self.primaryModules) {
        if ([[module tag] isEqualToString:tag]) {
            if ([self.delegate respondsToSelector:@selector(springboard:willPushModule:)]) {
                [self.delegate springboard:self
                            willPushModule:module];
            }
            
            [self.navigationController pushViewController:module.moduleHomeController
                                                 animated:YES];
            
            if ([self.delegate respondsToSelector:@selector(springboard:didPushModule:)]) {
                [self.delegate springboard:self
                             didPushModule:module];
            }
            
            module.hasLaunchedBegun = YES;
            [module didAppear];
        }
    }

}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (viewController == self)
    {
        [navigationController setToolbarHidden:YES
                                      animated:YES];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
}

#pragma mark -

-(void)viewWillAppear:(BOOL)animated{
    UIImageView * Nav_BG = (UIImageView *)[self.navigationController.navigationBar viewWithTag:1];
    Nav_BG.hidden = NO;
   
    [NTOUNotificationHandle setAllBadge];
    
    [super viewWillAppear:animated];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* Nav_BG = [[UIImageView alloc]
                           initWithFrame:CGRectMake(0, 0, 320, 44)];
    Nav_BG.image = [UIImage imageNamed:@"global/Nav_backGround.png"];
    Nav_BG.tag = 1;
    [self.navigationController.navigationBar addSubview:Nav_BG];
    
    self.grid = [[IconGrid alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] ;
    self.grid.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.grid setHorizontalMargin:5.0 vertical:10.0];
    [self.grid setHorizontalPadding:5.0 vertical:10.0];
    [self.grid setMinimumColumns:4 maximum:4];
    
    NSMutableArray *buttons = [NSMutableArray array];
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    for (NTOUModule *aModule in self.primaryModules) {
        SpringboardIcon *aButton = [SpringboardIcon buttonWithType:UIButtonTypeCustom];
        [aButton setImage:aModule.springboardIcon forState:UIControlStateNormal];
        [aButton setTitle:aModule.shortName forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
        aButton.moduleTag = aModule.tag;
        aModule.springboardButton = aButton;
        
        CGFloat titleHPadding = 15;
        CGFloat titleVPadding = 1;
        CGFloat titleHeight = 18;
        aButton.frame = CGRectMake(0, 0,
                                   aModule.springboardIcon.size.width + titleHPadding * 2,
                                   aModule.springboardIcon.size.height + titleHeight + titleVPadding * 2);
        aButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleHPadding, titleHeight, titleHPadding);
        aButton.titleEdgeInsets = UIEdgeInsetsMake(aModule.springboardIcon.size.height + titleVPadding,
                                                   -aModule.springboardIcon.size.width, titleVPadding, 0);
        aButton.titleLabel.font = font;
        [aButton addTarget:self action:@selector(showModuleForIcon:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:aButton];
        //[self.view addSubview:aButton];
        [aButton setUserInteractionEnabled:YES];
    }
    self.grid.icons = buttons;
    [self.view addSubview:self.grid];
    [self.view bringSubviewToFront:self.grid];
    [self.view setUserInteractionEnabled:YES];
    // prep data for showing banner
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *bannerInfoFile = [documentPath stringByAppendingPathComponent:@"bannerInfo.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:bannerInfoFile]) {
        bannerInfo = [[NSDictionary dictionaryWithContentsOfFile:bannerInfoFile] retain];
    }
    if (!bannerInfo) {
        bannerInfo = [[NSMutableDictionary alloc] init];
    }

    [self displayBannerImage];

}
-(void)viewWillDisappear:(BOOL)animated{
    
    UIImageView * Nav_BG = (UIImageView *)[self.navigationController.navigationBar viewWithTag:1];
    Nav_BG.hidden = YES;
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // force the visible viewController to reload its view.
    // without this, all modules except Stellar (still trying to find out why)
    // drop their view without reloading again until going back in the nav stack.
    UIViewController *viewController = nil;
    if (self.navigationController.visibleViewController != self) {
        viewController = [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.primaryModules = nil;
    [self.grid release];
	[checkBannerTimer release];
	[bannerInfo release];
    [super dealloc];
}


@end

@implementation SpringboardIcon

@synthesize moduleTag;
@synthesize badgeValue;

- (NSString *)badgeValue {
    return badgeValue;
}

#define BADGE_TAG 62
#define BADGE_LABEL_TAG 63
- (void)setBadgeValue:(NSString *)newValue {
    [badgeValue release];
    badgeValue = [newValue retain];
    
    UIView *badgeView = [self viewWithTag:BADGE_TAG];
    
    if (badgeValue) {
        UIFont *labelFont = [UIFont boldSystemFontOfSize:13.0f];
        
        if (!badgeView) {
            UIImage *image = [UIImage imageNamed:@"global/icon-badge.png"];
            UIImage *stretchableImage = [image stretchableImageWithLeftCapWidth:floor(image.size.width / 2) - 1 topCapHeight:0];
            
            badgeView = [[[UIImageView alloc] initWithImage:stretchableImage] autorelease];
            badgeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
            badgeView.tag = BADGE_TAG;
            
            UILabel *badgeLabel = [[[UILabel alloc] initWithFrame:badgeView.frame] autorelease];
            badgeLabel.backgroundColor = [UIColor clearColor];
            badgeLabel.textColor = [UIColor whiteColor];
            badgeLabel.font = labelFont;
            badgeLabel.textAlignment = NSTextAlignmentCenter;
            badgeLabel.tag = BADGE_LABEL_TAG;
            [badgeView addSubview:badgeLabel];
        }
        UILabel *badgeLabel = (UILabel *)[badgeView viewWithTag:BADGE_LABEL_TAG];
        CGSize size = [badgeValue sizeWithFont:labelFont];
        CGFloat padding = 7.0;
        CGRect frame = badgeView.frame;
        
        if (size.width + 2 * padding > frame.size.width) {
            // resize label for more digits
            frame.size.width = size.width;
            frame.origin.x += padding;
            badgeLabel.frame = frame;
            
            // resize bubble
            frame = badgeView.frame;
            frame.size.width = size.width + padding * 2;
            badgeView.frame = frame;
        }
        badgeLabel.text = badgeValue;
        
        // place badgeView on top right corner
        frame.origin = CGPointMake(self.frame.size.width - floor(badgeView.frame.size.width / 2) - 20,
                                   - floor(badgeView.frame.size.height / 2) + 5);
        badgeView.frame = frame;
        
        [self addSubview:badgeView];
    } else {
        [badgeView removeFromSuperview];
    }
}

- (void)dealloc {
    self.badgeValue = nil;
    self.moduleTag = nil;
    [super dealloc];
}

@end
