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
#import "TPRouteDetailViewController.h"
#import "NTRouteDetailViewController.h"
#import "UIKit+NTOUAdditions.h"
#define LAYER1_BUT_WIDTH    58
#define LAYER1_BUT_HEIGHT   40
#define LAYER1_BUT_GAP      5
#define LAYER2_BUT_WIDTH    148
#define LAYER2_BUT_HEIGHT   55

@interface TPRouteByButtonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIView * buttonFirstView;
    UIView * buttonSecondView;
    UITableView * tableview;
    BOOL havingTableView;
    NSMutableString * partBusName;
    NSArray * compBusName;
    NSMutableArray * compDeparName;
    NSMutableArray * compDestiName;
    NSMutableArray * cityName;
    CGFloat screenWidth;
    CGFloat screenHeight;
    UIColor *buttonTintColor;
    int counterT, counterN, counterK, index;
    NSMutableArray *arrayTaipeiBus;
    NSMutableArray *arrayNewTaipeiBus;
    NSMutableArray *arrayKeelungBus;
    NSMutableArray *depArrayTaipeiBus;
    NSMutableArray *depArrayNewTaipeiBus;
    NSMutableArray *depArrayKeelungBus;
    NSMutableArray *desArrayTaipeiBus;
    NSMutableArray *desArrayNewTaipeiBus;
    NSMutableArray *desArrayKeelungBus;
    //
    BOOL success;
    NSError *error;
    NSFileManager *fm;
    NSArray *paths;
    NSString *documentsDirecotry;
    NSString *writableDBPath;
    
    UILabel *partBusNameLabel;
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, retain) UIView * buttonFirstView;
@property (nonatomic, retain) UIView * buttonSecondView;
@property (nonatomic, retain) UITableView * tableview;
@property (nonatomic, assign) BOOL havingTableView;
@property (nonatomic, retain) NSMutableString * partBusName;
@property (nonatomic, retain) NSArray * compBusName;
@property (nonatomic, retain) NSMutableArray * compDeparName;
@property (nonatomic, retain) NSMutableArray * compDestiName;
@property (nonatomic, retain) NSMutableArray * cityName;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, retain) UIColor *buttonTintColor;
@property (nonatomic, retain) NSMutableArray *arrayTaipeiBus;
@property (nonatomic, retain) NSMutableArray *arrayNewTaipeiBus;
@property (nonatomic, retain) NSMutableArray *arrayKeelungBus;
@property (nonatomic, retain) NSMutableArray *depArrayTaipeiBus;
@property (nonatomic, retain) NSMutableArray *depArrayNewTaipeiBus;
@property (nonatomic, retain) NSMutableArray *depArrayKeelungBus;
@property (nonatomic, retain) NSMutableArray *desArrayTaipeiBus;
@property (nonatomic, retain) NSMutableArray *desArrayNewTaipeiBus;
@property (nonatomic, retain) NSMutableArray *desArrayKeelungBus;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *partBusNameLabel;
@end
