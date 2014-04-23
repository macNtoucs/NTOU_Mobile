//
//  Des_decrypt.m
//  APITest
//
//  Created by R MAC on 12/12/7.
//  Copyright (c) 2012年 R MAC. All rights reserved.
//

#import "Moodle_API.h"
#import "CommonCryptor.h"
#import "SBJson.h"


@implementation Moodle_API


static Byte iv[] = {1,2,3,4,5,6,7,8};

+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64Encoding];
    }
    return ciphertext;
}


+(NSDictionary *)queryFunctionType:(NSString *) type PostString:(NSString *)finailPost{
    // get response
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSMutableURLRequest * jsonQuest = [NSMutableURLRequest new];
    NSString * queryURL = [NSString stringWithFormat:@"http://140.121.100.103:8080/iNTOU/%@.do",type];
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest setHTTPMethod:@"POST"];
    [jsonQuest addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [jsonQuest setHTTPBody:[finailPost dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error
                            ];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    return dictionary;
    
}

+(bool)checkIsStringIncludePulseSymbol:(NSString*) input{
    NSString * plusSymbol = @"%";
    NSRange check = [input rangeOfString:plusSymbol];
    if (check.length) return true;
    else return false;
}

+(NSDictionary *)Login:(NSString *)username andPassword:(NSString*)password{
    // NSDictionary *dictionary = [self queryFunctionType:@"login" PostString:finailPost];
    NSDictionary *dictionary;
    bool validString=false;
    NSDictionary *postDic1;
    do{
        long long unsigned a = rand()%10000+10000;
        long long unsigned b = rand()%10000+10000;
        long long unsigned msec = ( a * b ) + 1430000000000;
        long long unsigned forEncrpt = msec%100000000;
        // setup post string
        NSString * encrypt_username =  [Moodle_API encryptUseDES:username key:[NSString stringWithFormat:@"%lld",forEncrpt]];
        NSString * encrypt_password =  [Moodle_API encryptUseDES:password key:[NSString stringWithFormat:@"%lld",forEncrpt]];
        
        
        postDic1 =[[NSDictionary alloc]initWithObjectsAndKeys:
                   encrypt_username,@"username",
                   encrypt_password,@"password",
                   [NSString stringWithFormat:@"%lld",msec],@"now", nil];
        
        if ( ![self checkIsStringIncludePulseSymbol:encrypt_username] &&  ![self checkIsStringIncludePulseSymbol:encrypt_password]) validString = true;
        
    }while (!validString);
    NSString *jsonRequest = [postDic1 JSONRepresentation];
    NSString *finailPost = [NSString stringWithFormat:@"json=%@",jsonRequest];
    dictionary = [self queryFunctionType:@"login" PostString:finailPost];
    if([[dictionary allValues]count]>1) {
        NSLog(@"登入成功");
    }
    else NSLog(@"登入失敗");
    
    
    return dictionary;
}

+(NSDictionary *)GetCourse_AndUseToken:(NSString*)token{
    NSDictionary *postDic = [[NSDictionary alloc]initWithObjectsAndKeys:token,@"stid", nil];
    NSString *jsonRequest = [postDic JSONRepresentation];
    NSString *finailPost = [NSString stringWithFormat:@"json=%@",jsonRequest];
    
    NSDictionary *dictionary = [self queryFunctionType:@"getCourse" PostString:finailPost];
    
    
    return dictionary;
}


+(NSDictionary* )GetCourseInfo_AndUseToken:(NSString *)token courseID:(NSString *)cosID classID:(NSString *)clsID{
    NSDictionary *postDic = [[NSDictionary alloc]initWithObjectsAndKeys:token,@"stid",cosID,@"cosid",clsID,@"clsid",nil];
    NSString *jsonRequest = [postDic JSONRepresentation];
    NSString *finailPost = [NSString stringWithFormat:@"json=%@",jsonRequest];
    NSDictionary *dictionary = [self queryFunctionType:@"CourseInfo" PostString:finailPost];
    return dictionary;
    
}

+(NSDictionary* )GetMoodleInfo_AndUseToken:(NSString *)token courseID:(NSString *)cosID classID:(NSString *)clsID{
    NSDictionary * Jsonlist =[[NSDictionary alloc]initWithObjectsAndKeys:cosID,@"cosid",clsID,@"clsid",nil];
    NSDictionary *postDic = [[NSDictionary alloc]initWithObjectsAndKeys:token,@"stid",Jsonlist,@"list",nil];
    NSString *const_jsonRequest = [postDic JSONRepresentation];
    NSMutableString *jsonRequest = [[NSMutableString alloc]initWithString:const_jsonRequest];
    
    [jsonRequest insertString:@"[" atIndex:8];
    [jsonRequest insertString:@"]" atIndex:[jsonRequest rangeOfString:@"stid"].location-2];
    
    NSString *finailPost = [NSString stringWithFormat:@"json=%@",jsonRequest];
    NSDictionary *dictionary = [self queryFunctionType:@"getMoodleInfo" PostString:finailPost];
    return dictionary;
}

+(NSDictionary* )GetGrade_AndUseToken:(NSString *)token courseID:(NSString *)cosID classID:(NSString *)clsID{
    NSDictionary *postDic = [[NSDictionary alloc]initWithObjectsAndKeys:token,@"stid",cosID,@"cosid",clsID,@"clsid",nil];
    NSString *jsonRequest = [postDic JSONRepresentation];
    NSString *finailPost = [NSString stringWithFormat:@"json=%@",jsonRequest];
    NSDictionary *dictionary = [self queryFunctionType:@"getGrade" PostString:finailPost];
    return dictionary;
}

+(NSDictionary* )GetMoodleID_AndUseToken:(NSString *)token courseID:(NSString *)cosID classID:(NSString *)clsID{
    NSDictionary *postDic = [[NSDictionary alloc]initWithObjectsAndKeys:token,@"stid",cosID,@"cosid",clsID,@"clsid",nil];
    NSString *jsonRequest = [postDic JSONRepresentation];
    NSString *finailPost = [NSString stringWithFormat:@"json=%@",jsonRequest];
    NSDictionary *dictionary = [self queryFunctionType:@"getMoodleID" PostString:finailPost];
    return dictionary;
}

+(NSDictionary* )MoodleID_AndUseToken:(NSString *)token module:(NSString *)module moodleID:(NSString *)mid courseID:(NSString *)cosID classID:(NSString *)clsID{
    NSDictionary *postDic = [[NSDictionary alloc]initWithObjectsAndKeys:token,@"stid",module,@"module",mid,@"mid",cosID,@"cosid",clsID,@"clsid",nil];
    NSString *jsonRequest = [postDic JSONRepresentation];
    NSString *finailPost = [NSString stringWithFormat:@"json=%@",jsonRequest];
    NSDictionary *dictionary = [self queryFunctionType:@"MoodleInfo" PostString:finailPost];
    return dictionary;
    
}

+(NSArray* )getFilesFolder_InDir:(NSString *)dir{
   // dir=@"/21464/課程講義";
    NSHTTPURLResponse *urlResponse = nil;
    NSError * error;
   NSString * queryURL = [NSString stringWithFormat:@"http://moodle.ntou.edu.tw/m/new_filestring.php?dir=%@",dir];
    NSString *encodeUrl = [queryURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * query = [[NSMutableURLRequest new]autorelease];
    [query setURL:[NSURL URLWithString:encodeUrl]];
    [query setHTTPMethod:@"GET"];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:query
                                                 returningResponse:&urlResponse
                                                             error:&error
                            ];
    NSString* responseStr = [[[NSString alloc] initWithData:responseData
                                                   encoding:NSUTF8StringEncoding] autorelease];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSMutableArray *result_Inventory = [NSMutableArray new];
    if ([dictionary count]==0){
        [result_Inventory addObject:@"尚無資料"];
        return result_Inventory;
    }
    NSArray * dic_val = [dictionary allValues];
    NSArray * inventory = [dic_val objectAtIndex:0];
   
    for (id pair in inventory){
        [result_Inventory addObject:[pair objectForKey:@"item"]];
    }
    return result_Inventory;
}



+(NSString * ) GetPathOfDownloadFiles_fileName:(NSString *)FileName
                                       FromDir:(NSString *)dir
{
    //moodle.ntou.edu.tw/file.php/19367/課程講義/_10_JavaScript_for_Ajax.pptx
    NSString *URL = [NSString stringWithFormat:@"http://moodle.ntou.edu.tw/file.php%@/%@",dir,FileName];
    return URL;
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL  *url = [NSURL URLWithString:URL];
    
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,FileName];
        [urlData writeToFile:filePath atomically:YES];
        return filePath;
    }
    else return @"Error_dir_or_FileName";
    
}

+(BOOL)CleanUpAllTheFiles{
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager new];
    NSError *err;
    return[manager removeItemAtPath:documentsDirectory error:&err];
    
}

@end
