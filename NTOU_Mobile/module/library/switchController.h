//
//  switchController.h
//  library
//
//  Created by apple on 13/7/3.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface switchController : UITabBarController<UITabBarControllerDelegate>{
  UIBarButtonItem * another;
}
@property (nonatomic, retain)  UIBarButtonItem * another;
-(void)ChangeDisplayView;
@end
