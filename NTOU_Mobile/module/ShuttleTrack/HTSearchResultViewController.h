//
//  HTSearchResultViewController.h
//  MIT Mobile
//  交通功能：高鐵 查詢結果
//  Created by MacAir on 12/11/26.
//
//

#import <UIKit/UIKit.h>
#import "DownloadingView.h"
#import "TFHpple.h"
#import "SecondaryGroupedTableViewCell.h"
@protocol HTStaionInfoDataSource;
@interface HTSearchResultViewController : UITableViewController{
    __unsafe_unretained id <HTStaionInfoDataSource> dataSource;
    NSArray * station;
    NSString * arrivalStation;
    NSString * departureStation;
    NSURL * dataURL;
    DownloadingView *downloadView;
    NSDate * selectedDate;
    NSString * selectedHTTime;
    NSString * queryResult;
    NSMutableArray * trainID;
    NSMutableArray * departureTime;
    NSMutableArray * arrivalTime;
    NSArray * HTStationNameCode;
    bool isFirstTimeLoad;
}

@property (nonatomic,unsafe_unretained)id dataSource;
@property (nonatomic,retain) NSDate * selectedDate;
@property (nonatomic,retain)NSString * selectedHTTime;//時間 e.g.16:00
@property (nonatomic,retain)NSString *selectedTimeCategory;//時段 e.g.下午，對應SetTimeViewController的TimeCategory
@property (nonatomic,retain)NSArray * HTStationNameCode;
-(void) recieveData;

@end

@protocol HTStaionInfoDataSource <NSObject>
- (NSURL*)HTStationInfoURL:(HTSearchResultViewController *)stationInfoTableView;
- (NSString *)HTstartStationTitile:(HTSearchResultViewController *)stationInfoTableView;
- (NSString *)HTdepatureStationTitile:(HTSearchResultViewController *)stationInfoTableView;
@end
