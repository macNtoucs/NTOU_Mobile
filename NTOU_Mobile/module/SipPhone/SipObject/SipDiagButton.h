//
//  SipDiagButton.h
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/4.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SipDiagButton : UIButton

@property (nonatomic,assign)NSString *sign;
@property (nonatomic,assign)UInt32 sound_id;
-(void)registerDiagSound;
-(void)playDiagSound;
@end
