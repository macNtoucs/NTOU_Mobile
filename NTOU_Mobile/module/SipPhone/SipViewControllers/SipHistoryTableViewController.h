//
//  SipHistoryTableViewController.h
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/24.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SipHistoryTableViewController : UITableViewController <UITableViewDataSource>
{
    NSMutableArray *numbers;
}

-(void)addNumber:(NSString*)number;


@end