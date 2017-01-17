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
    pjsua_acc_id acc_id;
    pj_str_t NtouUri;
    pjsua_call_id current_call;
    UIButton *hangup;
    UIButton *call;
}
@property (assign,nonatomic)UILabel *callinfo;
+(SipDiagPadViewController*)getSipDiagPadViewController;
-(void)makeCallToNTOU;
-(void)hangup;
-(void)SendDtmf;
@end
