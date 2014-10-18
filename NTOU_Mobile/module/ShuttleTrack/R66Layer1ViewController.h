//
//  R66Layer1ViewController.h
//  NTOU_Mobile
//
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondaryGroupedTableViewCell.h"

@interface R66Layer1ViewController : UITableViewController
{
    NSArray *weekday_marine;
    NSArray *weekday_qidu;
}
@property (nonatomic, retain) NSArray *weekday_marine;
@property (nonatomic, retain) NSArray *weekday_qidu;

@end
