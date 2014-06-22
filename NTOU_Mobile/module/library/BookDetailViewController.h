//
//  BookDetailViewController.h
//  library
//
//  Created by apple on 13/6/27.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
@interface BookDetailViewController : UITableViewController <UIAlertViewDelegate , NSURLConnectionDelegate ,NJKWebViewProgressDelegate,UIWebViewDelegate >
@property (nonatomic,retain) NSString *bookurl;


-(void)fetchBookDetailAndReview;
@end
