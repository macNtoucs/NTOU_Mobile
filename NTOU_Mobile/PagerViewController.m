//
//  ViewController.m
//  PageViewController
//
//  Created by Tom Fewster on 11/01/2012.
//

#import "PagerViewController.h"

@interface PagerViewController ()
@property (assign) BOOL pageControlUsed;
@property (assign) NSUInteger page;
@property (assign) BOOL rotating;
- (void)loadScrollViewWithPage:(int)page;
@end

@implementation PagerViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize pageControlUsed = _pageControlUsed;
@synthesize page = _page;
@synthesize rotating = _rotating;

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    offset = 0.0;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-20, 0, 360, [[UIScreen mainScreen] bounds].size.height-100)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(360*[self.childViewControllers count], [[UIScreen mainScreen] bounds].size.height-100);
    
    for (int i = 0; i<[self.childViewControllers count]; i++){
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(360*i, 0, 360, [[UIScreen mainScreen] bounds].size.height-100)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(360, [[UIScreen mainScreen] bounds].size.height-100);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];
        
        UIViewController *controller = [self.childViewControllers objectAtIndex:i];
        controller.view.frame = CGRectMake(20, 0, 320, [[UIScreen mainScreen] bounds].size.height-100);
        [controller.view setContentMode:UIViewContentModeScaleAspectFit];
        controller.view.userInteractionEnabled = YES;
        controller.view.tag = i+1;
        [controller.view addGestureRecognizer:doubleTap];
        [s addSubview:controller.view];
        
        [self.scrollView addSubview:s];
        
        [doubleTap release];
        [s release];
    }
    
    [self.view addSubview:self.scrollView];
    
	/*
     for (NSUInteger i =0; i < [self.childViewControllers count]; i++) {
     [self loadScrollViewWithPage:i];
     }
     
     self.pageControl.currentPage = 0;
     _page = 0;
     [self.pageControl setNumberOfPages:[self.childViewControllers count]];
     
     UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
     if (viewController.view.superview != nil) {
     [viewController viewWillAppear:animated];
     }
     
     self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.childViewControllers count], scrollView.frame.size.height);*/
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([self.childViewControllers count]) {
		UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		if (viewController.view.superview != nil) {
			[viewController viewDidAppear:animated];
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	if ([self.childViewControllers count]) {
		UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		if (viewController.view.superview != nil) {
			[viewController viewWillDisappear:animated];
		}
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	if (viewController.view.superview != nil) {
		[viewController viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
}
/*
 - (void)loadScrollViewWithPage:(int)page {
 if (page < 0)
 return;
 if (page >= [self.childViewControllers count])
 return;
 
 // replace the placeholder if necessary
 UIViewController *controller = [self.childViewControllers objectAtIndex:page];
 if (controller == nil) {
 return;
 }
 
 // add the controller's view to the scroll view
 if (controller.view.superview == nil) {
 CGRect frame = self.scrollView.frame;
 frame.origin.x = frame.size.width * page;
 frame.origin.y = 0;
 controller.view.frame = frame;
 [self.scrollView addSubview:controller.view];
 }
 }
 */
- (void)previousPage {
	if (_page - 1 > 0) {
        
		// update the scroll view to the appropriate page
		CGRect frame = self.scrollView.frame;
		frame.origin.x = frame.size.width * (_page - 1);
		frame.origin.y = 0;
		
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page - 1];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		
		[self.scrollView scrollRectToVisible:frame animated:YES];
		
		self.pageControl.currentPage = _page - 1;
		// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
		_pageControlUsed = YES;
	}
}

- (void)nextPage {
	if (_page + 1 > self.pageControl.numberOfPages) {
		
		// update the scroll view to the appropriate page
		CGRect frame = self.scrollView.frame;
		frame.origin.x = frame.size.width * (_page + 1);
		frame.origin.y = 0;
		
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page + 1];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		
		[self.scrollView scrollRectToVisible:frame animated:YES];
		
		self.pageControl.currentPage = _page + 1;
		// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
		_pageControlUsed = YES;
	}
}

- (IBAction)changePage:(id)sender {
    int page = ((UIPageControl *)sender).currentPage;
	
	// update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
	UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
	UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[oldViewController viewWillDisappear:YES];
	[newViewController viewWillAppear:YES];
	
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
	UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[oldViewController viewDidDisappear:YES];
	[newViewController viewDidAppear:YES];
	
	_page = self.pageControl.currentPage;
}

-(NSString *)displayContent:(int) tag
{
    
    switch (tag) {
        case 1:
            return @"02-24629171";
            break;
        case 2:
            return @"02-24621098";
            break;
        case 3:
            return @"0936151863";
            break;
        case 4:
            return @"0910953652";
            break;
        case 5:
            return @"0937865330";
            break;
        case 6:
            return @"02-24650507";
            break;
        case 7:
            return @"02-24626759";
            break;
        case 8:
            return @"02-24625858";
            break;
        case 9:
            return @"02-24621957";
            break;
        case 10:
            return @"02-24636215";
            break;
        case 11:
            return @"02-24622099";
            break;
        case 12:
            return @"02-24629255";
            break;
        case 13:
            return @"02-24631868";
            break;
        case 14:
            return @"02-24633616";
            break;
        case 15:
            return @"02-24621632";
            break;
        case 16:
            return @"02-24629561";
            break;
        case 17:
            return @"02-24621462";
            break;
        case 18:
            return @"02-24626266";
            break;
        case 19:
            return @"02-24628585";
            break;
        case 20:
            return nil;
            break;
        case 21:
            return @"02-24625688";
            break;
        case 22:
            return @"02-24620700";
            break;
        case 23:
            return nil;
            break;
        case 24:
            return @"02-66375121";
            break;
        case 25:
            return @"02-24622294";
            break;
        case 26:
            return @"02-24637089";
            break;
        case 27:
            return @"02-24625888";
            break;
        case 28:
            return @"02-24628151";
            break;
        case 29:
            return @"02-24627799";
            break;
        case 30:
            return @"02-24623101";
            break;
        case 31:
            return @"02-24624226";
            break;
        case 32:
            return @"02-24622381";
            break;
        case 33:
            return @"02-24627260";
            break;
        case 34:
            return @"02-24637174";
            break;
        case 35:
            return @"02-24622130";
            break;
        case 36:
            return @"02-24636753";
            break;
        case 37:
            return @"02-24622099";
            break;
        case 38:
            return @"02-24631235";
            break;
        case 39:
            return @"02-24624026";
            break;
        case 40:
            return @"02-24632911";
            break;
        case 41:
            return @"02-24620845";
            break;
        case 42:
            return @"02-24620158";
            break;
        case 43:
            return @"02-24620185";
            break;
        case 44:
            return @"02-24621098";
            break;
        case 45:
            return @"02-24626002";
            break;
        case 46:
            return @"0981364816";
            break;
        case 47:
            return @"0977-503192";
            break;
        case 48:
            return @"02-24636928";
            break;
        case 49:
            return @"02-24620860";
            break;
        case 50:
            return @"02-24624362";
            break;
        case 51:
            return @"02-24627904";
            break;
        case 52:
            return @"02-24621158";
            break;
        case 53:
            return @"02-24633369";
            break;
        case 54:
            return @"02-24626962";
            break;
        case 55:
            return @"0936141312";
            break;
        case 56:
            return @"0986101218";
            break;
        case 57:
            return @"02-24628954";
            break;
        case 58:
            return @"02-24628001";
            break;
        case 59:
            return @"02-24635696";
            break;
        case 60:
            return @"02-24631198";
            break;
        case 61:
            return @"0960749858";
            break;
        case 62:
            return @"02-24622782";
            break;
        case 63:
            return @"02-24620082";
            break;
        case 64:
            return @"02-24628313";
            break;
        case 65:
            return @"02-24631003";
            break;
        case 66:
            return @"02-24622872";
            break;
        case 67:
            return @"02-24631894";
            break;
        case 68:
            return @"02-24622123";
            break;
        case 69:
            return @"02-24634746";
            break;
        case 70:
            return @"02-24628621";
            break;
        case 71:
            return @"02-24665291";
            break;
        case 72:
            return @"02-24663399";
            break;
        case 73:
            return @"02-24667701";
            break;
        case 74:
            return @"02-24655409";
            break;
        case 75:
            return @"02-24685199";
            break;
        case 76:
            return @"02-24666063";
            break;
        case 77:
            return @"02-24683985";
            break;
        case 78:
            return @"02-24669473";
            break;
        case 79:
            return @"02-24652023";
            break;
        case 80:
            return @"02-24684991";
            break;
        case 81:
            return @"02-24684173";
            break;
        case 82:
            return @"02-24655900";
            break;
        case 83:
            return @"02-24685030";
            break;
        case 84:
            return @"02-24666767";
            break;
        case 85:
            return @"02-24666000";
            break;
        case 86:
            return @"02-24652880";
            break;
        case 87:
            return @"02-24683189";
            break;
        case 88:
            return @"02-24660988";
            break;
        case 89:
            return @"02-24687101";
            break;
        case 90:
            return @"02-24665009";
            break;
        case 91:
            return @"02-24660577";
            break;
        case 92:
            return @"02-24650507";
            break;
        case 93:
            return @"02-24654548";
            break;
        case 94:
            return @"02-24622203";
            break;
        case 95:
            return @"02-24663285";
            break;
        case 96:
            return @"02-24666606";
            break;
        case 97:
            return @"02-24652258";
            break;
        case 98:
            return @"02-23128016";
            break;
        case 99:
            return @"02-24663488";
            break;
        case 100:
            return @"02-24685768";
            break;
        case 101:
            return @"02-24667094";
            break;
        case 102:
            return @"02-24603368";
            break;
        case 103:
            return @"02-24602602";
            break;
        case 104:
            return @"02-24601307";
            break;
        case 105:
            return @"02-24601533";
            break;
            
        case 106:
            return @"02-24603832";
            break;
        case 107:
            return @"02-24601356";
            break;
        case 108:
            return @"02-24601316";
            break;
        case 109:
            return @"02-24601425";
            break;
        case 110:
            return @"02-24601597";
            break;
        case 111:
            return @"02-24692788";
            break;
        case 112:
            return @"02-24692488";
            break;
        case 113:
            return @"02-24693531";
            break;
        case 114:
            return @"02-24695133";
            break;
        case 115:
            return @"02-24698466";
            break;
        case 116:
            return @"02-24697101";
            break;
        case 117:
            return @"02-24699222";
            break;
        case 118:
            return @"02-24692091";
            break;
        case 119:
            return @"02-24691937";
            break;
        case 120:
            return @"02-24690861";
            break;
        case 121:
            return @"02-24699896";
            break;
        case 122:
            return @"02-24698502";
            break;
        case 123:
            return @"02-24695888";
            break;
        case 124:
            return @"02-24694634";
            break;
        case 125:
            return @"02-77298202";
            break;
        case 126:
            return @"02-24695318";
            break;
        case 127:
            return @"02-24699439";
            break;
        case 128:
            return @"02-24693818";
            break;
        case 129:
            return @"02-24696678";
            break;
        case 130:
            return @"02-24692802";
            break;
        case 131:
            return @"02-23316540";
            break;
        case 132:
            return @"02-24692356";
            break;
        case 133:
            return @"02-24695698";
            break;
        case 134:
            return @"02-24691742";
            break;
        case 135:
            return @"02-24691743";
            break;
        case 136:
            return @"02-24692595";
            break;
        case 137:
            return @"02-24696780";
            break;
        case 138:
            return @"02-24699556";
            break;
        case 139:
            return nil;
            break;
        default:
            break;
    }
    return nil;
    
}

-(NSString *)displayTitle:(int) tag
{
    switch (tag) {
        case 1:
            return @"瓦諾其舟烘培坊";
            break;
        case 2:
            return @"捌壹捌麵館";
            break;
        case 3:
            return @"3Q Pie 脆皮雞排";
            break;
        case 4:
            return @"涼麵小舖";
            break;
        case 5:
            return @"小蘋果蔥抓餅";
            break;
        case 6:
            return @"三媽臭臭鍋";
            break;
        case 7:
            return @"星翔快餐店";
            break;
        case 8:
            return @"超大杯甜品屋";
            break;
        case 9:
            return @"合成便當";
            break;
        case 10:
            return @"吸-up 中正店";
            break;
        case 11:
            return @"全德眼鏡";
            break;
        case 12:
            return @"董月花奶鋪";
            break;
        case 13:
            return @"鼎乃鮮小火鍋";
            break;
        case 14:
            return @"鴨香寶燒臘";
            break;
        case 15:
            return @"中正區衛生所";
            break;
        case 16:
            return @"隆誠機車";
            break;
        case 17:
            return @"來來炒飯";
            break;
        case 18:
            return @"清心福全中正店";
            break;
        case 19:
            return @"宜蘭包子店";
            break;
        case 20:
            return @"新嘉村用品行";
            break;
        case 21:
            return @"佬地方牛排";
            break;
        case 22:
            return @"阿玉炒飯/麵";
            break;
        case 23:
            return @"哈樂百貨買場";
            break;
        case 24:
            return @"OK便利商店 和平店";
            break;
        case 25:
            return @"仁人診所";
            break;
        case 26:
            return @"永和豆漿";
            break;
        case 27:
            return @"霸味薑母鴨";
            break;
        case 28:
            return @"和平大藥局";
            break;
        case 29:
            return @"海洋診所";
            break;
        case 30:
            return @"大學藥局";
            break;
        case 31:
            return @"全聯 中正店";
            break;
        case 32:
            return @"加油站 中正路";
            break;
        case 33:
            return @"全家 新祥豐店";
            break;
        case 34:
            return @"7-11 海洋店";
            break;
        case 35:
            return @"食神涮涮鍋";
            break;
        case 36:
            return @"港式便當";
            break;
        case 37:
            return @"超級雞車";
            break;
        case 38:
            return @"家薌牛肉麵";
            break;
        case 39:
            return @"切仔麵";
            break;
        case 40:
            return @"益文影印/文具";
            break;
        case 41:
            return @"早安美芝城";
            break;
        case 42:
            return @"超羣滷味/鹽酥雞";
            break;
        case 43:
            return @"好了啦紅茶冰";
            break;
        case 44:
            return @"紅燒牛肉麵";
            break;
        case 45:
            return @"正老店鹽酥雞/炭烤";
            break;
        case 46:
            return @"微笑11炭烤";
            break;
        case 47:
            return @"金釵越南美食";
            break;
        case 48:
            return @"阿邦燒臘";
            break;
        case 49:
            return @"CC早午餐專賣";
            break;
        case 50:
            return @"光泰影印";
            break;
        case 51:
            return @"瑞麟美而美";
            break;
        case 52:
            return @"古早味麵店";
            break;
        case 53:
            return @"北海影印";
            break;
        case 54:
            return @"20元麵店";
            break;
        case 55:
            return @"富而美早餐店";
            break;
        case 56:
            return @"陽光早餐店";
            break;
        case 57:
            return @"海洋麵店";
            break;
        case 58:
            return @"弘揚電腦維修";
            break;
        case 59:
            return @"豪嘉粥品";
            break;
        case 60:
            return @"日久阿囉哈";
            break;
        case 61:
            return @"北寧早餐店";
            break;
        case 62:
            return @"北寧牙科";
            break;
        case 63:
            return @"Double A 影印店";
            break;
        case 64:
            return @"振煒車業";
            break;
        case 65:
            return @"Double A 影印店";
            break;
        case 66:
            return @"東方影印";
            break;
        case 67:
            return @"東北機車";
            break;
        case 68:
            return @"美姿客披薩";
            break;
        case 69:
            return @"明益機車";
            break;
        case 70:
            return @"加油站";
            break;
        case 71:
            return @"屈臣氏";
            break;
        case 72:
            return @"必勝客";
            break;
        case 73:
            return @"吸-up 深溪店";
            break;
        case 74:
            return @"豐逸電腦醫生";
            break;
        case 75:
            return @"勁站車業";
            break;
        case 76:
            return @"瀚翔骨科";
            break;
        case 77:
            return @"小不點健保藥局";
            break;
        case 78:
            return @"和蕎屋壽司料理店";
            break;
        case 79:
            return @"和春蔘藥行";
            break;
        case 80:
            return @"1加1複合式早餐";
            break;
        case 81:
            return @"超運西點蛋糕";
            break;
        case 82:
            return @"你來旺熱炒";
            break;
        case 83:
            return @"同慶堂養生御膳房";
            break;
        case 84:
            return @"1212眼鏡";
            break;
        case 85:
            return @"竹間精緻鍋物";
            break;
        case 86:
            return @"小牧牛紅燒牛肉麵";
            break;
        case 87:
            return @"明洞韓式料理";
            break;
        case 88:
            return @"半桶水魯肉飯";
            break;
        case 89:
            return @"寶賢連鎖騎士精品";
            break;
        case 90:
            return @"康美診所";
            break;
        case 91:
            return @"百分百光學眼鏡";
            break;
        case 92:
            return @"三媽臭臭鍋";
            break;
        case 93:
            return @"頂好超市";
            break;
        case 94:
            return @"清心福全深溪店";
            break;
        case 95:
            return @"井上園日本料理";
            break;
        case 96:
            return @"來怡客牛排";
            break;
        case 97:
            return @"老三無刺虱目魚";
            break;
        case 98:
            return @"愛買";
            break;
        case 99:
            return @"富樂台式涮涮鍋";
            break;
        case 100:
            return @"福鍋涮涮鍋";
            break;
        case 101:
            return @"口福美鐵板燒";
            break;
        case 102:
            return @"馬德里診所";
            break;
        case 103:
            return @"十三鼎風味小火鍋";
            break;
        case 104:
            return @"超時代專業眼鏡";
            break;
        case 105:
            return @"郵局 新豐街";
            break;
        case 106:
            return @"頂好超市";
            break;
        case 107:
            return @"博群診所";
            break;
        case 108:
            return @"承泰藥局";
            break;
        case 109:
            return @"漫画學苑";
            break;
        case 110:
            return @"山海屋鐵板燒";
            break;
        case 111:
            return @"董娘精緻水餃";
            break;
        case 112:
            return @"八方雲集";
            break;
        case 113:
            return @"一頂鍋燒麵專賣店";
            break;
        case 114:
            return @"芸瑄味";
            break;
        case 115:
            return @"太陽堂中藥行";
            break;
        case 116:
            return @"禾豐101診所";
            break;
        case 117:
            return @"海大健保藥局";
            break;
        case 118:
            return @"麥當勞 新豐店";
            break;
        case 119:
            return @"酒居日式料理";
            break;
        case 120:
            return @"星空義大利麵";
            break;
        case 121:
            return @"QQ滷肉飯";
            break;
        case 122:
            return @"金旺港式燒腊店";
            break;
        case 123:
            return @"士林豪大大雞排";
            break;
        case 124:
            return @"饕客便當";
            break;
        case 125:
            return @"康是美";
            break;
        case 126:
            return @"7-11 財高店";
            break;
        case 127:
            return @"coco都可茶飲";
            break;
        case 128:
            return @"大麥穗法式烘培坊";
            break;
        case 129:
            return @"豐小館";
            break;
        case 130:
            return @"張師傅專業烘培";
            break;
        case 131:
            return @"ComeBuy";
            break;
        case 132:
            return @"全家 新豐店";
            break;
        case 133:
            return @"生活品味自助餐";
            break;
        case 134:
            return @"瑞美娥自助餐";
            break;
        case 135:
            return @"德利鎖店";
            break;
        case 136:
            return @"休閒小站";
            break;
        case 137:
            return @"湘誼小館";
            break;
        case 138:
            return @"大胖子古早味麵疙瘩";
            break;
        case 139:
            return @"好味鵝肉店";
            break;
        default:
            break;
    }
    return nil;
}

-(IBAction)displayInfomation:(id)sender
{
    UIButton* button = sender;
    if (button.tag) {
        UIAlertView *loadingAlertView;
        if ([self displayContent:button.tag]) {
            loadingAlertView = [[UIAlertView alloc]
                                initWithTitle:[self displayTitle:button.tag]message:[self displayContent:button.tag]
                                delegate:self cancelButtonTitle:@"確定"
                                otherButtonTitles:@"撥號",nil];
        }
        else
            loadingAlertView = [[UIAlertView alloc]
                                initWithTitle:[self displayTitle:button.tag]message:[self displayContent:button.tag]
                                delegate:self cancelButtonTitle:@"確定"
                                otherButtonTitles:nil];
        [loadingAlertView show];
        [loadingAlertView release];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@",alertView.message]];
        [[ UIApplication sharedApplication]openURL:url];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed || _rotating) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (self.pageControl.currentPage != page) {
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		self.pageControl.currentPage = page;
		[oldViewController viewDidDisappear:YES];
		[newViewController viewDidAppear:YES];
		_page = page;
	}
}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)View{
    
    for (UIView *v in View.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)View{
    _pageControlUsed = NO;
    if (View == self.scrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in View.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.frame = CGRectMake(20, 0, 320, [[UIScreen mainScreen] bounds].size.height-100);
                }
            }
        }
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        if (scrollView.zoomScale<1.0){
            //         v.center = CGPointMake(scrollView.frame.size.width/2.0, scrollView.frame.size.height/2.0);
        }
    }
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    UIView *view = gesture.view.superview;
    if ([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *s = (UIScrollView *)view;
        [s zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark - Utility methods

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(CGRect)resizeImageSize:(CGRect)rect{
    //    NSLog(@"x:%f y:%f width:%f height:%f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGRect newRect;
    
    CGSize newSize;
    CGPoint newOri;
    
    CGSize oldSize = rect.size;
    if (oldSize.width>=320.0 || oldSize.height>=460.0){
        float scale = (oldSize.width/320.0>oldSize.height/460.0?oldSize.width/320.0:oldSize.height/460.0);
        newSize.width = oldSize.width/scale;
        newSize.height = oldSize.height/scale;
    }
    else {
        newSize = oldSize;
    }
    newOri.x = (320.0-newSize.width)/2.0;
    newOri.y = (460.0-newSize.height)/2.0;
    
    newRect.size = newSize;
    newRect.origin = newOri;
    
    return newRect;
}


@end

