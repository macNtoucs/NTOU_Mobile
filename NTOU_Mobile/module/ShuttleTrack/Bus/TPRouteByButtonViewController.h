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
#import "KLRouteDetailViewController.h"
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
    
    UILabel *partBusNameLabel;
    UIActivityIndicatorView *activityIndicator;
    
    //plist
    NSString *path;
    int frequency;
    NSMutableDictionary * dict;
}
@property (nonatomic, retain) UIView * buttonFirstView;
@property (nonatomic, retain) UIView * buttonSecondView;
@property (nonatomic, retain) UITableView * tableview;
@property (nonatomic, assign) BOOL havingTableView;
@property (nonatomic, retain) NSMutableString * partBusName;
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
@property (nonatomic, retain) NSString *path;
@property (nonatomic, assign) int frequency;
@property (nonatomic, retain) NSMutableDictionary * dict;
@end
