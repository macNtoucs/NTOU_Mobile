//
//  NTOUGuide2ViewController.m
//  NTOUMobile
//
//  Created by cclin on 1/24/13.
//
//

#import "NTOUGuide2ViewController.h"
#import "UIKit+NTOUAdditions.h"
@interface NTOUGuide2ViewController ()

@end

@implementation NTOUGuide2ViewController

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"學生專區";
    }
    return self;
}

-(void) SetRoute:(int)RouteNumber
{
    self->WhatRoute = RouteNumber;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"1";
}


- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *headerTitle;
    switch (self->WhatRoute) {
        case 3:
            headerTitle = @"學生宿舍";
            break;
        case 0:
            headerTitle = @"各科系館";
            break;
        case 2:
            headerTitle = @"研究/實驗中心";
            break;
        case 1:
            headerTitle = @"學生活動領域";
            break;
        default:
            break;
    }
	return [UITableView groupedSectionHeaderWithTitle:headerTitle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self->WhatRoute) {
        case 3:         //學生宿舍
            return 5;
            break;
        case 0:
            return 16;//各科系館
            break;
        case 2:
            return 12;//研究/實驗中心
            break;
        case 1:
            return 13;//學生活動領域
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (self->WhatRoute) {
        case 0:
            switch (indexPath.row) { //各科系館
                case 0:
                    cell.textLabel.text = @"海洋環境資訊系館";
                    break;
                case 1:
                    cell.textLabel.text = @"食品科學系工程館";
                    break;
                case 2:
                    cell.textLabel.text = @"環境生物與漁業科學學系館";
                    break;
                case 3:
                    cell.textLabel.text = @"食品科學系館";
                    break;
                case 4:
                    cell.textLabel.text = @"航運管理學系館";
                    break;
                case 5:
                    cell.textLabel.text = @"延平技術大樓";
                    break;
                case 6:
                    cell.textLabel.text = @"生命科學院館";
                    break;
                case 7:
                    cell.textLabel.text = @"河工二館";
                    break;
                case 8:
                    cell.textLabel.text = @"河工一館";
                     break;
                case 9:
                    cell.textLabel.text = @"系工系館";
                     break;
                case 10:
                    cell.textLabel.text = @"工學院館";
                     break;
                case 11:
                    cell.textLabel.text = @"電機一館";
                     break;
                case 12:
                    cell.textLabel.text = @"資工系及電機二館";
                     break;
                case 13:
                    cell.textLabel.text = @"機械與機電工程一館及電算中心";
                     break;
                case 14:
                    cell.textLabel.text = @"機械與機電工程二館";
                    break;
                case 15:
                    cell.textLabel.text = @"商船系館";
                    break;
                default:
                    break;
            }
            break;
        case 2: //研究/實驗中心
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"海洋環境化學與生態研究所館";
                    break;
                case 1:
                    cell.textLabel.text = @"臺灣藻類資源應用研發中心";
                      break;
                case 2:
                    cell.textLabel.text = @"養殖系溫室";
                     break;
                case 3:
                    cell.textLabel.text = @"海洋工程綜合實驗館";
                    break;
                case 4:
                    cell.textLabel.text = @"臨海工作站";
                    break;
                case 5:
                    cell.textLabel.text = @"綜合研究中心";
                    break;
                case 6:
                    cell.textLabel.text = @"陸生動物實驗中心";
                    break;
                case 7:
                    cell.textLabel.text = @"水生動物實驗中心";
                    break;
                case 8:
                    cell.textLabel.text = @"大型空蝕水槽試驗館";
                    break;
                case 9:
                    cell.textLabel.text = @"輪機工廠";
                    break;
                case 10:
                    cell.textLabel.text = @"操船模擬機器室";
                    break;
                case 11:
                    cell.textLabel.text = @"臨海生物教學實驗場";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) { //學生活動領域
                case 0:
                    cell.textLabel.text = @"育樂館";
                    break;
                case 1:
                    cell.textLabel.text = @"第一餐廳";
                    break;
                case 2:
                    cell.textLabel.text = @"海洋廳及展示廳";
                    break;
                case 3:
                    cell.textLabel.text = @"大游泳池";
                    break;
                case 4:
                    cell.textLabel.text = @"溫水游泳池";
                    break;
                case 5:
                    cell.textLabel.text = @"圖書館";
                     break;
                case 6:
                    cell.textLabel.text = @"學生活動中心";
                    break;
                case 7:
                    cell.textLabel.text = @"體育館";
                    break;
                case 8:
                    cell.textLabel.text = @"五楠書局";
                    break;
                case 9:
                    cell.textLabel.text = @"運動場";
                     break;
                case 10:
                    cell.textLabel.text = @"網球場";
                    break;
                case 11:
                    cell.textLabel.text = @"夢泉";
                    break;
                case 12:
                    cell.textLabel.text = @"射箭場";
                    break;
                case 13:
                    cell.textLabel.text = @"小艇碼頭";
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"女生第一宿舍";
                    break;
                case 1:
                    cell.textLabel.text = @"女生第二宿舍及男生第三宿舍";
                    break;
                case 2:
                    cell.textLabel.text = @"男生第一宿舍";
                    break;
                case 3:
                    cell.textLabel.text = @"男生第二宿舍";
                    break;
                case 4:
                    cell.textLabel.text = @"國際學生宿舍";
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
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
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NTOUGuideSetViewController  * stopsLocation = [[NTOUGuideSetViewController  alloc]init];
    CLLocationCoordinate2D location ;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (self->WhatRoute) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    location.longitude = 121.773339;
                    location.latitude = 25.149881;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 1:
                    location.longitude = 121.772986;
                    location.latitude = 25.150667;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 2:
                    location.longitude = 121.772267;
                    location.latitude = 25.149667;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 3:
                    location.longitude = 121.773644;
                    location.latitude = 25.150792;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 4:
                    location.longitude = 121.778464;
                    location.latitude = 25.149469;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 5:
                    location.longitude = 121.777794;
                    location.latitude = 25.149214;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 6:
                    location.longitude = 121.772619;
                    location.latitude = 25.150589;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 7:
                    location.longitude = 121.782647;
                    location.latitude = 25.150133;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 8:
                    location.longitude = 121.781450;
                    location.latitude = 25.150217;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 9:
                    location.longitude = 121.781025;
                    location.latitude = 25.150356;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 10:
                    location.longitude = 121.780853;
                    location.latitude = 25.150650;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 11:
                    location.longitude = 121.780572;
                    location.latitude = 25.150503;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 12:
                    location.longitude = 121.780133;
                    location.latitude = 25.150911;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 13:
                    location.longitude = 121.776436;
                    location.latitude = 25.150281;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 14:
                    location.longitude = 121.776922;
                    location.latitude = 25.150025;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 15:
                    location.longitude = 121.777642;
                    location.latitude = 25.149725;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    location.longitude = 121.777006;
                    location.latitude = 25.149625;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 1:
                    location.longitude = 121.775178;
                    location.latitude = 25.149031;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 2:
                    location.longitude = 121.775722;
                    location.latitude = 25.149805;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 3:
                    location.longitude = 121.778897;
                    location.latitude = 25.149178;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 4:
                    location.longitude = 121.779522;
                    location.latitude = 25.149327;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 5:
                    location.longitude = 121.775481;
                    location.latitude = 25.150247;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 6:
                    location.longitude = 121.779913;
                    location.latitude = 25.150127;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 7:
                    location.longitude = 121.779000;
                    location.latitude = 25.150089;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 8:
                    location.longitude = 121.775600;
                    location.latitude = 25.150411;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 9:
                    location.longitude = 121.766950;
                    location.latitude = 25.150433;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 10:
                    location.longitude = 121.773114;
                    location.latitude = 25.150192;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 11:
                    location.longitude = 121.775008;
                    location.latitude = 25.149172;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 12:
                    location.longitude = 121.775594;
                    location.latitude = 25.148811;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    location.longitude = 121.773681;
                    location.latitude = 25.149261;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 1:
                    location.longitude = 121.773533;
                    location.latitude = 25.150142;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 2:
                    location.longitude = 121.773661;
                    location.latitude = 25.149753;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 3:
                    location.longitude = 121.782486;
                    location.latitude = 25.150033;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 4:
                    location.longitude = 121.775764;
                    location.latitude = 25.151197;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 5:
                    location.longitude = 121.775731;
                    location.latitude = 25.150522;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 6:
                    location.longitude = 121.773411;
                    location.latitude = 25.150814;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 7:
                    location.longitude = 121.779400;
                    location.latitude = 25.150911;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 8:
                    location.longitude = 121.783208;
                    location.latitude = 25.149742;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 9:
                    location.longitude = 121.778222;
                    location.latitude = 25.149992;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 10:
                    location.longitude = 121.777794;
                    location.latitude = 25.149736;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 11:
                    location.longitude = 121.779100;
                    location.latitude = 25.150914;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 12:
                    location.longitude = 121.775669;
                    location.latitude = 25.151767;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                default:
                    break;
            }
            break;
            
        case 3:
            switch (indexPath.row) {
                case 0:
                    location.longitude = 121.774044;
                    location.latitude = 25.148756;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 1:
                    location.longitude = 121.779078;
                    location.latitude = 25.148603;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 2:
                    location.longitude = 121.775325;
                    location.latitude = 25.148586;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 3:
                    location.longitude = 121.778881;
                    location.latitude = 25.148572;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                case 4:
                    location.longitude = 121.766489;
                    location.latitude = 25.144303;
                    [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
                    break;
                               
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    stopsLocation.view.hidden = NO;
    stopsLocation.title = [cell.textLabel.text retain];
    [self.navigationController pushViewController:stopsLocation animated:YES];
    stopsLocation.navigationItem.leftBarButtonItem.title=@"back";
    [stopsLocation release];
    
}

@end

