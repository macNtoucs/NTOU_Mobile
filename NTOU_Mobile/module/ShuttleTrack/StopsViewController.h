//
//  StopsViewController.h
//  MIT Mobile
//  交通功能：海洋專車：市區公車 站牌tableView
//  Created by mac_hero on 12/9/27.
//
//

#import <UIKit/UIKit.h>
#import "RouteDetailViewController.h"
@interface StopsViewController : UITableViewController{
    bool go;  //true 往市區, false 往八斗子
    NSMutableArray *innerStop;
    NSMutableArray *outerStop;
}
@property (nonatomic,retain) NSMutableArray *innerStop;
@property (nonatomic,retain) NSMutableArray *outerStop;
-(void) setDirection :(BOOL) dir;
@end
