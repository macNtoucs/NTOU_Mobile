//
//  SipDiagButton.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/4.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipDiagButton.h"
//@import AudioToolbox;

@implementation SipDiagButton
@synthesize sign;

-(void)registerDiagSound{
    NSString *prefix = @"Dtmf-";
    //AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[prefix stringByAppendingString:sign]ofType:@"wav"]],&sound_id);
    
    pj_status_t status;
    NSString *temp_ns = [[NSBundle mainBundle]pathForResource: [prefix stringByAppendingString:sign] ofType:@"wav"];
    char temp_c[500];
    strcpy(temp_c, [temp_ns UTF8String]);
    pj_str_t temp = pj_str(temp_c);
    status = pjsua_player_create(&temp,PJMEDIA_FILE_NO_LOOP, &player_id);
    [prefix release];
}
-(void)playDiagSound{
    //AudioServicesPlaySystemSound(sound_id);
    pjsua_conf_connect(pjsua_player_get_conf_port(player_id), 0);
    pjsua_player_set_pos(player_id,0);
    NSLog(@"%@",sign);
    
}
@end
