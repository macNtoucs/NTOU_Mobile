//
//  HistoryTableViewController.m
//  NTOU_Mobile
//
//  Created by Rick on 2014/4/24.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "LoginResResultViewController.h"
#import "LoginResultViewController.h"
#import "LoginOutResultViewController.h"
#import "UIKit+NTOUAdditions.h"
#import "MBProgressHUD.h"

@interface HistoryTableViewController ()
@property (strong, nonatomic) LoginResultViewController *history;
@property (strong, nonatomic) LoginResResultViewController *resHistory;
@property (strong, nonatomic) LoginOutResultViewController *outHistory;
@end

@implementation HistoryTableViewController
@synthesize history;
@synthesize resHistory;
@synthesize outHistory;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    [self.tableView applyStandardColors];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //配合nagitive和tabbar的圖片變動tableview的大小
    //nagitive 52 - 44 = 8 、 tabbar 55 - 49 = 6
    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,6,0)];
    
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"借閱歷史";
            break;
        case 1:
            cell.textLabel.text = @"預約記錄";
            break;
        case 2:
            cell.textLabel.text = @"借出記錄";
            break;
        default:
            break;
    }
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        switch (indexPath.row)
        {
            case 0:
            {
                if(history == NULL)
                {
                    history = [[LoginResultViewController alloc]initWithStyle:UITableViewStyleGrouped];
                    history.title= @"借閱歷史";
                }
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.labelText = @"Loading";
                    });
                    history.page =1;
                    [history fetchHistory];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.navigationController pushViewController:history  animated:YES];
                    });
                });
                break;
            }
            case 1:
            {
                if(resHistory == NULL)
                {
                    resHistory = [[LoginResResultViewController alloc]initWithStyle:UITableViewStyleGrouped];
                    resHistory.title=@"預約記錄";
                }
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.labelText = @"Loading";
                    });
                    [resHistory fetchresHistory];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.navigationController pushViewController:resHistory  animated:YES];
                    });
                });
                break;
            }
            case 2:
            {
                if(outHistory == NULL)
                {
                    outHistory = [[LoginOutResultViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    outHistory.title=@"借出記錄";
                }
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.labelText = @"Loading";
                    });
                    [outHistory fetchoutHistory];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.navigationController pushViewController:outHistory  animated:YES];
                    });
                });
                break;
            }
            default:
                break;
        }
}

@end
