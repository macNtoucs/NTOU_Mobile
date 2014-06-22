//
//  MainViewController.m
//  library
//
//  Created by R MAC on 13/5/28.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "MainViewController.h"
#import "SearchResultViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong,nonatomic) NSArray * searchType;
@property (strong, nonatomic) NSString * libSearchType;
@property(strong,nonatomic) UIPickerView *picker;
@property (strong,nonatomic)  UIButton *typeButton;
@property (strong,nonatomic) UILabel *buttonLabel;

@end

@implementation MainViewController
@synthesize searchResultArray;
@synthesize nextpage_url;
@synthesize maxpage;
@synthesize tapRecognizer;
@synthesize searchType;
@synthesize libSearchType;
@synthesize typeButton;
@synthesize  picker;
@synthesize buttonLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        NSInteger sheight = [[UIScreen mainScreen] bounds].size.height;
        mainView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , 320, sheight
                                                        )];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
    [_textField resignFirstResponder];
    return YES;
}

-(void)backgroundTap
{
        [sTextField resignFirstResponder];
    [textField resignFirstResponder];
    [self.view becomeFirstResponder];
}
/*
 - (void)textFieldDidBeginEditing:(UITextField *)_textField
 {
 [self animateTextField: _textField up: NO];
 }
 
 
 - (void)textFieldDidEndEditing:(UITextField *)_textField
 {
 [self animateTextField: _textField up: NO];
 }
 
 - (void) animateTextField: (UITextField*) textField up: (BOOL) up
 {
 const int movementDistance = 80; // tweak as needed
 const float movementDuration = 0.3f; // tweak as needed
 
 int movement = (up ? -movementDistance : movementDistance);
 
 [UIView beginAnimations: @"anim" context: nil];
 [UIView setAnimationBeginsFromCurrentState: YES];
 [UIView setAnimationDuration: movementDuration];
 self.view.frame = CGRectOffset(self.view.frame, 0, movement);
 [UIView commitAnimations];
 }
 */


-(void)search{
    [self backgroundTap];
    
    if([sTextField.text length] < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"關鍵字/ISBN為空白"
                                                        message:@"請輸入欲查詢的關鍵字/ISBN！"
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else{
        SearchResultViewController * display = [[SearchResultViewController alloc]initWithStyle:UITableViewStylePlain];
        display.data = [[NSMutableArray alloc] init];
        display.mainview = self;
        display.inputtext = sTextField.text;
        display.book_count = 10;   
        display.start = NO;
        display.Searchpage=1;
        if ([libSearchType  isEqual: @"關鍵字"])
        display.searchType = @"X";
        else display.searchType = @"i";
        
        [display search];
        [self.navigationController pushViewController:display animated:YES];
        [display release];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 27;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
    }
    
    retval.text = [searchType objectAtIndex: row];
    retval.font = [UIFont systemFontOfSize:14];
    return retval;
}


-(void)changeSearchType{
    if([libSearchType  isEqual: @"關鍵字"])
        libSearchType =@"ISBN";
    else libSearchType =@"關鍵字";
    [buttonLabel removeFromSuperview];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:13.0];
    buttonLabel.text = libSearchType;
    buttonLabel.font = font;
    [typeButton addSubview:buttonLabel];

}



- (void)viewDidLoad
{
    //self.title = @"國立海洋大學圖書館";
    //[self navAddRightButton];
    searchResultArray = [NSMutableArray new];
    searchType = [[NSArray alloc]initWithObjects:@"關鍵字",@"ISBN", nil];
    libSearchType = [[NSString alloc]initWithString:[searchType objectAtIndex: 0]];
    NSInteger swidth = [[UIScreen mainScreen] bounds].size.width;
    
       
    
    textField = [[UIView alloc] initWithFrame:CGRectMake(swidth/2 - 150,50, 300, 30)];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [[textField layer] setBorderWidth:1.0];
    [[textField layer] setBorderColor:[UIColor grayColor].CGColor];
    [[textField layer] setCornerRadius:15.0];
    sTextField = [[UITextField alloc] initWithFrame:CGRectMake(10 ,0,200, 30)];
    sTextField.delegate = self;
    sTextField.placeholder = @"書籍關鍵字/ISBN";
    sTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeButton addTarget:self
                   action:@selector(changeSearchType)
     forControlEvents:UIControlEventTouchDown];
    
    
    UILabel * divider = [[UILabel alloc]initWithFrame:CGRectMake(205 ,0,5, 30)];
    [divider setText:@"|"];
    divider.backgroundColor = [UIColor clearColor];
    
    buttonLabel = [[UILabel alloc]init];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:13.0];
    buttonLabel.frame = CGRectMake(0,0,40,28);
    buttonLabel.text = libSearchType;
    buttonLabel.textAlignment = NSTextAlignmentRight;
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.font = font;
   
    typeButton.frame =CGRectMake(textField.frame.origin.x + 210 ,
                                 textField.frame.origin.y + 1,
                                 40,
                                 28);
    [typeButton addSubview:buttonLabel];
   
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(search)
     forControlEvents:UIControlEventTouchDown];
    [button setImage:[UIImage imageNamed:@"LibrarySearch.png"] forState:UIControlStateNormal];
     button.frame = CGRectMake(textField.frame.origin.x + 260 ,
                               textField.frame.origin.y ,
                               35,
                               28);
    
    UIImage *Library = [UIImage imageNamed:@"NYOULogo.png"];
    UIImageView *NTU_Library = [[UIImageView alloc] initWithFrame:CGRectMake(swidth/2 - Library.size.width/4,180, Library.size.width/2, Library.size.height/2)];
    [NTU_Library setImage:Library];
    
    [mainView addSubview:NTU_Library];
    [mainView addSubview:textField];
    [textField addSubview:sTextField];
    [textField addSubview:divider];
    [mainView addSubview:button];
    [mainView addSubview:typeButton];
    self.view = mainView;
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)];
    tapRecognizer.delegate  = self;
    [self.view addGestureRecognizer:tapRecognizer];
     self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    [textField release];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end