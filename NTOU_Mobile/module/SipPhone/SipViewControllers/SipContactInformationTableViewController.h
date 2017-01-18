//
//  SipContactInformationTableViewController.h
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/15.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SipContactInformationTableViewController : UITableViewController<UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>
{
    UISearchBar *searchBar;
    NSArray* informations;
    NSArray* filteredInformations;
}

@property (assign, nonatomic) UISearchController *searchController;
@end
