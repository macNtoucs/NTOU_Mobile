//
//  WOLlistViewController.m
//  calandertest
//
//  Created by apple on 13/2/15.
//  Copyright (c) 2013年 apple. All rights reserved.
//
#import <EventKit/EventKit.h>
#import "WOLEnglistViewController.h"
#import "BIDNameAndColorCell.h"
#import "NTOUUIConstants.h"
#import "MBProgressHUD.h"

@interface WOLEnglistViewController ()

@property (nonatomic, strong) UIToolbar *actionToolbar;
@property (nonatomic, strong) NSMutableArray *selectindexs;
@property (nonatomic, strong) UIActionSheet *finishactionsheet;
@property (nonatomic, strong) UIActionSheet *endactionsheet;
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) UIView *mask;
@property (nonatomic) BOOL showing;
//@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation WOLEnglistViewController

@synthesize events;
@synthesize keys;
@synthesize actionToolbar;
@synthesize selectindexs;
@synthesize finishactionsheet;
@synthesize endactionsheet;
@synthesize showing;
@synthesize eventStore;
@synthesize switchviewcontroller;
@synthesize mask;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    NSInteger screenheight = [[UIScreen mainScreen] bounds].size.height;
    NSInteger height = screenheight - 64;
    self.view.frame = CGRectMake(0, 0, 320, height);
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectindexs = [[NSMutableArray alloc] init];
    
    self.title = @"清單";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CalenderList_eng" ofType:@"plist"];
    
    NSDictionary *list = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.events = list;
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"8",@"9",@"10",@"11",@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    self.keys = array;
    
    self.actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];

    UIBarButtonItem *flexiblespace_l = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    flexiblespace_l.width = 12.0;
    
    UIBarButtonItem *allselectButton =[[UIBarButtonItem alloc]
                                       initWithTitle:@"All  select"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(allselect:)];
    allselectButton.width = 110.0;
    
    UIBarButtonItem *flexiblespace_m = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    flexiblespace_m.width = 12.0;
    
    UIBarButtonItem *finishButton =[[UIBarButtonItem alloc]
                                    initWithTitle:@"Finish"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(finishselect:)];
    finishButton.width = 110.0;
    
    UIBarButtonItem *flexiblespace_r = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    flexiblespace_r.width = 12.0;
    
    
    
    [self.actionToolbar setItems:[NSArray arrayWithObjects:flexiblespace_l,allselectButton,flexiblespace_m,finishButton,flexiblespace_r, nil]];
    self.actionToolbar.barStyle = UIBarStyleBlack;
    
    [self.tableView setAllowsSelectionDuringEditing:YES];
     
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    
    self.events = nil;
    self.keys = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.allowsMultipleSelection = YES;
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [keys objectAtIndex:section];
    NSArray *eventsection = [events objectForKey:key];
    return [eventsection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *eventsection = [events objectForKey:key];
    
    NSDictionary *dateevent = [eventsection objectAtIndex:row];
    NSString *value = [dateevent objectForKey:@"value"];
    NSString *startdate = [dateevent objectForKey:@"startdate"];
    NSString *enddate = [dateevent objectForKey:@"enddate"];
    NSString *cross = [dateevent objectForKey:@"cross"];
    
    //-----------------
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *datelabel = nil;
    UILabel *eventlabel = nil;
    UILabel *date = nil;
    UILabel *event = nil;
    if (cell == nil)
    {
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        CGSize maximumLabelSize = CGSizeMake(230,9999);
        CGSize expectedLabelSize = [value sizeWithFont:cellFont
                                     constrainedToSize:maximumLabelSize
                                         lineBreakMode:UILineBreakModeWordWrap];
        
        datelabel = [[UILabel alloc] init];
        eventlabel = [[UILabel alloc] init];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        datelabel.frame = CGRectMake(62,8,230,14);
        eventlabel.frame = CGRectMake(62,29,230,expectedLabelSize.height);
        
        cell.backgroundColor = SECONDARY_GROUP_BACKGROUND_COLOR;
        
        datelabel.tag = indexPath.row;
        datelabel.font = cellFont;
        datelabel.textColor = CELL_STANDARD_FONT_COLOR;
        datelabel.backgroundColor = [UIColor clearColor];
        
        if([startdate isEqualToString:enddate])
        {
            NSString *valuestring = [[NSString alloc]initWithFormat:@"%@/%@",key,startdate];
            datelabel.text = valuestring;
        }
        else
        {
            NSString *nextkey;
            if(section != 11)
                nextkey = [keys objectAtIndex:section+1];
            else
                nextkey = @"8";
            
            if([cross isEqualToString:@"no"])
            {
                NSString *valuestring = [[NSString alloc]initWithFormat:@"%@/%@ - %@/%@",key,startdate,key,enddate];
                datelabel.text = valuestring;
            }
            else
            {
                NSString *valuestring = [[NSString alloc]initWithFormat:@"%@/%@ - %@/%@",key,startdate,nextkey,enddate];
                datelabel.text = valuestring;
            }
        }
        
        eventlabel.tag=indexPath.row;
        eventlabel.lineBreakMode = UILineBreakModeWordWrap;
        eventlabel.numberOfLines = 0;
        eventlabel.backgroundColor = [UIColor clearColor];
        eventlabel.font = cellFont;
        eventlabel.textColor = CELL_STANDARD_FONT_COLOR;
        eventlabel.text = value;
        
        
        event = [[UILabel alloc] init];
        date= [[UILabel alloc] init];
        
        event.frame = CGRectMake(14,25,45,21);
        event.text = @"事件：";
        event.tag=indexPath.row;
        event.backgroundColor = [UIColor clearColor];
        event.font = cellFont;
        event.textColor = CELL_STANDARD_FONT_COLOR;
        
        date.frame = CGRectMake(14,4,45,21);
        date.text = @"日期：";
        date.tag=indexPath.row;
        date.backgroundColor = [UIColor clearColor];
        date.font = cellFont;
        date.textColor = CELL_STANDARD_FONT_COLOR;
        
        [cell.contentView addSubview:datelabel];
        [cell.contentView addSubview:eventlabel];
        [cell.contentView addSubview:date];
        [cell.contentView addSubview:event];
    }
    
    if (self.tableView.editing)
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    else
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [keys objectAtIndex:section];
    NSString *sectiontitle;
    if(section < 5)
    {
        sectiontitle = [[NSString alloc] initWithFormat:@"2012 / %@",key];
    }
    else
    {
        sectiontitle = [[NSString alloc] initWithFormat:@"2013 / %@",key];
    }
    return sectiontitle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *key = [keys objectAtIndex:section];
    NSArray *eventsection = [events objectForKey:key];
    NSDictionary *dateevent = [eventsection objectAtIndex:row];
    
    NSString *value = [dateevent objectForKey:@"value"];

    CGSize maximumLabelSize = CGSizeMake(230,9999);
    CGSize size = [value sizeWithFont:[UIFont systemFontOfSize:14.0f]
                        constrainedToSize:maximumLabelSize
                        lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = 33.0 + size.height;
    return height;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return keys;
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing)//編輯中
    {
        BOOL selected = NO;
        for(NSIndexPath *index in selectindexs)
        {
            if([indexPath isEqual:index])
                selected = YES;
        }
        
        if(selected == NO)
            [selectindexs addObject:indexPath];
        NSLog(@"end a select");
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing)//編輯中
    {
        [selectindexs removeObject:indexPath];

        NSLog(@"end a select");
    }
}

#pragma mark -
#pragma mark Toolbar

- (void)showActionToolbar:(BOOL)show
{
	CGRect toolbarFrame = actionToolbar.frame;
	CGRect viewFrame = self.tableView.frame;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	if (show && showing == NO)
	{
		toolbarFrame.origin.y = self.tableView.frame.size.height - toolbarFrame.size.height;
		viewFrame.size.height -= toolbarFrame.size.height;
        showing = YES;
        actionToolbar.frame = toolbarFrame;
        self.tableView.frame = viewFrame;
        
        [self.view.superview insertSubview:actionToolbar atIndex:0];
	}
	else if(!show && showing == YES)
	{
		toolbarFrame.origin.y = self.tableView.frame.size.height;
		viewFrame.size.height += toolbarFrame.size.height;
        showing = NO;
        actionToolbar.frame = toolbarFrame;
        self.tableView.frame = viewFrame;
        
        [actionToolbar removeFromSuperview];
	}
	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Select

- (IBAction)chooseitem
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {//編輯中
        [selectindexs removeAllObjects];
        
        [self showActionToolbar:YES];
    }
    else
        [self showActionToolbar:NO];
    
    [self.tableView reloadData];
}

- (IBAction)allselect:(id)sender
{
    NSInteger s,r;
    for (s = 0; s < self.tableView.numberOfSections; s++) {
        for (r = 0; r < [self.tableView numberOfRowsInSection:s]; r++) {
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (IBAction)finishselect:(id)sender
{
    finishactionsheet = [[UIActionSheet alloc]
                         initWithTitle:@"Are you sure to download?"
                         delegate:self
                         cancelButtonTitle:@"Cancel."
                         destructiveButtonTitle:@"Sure."
                         otherButtonTitles:nil];
    [finishactionsheet showFromToolbar:actionToolbar];
}

#pragma mark DownLoad

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([actionSheet isEqual:finishactionsheet])
    {
        if(buttonIndex == [finishactionsheet destructiveButtonIndex])
        {
            [self showActionToolbar:NO];
            
            //灰色覆蓋view
            mask = [[UIView alloc] initWithFrame:self.view.frame];
            [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
            [self.view.superview addSubview:mask];

            //旋轉動畫
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            //開始UIActivityIndicatorView動畫（旋轉效果）
            [indicator startAnimating];
            
            //設定位置並加入畫面
            NSInteger screenheight = [[UIScreen mainScreen] bounds].size.height;
            NSInteger height = (screenheight - 64)/2;
            indicator.center = CGPointMake(160, height);
            [self.view.superview addSubview:indicator];
            //[indicator release];
            
            //下載成功ActionSheet
            UIAlertView *alertfinish = [[UIAlertView alloc] initWithTitle:@"【NTOU】Calendar"
                                                            message:@"-Download successfully!-"
                                                           delegate:self
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil];

            endactionsheet = [[UIActionSheet alloc]
                              initWithTitle:@"Download successfully!\nRun Calendar APP?"
                              delegate:self
                              cancelButtonTitle:@"Continue browsing."
                              destructiveButtonTitle:@"Run Calendar APP"
                              otherButtonTitles:nil];
            endactionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            
            eventStore = [[EKEventStore alloc] init];
            
            if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
                // iOS 6 and later
                [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                    if (granted)
                    {
                        //---- codes here when user allow your app to access theirs' calendar.
                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                            // Show the HUD in the main tread
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // No need to hod onto (retain)
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                hud.labelText = @"DownLoading";
                            });
                            
                            
                            [self addEventData];
                            //[mask removeFromSuperview];
                            //[self.tableView setEditing:YES animated:NO];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [alertfinish show];
                                [self.switchviewcontroller Chichooseitem];
                                [eventStore release];
                            });
                        });

                    }
                    else
                    {
                        [indicator stopAnimating];
                        //----- codes here when user NOT allow your app to access the calendar.
                        UIAlertView *alertfause = [[UIAlertView alloc] initWithTitle:@"【NTOU】Calendar"
                                                                        message:@"-Can't Download-\n無法存取您手機內的行事曆\n請更改您的設定\n(iOS6以上會出現這個問題)"
                                                                       delegate:self
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil];
                        [alertfause show];
                        [mask removeFromSuperview];
                    }
                }];
            }
            else
            {
                //---- codes here for IOS < 6.0.
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Show the HUD in the main tread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // No need to hod onto (retain)
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.labelText = @"DownLoading";
                    });
                    
                    
                    [self addEventData];
                    //[mask removeFromSuperview];
                    //[self.tableView setEditing:YES animated:NO];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [alertfinish show];
                        [self.switchviewcontroller Chichooseitem];
                        [eventStore release];
                    });
                });

            }
        }
    }
}

- (EKCalendar *)  getFirstModifiableLocalCalendar{
    
    EKCalendar *result = nil;
    
    EKEventStore *getEventStore = [[EKEventStore alloc] init];
    
    for (EKCalendar *thisCalendar in getEventStore.calendars){
        if (thisCalendar.type == EKCalendarTypeLocal &&
            [thisCalendar allowsContentModifications]){
            return thisCalendar;
        }
    }
    
    return result;
}

-(void)addEventData
{
    for(NSIndexPath *index in selectindexs)
    {
        NSUInteger section = [index section];
        NSUInteger row = [index row];
        
        NSString *key = [keys objectAtIndex:section];
        NSArray *eventsection = [events objectForKey:key];
        NSDictionary *dateevent = [eventsection objectAtIndex:row];
        
        EKEvent *addEvent = [EKEvent eventWithEventStore:eventStore];
        NSString *titlestring = [[NSString alloc] initWithFormat:@"【NTOU】%@",[dateevent objectForKey:@"value"]];
        addEvent.title = titlestring;
        addEvent.allDay = YES;
        
        NSDateComponents *startcomps = [[NSDateComponents alloc] init];
        if(section < 5)
            [startcomps setYear:2012];
        else
            [startcomps setYear:2013];
        
        [startcomps setMonth:[key intValue]];
        
        NSString *startday = [[NSString alloc]initWithString:[dateevent objectForKey:@"startdate"]];
        [startcomps setDay:[startday intValue]];
        NSCalendar *startcal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *startDate = [startcal dateFromComponents:startcomps];
        
        addEvent.startDate = startDate;
        
        
        NSDateComponents *endcomps = [[NSDateComponents alloc] init];
        if(section < 4 || (section == 4 && [[dateevent objectForKey:@"cross"] isEqualToString:@"NO"]) )
            [endcomps setYear:2012];
        else
            [endcomps setYear:2013];
        
        NSString *endkey;
        if([[dateevent objectForKey:@"cross"] isEqualToString:@"yes"])
        {
            if(section != 11)
            {
                endkey = [keys objectAtIndex:section+1];
            }
            else
            {
                endkey = @"8";
            }
        }
        else
            endkey = key;
        
        [endcomps setMonth:[endkey intValue]];
        
        NSString *endday = [[NSString alloc]initWithString:[dateevent objectForKey:@"enddate"]];
        [endcomps setDay:[endday intValue]];
        
        NSCalendar *endcal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *endDate = [endcal dateFromComponents:endcomps];
        
        addEvent.endDate = endDate;
        [addEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
        //[addEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
        //活動日期警示窗
        //addEvent.alarms = [NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:addEvent.startDate]];
        
        NSError *saveError = nil;
        if([eventStore saveEvent:addEvent span:EKSpanThisEvent error:&saveError])
        {
            NSLog(@"%@ save success!",index);
        }
        else
            NSLog(@"%@ Failed to save the event. Error = %@",index,saveError);
    }
    NSLog(@"包裝完成");
}

@end