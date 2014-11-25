//
//  igViewController.h
//  ScanBarCodes
//  條碼掃描
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "switchController.h"

@class MainViewController;
@interface igViewController : UIViewController <UIAlertViewDelegate>{
  MainViewController *mainview;
    switchController * switchCon;

}



@property (nonatomic, retain)switchController * switchCon;
@property (nonatomic,retain) MainViewController *mainview;
@end