//
//  ClassLabelBasis.m
//  MIT Mobile
//
//  Created by mini server on 12/10/31.
//
//

#import "ClassLabelBasis.h"

@implementation ClassLabelBasis
@synthesize tempBackground;
@synthesize changeColor,badgeValue,topDisplayView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define BADGE_TAG 62
#define BADGE_LABEL_TAG 63
- (void)setBadgeValue:(NSString *)newValue {
    [badgeValue release];
    badgeValue = [newValue retain];
    
    UIView *badgeView = [self.topDisplayView.superview viewWithTag:BADGE_TAG];
    
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
        //frame.origin = CGPointMake(self.frame.size.width - floor(badgeView.frame.size.width / 2) - 10,
        //                           - floor(badgeView.frame.size.height / 2) + 5);
        frame.origin = CGPointMake(self.frame.origin.x + 37,self.frame.origin.y -7);
        badgeView.frame = frame;
        self.clipsToBounds = NO;
        [self.topDisplayView.superview addSubview:badgeView];
    } else {
        [badgeView removeFromSuperview];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
