//
//  KUO_Data_Bra2.h
//  MIT Mobile
//
//  Created by mini server on 12/11/17.
//
//

#import <Foundation/Foundation.h>
#import "ShuttleConstants.h"
@interface KUO_Data_Bra2 : NSObject{
    NSMutableDictionary* memory;
}
+ (KUO_Data_Bra2 *)sharedData;

-(NSDictionary *)fetchInboundJourney;

-(NSDictionary *)fetchOutboundJourney;
@end
