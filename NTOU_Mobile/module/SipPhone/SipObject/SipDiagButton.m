//
//  SipDiagButton.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/4.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipDiagButton.h"
#import <AVFoundation/AVFoundation.h>

@implementation SipDiagButton
@synthesize sign;

-(void)registerDiagSound{
    NSError* error = nil;
    NSString *prefix = @"Dtmf-";
    myPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]pathForResource: [prefix stringByAppendingString:sign] ofType:@"wav"]] error:&error];
    

}

-(void)playDiagSound{
    if([myPlayer isPlaying]){
        [myPlayer stop];
        [myPlayer setCurrentTime:0.0];
    }
    [myPlayer play];
}

@end
