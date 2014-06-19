//
//  igViewController.h
//  ScanBarCodes
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@class MainViewController;
@interface igViewController : UIViewController <UIAlertViewDelegate>{
  MainViewController *mainview;
}



@property (nonatomic,retain) MainViewController *mainview;
@end