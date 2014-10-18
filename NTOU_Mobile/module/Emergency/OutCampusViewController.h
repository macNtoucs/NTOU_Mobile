//
//  OutCampusViewController.h
//  NTOU Mobile
//
//  Created by mac_hero on 12/10/16.
//
//

#import <UIKit/UIKit.h>
#import "SecondaryGroupedTableViewCell.h"
#import "UIKit+NTOUAdditions.h"
@interface OutCampusViewController : UITableViewController <UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSArray *emergencyData;

}
@property (nonatomic ,retain) NSArray *emergencyData;
@end
