//
//  SipDiagButton.h
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/4.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SipDiagButton : UIButton{
    AVAudioPlayer *myPlayer;
}

@property (nonatomic,assign)NSString *sign;
-(void)registerDiagSound;
-(void)playDiagSound;

@end
