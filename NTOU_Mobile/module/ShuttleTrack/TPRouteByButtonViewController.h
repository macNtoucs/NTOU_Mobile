//
//  TPRouteByButtonViewController.h
//  bus
//
//  Created by NTOUCS on 12/10/30.
//
//

#import <UIKit/UIKit.h>
#import "TPRouteGoBackViewController.h"
#import "NTRouteGoBackViewController.h"
#import "UIKit+NTOUAdditions.h"

// Get Current Screen Size
#define CURRENT_IPHONE_SIZE (unsigned int)[[UIScreen mainScreen] bounds].size.height
#define BUTTON_STYLE UIButtonTypeRoundedRect
#define BUTTON_PLATE_COLOR [UIColor colorWithRed:12.0/255 green:46.0/255 blue:112.0/255 alpha:1.0]
#define BUTTON_SELECTED_COLOR [UIColor colorWithHexString:@"#0257EE"]

@interface TPRouteByButtonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIView * buttonFirstView;
    UIView * buttonSecondView;
    UITableView * tableview;
    BOOL havingTableView;
    NSMutableString * partBusName;
    NSArray * compBusName;
    NSMutableArray * cityName;
    NSMutableArray * taipeiDeparName;
    NSMutableArray * taipeiDestiName;
    NSMutableArray * taipeiBusName;
    NSMutableArray * nTaipeiDeparName;
    NSMutableArray * nTaipeiDestiName;
    NSMutableArray * nTaipeiBusName;
    NSInteger countT, countN, countAll;
}
@property (nonatomic, retain) UIView * buttonFirstView;
@property (nonatomic, retain) UIView * buttonSecondView;
@property (nonatomic, retain) UITableView * tableview;
@property (nonatomic, assign) BOOL havingTableView;
@property (nonatomic, retain) NSMutableString * partBusName;
@property (nonatomic, retain) NSArray * compBusName;
@property (nonatomic, retain) NSMutableArray * cityName;
@property (nonatomic, retain) NSMutableArray * taipeiDeparName;
@property (nonatomic, retain) NSMutableArray * taipeiDestiName;
@property (nonatomic, retain) NSMutableArray * taipeiBusName;
@property (nonatomic, retain) NSMutableArray * nTaipeiDeparName;
@property (nonatomic, retain) NSMutableArray * nTaipeiDestiName;
@property (nonatomic, retain) NSMutableArray * nTaipeiBusName;

@end
