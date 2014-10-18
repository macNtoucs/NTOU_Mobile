//
//  AccountViewController.m
//  library
//
//  Created by apple on 13/8/22.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "AccountViewController.h"
#import "TFHpple.h"
#import "MBProgressHUD.h"

@interface AccountViewController ()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UILabel *LoginAccount;
@property (strong, nonatomic) UIButton *Loginbutton;
@end

@implementation AccountViewController
@synthesize tapRecognizer;
@synthesize LoginAccount;
@synthesize Loginbutton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSInteger swidth = [[UIScreen mainScreen] bounds].size.width;
    
    LoginAccount = [[UILabel alloc] init];
    Loginbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     
    NSString *notice1 = [NSString stringWithFormat:@"* 重複登入不論成功失敗，皆會刪除之前的記錄"];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:18.0];
    CGSize Notice1LabelSize = [notice1 sizeWithFont:font
                                constrainedToSize:CGSizeMake(280,9999)
                                    lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *notice1Label = [[UILabel alloc] init];
    notice1Label.text = notice1;
    notice1Label.frame = CGRectMake((swidth - Notice1LabelSize.width)/2,220,Notice1LabelSize.width,Notice1LabelSize.height);
    notice1Label.backgroundColor = [UIColor clearColor];
    notice1Label.font = font;
    notice1Label.lineBreakMode = NSLineBreakByWordWrapping;
    notice1Label.numberOfLines = 0;
    
    NSString *notice2 = [NSString stringWithFormat:@"* 登入使用以下網址適用的帳號："];
    CGSize Notice2LabelSize = [notice2 sizeWithFont:font
                                  constrainedToSize:CGSizeMake(280,9999)
                                      lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *notice2Label = [[UILabel alloc] init];
    notice2Label.text = notice2;
    notice2Label.frame = CGRectMake((swidth - Notice2LabelSize.width)/2,270,Notice2LabelSize.width,Notice2LabelSize.height);
    notice2Label.backgroundColor = [UIColor clearColor];
    notice2Label.font = font;
    notice2Label.lineBreakMode = NSLineBreakByWordWrapping;
    notice2Label.numberOfLines = 0;
    
    NSString *notice3 = [NSString stringWithFormat:@"http://ocean.ntou.edu.tw:1083/patroninfo*cht"];
    CGSize Notice3LabelSize = [notice3 sizeWithFont:font
                                  constrainedToSize:CGSizeMake(280,9999)
                                      lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *notice3Label = [[UILabel alloc] init];
    notice3Label.text = notice3;
    notice3Label.frame = CGRectMake((swidth - Notice3LabelSize.width)/2,290,Notice3LabelSize.width,Notice3LabelSize.height);
    notice3Label.backgroundColor = [UIColor clearColor];
    notice3Label.font = font;
    notice3Label.lineBreakMode = NSLineBreakByWordWrapping;
    notice3Label.numberOfLines = 0;

    
    /*
    NSString *notice2 = [NSString stringWithFormat:@"* 若輸入錯誤，會刪除原先的登陸資訊"];
    CGSize Notice2LabelSize = [notice2 sizeWithFont:font
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *notice2Label = [[UILabel alloc] init];
    notice2Label.text = notice2;
    notice2Label.frame = CGRectMake((swidth - Notice2LabelSize.width)/2,245,Notice2LabelSize.width,20);
    notice2Label.backgroundColor = [UIColor clearColor];
    notice2Label.font = font;
    */
    self.view.backgroundColor = [[UIColor alloc]initWithRed:232.0/255.0 green:225.0/255.0 blue:208.0/255.0 alpha:0.5];

    [self.view addSubview:notice1Label];
    [self.view addSubview:notice2Label];
    [self.view addSubview:notice3Label];

    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)];
    tapRecognizer.delegate  = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [accounttextField removeFromSuperview];
    [passWordtextField removeFromSuperview];
    [LoginAccount removeFromSuperview];
    [Loginbutton removeFromSuperview];
    
    Loginbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    NSInteger swidth = [[UIScreen mainScreen] bounds].size.width;
    
    UIFont *boldfont = [UIFont boldSystemFontOfSize:18.0];
    CGSize maximumLabelSize = CGSizeMake(320,9999);
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountKey"];
    NSString *pwd =[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordKey"];
    
    LoginAccount = [[UILabel alloc] init];
    NSString *loginText = NULL;
    if(account == NULL || pwd==NULL)
    {
        loginText = [NSString stringWithFormat:@"目前沒有登錄的帳戶"];
    }
    else
    {
        loginText = [NSString stringWithFormat:@"- %@ 登入中 -",account];
    }
    CGSize AccountLabelSize = [loginText sizeWithFont:boldfont
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
    LoginAccount = [[UILabel alloc] init];
    LoginAccount.text = loginText;
    LoginAccount.frame = CGRectMake((swidth - AccountLabelSize.width)/2,20,AccountLabelSize.width,20);
    LoginAccount.backgroundColor = [UIColor clearColor];
    LoginAccount.font = boldfont;
    LoginAccount.textColor = [UIColor brownColor];

    if(account == NULL)
    {
        accounttextField = [[UITextField alloc] initWithFrame:CGRectMake(swidth/2 - 125,50, 250, 30)];
        accounttextField.borderStyle = UITextBorderStyleRoundedRect;
        accounttextField.font = [UIFont systemFontOfSize:15];
        accounttextField.delegate = self;
        accounttextField.placeholder = @"學號、敎職員證號 或 本館借書證號";
        accounttextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        passWordtextField = [[UITextField alloc] initWithFrame:CGRectMake(swidth/2 - 125,90, 250, 30)];
        passWordtextField.borderStyle = UITextBorderStyleRoundedRect;
        passWordtextField.font = [UIFont systemFontOfSize:15];
        passWordtextField.delegate = self;
        passWordtextField.secureTextEntry = YES;
        passWordtextField.placeholder = @"密碼 (預設為 身分證字號)";
        passWordtextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [Loginbutton addTarget:self
                        action:@selector(Login)
              forControlEvents:UIControlEventTouchDown];
        [Loginbutton setTitle:@"登入" forState:UIControlStateNormal];
        Loginbutton.frame = CGRectMake(swidth/2 - 80, 140.0, 160.0, 30.0);
        [Loginbutton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [Loginbutton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        [self.view addSubview:accounttextField];
        [self.view addSubview:passWordtextField];
        
    }
    else
    {
        [Loginbutton addTarget:self
                        action:@selector(Logout)
              forControlEvents:UIControlEventTouchDown];
        [Loginbutton setTitle:@"登出" forState:UIControlStateNormal];
        Loginbutton.frame = CGRectMake(swidth/2 - 80, 90.0, 160.0, 30.0);
        [Loginbutton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [Loginbutton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    
   // [self.view addSubview:Loginbutton];
    [self.view addSubview:LoginAccount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backgroundTap
{
    [accounttextField resignFirstResponder];
    [passWordtextField resignFirstResponder];
}

-(void)Logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NTOULibraryAccount"];
    
    NSDictionary *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"NTOULibraryAccount"];
    
    if(account == NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登出成功！"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else    //發生錯誤，強制終止
        exit(-1);
}

-(void)Login
{
     __block NSInteger resault = 2;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    // Show the HUD in the main tread
        dispatch_async(dispatch_get_main_queue(), ^{
            // No need to hod onto (retain)
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
            hud.labelText = @"Loading";
        });
        
        resault = [self LoginAccount:accounttextField.text passWord:passWordtextField.text];

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            
            [self.view setNeedsDisplay];
            if(resault == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"帳號密碼錯誤！"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"好"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else if(resault == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登入成功！"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"好"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陸失敗！"
                                                                message:@"請檢查您的網路"
                                                               delegate:self
                                                      cancelButtonTitle:@"好"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            [self backgroundTap];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}



@end
