//
//  NewsDetailViewController.h
//  NTOU_Mobile
//
//  Created by IMAC on 2014/5/7.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Announce_API_Key.h"
#import "NJKWebViewProgress.h"
@interface NewsDetailViewController : UIViewController<UIAlertViewDelegate,NJKWebViewProgressDelegate,UIWebViewDelegate >

@property (strong) NSDictionary *story;
@end
