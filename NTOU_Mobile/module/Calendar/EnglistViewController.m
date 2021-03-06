//
//  listViewController.m
//  calandertest
//
//  Created by apple on 13/2/15.
//  Copyright (c) 2013年 apple. All rights reserved.
//
#import <EventKit/EventKit.h>
#import "EnglistViewController.h"
#import "NTOUUIConstants.h"
#import "MBProgressHUD.h"
#define YEAR 2015   //起始學期年份
@interface EnglistViewController ()

@property (nonatomic, strong) NSMutableArray *selectindexs;
@property (nonatomic, strong) UIActionSheet *finishactionsheet;
@property (nonatomic, strong) UIActionSheet *endactionsheet;
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) UIView *mask;
@property (nonatomic) BOOL showing;
//@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation EnglistViewController

@synthesize events;
@synthesize keys;
@synthesize actionToolbar;
@synthesize selectindexs;
@synthesize finishactionsheet;
@synthesize endactionsheet;
@synthesize showing;
@synthesize eventStore;
@synthesize switchviewcontroller;
@synthesize downLoadEditing;
@synthesize mask;
@synthesize menuHeight;


- (void)setupFrame:(float) NavBarHeight
{
    NSInteger screenHeight = [[UIScreen mainScreen] bounds].size.height;
    NSInteger screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.tableView.frame = CGRectMake(0, NavBarHeight, screenWidth, screenHeight-NavBarHeight);
    NSLog(@"navigationBar height:%f", NavBarHeight);
}

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    NSInteger screenheight = [[UIScreen mainScreen] bounds].size.height;
    NSInteger height = screenheight;
    self.tableView.frame = CGRectMake(0, 0, 320, height);
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    eventStore = [[EKEventStore alloc] init];
    selectindexs = [[NSMutableArray alloc] init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    //self.title = @"清單";
    
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
    
    downLoadEditing = NO;
    
    [self.tableView reloadData];
    
    [self scrolltableview];
}

-(void)scrolltableview
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:(NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekCalendarUnit) fromDate:today];
    NSInteger month = [dateComponents month];
    if(month >= 8)
        month -= 8;
    else
        month += 4;
    [self.searchDisplayController.searchResultsTableView setContentOffset:CGPointZero];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:month] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!(self.isMovingToParentViewController || self.isBeingPresented))
    {
        [self scrolltableview];
    }
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
    NSArray *monthevent = [events objectForKey:key];
    NSDictionary *dateevent = [monthevent objectAtIndex:row];
    
    UITableViewCell *cell = [self mackCell:tableView sectionForCell:section rowForCell:row eventForRow:dateevent monthForEvent:key];
    
    BOOL selet = NO;
    for(NSIndexPath *index in selectindexs)
    {
        if([indexPath isEqual:index])
        {
            selet = YES;
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    if(selet == NO)
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

-(UITableViewCell*)mackCell:(UITableView *)tableView sectionForCell:(NSUInteger)section rowForCell:(NSUInteger)row eventForRow:(NSDictionary *)rowevent monthForEvent:(NSString*)month
{
    NSString *value = [rowevent objectForKey:@"value"];
    NSString *startdate = [rowevent objectForKey:@"startdate"];
    NSString *enddate = [rowevent objectForKey:@"enddate"];
    NSString *cross = [rowevent objectForKey:@"cross"];
    NSString *startweek = [rowevent objectForKey:@"startweek"];
    NSString *endweek = [rowevent objectForKey:@"endweek"];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d%@%@",section,row,month,startdate];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *datelabel = nil;
    UILabel *eventlabel = nil;
    UILabel *date = nil;
    UILabel *event = nil;
    
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize maximumLabelSize = CGSizeMake(230,9999);
    CGSize expectedLabelSize = [value sizeWithFont:cellFont
                                 constrainedToSize:maximumLabelSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
    
    if (cell == nil)
    {
        datelabel = [[UILabel alloc] init];
        eventlabel = [[UILabel alloc] init];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        event = [[UILabel alloc] init];
        date= [[UILabel alloc] init];
        
        event.frame = CGRectMake(11,25,45,21);
        event.text = @"Event:";
        event.textAlignment = UITextAlignmentRight;
        event.tag=row;
        event.backgroundColor = [UIColor clearColor];
        event.font = cellFont;
        event.textColor = CELL_STANDARD_FONT_COLOR;
        
        date.frame = CGRectMake(11,4,45,21);
        date.text = @"Date:";
        date.textAlignment = UITextAlignmentRight;
        date.tag=row;
        date.backgroundColor = [UIColor clearColor];
        date.font = cellFont;
        date.textColor = CELL_STANDARD_FONT_COLOR;
        
        [cell.contentView addSubview:datelabel];
        [cell.contentView addSubview:eventlabel];
        [cell.contentView addSubview:date];
        [cell.contentView addSubview:event];
    }
    
    datelabel.frame = CGRectMake(62,8,230,14);
    eventlabel.frame = CGRectMake(62,29,230,expectedLabelSize.height);
    
    cell.backgroundColor = SECONDARY_GROUP_BACKGROUND_COLOR;
    
    datelabel.tag = row;
    datelabel.font = cellFont;
    datelabel.textColor = CELL_STANDARD_FONT_COLOR;
    datelabel.backgroundColor = [UIColor clearColor];
    
    if([startdate isEqualToString:enddate])
    {
        NSString *valuestring = [[NSString alloc]initWithFormat:@"%@/%@ (%@)",month,startdate,startweek];
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
            NSString *valuestring = [[NSString alloc]initWithFormat:@"%@/%@ (%@) ~ %@/%@ (%@)",month,startdate,startweek,month,enddate,endweek];
            datelabel.text = valuestring;
        }
        else
        {
            NSString *valuestring = [[NSString alloc]initWithFormat:@"%@/%@ (%@) ~ %@/%@ (%@)",month,startdate,startweek,nextkey,enddate,endweek];
            datelabel.text = valuestring;
        }
    }
    
    eventlabel.tag=row;
    eventlabel.lineBreakMode = NSLineBreakByWordWrapping;
    eventlabel.numberOfLines = 0;
    eventlabel.backgroundColor = [UIColor clearColor];
    eventlabel.font = cellFont;
    eventlabel.textColor = CELL_STANDARD_FONT_COLOR;
    eventlabel.text = value;
    
    
    if (downLoadEditing)
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *key = [keys objectAtIndex:section];
    NSString *sectiontitle;
    /*
     //除七月其他皆更新
     if(section < 5)
     sectiontitle = [[NSString alloc] initWithFormat:@"  %d / %@",YEAR,key];    //當年
     else if(section == 11) //七月
     sectiontitle = [[NSString alloc] initWithFormat:@"  %d / %@",YEAR,key];
     else
     sectiontitle = [[NSString alloc] initWithFormat:@"  %d / %@",YEAR+1,key];    //隔年
    */
    
    //全更新
    if(section < 5)
        sectiontitle = [[NSString alloc] initWithFormat:@"  %d / %@",YEAR,key];
    else
        sectiontitle = [[NSString alloc] initWithFormat:@"  %d / %@",YEAR+1,key];
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)] autorelease];
    label.text = sectiontitle;
    label.textColor =[UIColor colorWithHexString:@"#565656"] ;
    label.font = [UIFont fontWithName:@"Helvetica" size:14.0] ;
    UIImage *backgroundImage = [UIImage imageNamed:NTOUImageNameScrollTabBackgroundOpaque];
    label.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    [headerView addSubview:label];
    return headerView;
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
                        lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = 33.0 + size.height;
    return height;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return keys;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (downLoadEditing)//編輯中
    {
        BOOL selected = NO;
        for(NSIndexPath *index in selectindexs)
        {
            if([indexPath isEqual:index])
                selected = YES;
        }
        
        if(selected == NO)
        {
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            [selectindexs addObject:indexPath];
            NSLog(@"%@",indexPath);
        }
            
        NSLog(@"end a select");
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (downLoadEditing)//編輯中
    {
        [selectindexs removeObject:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        
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
		toolbarFrame.origin.y = switchviewcontroller.view.frame.size.height - toolbarFrame.size.height;
		viewFrame.size.height -= toolbarFrame.size.height;
        showing = YES;
        actionToolbar.frame = toolbarFrame;
        self.tableView.frame = viewFrame;
        
        [switchviewcontroller.view addSubview:actionToolbar];
        //[self.view.superview insertSubview:actionToolbar atIndex:0];
	}
	else if(!show && showing == YES)
	{
		toolbarFrame.origin.y = switchviewcontroller.view.frame.size.height;
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
    downLoadEditing = !downLoadEditing;
    //[self.tableView setEditing:!self.tableView.editing animated:YES];
    if (downLoadEditing) //編輯中
        [self showActionToolbar:YES];
    else
    {
        [self showActionToolbar:NO];
        [selectindexs removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (IBAction)allselect:(id)sender
{
    NSInteger s,r;
    for (s = 0; s < self.tableView.numberOfSections; s++) {
        for (r = 0; r < [self.tableView numberOfRowsInSection:s]; r++) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
        }
    }
}

- (IBAction)finishselect:(id)sender
{
    finishactionsheet = [[UIActionSheet alloc]
                         initWithTitle:@"Are you sure you want to import?"
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
            
            UIAlertView *alertfinish = [[UIAlertView alloc] initWithTitle:@"【NTOU】Calendar"
                                                                  message:@"-Import successfully!-"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK!"
                                                        otherButtonTitles:nil];
            
            eventStore = [[EKEventStore alloc] init];
            
            if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
                // iOS 6 and later
                [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                    if (granted)
                    {
                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                            // Show the HUD in the main tread
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // No need to hod onto (retain)
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.switchviewcontroller.view animated:YES];
                                hud.labelText = @"Importing";
                            });
                            
                            
                            [self addEventData];
                            //[mask removeFromSuperview];
                            //[self.tableView setEditing:YES animated:NO];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.switchviewcontroller.view animated:YES];
                                [alertfinish show];
                                [self.switchviewcontroller Engchooseitem];
                                [eventStore release];
                            });
                        });
                    }
                    else
                    {
                        //----- codes here when user NOT allow your app to access the calendar.
                        UIAlertView *alertfause = [[UIAlertView alloc] initWithTitle:@"【NTOU】Calendar"
                                                                             message:@"-Import error-\nWe does not have access to Your Calendar\nPlease allow access for your device\nunder Settings/Calendar"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"知道了"
                                                                   otherButtonTitles:nil];
                        [alertfause show];
                        //[mask removeFromSuperview];
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [alertfinish show];
                        [self.switchviewcontroller Engchooseitem];
                        [eventStore release];
                    });
                });
                
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [switchviewcontroller showMenuView];
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
    [self setupCalendar];
    
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
        /*
         //除七月其他皆更新版
         if(section < 5)
         [startcomps setYear:YEAR];      //當年
         else if (section == 11)
         [startcomps setYear:YEAR];      //七月
         else
         [startcomps setYear:YEAR+1];    //隔年
         */
        
        //全更新
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
        /*
         //除七月其他皆更新版
         if(section == 11 || section < 4 || (section == 4 && [[dateevent objectForKey:@"cross"] isEqualToString:@"NO"]) )
         [endcomps setYear:YEAR];    //當年1~11月 或 12月無跨月份 或 七月
         else
         [endcomps setYear:YEAR+1];  //隔年
        */
        
        //全更新
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
        for (EKCalendar *thisCalendar in eventStore.calendars){
            if ([thisCalendar.title isEqualToString:@"NTOU"]){
                [addEvent setCalendar:thisCalendar];
            }
        }

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

-(void)setupCalendar
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[eventStore calendarWithIdentifier:[userDefaults objectForKey:@"NTOUCalendarIdentifier"]]);
    if (![eventStore calendarWithIdentifier:[userDefaults objectForKey:@"NTOUCalendarIdentifier"]])
    {
        EKCalendar *localCalendar;
        if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])// iOS 6 and later
            localCalendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
        else
            localCalendar = [EKCalendar calendarWithEventStore:eventStore];
        
        localCalendar.title = @"NTOU";
        
        // find local source
        EKSource *localSource = nil;
        for (EKSource *source in eventStore.sources){
            if (source.sourceType == EKSourceTypeLocal)
            {
                localSource = source;
                break;
            }
        }
        localCalendar.source = localSource;
        [eventStore saveCalendar:localCalendar commit:YES error:nil];
        
        if([userDefaults objectForKey:@"NTOUCalendarIdentifier"])
        {
            [userDefaults removeObjectForKey:@"NTOUCalendarIdentifier"];
        }
        [userDefaults setObject:localCalendar.calendarIdentifier forKey:@"NTOUCalendarIdentifier"];
        [userDefaults synchronize];
    }
}

//ios8 defaule is 0
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

@end
