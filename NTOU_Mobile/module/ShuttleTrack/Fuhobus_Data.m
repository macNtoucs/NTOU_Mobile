//
//  Fuhobus_Data.m
//  NTOU_Mobile
//
//  Created by MacAir on 13/3/24.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "Fuhobus_Data.h"

@implementation Fuhobus_Data

static Fuhobus_Data *sharedData = nil;

+ (Fuhobus_Data *)sharedData {
    @synchronized(self) {
        if (sharedData == nil) {
            sharedData = [[super allocWithZone:NULL] init];
        }
    }
    return sharedData;
}


-(id)init
{
    self = [super init];
    if (self) {
        BOOL success;
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
        NSString *filePath = [paths objectAtIndex:0];
        filePath = [filePath stringByAppendingString:@"/Fuho_Data.plist"];
        success = [fileManager fileExistsAtPath:filePath];
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Fuho_Data.plist"];
        if (![fileManager contentsEqualAtPath:filePath andPath:path]) {
            [fileManager removeItemAtPath:filePath error:&error];
            success = NO;
        }
        if (!success){
            success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
        }
        if (!success) {
            NSAssert1(0, @"Failed to copy Plist. Error %@", [error localizedDescription]);
        }
        memory = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSLog(@"%@",filePath);
    }
    return self;
}

-(NSDictionary *)fetchInboundJourney{
    return [memory objectForKey:InboundJourney];
}

-(NSDictionary *)fetchOutboundJourney{
    return [memory objectForKey:OutboundJourney];
}


@end
