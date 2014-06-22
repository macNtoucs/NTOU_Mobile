//
//  NewsDetailViewController.m
//  NTOU_Mobile
//
//  Created by IMAC on 2014/5/7.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "NewsDetailViewController.h"
#define pictureHeight 75
#define pictureWeight 75
#define personAndContentSpacing 20
#define Spacing 10
#define infoFontSize 14
@interface NewsDetailViewController ()

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

-(IBAction)open_URL:(UITapGestureRecognizer*)sender
{
    UILabel* urlLabel = (UILabel*) sender.view;
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[[[[[[story objectForKey:NewsAPIKeyAttachment_URL] objectForKey: NewsAPIKeyText] stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] componentsSeparatedByString:@","] objectAtIndex:urlLabel.tag]]];
    UIViewController *webViewController = [[[UIViewController alloc]init] autorelease];
    webViewController.title = urlLabel.text;
    UIWebView *webView = [[[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webViewController.view addSubview: webView];
    
    [self.navigationController pushViewController:webViewController animated:YES];
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
    self.navigationItem.title = @"公告";
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-person.jpg"]] ;
    imageView.frame = CGRectMake(Spacing, Spacing, pictureWeight, pictureHeight);
    
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
    
    NSMutableArray * attachment_Title = [[[[[[story objectForKey:NewsAPIKeyAttachment_Title] objectForKey: NewsAPIKeyText] stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] componentsSeparatedByString:@","] mutableCopy];
    int attachment_TitleHeight = 0;
    maximumLabelSize = CGSizeMake(280, FLT_MAX);
    
    for (int i = 0; i < [attachment_Title count]; i++) {
        if ([attachment_Title[i] isEqualToString:@""]) {
            [attachment_Title removeObjectAtIndex:i];
            i--;
            continue;
        }
        UILabel *attachment = [[UILabel alloc] initWithFrame:CGRectMake(Spacing, pictureHeight +10 +attachment_TitleHeight, 280, 25)];
        attachment.text = attachment_Title[i];
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
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(Spacing, pictureHeight + personAndContentSpacing + attachment_TitleHeight, 280, 500)];
    content.text = [[[[story objectForKey:NewsAPIKeyBody] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    content.font = [UIFont fontWithName:@"Helvetica" size:15];
    content.lineBreakMode = NSLineBreakByCharWrapping;
    content.numberOfLines = 0;
    content.backgroundColor = [UIColor clearColor];
    
    expectedLabelSize = [content.text sizeWithFont:content.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByCharWrapping];
    newFrame = content.frame;
    newFrame.size.height = expectedLabelSize.height;
    content.frame = newFrame;
    
    newFrame = infoBackground.frame;
    newFrame.size.height = expectedLabelSize.height + pictureHeight + 2 * personAndContentSpacing + attachment_TitleHeight;
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
