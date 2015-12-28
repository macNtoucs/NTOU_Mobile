//
//  NewsDetailViewController.m
//  NTOU_Mobile
//
//  Created by IMAC on 2014/5/7.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "NewsDetailViewController.h"
#define pictureHeight 50
#define pictureWeight 50
#define personAndContentSpacing 20
#define Spacing 10
#define infoFontSize 14
@interface NewsDetailViewController ()
{
    UIProgressView *progressView;
}
@end

@implementation NewsDetailViewController
@synthesize story;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)callTel:(UITapGestureRecognizer*)sender
{
    UILabel* tel = (UILabel*) sender.view;
    UIAlertView * telAlertView = [[UIAlertView alloc] initWithTitle:@"電話" message:tel.text delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"撥打", nil];
    telAlertView.delegate = self;
    [telAlertView show];
    [telAlertView release];
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

#define NAV_X self.navigationController.navigationBar.frame.origin.x
#define NAV_Y self.navigationController.navigationBar.frame.origin.y
#define NAV_HEIGHT self.navigationController.navigationBar.frame.size.height
#define NAV_WIDTH   self.navigationController.navigationBar.frame.size.width

-(IBAction)open_URL:(UITapGestureRecognizer*)sender
{
    
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
    UILabel* urlLabel = (UILabel*) sender.view;
    /*
     NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[[[[[[story objectForKey:NewsAPIKeyAttachment_URL] objectForKey: NewsAPIKeyText] stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] componentsSeparatedByString:@","] objectAtIndex:urlLabel.tag]]];
     */
    
    
    
    NSMutableArray * attachment_URL;
    NSMutableArray *attachment_Temp=[story objectForKey:NewsAPIKeyAttachment_URL];
    attachment_URL =[[NSMutableArray alloc]init];
    if([attachment_Temp count]>1){
        for(int i=0;i<[attachment_Temp count];++i)
            [attachment_URL addObject:[attachment_Temp[i] objectForKey:NewsAPIKeyText]];
    }
    else if([attachment_Temp count]==1)
        [attachment_URL addObject:[attachment_Temp objectForKey:NewsAPIKeyText]];
    NSString *urlString=[[[NSString stringWithFormat:@"%@",attachment_URL[urlLabel.tag]]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    
    
    UIViewController* webViewController = [[[UIViewController alloc]init] autorelease];
    webViewController.title = @"附件";
    UIWebView* webView = [[[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
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
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webViewController.view addSubview: webView];
    [webView addSubview:progressView];
    [self.navigationController pushViewController:webViewController animated:YES];
    
    /*
     UILabel* urlLabel = (UILabel*) sender.view;
     NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[[[[[[story objectForKey:NewsAPIKeyAttachment_URL] objectForKey: NewsAPIKeyText] stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] componentsSeparatedByString:@","] objectAtIndex:urlLabel.tag]]];
     UIViewController *webViewController = [[[UIViewController alloc]init] autorelease];
     webViewController.title = urlLabel.text;
     UIWebView *webView = [[[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
     webView.scalesPageToFit = YES;
     [webView loadRequest:[NSURLRequest requestWithURL:url]];
     [webViewController.view addSubview: webView];
     
     [self.navigationController pushViewController:webViewController animated:YES];*/
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",alertView.message]]];
            break;
        default:
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"公告細節";
    /*
     UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(Spacing,20,300,50)];
     NSString *urlString=[[[[[story objectForKey:NewsAPIKeyLink]objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""]stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
     urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSURL *url=[NSURL URLWithString:urlString];
     NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
     [webView loadRequest:requestUrl];
     webView.scalesPageToFit=YES;
     self.view=webView;
     */
    self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    UIScrollView * background = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]<7.0)
    {
        CGRect newFrame = background.frame;
        newFrame.size.height -= 64;
        background.frame = newFrame;
    }
    background.bounces = NO;
    
    //大標題
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(Spacing, 20, 300, 50)];
    title.text = [[[[story objectForKey:NewsAPIKeyTitle]objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    title.lineBreakMode = NSLineBreakByCharWrapping;
    title.numberOfLines = 0;
    
    title.backgroundColor = [UIColor clearColor];
    CGSize maximumLabelSize = CGSizeMake(300, FLT_MAX);
    CGSize expectedLabelSize = [title.text sizeWithFont:title.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByCharWrapping];
    
    //adjust the label the the new height.
    CGRect newFrame = title.frame;
    newFrame.size.height = expectedLabelSize.height;
    title.frame = newFrame;
    
    //白色背景
    
    UIView *infoBackground = [[UIView alloc] initWithFrame:CGRectMake(Spacing, 40 + expectedLabelSize.height, 300, 500)];
    infoBackground.backgroundColor = [UIColor whiteColor];
    
    //圖
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]] ;
    imageView.frame = CGRectMake(2*Spacing, 2*Spacing, pictureWeight, pictureHeight);
    
    //名字
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 190, 15)];
    NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"%@    %@",[[[[story objectForKey:NewsAPIKeyDpname] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""],[[[[story objectForKey:NewsAPIKeyPromoter] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
    name.backgroundColor = [UIColor clearColor];
    name.text = string;
    name.font = [UIFont fontWithName:@"Helvetica" size:infoFontSize];
    name.lineBreakMode = NSLineBreakByCharWrapping;
    name.numberOfLines = 0;
    
    //電話
    
    UILabel *telephone = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 190, 15)];
    string = [[[[[story objectForKey:NewsAPIKeyTel] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] mutableCopy];
    if (string) {
        if ([string rangeOfString:@"24622192"].location == NSNotFound) {
            [string insertString:@"24622192," atIndex:0];
        }
        [string insertString:@"02" atIndex:0];
        [string stringByReplacingOccurrencesOfString:@"-" withString:@","];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTel:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [telephone addGestureRecognizer:tapGestureRecognizer];
    telephone.userInteractionEnabled = YES;
    [tapGestureRecognizer release];
    telephone.backgroundColor = [UIColor clearColor];
    telephone.textColor = [UIColor blueColor];
    telephone.text = string;
    telephone.font = [UIFont fontWithName:@"Helvetica" size:infoFontSize];
    telephone.lineBreakMode = NSLineBreakByCharWrapping;
    telephone.numberOfLines = 0;
    
    //時間
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 190, 15)];
    date.text = [[[[story objectForKey:NewsAPIKeyStartdate] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    date.font = [UIFont fontWithName:@"Helvetica" size:infoFontSize];
    date.lineBreakMode = NSLineBreakByCharWrapping;
    date.numberOfLines = 0;
    date.backgroundColor = [UIColor clearColor];
    
    //附件
    NSMutableArray * attachment_Title;
    NSMutableArray *attachment_Temp=[story objectForKey:NewsAPIKeyAttachment_Title];
    attachment_Title =[[NSMutableArray alloc]init];
    if([attachment_Temp count]>1){
        for(int i=0;i<[attachment_Temp count];++i)
            [attachment_Title addObject:[[[attachment_Temp[i] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
    }
    else if([attachment_Temp count]==1)
        [attachment_Title addObject:[[[attachment_Temp objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
    //    [attachment_Title addObject:@""];
    int attachment_TitleHeight = 0;
    maximumLabelSize = CGSizeMake(280, FLT_MAX);
    
    for (int i = 0; i < [attachment_Title count]; i++) {
        if ([attachment_Title[i] isEqualToString:@""]) {
            [attachment_Title removeObjectAtIndex:i];
            i--;
            continue;
        }
        UILabel *attachment = [[UILabel alloc] initWithFrame:CGRectMake(Spacing, 2*Spacing+pictureHeight +10 +attachment_TitleHeight, 280, 25)];
        attachment.text =  attachment_Title[i];
        attachment.font = [UIFont fontWithName:@"Helvetica" size:14];
        attachment.textColor = [UIColor blueColor];
        attachment.lineBreakMode = NSLineBreakByCharWrapping;
        attachment.numberOfLines = 0;
        attachment.backgroundColor = [UIColor clearColor];
        attachment.tag = i;
        attachment.userInteractionEnabled = YES;
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(open_URL:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [attachment addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        expectedLabelSize = [attachment.text sizeWithFont:attachment.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByCharWrapping];
        if (expectedLabelSize.height > 25) {
            newFrame = attachment.frame;
            newFrame.size.height = expectedLabelSize.height;
            attachment.frame = newFrame;
            attachment_TitleHeight += newFrame.size.height+10;
        }
        else
            attachment_TitleHeight += 25;
        [infoBackground addSubview:attachment];
    }
    
    
    
    
    
    
    //新聞內容
    /*
     NSString *news = [NSString stringWithFormat:@"資料來源<br>臺北市公車-臺北市政府交通局<br>新北市公車-我愛巴士5284行動查詢系統<br>基隆市公車-基隆市公車資訊便民服務系統<br>客運-我愛巴士5284行動查詢系統<br>火車-臺灣鐵路管理局<br>高鐵-台灣高鐵<br><br><br>公告<br>%@",responseData?[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]:@""];
     NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[news dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
     UITextView *newsDisplay = [[UITextView alloc]initWithFrame:CGRectMake(40,380,240,100)];
     [newsDisplay setFont:[UIFont systemFontOfSize:10]];
     newsDisplay.attributedText=attrStr;
     
     
     UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(Spacing, 2*Spacing + pictureHeight + personAndContentSpacing + attachment_TitleHeight, 280, 500)];
     content.text = [[[[story objectForKey:NewsAPIKeyBody] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
     content.font = [UIFont fontWithName:@"Helvetica" size:15];
     content.lineBreakMode = NSLineBreakByCharWrapping;
     content.numberOfLines = 0;
     content.backgroundColor = [UIColor clearColor];
     */
    
    
    NSString *news = [[[[[story objectForKey:NewsAPIKeyBody] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""]stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[news dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *temp=[[[[[story objectForKey:NewsAPIKeyBody] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n\r" withString:@"</br>"]stringByReplacingOccurrencesOfString:@"\t" withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
    UIWebView *content = [[UIWebView alloc] initWithFrame:CGRectMake(Spacing, 2*Spacing + pictureHeight + personAndContentSpacing + attachment_TitleHeight, 280, infoBackground.frame.size.height-2*Spacing-pictureHeight-personAndContentSpacing-attachment_TitleHeight)];
    [content loadHTMLString:temp baseURL:nil];
    
    
    newFrame = infoBackground.frame;
    newFrame.size.height = 2*Spacing + content.frame.size.height+ pictureHeight + 2 * personAndContentSpacing + attachment_TitleHeight;
    infoBackground.frame = newFrame;
    
    background.contentSize= CGSizeMake(320,infoBackground.frame.origin.y + infoBackground.frame.size.height + Spacing);
    
    [self.view addSubview:background];
    [background addSubview:title];
    [background addSubview:infoBackground];
    [infoBackground addSubview:imageView];
    [infoBackground addSubview:name];
    [infoBackground addSubview:date];
    [infoBackground addSubview:telephone];
    [infoBackground addSubview:content];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
