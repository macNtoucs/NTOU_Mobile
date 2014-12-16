#import <UIKit/UIKit.h>
#import "CKViewDelegate.h"
//台鐵高鐵日期選擇


@interface CKViewController : UIViewController <CKViewDelegate>
{
    NSDate * selectedDate;
}

@property (strong,nonatomic) NSDate* selectedDate;
@end
