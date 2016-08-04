//
//  TestViewController.m
//  NTOU_Mobile
//
//  Created by Lab414 on 2016/7/27.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "TestViewController.h"
#import <pjsua.h>
#import "SipDiagButton.h"
@import AudioToolbox;

@interface TestViewController ()

@end

@implementation TestViewController

@synthesize current_call;

-(void)callToNtou{
    if(current_call == PJSUA_INVALID_ID)
        pjsua_call_make_call(acc_id,&NtouUri,0,0,0,&current_call);
    else{
        if(pjsua_call_is_active(current_call) == PJ_FALSE)
            pjsua_call_make_call(acc_id,&NtouUri,0,0,0,&current_call);
    }
    
}
-(void)hangup{
    pjsua_call_hangup_all();
}
-(void)DTMF:(SipDiagButton*)button{
    [button playDiagSound];
    if(current_call != PJSUA_INVALID_ID){
        if(pjsua_call_is_active(current_call) == PJ_TRUE){
        char temp[2];
        strcpy(temp,[button.titleLabel.text UTF8String]);
        pj_str_t diag = pj_str(temp);
        pjsua_call_dial_dtmf(current_call,&diag);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"數字鍵盤";
    current_call = PJSUA_INVALID_ID;
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    background.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    [self.view addSubview:background];
    
    UILabel * callinfo = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2-(self.view.bounds.size.height/8)*3,self.view.bounds.size.width, (self.view.bounds.size.height/8))];
    callinfo.text = @"請先撥號";
    callinfo.textAlignment = NSTextAlignmentCenter;
    callinfo.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:callinfo];
    
    call = [UIButton buttonWithType:UIButtonTypeSystem];
    [call setTitle:@"撥號" forState:UIControlStateNormal];
    call.frame = CGRectMake(0, self.view.bounds.size.height/2-(self.view.bounds.size.height/8)*2, (self.view.bounds.size.width/3), (self.view.bounds.size.height/8));
    [call addTarget:self
             action:@selector(callToNtou)
   forControlEvents:UIControlEventTouchUpInside];
    call.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:call];
    
    hangup = [UIButton buttonWithType:UIButtonTypeSystem];
    [hangup setTitle:@"掛斷" forState:UIControlStateNormal];
    hangup.frame = CGRectMake((self.view.bounds.size.width/3)*2,self.view.bounds.size.height/2-(self.view.bounds.size.height/8)*2, (self.view.bounds.size.width/3), (self.view.bounds.size.height/8));
    [hangup addTarget:self
               action:@selector(hangup)
     forControlEvents:UIControlEventTouchUpInside];
    hangup.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:hangup];
    
    
    for(int i=0;i<4;i++){
        for(int j=0;j<3;j++){
            SipDiagButton *bx = [SipDiagButton buttonWithType:UIButtonTypeSystem];
            if(i*3+j+1>9)
                switch(i*3+j+1){
                    case 10:
                        [bx setTitle: @"*" forState:UIControlStateNormal];
                        bx.sign = @"*";
                        break;
                    case 11:
                        [bx setTitle: @"0" forState:UIControlStateNormal];
                        bx.sign = @"0";
                        break;
                    case 12:
                        [bx setTitle: @"#" forState:UIControlStateNormal];
                        bx.sign = @"#";
                        break;
                }
            else{
                [bx setTitle: [NSString stringWithFormat:@"%d",i*3+j+1] forState:UIControlStateNormal];
                bx.sign = [[NSString alloc] initWithFormat:@"%d",i*3+j+1];
            }
            [bx registerDiagSound];
            bx.frame = CGRectMake((self.view.bounds.size.width/3)*j, self.view.bounds.size.height/2+(self.view.bounds.size.height/8)*(i-1), (self.view.bounds.size.width/3), (self.view.bounds.size.height/8));
            [bx addTarget:self
                   action:@selector(DTMF:)
         forControlEvents:UIControlEventTouchUpInside];
            bx.titleLabel.font = [UIFont systemFontOfSize:30];
            [self.view addSubview:bx];
        }
    }
    
    /*SipDiagButton * test1 = [SipDiagButton new];
    test1.sign = @"1";
    [test1 registerSystemSound];
    [test1 playSystemSound];*/
   
    pjsua_acc_config_default(&acc);
    acc.id = pj_str("<sip:601@140.121.99.170>");
    acc.reg_uri = pj_str("sip:140.121.99.170");
    acc.cred_count = 1;
    acc.cred_info[0].realm = pj_str("*");
    acc.cred_info[0].scheme = pj_str("digest");
    acc.cred_info[0].username = pj_str("601");
    acc.cred_info[0].data_type = 0;
    acc.cred_info[0].data = pj_str("12345678");
    
    static pj_thread_desc a_thread_desc;
    static pj_thread_t *a_thread;
    if (!pj_thread_is_registered()) {
        pj_thread_register("ipjsua", a_thread_desc, &a_thread);
    }
    
    NtouUri = pj_str("sip:16877@140.121.99.170");
    pjsua_acc_add(&acc, PJ_TRUE, &acc_id);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
