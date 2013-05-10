//
//  KUO_RouteViewController_Bra2.h
//  MIT Mobile
//
//  Created by mini server on 12/11/17.
//
//

#import <UIKit/UIKit.h>
#import "KUO_Data_Bra2.h"
#import "Fuhobus_Data.h"
#import "KUO_TimeViewController.h"
#import "SecondaryGroupedTableViewCell.h"
#define Kuo_Data 1
#define Fuho_Data 2

#define exceptionSectionName @"基隆"
#define exceptionIndex 4
@interface KUO_RouteViewController_Bra2 : UITableViewController<KUO_TimeViewControllerDelegate>{
    NSDictionary* display;
    NSMutableDictionary* inbound;
    NSMutableDictionary* outbound;
    NSMutableDictionary* exception;
    KUO_TimeViewController* tabc;
}

- (id)initWithStyle:(UITableViewStyle)style WithType:(int)type;

@end
