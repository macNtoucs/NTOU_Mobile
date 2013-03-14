//
//  Announce_API.m
//  Announce_API
//
//  Created by R MAC on 13/2/19.
//  Copyright (c) 2013年 R MAC. All rights reserved.
//

#import "Announce_API.h"

@implementation Announce_API

+ (NSDictionary *)getAnnounceInfo_Count:(int)count andType:(NSString *)type andPage:(int) page {
    NSString *url = [NSString stringWithFormat:@"http://dtop.ntou.edu.tw/app1020311.php?page=%d&count=%d&class=%@",page,count,type];
      url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding)];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    NSError * parseError;
    
    NSString * XMLResponse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
   return [XMLReader dictionaryForXMLString:XMLResponse error:&parseError];
   
    
    // return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}


@end
