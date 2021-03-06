//
//  KUO_RouteViewController_Bra2.m
//  MIT Mobile
//
//  Created by mini server on 12/11/17.
//
//

#import "KUO_RouteViewController_Bra2.h"
#import "UIKit+NTOUAdditions.h"
@interface KUO_RouteViewController_Bra2 (){
    int busType;
    NSIndexPath *tabcIndexPath;
    BOOL except;
    BOOL direct;
}
@end

@implementation KUO_RouteViewController_Bra2

- (id)initWithStyle:(UITableViewStyle)style WithType:(int)type
{
    busType = type;
    self = [super initWithStyle:style];
    if (self) {
        if (type == Kuo_Data) {
            inbound = [[[KUO_Data_Bra2 sharedData] fetchInboundJourney] mutableCopy] ;
            outbound = [[[KUO_Data_Bra2 sharedData] fetchOutboundJourney] mutableCopy] ;
        }
        else
        {
            inbound = [[[Fuhobus_Data sharedData] fetchInboundJourney] mutableCopy] ;
            outbound = [[[Fuhobus_Data sharedData] fetchOutboundJourney] mutableCopy] ;
        }
        display = inbound;
        except = FALSE;
        direct = FALSE;
        // Custom initialization
    }
    return self;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (busType == Kuo_Data)
        return [display allKeys];
    return nil;
}

-(void)changeDirectType
{
    if (direct) {
        if ([[[display allKeys]objectAtIndex:tabcIndexPath.section] isEqualToString:@"基隆"]&&(tabcIndexPath.row==exceptionIndex)&&except==FALSE) {
            except = TRUE;
        }
        else{
            display = inbound;
            direct = FALSE;
            except = FALSE;
        }
        //self.title = [NSString stringWithFormat:@"路線  →"];
    } else {
        display = outbound;
        direct = TRUE;
        //self.title = [NSString stringWithFormat:@"→  路線"];
    }
    [self.tableView reloadData];
}

-(NSArray *)checkExceptionArriveTime:(NSArray*) arr{
    if ([[[display allKeys]objectAtIndex:tabcIndexPath.section] isEqualToString:@"基隆"]&&(tabcIndexPath.row==exceptionIndex)&&except==FALSE&&direct==TRUE) {
        return [arr objectAtIndex:0];
    }
    else if ([[[display allKeys]objectAtIndex:tabcIndexPath.section] isEqualToString:@"基隆"]&&(tabcIndexPath.row==exceptionIndex)&&except==TRUE){
        return [arr objectAtIndex:1];
    }
    else
        return arr;
}

-(void)TimeViewControllerDirectChange
{
    [self changeDirectType];
    [self changeTabcTittle];
    if (busType == Kuo_Data)
        tabc.data = [[display objectForKey:[[display allKeys] objectAtIndex:tabcIndexPath.section]] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(tabcIndexPath.row*5, 5)]];
    else
        tabc.data = [[display objectForKey:[[display allKeys] objectAtIndex:tabcIndexPath.section]] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    [self.tableView applyStandardColors];
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"往返切換"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(changeDirectType)];
    [self.navigationItem setRightBarButtonItem:rightButton];*/
    if (busType == Kuo_Data) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self                                                                                                 action:@selector(changeDirectType)];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight;
        
        [self.tableView addGestureRecognizer:swipeGestureRecognizer];
        
        [swipeGestureRecognizer release];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    rowHeight = labelSize.height + 20.0f;
    
    return rowHeight;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (busType == Kuo_Data)
        return @" ";
    return nil;
}
- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (busType == Kuo_Data)
    {
        if (display==inbound) {
            return [UITableView groupedSectionHeaderWithTitle:[[[display allKeys]objectAtIndex:section] stringByAppendingString:@"  → "]] ;
        }
        else
            return [UITableView groupedSectionHeaderWithTitle:[[NSString stringWithFormat:@"  → "]  stringByAppendingString:[[display allKeys]objectAtIndex:section]]] ;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (busType == Kuo_Data) {
        return [display count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (busType == Kuo_Data)
        return [[display objectForKey:[[display allKeys] objectAtIndex:section]] count]/StationInformationCount;
    else
        return [display count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (busType == Kuo_Data) {
        cell.textLabel.text= [[display objectForKey:[[display allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row*StationInformationCount];
    }
    else{
        cell.textLabel.text=[[[[display allKeys]objectAtIndex:indexPath.row] stringByAppendingString:@"  ⇌  "] stringByAppendingString:[[display objectForKey:[[display allKeys] objectAtIndex:indexPath.row]] objectAtIndex:0]];
    }
    return cell;
}

-(void)changeTabcTittle{
    if (tabcIndexPath.row==exceptionIndex&&except==TRUE) {
        return;
    }
    NSArray* Separated= [tabc.title componentsSeparatedByString:@"  →  "];
    tabc.title = [[[Separated objectAtIndex:1] stringByAppendingString:@"  →  "] stringByAppendingString:[Separated objectAtIndex:0]];
}

-(NSString*)changeTimeViewTittle:(NSString*) name
{
    if ([[[display allKeys]objectAtIndex:tabcIndexPath.section] isEqualToString:@"基隆"]&&tabcIndexPath.row==exceptionIndex&&except==FALSE&&direct==TRUE) {
        name = [name stringByAppendingString:@"(平日班次)"];
    }
    else if ([[[display allKeys]objectAtIndex:tabcIndexPath.section] isEqualToString:@"基隆"]&&tabcIndexPath.row==exceptionIndex&&except==TRUE) {
        name = [[name componentsSeparatedByString:@"(平日班次)"] objectAtIndex:0];
        name = [name stringByAppendingString:@"(假日班次)"];
    }
    else{
        name = [[name componentsSeparatedByString:@"(假日班次)"] objectAtIndex:0];
    }
    return name;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tabcIndexPath = [indexPath retain];
    SecondaryGroupedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (busType == Kuo_Data){
    tabc = [[KUO_TimeViewController alloc] init:[[display objectForKey:[[display allKeys] objectAtIndex:indexPath.section]] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row*StationInformationCount, StationInformationCount)]]delegate:self];
        
        if (display==inbound) {
            tabc.title = [[[[display allKeys]objectAtIndex:indexPath.section] stringByAppendingString:@"  →  "] stringByAppendingString:cell.textLabel.text];
        } else {
            tabc.title = [[cell.textLabel.text stringByAppendingString:@"  →  "] stringByAppendingString:[[display allKeys]objectAtIndex:indexPath.section]];
        }
        
    }
    else
    {
        tabc = [[KUO_TimeViewController alloc] init:[[display objectForKey:[[display allKeys] objectAtIndex:indexPath.row]] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, StationInformationCount)]]delegate:self];
        tabc.title = [cell.textLabel.text stringByReplacingOccurrencesOfString:@"⇌" withString:@"→"];
        
    }
    
    except = FALSE;
    [self.navigationController pushViewController:tabc animated:YES];
    tabc.navigationItem.leftBarButtonItem.title=@"back";
    [tabc release];
}

@end
