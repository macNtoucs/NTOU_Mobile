//
//  R66Layer2ViewController.h
//  NTOU_Mobile
//
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondaryGroupedTableViewCell.h"

@interface R66RightLayerViewController : UITableViewController
{
    NSArray *weekend_marine;
    NSArray *weekend_qidu;
}
@property (nonatomic, retain) NSArray *weekend_marine;
@property (nonatomic, retain) NSArray *weekend_qidu;

@end
