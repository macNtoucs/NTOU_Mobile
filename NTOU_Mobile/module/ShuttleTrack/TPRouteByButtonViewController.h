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
#define BUTTON_PLATE_COLOR [UIColor colorWithRed:141/255.0 green:182/255.0 blue:205/255.0 alpha:0.9]
//#define BUTTON_PLATE_COLOR2 [UIColor colorWithRed:12.0/255 green:46.0/255 blue:112.0/255 alpha:1.0]
#define BUTTON_SELECTED_COLOR [UIColor colorWithHexString:@"#0257EE"]
#define NO_DATA_COLOR [UIColor colorWithRed:141/255.0 green:182/255.0 blue:205/255.0 alpha:1.0]
#define ANIMATION_DURATION 0.5
#define CHECK_SUBVIEW_TAG 20
#define NO_DATA_LABEL_WIDTH 250
#define NO_DATA_LABEL_HEIGHT 50

@interface TPRouteByButtonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIView * buttonFirstView;
    UIView * buttonSecondView;
    UITableView * tableview;
    BOOL havingTableView;
    NSInteger enteringCounter;
    NSInteger sectionNumber;
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
    UIView *noDataView;
    UILabel *noDataLabel;
}

@property (nonatomic, retain) UIView * buttonFirstView;
@property (nonatomic, retain) UIView * buttonSecondView;
@property (nonatomic, retain) UITableView * tableview;
@property (nonatomic, assign) BOOL havingTableView;
@property (nonatomic, assign) NSInteger enteringCounter;
@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, retain) NSMutableString * partBusName;
@property (nonatomic, retain) NSArray * compBusName;
@property (nonatomic, retain) NSMutableArray * cityName;
@property (nonatomic, retain) NSMutableArray * taipeiDeparName;
@property (nonatomic, retain) NSMutableArray * taipeiDestiName;
@property (nonatomic, retain) NSMutableArray * taipeiBusName;
@property (nonatomic, retain) NSMutableArray * nTaipeiDeparName;
@property (nonatomic, retain) NSMutableArray * nTaipeiDestiName;
@property (nonatomic, retain) NSMutableArray * nTaipeiBusName;
@property (nonatomic, retain) UIView *noDataView;
@property (nonatomic, retain) UILabel *noDataLabel;

@end
