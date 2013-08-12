//
//  TPRouteGoBackViewController.h
//  bus
//
//  Created by iMac on 12/10/29.
//
//

#import <UIKit/UIKit.h>
#import "NTOUConstants.h"

@interface TPRouteGoBackViewController : UITableViewController
{
    NSString * departure;   // 存起始站牌名稱
    NSString * destination; // 存終點站牌名稱
    NSString * busName; // 存取公車名稱
}

@property (nonatomic, retain) NSString * busName;
@property (nonatomic, retain) NSString * departure;
@property (nonatomic, retain) NSString * destination;

- (void) setter_departure:(NSString *) name;    // 取得所點選的公車路線起始位置
- (void) setter_destination:(NSString *) name;  // 取得所點選的公車路線終點位置
- (void) setter_busName:(NSString *) name; // 取得公車名稱

@end
