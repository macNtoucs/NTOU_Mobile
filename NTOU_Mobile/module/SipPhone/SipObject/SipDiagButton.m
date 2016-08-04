//
//  SipDiagButton.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/4.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipDiagButton.h"
@import AudioToolbox;

@implementation SipDiagButton
@synthesize sign,sound_id;

-(void)registerDiagSound{
    NSString *prefix = @"Dtmf-";
    AudioServicesCreateSystemSoundID(
                                      (CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                        pathForResource:[prefix stringByAppendingString:sign]
                                                                        ofType:@"wav"]],&sound_id);
    [prefix release];
}
-(void)playDiagSound{
    AudioServicesPlaySystemSound(sound_id);
}
@end
