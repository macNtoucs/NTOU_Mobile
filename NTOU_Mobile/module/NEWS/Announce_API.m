//
//  Announce_API.m
//  Announce_API
//
//  Created by R MAC on 13/2/19.
//  Copyright (c) 2013年 R MAC. All rights reserved.
//

#import "Announce_API.h"

@implementation Announce_API
@synthesize delegate;
@synthesize content;
- (id) init {
    self = [super init];
    if (self != nil) {
        updatePackage = [NSMutableData new];
        
    }
    return self;
}


- (void)getAnnounceInfo_Count:(int)count andType:(NSString *)type andPage:(int) page {
    NSString *url = [NSString stringWithFormat:@"http://dtop.ntou.edu.tw/app1020311.php?page=%d&count=%d&class=%@",page,count,type];
    url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding)];
    updatePackage = [[NSMutableData alloc] init];
 	NSError * error = nil;
    NSURLRequest *request = [[NSURLRequest alloc]
 							 initWithURL: [NSURL URLWithString:url]
 							 cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
 							 timeoutInterval: 10
 							 ];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        isConnected = true;
        connection = [[NSURLConnection alloc]
                      initWithRequest:request
                      delegate:self
                      startImmediately:YES];
        
        if(!connection) {
            NSLog(@"connection failed");
            [delegate parser:self didFailWithDownloadError:error];
        } else {
            NSLog(@"connection succeeded");
            
        }
        [delegate parserDidStartParsing:self];
        [connection release];
        [request release];
    });
    // NSError * parseError;
    //NSString * XMLResponse = [[NSString alloc] initWithData:updatePackage encoding:NSUTF8StringEncoding];
    //return [XMLReader dictionaryForXMLString:XMLResponse error:&parseError];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [delegate parserDidStartDownloading:self];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        mFileSize = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
    }
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error{
    isConnected = false;
    [connection cancel];
    [delegate parser:self didFailWithDownloadError:error];
    NSLog(@"HTTP DownloadError");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [updatePackage appendData:data];
    float t = [updatePackage length]/1024;
    float t2= mFileSize/1024;
    NSString *output = [NSString stringWithFormat:@"正在下载 進度:%.2fk/%.2fk .",t,t2];
    [delegate parser:self didMakeProgress:t/t2 ];
    NSLog(@"%@",output);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    isConnected = false;
    NSError * parseError;
    NSString * XMLResponse = [[NSString alloc] initWithData:updatePackage encoding:NSUTF8StringEncoding];
    XMLResponse = [XMLResponse stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    content= [XMLReader dictionaryForXMLString:XMLResponse error:&parseError];
    [delegate parserDidFinishParsing:self];
}

-(void)CancelConnection{
    if(isConnected){
        isConnected = false;
        [connection cancel];
    }
    else return;
}
@end
