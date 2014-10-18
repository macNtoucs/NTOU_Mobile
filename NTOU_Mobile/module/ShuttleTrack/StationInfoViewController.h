//
//  StationInfoViewController.h
//  MIT Mobile
//
//  Created by MacAir on 12/11/3.
//
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "DownloadingView.h"
#import "SecondaryGroupedTableViewCell.h"
#import "FMDatabase.h"

@protocol StaionInfoDataSource;
@interface StaionInfoTableViewController : UITableViewController{
    __unsafe_unretained id <StaionInfoDataSource> dataSource;
    NSURL * dataURL;
    NSMutableArray *trainNumber;
    NSMutableArray *trainStartFroms;
    NSMutableArray *trainTravelTos;
    NSMutableArray *departureTimes;
    NSMutableArray *arrivalTimes;
    NSMutableArray *trainStyle;
    NSString *arrivalStation;
    NSString *departureStation;
    DownloadingView *downloadView;
    NSString * selectedDate;
    NSString * selectedTrainStyle;
    NSString * lineDir;
}
@property (nonatomic,retain) NSURL * dataURL;
@property (nonatomic ,retain )NSMutableArray *trainNumber;
@property (nonatomic, retain) NSMutableArray *trainStartFroms;
@property (nonatomic, retain) NSMutableArray *trainTravelTos;
@property (nonatomic, retain) NSMutableArray *departureTimes;
@property (nonatomic, retain) NSMutableArray *arrivalTimes;
@property (nonatomic, retain) NSString * selectedDate;
@property (nonatomic, retain) NSString * selectedTrainStyle;
@property (nonatomic, retain) NSString * lineDir;
@property (nonatomic, unsafe_unretained) id <StaionInfoDataSource> dataSource;
-(void) recieveData;

@end


@protocol StaionInfoDataSource <NSObject>
- (NSURL*)StationInfoURL:(StaionInfoTableViewController *)stationInfoTableView;
- (NSString *)startStationTitile:(StaionInfoTableViewController *)stationInfoTableView;
- (NSString *)depatureStationTitile:(StaionInfoTableViewController *)stationInfoTableView;
@end
