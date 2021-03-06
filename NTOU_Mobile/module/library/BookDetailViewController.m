//
//  BookDetailViewController.m
//  library-書籍詳細資料
//
//  Created by apple on 13/6/27.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "BookDetailViewController.h"
#import "TFHpple.h"
#import "RBookViewController.h"
#import "SettingsModuleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


#define NAV_X self.navigationController.navigationBar.frame.origin.x
#define NAV_Y self.navigationController.navigationBar.frame.origin.y
#define NAV_HEIGHT self.navigationController.navigationBar.frame.size.height
#define NAV_WIDTH   self.navigationController.navigationBar.frame.size.width
#define reserveTitle @"是否要預約?"
@interface BookDetailViewController ()
{
    NSString *book_part1[10];
    NSString *book_part2[10];
    NSString *book_part3[10];
    NSString *book_part4[10];
    NSString *book_part5[10];
    NSInteger book_count;
     UIProgressView *progressView;
}
@property (nonatomic,retain) NSMutableDictionary *bookdetail;
@property (nonatomic, retain) NSMutableData* receiveData;
@property (nonatomic,retain) NSArray * electricBookArray;
@property (nonatomic,retain) NSString* goToEternalLinkURL;
@property(nonatomic, retain) UIViewController *webViewController;
@property (nonatomic ,retain) UIWebView *webView ;
@property (nonatomic, retain) NSMutableArray * reviewsResult;
@property (nonatomic) NSInteger nowSelectCellIndex;

@end

@implementation BookDetailViewController
@synthesize bookurl;
@synthesize bookdetail;
@synthesize receiveData;
@synthesize electricBookArray;
@synthesize webViewController;
@synthesize webView;
@synthesize reviewsResult;
@synthesize goToEternalLinkURL;
@synthesize nowSelectCellIndex;
const char MyConstantKey;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        electricBookArray = [NSArray new];
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



-(void)viewWillAppear:(BOOL)animated{
    [progressView release];
    [webView stopLoading];
}

-(void) fetchBookDetail{
    bookurl = [bookurl stringByReplacingOccurrencesOfString:@"&" withString:@"(ANDCHAR)"];
    bookurl = [bookurl stringByReplacingOccurrencesOfString:@"+" withString:@"(PLUSCHAR)"];
    bookurl = [bookurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *parameter= [[NSString alloc]initWithFormat:@"URL=%@",bookurl];
    NSHTTPURLResponse *urlResponse = nil;
    NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
    NSString * queryURL = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/Search.do"];
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
    NSArray * electricBookDetail = [bookResultDic objectForKey:@"electricBookDetail"];
    if ([realBookDetail count]>0){
        [bookdetail setObject:@"realBook" forKey:@"bookType"];
        
        
        if (![[bookResultDic objectForKey:@"reserveURL"] isEqualToString:@""]) {
            NSString * str = [NSString stringWithString:[bookResultDic objectForKey:@"reserveURL"]];
            str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"(ANDCHAR)"];
            str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"(PLUSCHAR)"];
            NSString *parameter2= [[NSString alloc]initWithFormat:@"account=App001&password=App001&reserveURL=%@",str];
            NSHTTPURLResponse *urlResponse2 = nil;
            NSMutableURLRequest * request2 = [[NSMutableURLRequest new]autorelease];
            NSString * queryURL2 = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/canReserveBooksList.do"];
            [request2 setURL:[NSURL URLWithString:queryURL2]];
            [request2 setHTTPMethod:@"POST"];
            [request2 setHTTPBody:[parameter2 dataUsingEncoding:NSUTF8StringEncoding]];
            // NSLog(@"%@",  [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
            // NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
            NSData *responseData2 = [NSURLConnection sendSynchronousRequest:request2
                                                          returningResponse:&urlResponse2
                                                                      error:nil];
            NSString *res = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
            NSArray * bookDetailDic2=  [NSJSONSerialization JSONObjectWithData:responseData2 options:0 error:nil];
            [bookDetailDic2 retain];
            NSLog(@"%@,%@",[bookResultDic objectForKey:@"reserveURL"],bookDetailDic2);

            for (size_t realBook_it =0 ; realBook_it < [bookDetailDic2 count] ; ++realBook_it){
                NSDictionary * realBookDetailDic = [bookDetailDic2 objectAtIndex:realBook_it];
                book_part1[realBook_it] = [realBookDetailDic objectForKey:@"bookLocation"];
                book_part2[realBook_it] = [realBookDetailDic objectForKey:@"bookCall"];
                book_part3[realBook_it] = [realBookDetailDic objectForKey:@"bookCode"];
                book_part4[realBook_it] = [realBookDetailDic objectForKey:@"bookResStatus"];
                book_part5[realBook_it] = [realBookDetailDic objectForKey:@"radioVal"];
            }
            
        } else {
            
            for (size_t realBook_it =0 ; realBook_it < [realBookDetail count] ; ++realBook_it){
                NSDictionary * realBookDetailDic = [realBookDetail objectAtIndex:realBook_it];
                book_part1[realBook_it] = [realBookDetailDic objectForKey:@"location"];
                book_part2[realBook_it] = [realBookDetailDic objectForKey:@"number"];
                book_part3[realBook_it] = [realBookDetailDic objectForKey:@"barcode"];
                book_part4[realBook_it] = [realBookDetailDic objectForKey:@"status"];
            }
        }
        
        
        book_count = [realBookDetail count];
    }
    
    if ([electricBookDetail count]>0){
        [bookdetail setObject:@"ebook" forKey:@"bookType"];
        for (size_t eBook_it =0 ; eBook_it < [electricBookDetail count] ; ++eBook_it){
            NSDictionary * electricBookDetailDic = [electricBookDetail objectAtIndex:eBook_it];
            book_part1[eBook_it] = [electricBookDetailDic objectForKey:@"subtitle"];
            book_part2[eBook_it] = [electricBookDetailDic objectForKey:@"url"];
        }
        book_count = [electricBookDetail count];
    }
    
    [bookdetail setObject:[bookResultDic objectForKey:@"title"] forKey:@"name"];
    [bookdetail setObject:[bookResultDic objectForKey:@"author"] forKey:@"author"];
    [bookdetail setObject:[bookResultDic objectForKey:@"pubInform"] forKey:@"press"];
    [bookdetail setObject:[bookResultDic objectForKey:@"reserveURL"] forKey:@"resurl"];
    [bookdetail setObject:[bookResultDic objectForKey:@"ISBN"] forKey:@"ISBN"];
    


}

-(void)checkReviewsResult{
    NSMutableArray * reviews_t = [[NSMutableArray alloc]init];
    for (NSDictionary * review in reviewsResult){
        if (![[review objectForKey:@"reviewsURL"]  isEqual: @""] )
            [reviews_t addObject:review];
    }
    reviewsResult = [NSMutableArray arrayWithArray:reviews_t];
    [reviewsResult retain];
}

-(void)fetchBookReview{
    NSString * ISBN = [bookdetail objectForKey:@"ISBN"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
    NSString * queryURL = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/Reviews.do?ISBN=%@",ISBN];
    [request setURL:[NSURL URLWithString:queryURL]];
    [request setHTTPMethod:@"GET"];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:nil];
    
    NSDictionary * bookReviewDic=  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    reviewsResult = [[NSMutableArray alloc]initWithArray:[bookReviewDic objectForKey:@"reivewsResult"]];
    [self checkReviewsResult];
}


-(void) fetchBookDetailAndReview{
    
    [self fetchBookDetail];
    [self fetchBookReview];

}

- (void)viewDidLoad
{
    self.title = @"詳細資訊";
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
    NSInteger numberOfSections;
    
    if ([[bookdetail objectForKey:@"bookType"]  isEqual: @"ebook"]){
       numberOfSections =  2;
   }
    
   else if ([[bookdetail objectForKey:@"bookType"]  isEqual: @"realBook"]){
        if(book_count == 0 && [bookdetail objectForKey:@"resurl"] == NULL)
            numberOfSections= 1;   //只有書籍資料
        else if( [[bookdetail objectForKey:@"resurl"] isEqualToString:@""])
            numberOfSections= 2;   //書籍資料＋借閱資訊
        else
            numberOfSections= 2;   //可預約
    }
    
    if ([reviewsResult count]!=0)
        return ++numberOfSections;
    else
        return numberOfSections;
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([[bookdetail objectForKey:@"bookType"]  isEqual: @"ebook"]){
        switch (section) {
            case 0:
                return [NSString stringWithFormat:@"書籍資訊"];
                break;
            case 1:
                return [NSString stringWithFormat:@"外部連結"];
                break;
            case 2:
                return [NSString stringWithFormat:@"書評"];
                break;
             }
    }
    
    
    if ([[bookdetail objectForKey:@"bookType"]  isEqual: @"realBook"]){
         switch (section) {
             case 0:
                 return [NSString stringWithFormat:@"書籍資訊"];
                 break;
             case 1:
                 return [NSString stringWithFormat:@"預約（暫時關閉預約功能）"];
                 break;
             case 2:
                 return [NSString stringWithFormat:@"書評"];
                 break;
             default:
                 return [NSString stringWithFormat:@" "];
                 break;
         }
     }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
     if ([[bookdetail objectForKey:@"bookType"]  isEqual: @"ebook"]){
         if(section == 0)
             return 3;
         else if (section == 1)
             return book_count; 
         else if (section == 2)
             return [reviewsResult count];
         else return 0;

        }
     if ([[bookdetail objectForKey:@"bookType"]  isEqual: @"realBook"]){
         if(section == 0)
             return 4;
         else if (section == 1)
             return book_count;
         else if (section == 2)
             return [reviewsResult count];
         else if (section == 3)
             return 1;   //按鈕
         else
             return 0;
     }
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
        NSString *ISBN = [bookdetail objectForKey:@"ISBN"];
        
        CGSize booknameLabelSize,authorLabelSize,pressLabelSize,ISBNLabelSize;
        CGRect booknameLabelRect, authorLabelRect,pressLabelRect,ISBNLabelRect;
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
            ISBNLabelRect = [ISBN boundingRectWithSize:maximumLabelSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:font}
                                                     context:nil];
            
            ISBNLabelSize = ISBNLabelRect.size;
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
            
            ISBNLabelSize =[ISBN sizeWithFont:font
                                  constrainedToSize:maximumLabelSize
                                      lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        
        
        switch (row) {
            case 0:
                namelabel.frame = CGRectMake(0,10,80,16);
                namelabel.text = @"書名：";
                namelabel.lineBreakMode = NSLineBreakByWordWrapping;
                namelabel.numberOfLines = 0;
                namelabel.textAlignment = NSTextAlignmentRight;
                namelabel.tag = indexPath.row;
                namelabel.backgroundColor = [UIColor clearColor];
                namelabel.font = boldfont;
                
                name.frame = CGRectMake(85,10,200,booknameLabelSize.height);
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
                authorlabel.frame = CGRectMake(0,10,80,16);
                authorlabel.text = @"作者：";
                authorlabel.lineBreakMode = NSLineBreakByWordWrapping;
                authorlabel.numberOfLines = 0;
                authorlabel.textAlignment = NSTextAlignmentRight;
                authorlabel.tag = indexPath.row;
                authorlabel.backgroundColor = [UIColor clearColor];
                authorlabel.font = boldfont;
                
                author.frame = CGRectMake(85,10,200,authorLabelSize.height);
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
                presslabel.frame = CGRectMake(0,10,80,16);
                presslabel.text = @"出版項：";
                presslabel.lineBreakMode = NSLineBreakByWordWrapping;
                presslabel.numberOfLines = 0;
                presslabel.textAlignment = NSTextAlignmentRight;
                presslabel.tag = indexPath.row;
                presslabel.backgroundColor = [UIColor clearColor];
                presslabel.font = boldfont;
                
                press.frame = CGRectMake(85,10,200,pressLabelSize.height);
                press.text = book_press;
                press.lineBreakMode = NSLineBreakByWordWrapping;
                press.numberOfLines = 0;
                press.tag = indexPath.row;
                press.backgroundColor = [UIColor clearColor];
                press.font = font;
                
                [cell.contentView addSubview:presslabel];
                [cell.contentView addSubview:press];
                break;
            case 3:
                presslabel.frame = CGRectMake(0,10,80,16);
                presslabel.text = @"ISBN：";
                presslabel.lineBreakMode = NSLineBreakByWordWrapping;
                presslabel.numberOfLines = 0;
                presslabel.textAlignment = NSTextAlignmentRight;
                presslabel.tag = indexPath.row;
                presslabel.backgroundColor = [UIColor clearColor];
                presslabel.font = boldfont;
                
                press.frame = CGRectMake(85,10,200,ISBNLabelSize.height);
                press.text = ISBN;
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
    else if (section == 1 && [[bookdetail objectForKey:@"bookType"]  isEqual: @"realBook"])
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
        /*
        if (![book_part5[row] isEqualToString:@"NULL"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }*/
        
        if([book_part4[row] rangeOfString:@"在架上"].location == NSNotFound ){
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            
    }
    
    else if (section == 1 && [[bookdetail objectForKey:@"bookType"]  isEqual: @"ebook"])
    {
      
        UILabel *externalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10,250,25)];
        externalLabel.font = font;
        externalLabel.backgroundColor = [UIColor clearColor];
        [externalLabel setText:@"  KOOBE"];
    /*
        ISBNLabel.lineBreakMode = NSLineBreakByWordWrapping;
        ISBNLabel.numberOfLines = 0;
     */
        [cell.contentView addSubview:externalLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    else if (section == 2){
        
        UILabel *bookReivews = [[UILabel alloc]initWithFrame:CGRectMake(10,10,60,25)];
        bookReivews.font = font;
        bookReivews.backgroundColor = [UIColor clearColor];
        if ([[reviewsResult[row] objectForKey:@"bookstoreName" ] isEqual:@"Books"])
            [bookReivews setText:@"博客來"];
        else if ([[reviewsResult[row] objectForKey:@"bookstoreName" ] isEqual:@"KingStone"])
            [bookReivews setText:@"金石堂"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:bookReivews];
        
    }
    
    else if (section == 3)
    {
        UIFont *buttonfont = [UIFont boldSystemFontOfSize:18.0];
        
        button.frame = CGRectMake(110,11,100,18);
        button.text = @"預        約";
        button.textColor = [UIColor blueColor];
        button.tag = indexPath.row;
        button.backgroundColor = [UIColor whiteColor];
        button.font = buttonfont;
        
        [cell.contentView addSubview:button];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGSize booknameLabelSize, authorLabelSize, pressLabelSize, ISBNLabelSize;
    CGRect booknameLabelRect, authorLabelRect, pressLabelRect, ISBNLabelRect;
    CGSize maximumLabelSize = CGSizeMake(200,9999);
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    
    if(section == 0)
    {
       
        NSString *name = [bookdetail objectForKey:@"name"];
        NSString *author = [bookdetail objectForKey:@"author"];
        NSString *press = [bookdetail objectForKey:@"press"];
        NSString * ISBN = [bookdetail objectForKey:@"ISBN"];
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
            ISBNLabelRect = [ISBN boundingRectWithSize:maximumLabelSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
            
            ISBNLabelSize = ISBNLabelRect.size;
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
            
            ISBNLabelSize =[ISBN sizeWithFont:font
                            constrainedToSize:maximumLabelSize
                                lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        
        switch (row) {
            case 0:
                return 20 + booknameLabelSize.height;
            case 1:
                return 20 + authorLabelSize.height;
            case 2:
                return 20 + pressLabelSize.height;
            case 3:
                return 20 + ISBNLabelSize.height;
            default:
                return 0;
        }
    }
    else if(section == 1 && [[bookdetail objectForKey:@"bookType"]  isEqual: @"realBook"])
        return 88;  //6*2 + 20*3 + 16 = 12 + 60 + 16
    
    
    else if (section == 1 && [[bookdetail objectForKey:@"bookType"]  isEqual: @"ebook"]){
      /*   NSString *link = book_part1[indexPath.row];
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            linkLabelRect = [link boundingRectWithSize:maximumLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:font}
                                                   context:nil];
         
            linkLabelSize = linkLabelRect.size;
        }
        else {
           linkLabelSize = [link sizeWithFont:font
                                 constrainedToSize:maximumLabelSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
                 }
        
        
        return linkLabelSize.height+12;*/ //網址很醜
        return 45;
            }
    
    else if (section == 2 || section == 3)
        return 45;
        else
        return 0;
}


-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - progressView.progress options:0 animations:^{
            progressView.alpha = 0.0;
        } completion:nil];
    }
    
    [progressView setProgress:progress animated:NO];
}


#pragma mark - Table view delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqualToString:reserveTitle]) {
        switch (buttonIndex) {
            case 1:{
                NSString *reserveURL = [bookdetail objectForKey:@"resurl"];
                reserveURL= [reserveURL stringByReplacingOccurrencesOfString:@"&" withString:@"(ANDCHAR)"];
                NSString *account = [SettingsModuleViewController getLibraryAccount];
                NSString *pwd = [SettingsModuleViewController getLibraryPassword];
                NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@&reserveURL=%@&radioValue=%@",
                                         account, pwd, reserveURL, book_part5[nowSelectCellIndex]];
                NSHTTPURLResponse *urlResponse = nil;
                NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
                NSString * queryURL = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/reserveBook.do"];
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
                    if (errorMsg ==nil) errorMsg = @"尚未登入";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"預約失敗" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    if ([responseDic objectForKey:@"errorMsg"] == nil) {
                        accountTableViewController *detailViewController = [[accountTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                        detailViewController.title = library;
                        detailViewController.explanation = @"帳號:     請輸入學號,敎職員證號或本館借書證號\n密碼:     您的身份證字號(預設值)\n\n若無法使用，請將您的《姓名》、《讀者證號》、《身份證號》E-mail 至hwa重新設定！\n        若您的證件曾經補發過一次，請在讀者證號後加二位數字01；補發二次，請加02；其餘類推。";
                        detailViewController.accountStoreKey = libraryAccountKey;
                        detailViewController.passwordStoreKey = libraryPasswordKey;
                        detailViewController.loginSuccessStoreKey = libraryLoginSuccessKey;
                        //SettingsModuleViewController * settingDelegate = [[SettingsModuleViewController init] alloc];
                        //detailViewController.delegate = settingDelegate;
                        [self.navigationController pushViewController:detailViewController animated:YES];
                        [detailViewController release];
                    }
                }

            }
                break;
            default:
                break;
        }
    }
    else
        switch (buttonIndex) {
            case 1:{
                
                progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
                if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0){
                    progressView.frame = CGRectMake(NAV_X,
                                                    NAV_Y+NAV_HEIGHT,
                                                    NAV_WIDTH ,
                                                    20);
                }else{
                    progressView.frame = CGRectMake(NAV_X,
                                                    -3,
                                                    NAV_WIDTH ,
                                                    20);
                    
                }
                webViewController = [[[UIViewController alloc]init] autorelease];
                webView = [[[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
                if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)
                {
                    CGRect webFrame = webView.frame;
                    webFrame.size.height -= 64;
                    webView.frame = webFrame;
                }
                webView.scalesPageToFit = YES;
                NJKWebViewProgress *_progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
                webView.delegate = _progressProxy;
                _progressProxy.webViewProxyDelegate = self;
                _progressProxy.progressDelegate = self;
                
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:goToEternalLinkURL]]];
                [webViewController.view addSubview: webView];
                [webView addSubview:progressView];
                [self.navigationController pushViewController:webViewController animated:YES];
                
                break;
            }
            case 0:
                break;
            default:
                break;
        }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *nowCell = [tableView cellForRowAtIndexPath:indexPath];
    /*
    if([nowCell accessoryType] == UITableViewCellAccessoryDisclosureIndicator)
    {
        
         if (indexPath.section ==1 && [[bookdetail objectForKey:@"bookType"]  isEqual: @"realBook"] &&book_part5[indexPath.row]!=nil&& ![book_part5[indexPath.row] isEqualToString:@"NULL"]){
        
            nowSelectCellIndex = indexPath.row;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reserveTitle message:book_part2[indexPath.row] delegate:self cancelButtonTitle:@"否"     otherButtonTitles:@"是", nil];
            [alert show];
            [alert release];
            
        }
    }
    */ //預約功能 2017/1/15關閉
    
    if (indexPath.section ==1 && [[bookdetail objectForKey:@"bookType"]  isEqual: @"ebook"]){
            goToEternalLinkURL = book_part2[indexPath.row];
            [goToEternalLinkURL retain];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"將會連到校外網站，確定前往" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
            [alert show];
            [alert release];
    }
    
    if (indexPath.section ==2 && reviewsResult!=nil){
        goToEternalLinkURL = [reviewsResult[indexPath.row] objectForKey:@"reviewsURL"];
        [goToEternalLinkURL retain];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"將會連到校外網站，確定前往" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
        [alert show];
        [alert release];
    }
    
    
}

@end
