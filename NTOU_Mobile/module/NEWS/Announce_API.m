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
    NSString *url = [NSString stringWithFormat:@"http://dtop.ntou.edu.tw/app1020402.php?page=%d&count=%d&class=%@",page,count,type];
    //NSString *url = [NSString stringWithFormat:@"http://dtop.ntou.edu.tw/appAPI.php?page=%d&count=%d&class=%@",page,count,type];
    //  NSString *url = [NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/68445784/test.htm"];
    
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

-(void)fix_content:(NSDictionary*) _content{
    NSLog(@"%d",[[[_content valueForKey:@"ntou"]valueForKey:@"notice" ] count]);
    if ([[[_content valueForKey:@"ntou"]valueForKey:@"notice" ] count]==0) return;
    if (![[[_content valueForKey:@"ntou"]valueForKey:@"notice" ] isKindOfClass:[NSArray class]]){
        NSArray * content_array = [NSArray arrayWithObject:[[_content valueForKey:@"ntou"]valueForKey:@"notice" ]];
        NSMutableDictionary * mutalbe_content = [NSMutableDictionary dictionaryWithDictionary:_content];
        [[mutalbe_content valueForKey:@"ntou"]removeObjectForKey:@"notice"];
        [[mutalbe_content valueForKey:@"ntou"]setObject:content_array forKey:@"notice"];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    isConnected = false;
    content = [NSDictionary new];
    NSError * parseError;
    NSString * XMLResponse = [[NSString alloc] initWithData:updatePackage encoding:NSUTF8StringEncoding];
    XMLResponse = [XMLResponse stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    XMLResponse = [XMLResponse stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    content= [XMLReader dictionaryForXMLString:XMLResponse error:&parseError];
    [self fix_content:content];
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