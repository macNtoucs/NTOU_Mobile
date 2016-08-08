//
//  TestViewController.h
//  NTOU_Mobile
//
//  Created by Lab414 on 2016/7/27.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pjsua.h>
@interface TestViewController : UIViewController{
    pjsua_acc_config acc;
    pjsua_acc_id acc_id;
    pj_str_t NtouUri;
    pjsua_call_id current_call;
    UIButton *call;
    UIButton *hangup;
    NSArray *dtmf_ids;
    UILabel *callinfo;

}
@end
