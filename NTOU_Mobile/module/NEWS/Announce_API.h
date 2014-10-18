//
//  Announce_API.h
//  Announce_API
//
//  Created by R MAC on 13/2/19.
//  Copyright (c) 2013年 R MAC. All rights reserved.
//
@class Announce_API;
@protocol Announce_API_Delegate <NSObject>
@required
- (void)parserDidStartDownloading:(Announce_API *)parser;
- (void)parserDidStartParsing:(Announce_API *)parser;
- (void)parser:(Announce_API *)parser didMakeProgress:(CGFloat)percentDone;
- (void)parser:(Announce_API *)parser didFailWithDownloadError:(NSError *)error;
- (void)parser:(Announce_API *)parser didFailWithParseError:(NSError *)error;
- (void)parserDidFinishParsing:(Announce_API *)parser;
@end

#import <Foundation/Foundation.h>
#import "XMLReader.h"
@interface Announce_API : NSObject <NSURLConnectionDelegate >{
    id delegate;
    int mFileSize;
    int currentRieceved;
    NSMutableData * updatePackage;
    NSDictionary *content;
    NSURLConnection *connection;
    BOOL isConnected;
}
//@property (nonatomic,retain)  NSString * Myfilenmame;
//@property (nonatomic,retain)  NSString * Myfilelength;
@property (assign) id delegate;
@property (retain,nonatomic) NSDictionary* content;
/*
 取得公佈欄資料
 參數：
 (int) count : 要求的數量
 (NSString) type : 類型{   , 共有以下 6 種類型
 a.) announce (學校公告)
 b.) symposium (研討會)
 c.) art (藝文活動)
 d.) lecture  (演講公告)
 e.) document (電子公文)
 f.) Information (校外訊息)  }
 (int)page: 頁數
 
 EX : NSDictionary* response= [Announce_API getAnnounceInfo_Count:5 andType:@"art" andPage:1];
 */
- (void)getAnnounceInfo_Count:(NSInteger)count andType:(NSString *)type andPage:(NSInteger) page ;
-(void)CancelConnection;
@end
