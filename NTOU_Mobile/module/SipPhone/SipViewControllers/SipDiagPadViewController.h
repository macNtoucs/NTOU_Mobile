//
//  SipDiagPadViewController.h
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/22.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pjsua.h>

@interface SipDiagPadViewController : UIViewController{
    pjsua_acc_config acc;
    pjsua_acc_id acc_id;
    pj_str_t NtouUri;
    pjsua_call_id current_call;
    pjsua_call_info call_info;
    UIButton *call;
    UIButton *hangup;
    NSArray *dtmf_ids;
}
@property (assign,nonatomic)UILabel *callinfo;
-(void)makeCallToNTOU;

@end
