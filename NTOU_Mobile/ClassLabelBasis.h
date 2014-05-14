//
//  ClassLabelBasis.h
//  MIT Mobile
//
//  Created by mini server on 12/10/31.
//
//

#import <UIKit/UIKit.h>

@interface ClassLabelBasis : UILabel
{
    UIColor* tempBackground;
    NSString *badgeValue;
    UIView *topDisplayView;
}
- (void)setBadgeValue:(NSString *)newValue;
@property (nonatomic,retain) UIColor* tempBackground;
@property (nonatomic, retain) NSString *badgeValue;
@property (nonatomic, retain) UIView *topDisplayView;
@property BOOL changeColor;

@end
