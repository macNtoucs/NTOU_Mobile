//
//  NTOU_MobileAppDelegate+SipPhone.m
//  NTOU_Mobile
//
//  Created by Lab414 on 2016/7/28.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//
/*
 http://www.pjsip.org/pjsip/docs/html/group__PJSUA__LIB__BASE.htm#details  // please see pjsip Documentations
 */
#import "NTOU_MobileAppDelegate+SipPhone.h"
#import <pjlib.h>
#import <pjsua.h>

@implementation NTOU_MobileAppDelegate (SipPhone)


static void on_call_media_state(pjsua_call_id call_id) // a special c-function called by pjsua, go to pjsip Documentations see more function like this
{
    pjsua_call_info ci;
    
    pjsua_call_get_info(call_id, &ci);
    
    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) { // when answering the phone,open sound outbound
        pjsua_conf_connect(ci.conf_slot, 0);
        pjsua_conf_connect(0, ci.conf_slot);
    }  
}

- (void)pjsuaStart{
    pj_status_t status;

    status = pjsua_create(); // create pjsua
    
    pjsua_config ua_cfg; //setup config default
    pjsua_config_default(&ua_cfg);
    pjsua_logging_config log_cfg;
    pjsua_logging_config_default(&log_cfg);
    pjsua_media_config media_cfg;
    pjsua_media_config_default(&media_cfg);
    
    ua_cfg.cb.on_call_media_state = &on_call_media_state; //connect function
    
    status = pjsua_init(&ua_cfg,&log_cfg,&media_cfg); //after setting config ,init it
    
    pjsua_transport_config transport_config; //set udp
    pjsua_transport_config_default(&transport_config);
    transport_config.port = 44987;
    status = pjsua_transport_create(PJSIP_TRANSPORT_UDP,&transport_config,NULL);
    pjsua_transport_config_default(&transport_config);
    
    status = pjsua_start(); //start pjsua
    
    pjmedia_codec_g722_deinit();  //deinit for NTOU server , or it would be lag or disconnecting for calling to NTOU, only use PCMU codec
    pjmedia_codec_ilbc_deinit();
    pjmedia_codec_speex_deinit();
    pjmedia_codec_gsm_deinit();
    
    //test code,it should work! or use TestViewController!
     
    /*
    pjsua_acc_config acc;
    pjsua_acc_id acc_id;
    pjsua_acc_config_default(&acc);
    acc.id = pj_str("<sip:601@140.121.99.170>");
    acc.reg_uri = pj_str("sip:140.121.99.170");
    acc.cred_count = 1;
    acc.cred_info[0].realm = pj_str("*");
    acc.cred_info[0].scheme = pj_str("digest");
    acc.cred_info[0].username = pj_str("601");
    acc.cred_info[0].data_type = 0;
    acc.cred_info[0].data = pj_str("12345678");
    status = pjsua_acc_add(&acc, PJ_TRUE, &acc_id);
     
    pj_str_t NtouUri = pj_str("sip:16877@140.121.99.170");
     
    pjsua_call_make_call(acc_id,&NtouUri,0,0,0,0);
    */
    
    
}

@end
