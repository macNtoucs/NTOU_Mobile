//
//  ViewController.h
//  PageViewController
//
//  Created by Tom Fewster on 11/01/2012.
//

#import <UIKit/UIKit.h>

@interface PagerViewController : UIViewController <UIScrollViewDelegate,UIAlertViewDelegate>
{
    CGFloat offset;
}

@property (nonatomic, strong) IBOutlet UIScrollView *lifeScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@end
