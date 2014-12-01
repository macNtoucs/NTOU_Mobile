//
//  ContactInfoTableViewController.m
//  NTOU_Mobile
//  library-關於圖書館-聯絡資訊
//
//  Created by Rick on 2014/6/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "ContactInfoTableViewController.h"



@interface ContactInfoTableViewController ()
@property (nonatomic , retain) NSArray * contactInfo;
@property (nonatomic ,retain)  NSString * phoneNumber;
@end

@implementation ContactInfoTableViewController
@synthesize contactInfo;
@synthesize phoneNumber;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"聯絡資訊";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    contactInfo = [[NSArray alloc]initWithObjects:@"0224622192,1187", @"0224624651",@"lit@mail.ntou.edu.tw",@"0224622192,1171",@"0224631208",@"staff@mail.ntou.edu.tw",nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    //執行取消發送電子郵件畫面的動畫
    [self dismissModalViewControllerAnimated:YES];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"圖書服務";
            break;
            
        default:
            return @"資訊服務";
            break;
    }

}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *SecondaryCellIdentifier = @"SecondaryCell";
    
    
    SecondaryGroupedTableViewCell *cell = (SecondaryGroupedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondaryCellIdentifier];
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondaryCellIdentifier] autorelease];
    }
    if(indexPath.section ==0){
        switch (indexPath.row){
        
            case 0 : {
                cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewPhone];
                cell.textLabel.text = @"電話 : ";
                cell.secondaryTextLabel.text = @"0224622192,1187";
                break;
                }
            case 1 : {
                cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewPhone];
                cell.textLabel.text = @"FAX : ";
                cell.secondaryTextLabel.text = @"0224624651";
                break;
            }
            case 2 : {
                cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewEmail];
                cell.textLabel.text = @"信箱 : ";
                cell.secondaryTextLabel.text = @"lit@mail.ntou.edu.tw";
                break;
            }
            default: break;
        
        
        }
    }
        if(indexPath.section ==1){
            switch (indexPath.row){
                    
                case 0 : {
                    cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewPhone];
                    cell.textLabel.text = @"電話 : ";
                    cell.secondaryTextLabel.text = @"0224622192,1171";
                    break;
                }
                case 1 : {
                    cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewPhone];
                    cell.textLabel.text = @"FAX : ";
                    cell.secondaryTextLabel.text = @"0224631208";
                    break;
                }
                case 2 : {
                    cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewEmail];
                    cell.textLabel.text = @"信箱 : ";
                    cell.secondaryTextLabel.text = @"staff@mail.ntou.edu.tw";
                    break;
                }
                default: break;
                    
                    
            }
            
            
    }
       
    return cell;
    
    }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
           // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString  *title;
            NSURL * aURL;
    
            if (indexPath.row==2 && [MFMailComposeViewController canSendMail]){
                      MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
                    mailView.mailComposeDelegate = self;
                if (indexPath.section ==0)
                    [mailView setToRecipients:[NSArray arrayWithObjects:[contactInfo objectAtIndex:2 ], nil]];
                 else
                      [mailView setToRecipients:[NSArray arrayWithObjects:[contactInfo objectAtIndex:5 ], nil]];
                    [self dismissModalViewControllerAnimated:NO];
                    [self presentModalViewController:mailView
                                            animated:YES];
                    return;
                
            }
            if (indexPath.section ==0){
                    phoneNumber = [contactInfo objectAtIndex:indexPath.row+indexPath.section ];
                    title = @"圖書服務";
                }
            else{
                phoneNumber = [contactInfo objectAtIndex:indexPath.row+indexPath.section +2];
                 title = @"資訊服務";
            }
            aURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
            if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告" message:[NSString stringWithFormat:@"即將撥往%@",title] delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"撥打", nil];
                [alert show];
            }
   
    
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            break;
        default:{
               NSURL *aURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
            [[UIApplication sharedApplication] openURL:aURL];
            break;
        }
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
