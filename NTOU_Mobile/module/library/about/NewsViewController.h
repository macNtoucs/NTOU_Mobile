//
//  NewsViewController.h
//  library
//
//  Created by su on 13/7/5.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLReader.h"
#import "NJKWebViewProgress.h"
@interface NewsViewController : UITableViewController<NJKWebViewProgressDelegate,UIWebViewDelegate >{    
    UIProgressView *progressView;
}

@property (nonatomic,strong) NSArray *NEWSdata;
@end
