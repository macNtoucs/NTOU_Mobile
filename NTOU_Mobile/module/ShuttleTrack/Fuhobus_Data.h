//
//  Fuhobus_Data.h
//  NTOU_Mobile
//
//  Created by MacAir on 13/3/24.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShuttleConstants.h"
@interface Fuhobus_Data : NSObject{
    NSMutableDictionary* memory;
}
+ (Fuhobus_Data *)sharedData;

-(NSDictionary *)fetchInboundJourney;

-(NSDictionary *)fetchOutboundJourney;

@end
