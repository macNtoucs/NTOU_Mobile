//
//  BookDetailViewController.m
//  library
//
//  Created by apple on 13/6/27.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "BookDetailViewController.h"
#import "TFHpple.h"
#import "RBookViewController.h"
#import "SettingsModuleViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BookDetailViewController ()
{
    NSString *book_part1[10];
    NSString *book_part2[10];
    NSString *book_part3[10];
    NSString *book_part4[10];
    NSInteger book_count;
}
@property (nonatomic,retain) NSMutableDictionary *bookdetail;
@property (nonatomic, retain) NSMutableData* receiveData;
@end

@implementation BookDetailViewController
@synthesize bookurl;
@synthesize bookdetail;
@synthesize receiveData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);
    self.receiveData = [NSMutableData data];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receiveStr);
}

-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}



- (void)viewDidLoad
{
    self.title = @"詳細資訊";
    self.title = @"詳細資訊";
    bookurl = [bookurl stringByReplacingOccurrencesOfString:@"&" withString:@"(ANDCHAR)"];
    NSString *parameter= [[NSString alloc]initWithFormat:@"URL=%@",bookurl];
    NSHTTPURLResponse *urlResponse = nil;
    NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
    NSString * queryURL = [NSString stringWithFormat:@"http://140.121.197.135:11114/NTOULibrarySearchAPI/Search.do"];
    [request setURL:[NSURL URLWithString:queryURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    // NSLog(@"%@",  [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    // NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:nil];
    
    
    
    
    NSDictionary * bookDetailDic=  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    [bookDetailDic retain];
    bookdetail = [[NSMutableDictionary alloc] init];
    NSArray * bookResult = [bookDetailDic objectForKey:@"bookResult"];
    NSDictionary * bookResultDic = [bookResult objectAtIndex:0];
    NSArray * realBookDetail =[bookResultDic objectForKey:@"realBookDetail"];
    
    for (size_t realBook_it =0 ; realBook_it < [realBookDetail count] ; ++realBook_it){
        NSDictionary * realBookDetailDic = [realBookDetail objectAtIndex:realBook_it];
        book_part1[realBook_it] = [realBookDetailDic objectForKey:@"location"];
        book_part2[realBook_it] = [realBookDetailDic objectForKey:@"number"];
        book_part3[realBook_it] = [realBookDetailDic objectForKey:@"barcode"];
        book_part4[realBook_it] = [realBookDetailDic objectForKey:@"status"];
    }
    
    
    [bookdetail setObject:[bookResultDic objectForKey:@"title"] forKey:@"name"];
    [bookdetail setObject:[bookResultDic objectForKey:@"author"] forKey:@"author"];
    [bookdetail setObject:[bookResultDic objectForKey:@"pubInform"] forKey:@"press"];
    [bookdetail setObject:[bookResultDic objectForKey:@"reserveURL"] forKey:@"resurl"];
    
    book_count = [realBookDetail count];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(book_count == 0 && [bookdetail objectForKey:@"resurl"] == NULL)
        return 1;   //只有書籍資料
    else if( [[bookdetail objectForKey:@"resurl"] isEqualToString:@""])
        return 2;   //書籍資料＋借閱資訊
    else
        return 3;   //可預約
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"書籍資訊"];
            break;
        case 1:
            return [NSString stringWithFormat:@"借閱情況"];
            break;
        default:
            return [NSString stringWithFormat:@" "];
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 3;
    else if (section == 1)
        return book_count;
    else if (section == 2)
        return 1;   //按鈕
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",row,section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *presslabel = nil;
    UILabel *press = nil;
    UILabel *authorlabel = nil;
    UILabel *author = nil;
    UILabel *namelabel = nil;
    UILabel *name = nil;
    //館藏地
    UILabel *part1label = nil;
    UILabel *part1 = nil;
    //索書號／卷期
    UILabel *part2label = nil;
    UILabel *part2 = nil;
    //條碼
    UILabel *part3label = nil;
    UILabel *part3 = nil;
    //處理狀態
    UILabel *part4label = nil;
    UILabel *part4 = nil;
    
    UILabel *button = nil;
    
    if (cell == nil)
    {
        presslabel = [[UILabel alloc] init];
        press = [[UILabel alloc] init];
        authorlabel = [[UILabel alloc] init];
        author = [[UILabel alloc] init];
        namelabel = [[UILabel alloc] init];
        name = [[UILabel alloc] init];
        
        part1 = [[UILabel alloc] init];
        part2 = [[UILabel alloc] init];
        part3 = [[UILabel alloc] init];
        part4 = [[UILabel alloc] init];
        part1label = [[UILabel alloc] init];
        part2label = [[UILabel alloc] init];
        part3label = [[UILabel alloc] init];
        part4label = [[UILabel alloc] init];
        
        button = [[UILabel alloc] init];
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    UIFont *boldfont = [UIFont boldSystemFontOfSize:14.0];
    if(section == 0)
    {
        
        NSString *book_name = [bookdetail objectForKey:@"name"];
        NSString *book_author = [bookdetail objectForKey:@"author"];
        NSString *book_press = [bookdetail objectForKey:@"press"];
        
        CGSize booknameLabelSize,authorLabelSize,pressLabelSize;
        CGRect booknameLabelRect, authorLabelRect,pressLabelRect;
        CGSize maximumLabelSize = CGSizeMake(200,9999);
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            
            booknameLabelRect = [book_name boundingRectWithSize:maximumLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:font}
                                                   context:nil];
            
            
            authorLabelRect = [book_author boundingRectWithSize:maximumLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:font}
                                                   context:nil];
            
            pressLabelRect = [book_press boundingRectWithSize:maximumLabelSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:font}
                                                 context:nil];
            booknameLabelSize = booknameLabelRect.size;
            authorLabelSize = authorLabelRect.size;
            pressLabelSize = pressLabelRect.size;
            
        }
        else {
            booknameLabelSize = [book_name sizeWithFont:font
                                 constrainedToSize:maximumLabelSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
            authorLabelSize = [book_author sizeWithFont:font
                                 constrainedToSize:maximumLabelSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
            
            pressLabelSize = [book_press sizeWithFont:font
                               constrainedToSize:maximumLabelSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        
        
        switch (row) {
            case 0:
                namelabel.frame = CGRectMake(0,6,80,16);
                namelabel.text = @"書名：";
                namelabel.lineBreakMode = NSLineBreakByWordWrapping;
                namelabel.numberOfLines = 0;
                namelabel.textAlignment = NSTextAlignmentRight;
                namelabel.tag = indexPath.row;
                namelabel.backgroundColor = [UIColor clearColor];
                namelabel.font = boldfont;
                
                name.frame = CGRectMake(85,6,200,booknameLabelSize.height);
                name.text = book_name;
                name.lineBreakMode = NSLineBreakByWordWrapping;
                name.numberOfLines = 0;
                name.tag = indexPath.row;
                name.backgroundColor = [UIColor clearColor];
                name.font = font;
                
                [cell.contentView addSubview:namelabel];
                [cell.contentView addSubview:name];
                break;
            case 1:
                authorlabel.frame = CGRectMake(0,6,80,16);
                authorlabel.text = @"作者：";
                authorlabel.lineBreakMode = NSLineBreakByWordWrapping;
                authorlabel.numberOfLines = 0;
                authorlabel.textAlignment = NSTextAlignmentRight;
                authorlabel.tag = indexPath.row;
                authorlabel.backgroundColor = [UIColor clearColor];
                authorlabel.font = boldfont;
                
                author.frame = CGRectMake(85,6,200,authorLabelSize.height);
                author.text = book_author;
                author.lineBreakMode = NSLineBreakByWordWrapping;
                author.numberOfLines = 0;
                author.tag = indexPath.row;
                author.backgroundColor = [UIColor clearColor];
                author.font = font;
                
                [cell.contentView addSubview:authorlabel];
                [cell.contentView addSubview:author];
                break;
            case 2:
                presslabel.frame = CGRectMake(0,6,80,16);
                presslabel.text = @"出版項：";
                presslabel.lineBreakMode = NSLineBreakByWordWrapping;
                presslabel.numberOfLines = 0;
                presslabel.textAlignment = NSTextAlignmentRight;
                presslabel.tag = indexPath.row;
                presslabel.backgroundColor = [UIColor clearColor];
                presslabel.font = boldfont;
                
                press.frame = CGRectMake(85,6,200,pressLabelSize.height);
                press.text = book_press;
                press.lineBreakMode = NSLineBreakByWordWrapping;
                press.numberOfLines = 0;
                press.tag = indexPath.row;
                press.backgroundColor = [UIColor clearColor];
                press.font = font;
                
                [cell.contentView addSubview:presslabel];
                [cell.contentView addSubview:press];
                break;
            default:
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (section == 1)
    {
        part1label.frame = CGRectMake(0,6,100,16);
        part1label.text = @"館藏地：";
        part1label.lineBreakMode = NSLineBreakByWordWrapping;
        part1label.numberOfLines = 0;
        part1label.textAlignment = NSTextAlignmentRight;
        part1label.tag = indexPath.row;
        part1label.backgroundColor = [UIColor clearColor];
        part1label.font = boldfont;
        
        part1.frame = CGRectMake(105,6,200,16);
        part1.text = book_part1[row];
        part1.lineBreakMode = NSLineBreakByWordWrapping;
        part1.numberOfLines = 0;
        part1.tag = indexPath.row;
        part1.backgroundColor = [UIColor clearColor];
        part1.font = font;
        
        part2label.frame = CGRectMake(0,26,100,16);
        part2label.text = @"索書號/卷期：";
        part2label.lineBreakMode = NSLineBreakByWordWrapping;
        part2label.numberOfLines = 0;
        part2label.textAlignment = NSTextAlignmentRight;
        part2label.tag = indexPath.row;
        part2label.backgroundColor = [UIColor clearColor];
        part2label.font = boldfont;
        
        part2.frame = CGRectMake(105,26,200,16);
        part2.text = book_part2[row];
        part2.lineBreakMode = NSLineBreakByWordWrapping;
        part2.numberOfLines = 0;
        part2.tag = indexPath.row;
        part2.backgroundColor = [UIColor clearColor];
        part2.font = font;
        
        part3label.frame = CGRectMake(0,46,100,16);
        part3label.text = @"條碼：";
        part3label.lineBreakMode = NSLineBreakByWordWrapping;
        part3label.numberOfLines = 0;
        part3label.textAlignment = NSTextAlignmentRight;
        part3label.tag = indexPath.row;
        part3label.backgroundColor = [UIColor clearColor];
        part3label.font = boldfont;
        
        part3.frame = CGRectMake(105,46,200,16);
        part3.text = book_part3[row];
        part3.lineBreakMode = NSLineBreakByWordWrapping;
        part3.numberOfLines = 0;
        part3.tag = indexPath.row;
        part3.backgroundColor = [UIColor clearColor];
        part3.font = font;
        
        part4label.frame = CGRectMake(0,66,100,16);
        part4label.text = @"處理狀態：";
        part4label.lineBreakMode = NSLineBreakByWordWrapping;
        part4label.numberOfLines = 0;
        part4label.textAlignment = NSTextAlignmentRight;
        part4label.tag = indexPath.row;
        part4label.backgroundColor = [UIColor clearColor];
        part4label.font = boldfont;
        
        part4.frame = CGRectMake(105,66,200,16);
        part4.text = book_part4[row];
        part4.lineBreakMode = NSLineBreakByWordWrapping;
        part4.numberOfLines = 0;
        part4.tag = indexPath.row;
        part4.backgroundColor = [UIColor clearColor];
        part4.font = font;
        
        [cell.contentView addSubview:part1label];
        [cell.contentView addSubview:part1];
        
        [cell.contentView addSubview:part2label];
        [cell.contentView addSubview:part2];
        
        [cell.contentView addSubview:part3label];
        [cell.contentView addSubview:part3];
        
        [cell.contentView addSubview:part4label];
        [cell.contentView addSubview:part4];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (section == 2)
    {
        UIFont *buttonfont = [UIFont boldSystemFontOfSize:18.0];
        
        button.frame = CGRectMake(110,6,100,18);
        button.text = @"預        約";
        button.textColor = [UIColor blueColor];
        button.tag = indexPath.row;
        button.backgroundColor = [UIColor clearColor];
        button.font = buttonfont;
        
        [cell.contentView addSubview:button];
        
        cell.backgroundColor = [UIColor clearColor];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0)
    {
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
        NSString *name = [bookdetail objectForKey:@"name"];
        NSString *author = [bookdetail objectForKey:@"author"];
        NSString *press = [bookdetail objectForKey:@"press"];
        CGSize booknameLabelSize,authorLabelSize,pressLabelSize;
        CGRect booknameLabelRect, authorLabelRect,pressLabelRect;
        CGSize maximumLabelSize = CGSizeMake(200,9999);
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            
            booknameLabelRect = [name boundingRectWithSize:maximumLabelSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:font}
                                                       context:nil];
            
            
            authorLabelRect = [author boundingRectWithSize:maximumLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:font}
                                                   context:nil];
            
            pressLabelRect = [press boundingRectWithSize:maximumLabelSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:font}
                                                 context:nil];
            booknameLabelSize = booknameLabelRect.size;
            authorLabelSize = authorLabelRect.size;
            pressLabelSize = pressLabelRect.size;
            
        }
        else {
            booknameLabelSize = [name sizeWithFont:font
                                     constrainedToSize:maximumLabelSize
                                         lineBreakMode:NSLineBreakByWordWrapping];
            authorLabelSize = [author sizeWithFont:font
                                 constrainedToSize:maximumLabelSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
            
            pressLabelSize = [press sizeWithFont:font
                               constrainedToSize:maximumLabelSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
        }

        
        switch (row) {
            case 0:
                return 12 + booknameLabelSize.height;
            case 1:
                return 12 + authorLabelSize.height;
            case 2:
                return 12 + pressLabelSize.height;
            default:
                return 0;
        }
    }
    else if(section == 1)
        return 88;  //6*2 + 20*3 + 16 = 12 + 60 + 16
    else if (section == 2)
        return 30;
    else
        return 0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2){
        NSString *reserveURL = [bookdetail objectForKey:@"resurl"];
        reserveURL= [reserveURL stringByReplacingOccurrencesOfString:@"&" withString:@"(ANDCHAR)"];
        NSString *account = [SettingsModuleViewController getLibraryAccount];
        NSString *pwd = [SettingsModuleViewController getLibraryPassword];
        NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@&reserveURL=%@",account,pwd,reserveURL];
        NSHTTPURLResponse *urlResponse = nil;
        NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
        NSString * queryURL = [NSString stringWithFormat:@"http://140.121.197.135:11114/LibraryHistoryAPI/reserveBook.do"];
        [request setURL:[NSURL URLWithString:queryURL]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[historyPost dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&urlResponse
                                                                 error:nil];
        NSDictionary * responseDic = [NSDictionary new];
        responseDic= [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        if ([[responseDic objectForKey: @"querySuccess"] isEqualToString:@"true"]){
            NSString * msg = @"取書地點: "  ;
            msg = [msg stringByAppendingString:[responseDic objectForKey: @"location"]];
            msg = [msg stringByAppendingString:@"\n狀態:"];
            msg = [msg stringByAppendingString:[responseDic objectForKey: @"status"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"預約成功" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [alert release];
        }
        else {
            NSString * errorMsg = [responseDic objectForKey:@"errorMsg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"預約失敗" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
        
        
        
    }
    
}

@end