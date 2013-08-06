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

@end
