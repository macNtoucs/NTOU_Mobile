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
            return @"02-24627260";
            break;
        case 2:
            return nil;
            break;
        case 3:
            return @"02-24637174";
            break;
        case 4:
            return @"02-24622130";
            break;
        case 5:
            return @"02-24632753";
            break;
        case 6:
            return @"02-24622099";
            break;
        case 7:
            return nil;
            break;
        case 8:
            return @"02-24629171";
            break;
        case 9:
            return @"02-24627777";
            break;
        case 10:
            return @"02-24624621";
            break;
        case 11:
            return @"02-24636959";
            break;
        case 12:
            return @"0936151863";
            break;
        case 13:
            return @"0910953652";
            break;
        case 14:
            return @"0937865330";
            break;
        case 15:
            return @"02-24650507";
            break;
        case 16:
            return @"02-24631558";
            break;
        case 17:
            return @"02-24624991";
            break;
        case 18:
            return @"0919249660";
            break;
        case 19:
            return @"02-24626759";
            break;
        case 20:
            return @"02-24625858";
            break;
        case 21:
            return @"02-24621957";
            break;
        case 22:
            return @"02-24636215";
            break;
        case 23:
            return @"02-24622099";
            break;
        case 24:
            return @"02-24632280";
            break;
        case 25:
            return @"02-24631868";
            break;
        case 26:
            return @"02-24632928";
            break;
        case 27:
            return @"02-24633616";
            break;
        case 28:
            return @"02-24629561";
            break;
        case 29:
            return @"02-24629561";
            break;
        case 30:
            return @"02-24621462";
            break;
        case 31:
            return @"02-24626266";
            break;
        case 32:
            return @"02-24628585";
            break;
        case 33:
            return nil;
            break;
        case 34:
            return nil;
            break;
        case 35:
            return @"02-24625688";
            break;
        case 36:
            return @"02-24620700";
            break;
        case 37:
            return @"02-24624529";
            break;
        case 38:
            return @"02-66375121";
            break;
        case 39:
            return @"02-24622294";
            break;
        case 40:
            return @"02-24637089";
            break;
        case 41:
            return @"02-24625888";
            break;
        case 42:
            return @"02-24628151";
            break;
        case 43:
            return @"02-24627799";
            break;
        case 44:
            return @"02-24623101";
            break;
        case 45:
            return @"02-24622588";
            break;
        case 46:
            return @"02-24624226";
            break;
        case 47:
            return @"02-24622381";
            break;
        case 48:
            return @"02-24624026";
            break;
        case 49:
            return @"02-24620767";
            break;
        case 50:
            return @"02-24631235";
            break;
        case 51:
            return @"02-24620845";
            break;
        case 52:
            return @"02-24627904";
            break;
        case 53:
            return @"02-24620158";
            break;
        case 54:
            return @"02-24620185";
            break;
        case 55:
            return @"02-24621098";
            break;
        case 56:
            return @"02-24626012";
            break;
        case 57:
            return @"0910815092";
            break;
        case 58:
            return @"0977503192";
            break;
        case 59:
            return @"02-24636928";
            break;
        case 60:
            return @"02-24620860";
            break;
        case 61:
            return @"02-24624362";
            break;
        case 62:
            return @"02-24624778";
            break;
        case 63:
            return @"02-24621158";
            break;
        case 64:
            return @"02-24621336";
            break;
        case 65:
            return @"02-24633369";
            break;
        case 66:
            return @"02-24626962";
            break;
        case 67:
            return @"0936141312";
            break;
        case 68:
            return @"0986101218";
            break;
        case 69:
            return @"02-24628954";
            break;
        case 70:
            return @"02-24628001";
            break;
        case 71:
            return @"02-24635696";
            break;
        case 72:
            return @"0978652824";
            break;
        case 73:
            return @"02-24631198";
            break;
        case 74:
            return @"0960749858";
            break;
        case 75:
            return @"02-24622782";
            break;
        case 76:
            return @"02-24620082";
            break;
        case 77:
            return @"02-24628313";
            break;
        case 78:
            return @"02-24631003";
            break;
        case 79:
            return @"02-24622872";
            break;
        case 80:
            return @"02-24631894";
            break;
        case 81:
            return @"02-24622123";
            break;
        case 82:
            return @"02-24634746";
            break;
        case 83:
            return @"02-24628621";
            break;
        case 84:
            return @"02-24663826";
            break;
        case 85:
            return @"02-24665009";
            break;
        case 86:
            return @"02-24660577";
            break;
        case 87:
            return nil;
            break;
        case 88:
            return @"02-24669137";
            break;
        case 89:
            return @"02-24650507";
            break;
        case 90:
            return @"02-24684121";
            break;
        case 91:
            return @"02-24662203";
            break;
        case 92:
            return @"02-24666085";
            break;
        case 93:
            return @"0912-502511";
            break;
        case 94:
            return nil;
            break;
        case 95:
            return @"02-24666606";
            break;
        case 96:
            return @"02-24660262";
            break;
        case 97:
            return @"02-24663285";
            break;
        case 98:
            return @"02-24652258";
            break;
        case 99:
            return @"0800-089-899";
            break;
        case 100:
            return @"02-2466-4299";
            break;
        case 101:
            return @"02-24654548";
            break;
        case 102:
            return @"02-24685768";
            break;
        case 103:
            return @"02-24655559";
            break;
        case 104:
            return @"02-24665291";
            break;
        case 105:
            return @"02-24663399";
            break;
            
        case 106:
            return @"02-24680531";
            break;
        case 107:
            return @"02-24667701";
            break;
        case 108:
            return @"02-24668686";
            break;
        case 109:
            return @"02-24653138";
            break;
        case 110:
            return @"02-24684038";
            break;
        case 111:
            return @"0936-155870";
            break;
        case 112:
            return @"02-24685199";
            break;
        case 113:
            return @"02-24660606";
            break;
        case 114:
            return @"02-24655409";
            break;
        case 115:
            return @"02-24666063";
            break;
        case 116:
            return @"02-24680294";
            break;
        case 117:
            return @"02-24650085";
            break;
        case 118:
            return @"02-24683985";
            break;
        case 119:
            return @"02-24652877";
            break;
        case 120:
            return @"02-24669473";
            break;
        case 121:
            return @"02-24652023";
            break;
        case 122:
            return @"02-24684173";
            break;
        case 123:
            return @"02-24661531";
            break;
        case 124:
            return @"02-24683311";
            break;
        case 125:
            return @"02-24655900";
            break;
        case 126:
            return @"02-24685030";
            break;
        case 127:
            return @"02-24660809";
            break;
        case 128:
            return @"02-24685000";
            break;
        case 129:
            return @"02-24683237";
            break;
        case 130:
            return @"02-24666000";
            break;
        case 131:
            return @"02-24652880";
            break;
        case 132:
            return nil;
            break;
        case 133:
            return @"02-24667094";
            break;
        case 134:
            return @"0910-465321";
            break;
        case 135:
            return @"02-24883189";
            break;
        case 136:
            return @"02-24660988";
            break;
        case 137:
            return @"02-24692242";
            break;
        case 138:
            return @"02-24698502";
            break;
        case 139:
            return @"02-24695888";
            break;
        case 140:
            return @"02-24694634";
            break;
        case 141:
            return nil;
            break;
        case 142:
            return nil; //7-11 新豐
            break;
        case 143:
            return @"02-24699439";
            break;
        case 144:
            return @"02-24693818";
            break;
        case 145:
            return @"02-24696678";
            break;
        case 146:
            return @"02-24693108";
            break;
        case 147:
            return nil;
            break;
        case 148:
            return nil;
            break;
        case 149:
            return @"02-24691742";
            break;
        case 150:
            return @"0936118169";
            break;
        case 151:
            return @"02-24692595";
            break;
        case 152:
            return @"02-24696780";
            break;
        case 153:
            return nil;
            break;
        case 154:
            return @"02-24695133";
            break;
        case 155:
            return nil;
            break;
        case 156:
            return @"02-24698466";
            break;
        case 157:
            return @"02-24699912";
            break;
        case 158:
            return nil;
            break;
        case 159:
            return nil;
            break;
        case 160:
            return nil;
            break;
        case 161:
            return @"02-24696971";
            break;
        case 162:
            return @"02-24693961";
            break;
        case 163:
            return @"02-24697101";
            break;
        case 164:
            return @"02-24699222";
            break;
        case 165:
            return @"02-24692091";
            break;
        case 166:
            return @"02-24691937";
            break;
        case 167:
            return @"02-24690861";
            break;
        case 168:
            return @"02-24690080";
            break;
        case 169:
            return @"02-24603368";
            break;
        case 170:
            return @"02-24602602";
            break;
        case 171:
            return @"02-24601307";
            break;
        case 172:
            return @"02-24601533";
            break;
        case 173:
            return nil;
            break;
        case 174:
            return @"02-24601356";
            break;
        case 175:
            return @"02-24601316";
            break;
        case 176:
            return @"02-24601425";
            break;
        case 177:
            return @"02-24601597";
            break;
        case 178:
            return @"02-24692488";
            break;
        case 179:
            return @"02-24692488";
            break;
        case 180:
            return @"02-24693531";
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
            return @"全家新祥豐店";
            break;
        case 2:
            return @"海洋撞球";
            break;
        case 3:
            return @"7-11海洋店";
            break;
        case 4:
            return @"食神涮涮鍋";
            break;
        case 5:
            return @"港式便當";
            break;
        case 6:
            return @"超級機車";
            break;
        case 7:
            return @"陳家麵店";
            break;
        case 8:
            return @"瓦諾其舟烘焙坊";
            break;
        case 9:
            return @"海大媽咪pizza";
            break;
        case 10:
            return @"捌壹捌麵館";
            break;
        case 11:
            return @"OZ飲料滷味";
            break;
        case 12:
            return @"3Q Pie 脆皮雞排";
            break;
        case 13:
            return @"涼麵小舖";
            break;
        case 14:
            return @"小蘋果蔥抓餅";
            break;
        case 15:
            return @"三媽臭臭鍋";
            break;
        case 16:
            return @"2D水";
            break;
        case 17:
            return @"駭客網路生活館";
            break;
        case 18:
            return @"寶妹雲泰料理";
            break;
        case 19:
            return @"星翔快餐屋";
            break;
        case 20:
            return @"超大杯甜品屋";
            break;
        case 21:
            return @"合成便當";
            break;
        case 22:
            return @"吸-up中正店";
            break;
        case 23:
            return @"全德眼鏡";
            break;
        case 24:
            return @"兩披索小火鍋";
            break;
        case 25:
            return @"鼎乃鮮小火鍋";
            break;
        case 26:
            return @"Apple203早午餐";
            break;
        case 27:
            return @"鴨香飽燒臘";
            break;
        case 28:
            return @"中正區衛生所";
            break;
        case 29:
            return @"隆誠機車";
            break;
        case 30:
            return @"來來炒飯";
            break;
        case 31:
            return @"清心福全中正店";
            break;
        case 32:
            return @"宜蘭包子店";
            break;
        case 33:
            return @"投幣式洗衣店";
            break;
        case 34:
            return @"新嘉村用品行";
            break;
        case 35:
            return @"佬地方牛排";
            break;
        case 36:
            return @"阿玉炒飯/麵";
            break;
        case 37:
            return @"哈樂百貨賣場";
            break;
        case 38:
            return @"OK便利商店 和平店";
            break;
        case 39:
            return @"仁人診所";
            break;
        case 40:
            return @"永和豆漿";
            break;
        case 41:
            return @"霸味薑母鴨";
            break;
        case 42:
            return @"和平大藥局";
            break;
        case 43:
            return @"海洋診所";
            break;
        case 44:
            return @"大學藥局";
            break;
        case 45:
            return @"光陽機車";
            break;
        case 46:
            return @"全聯中正店";
            break;
        case 47:
            return @"加油站中正店";
            break;
        case 48:
            return @"切仔麵";
            break;
        case 49:
            return @"益文影印/文具";
            break;
        case 50:
            return @"家薌牛肉麵";
            break;
        case 51:
            return @"早安美芝城";
            break;
        case 52:
            return @"瑞麟美而美";
            break;
        case 53:
            return @"超羣滷味/鹽酥雞";
            break;
        case 54:
            return @"好了啦紅茶冰";
            break;
        case 55:
            return @"味美紅燒牛肉麵";
            break;
        case 56:
            return @"正老店鹽酥雞/炭烤";
            break;
        case 57:
            return @"美味蛋飯";
            break;
        case 58:
            return @"晶彩麵飯館";
            break;
        case 59:
            return @"阿邦燒臘";
            break;
        case 60:
            return @"CC早午餐專賣";
            break;
        case 61:
            return @"光泰影印";
            break;
        case 62:
            return @"早安媽中西韓美食館";
            break;
        case 63:
            return @"古早味麵店";
            break;
        case 64:
            return @"讚美餐飲坊";
            break;
        case 65:
            return @"北海影印";
            break;
        case 66:
            return @"20元麵店";
            break;
        case 67:
            return @"富而美早餐店";
            break;
        case 68:
            return @"陽光早餐店";
            break;
        case 69:
            return @"海洋麵店";
            break;
        case 70:
            return @"弘揚科技";
            break;
        case 71:
            return @"豪嘉粥品";
            break;
        case 72:
            return @"日久阿羅哈";
            break;
        case 73:
            return @"北寧早餐店";
            break;
        case 74:
            return @"北寧牙科";
            break;
        case 75:
            return @"Double A 影印店";
            break;
        case 76:
            return @"振煒車業";
            break;
        case 77:
            return @"Double A 影印店";
            break;
        case 78:
            return @"東方影印";
            break;
        case 79:
            return @"東北機車";
            break;
        case 80:
            return @"美滋客披薩";
            break;
        case 81:
            return @"名益機車";
            break;
        case 82:
            return @"加油站";
            break;
        case 83:
            return @"元登藥局";
            break;
        case 84:
            return @"康美診所";
            break;
        case 85:
            return @"百分百光學";
            break;
        case 86:
            return @"寶賢騎士精品";
            break;
        case 87:
            return @"速必利乾洗";
            break;
        case 88:
            return @"三媽臭臭鍋";
            break;
        case 89:
            return @"至尊鵝攤";
            break;
        case 90:
            return @"清心";
            break;
        case 91:
            return @"美而美";
            break;
        case 92:
            return @"自助洗衣";
            break;
        case 93:
            return @"JIT快剪";
            break;
        case 94:
            return @"來怡客";
            break;
        case 95:
            return @"美芝城";
            break;
        case 96:
            return @"井上園";
            break;
        case 97:
            return @"老三無刺虱目魚";
            break;
        case 98:
            return @"CQ2快剪";
            break;
        case 99:
            return @"愛買";
            break;
        case 100:
            return @"富樂涮涮鍋";
            break;
        case 101:
            return @"頂好";
            break;
        case 102:
            return @"福鍋";
            break;
        case 103:
            return @"QQ魯肉飯";
            break;
        case 104:
            return @"屈臣氏";
            break;
        case 105:
            return @"必勝客";
            break;
        case 106:
            return @"靈智科技";
            break;
        case 107:
            return @"遠傳";
            break;
        case 108:
            return @"白帥乾洗";
            break;
        case 109:
            return @"吸-up";
            break;
        case 110:
            return @"費絲髮型";
            break;
        case 111:
            return @"可樂洗衣";
            break;
        case 112:
            return @"勁站車業";
            break;
        case 113:
            return @"Rado理髮";
            break;
        case 114:
            return @"豐逸電腦醫生";
            break;
        case 115:
            return @"瀚翔骨科";
            break;
        case 116:
            return @"巧雅美髮";
            break;
        case 117:
            return @"Apple203";
            break;
        case 118:
            return @"小不點健保藥局";
            break;
        case 119:
            return @"密酥雞排";
            break;
        case 120:
            return @"和蕎屋";
            break;
        case 121:
            return @"和春蔘藥行";
            break;
        case 122:
            return @"超運西點";
            break;
        case 123:
            return @"正義國術";
            break;
        case 124:
            return @"中華電信";
            break;
        case 125:
            return @"你來旺熱炒";
            break;
        case 126:
            return @"同慶堂";
            break;
        case 127:
            return @"德瑞克的美嚷";
            break;
        case 128:
            return @"媽媽咪呀";
            break;
        case 129:
            return @"天嚐地酒";
            break;
        case 130:
            return @"竹間";
            break;
        case 131:
            return @"小牧牛";
            break;
        case 132:
            return @"順豐水果";
            break;
        case 133:
            return @"口福美";
            break;
        case 134:
            return @"桶Q飯糰";
            break;
        case 135:
            return @"明洞韓式料理";
            break;
        case 136:
            return @"半桶水魯肉飯";
            break;
        case 137:
            return @"QQ滷肉飯";
            break;
        case 138:
            return @"金旺港式燒臘";
            break;
        case 139:
            return @"士林豪大大雞排";
            break;
        case 140:
            return @"50元便當";
            break;
        case 141:
            return @"康是美";
            break;
        case 142:
            return @"SEVEN-ELEVEN";
            break;
        case 143:
            return @"Coco 都可茶飲";
            break;
        case 144:
            return @"大麥穗烘焙坊";
            break;
        case 145:
            return @"豐小館";
            break;
        case 146:
            return @"張師傅麵包店";
            break;
        case 147:
            return @"全家便利商店";
            break;
        case 148:
            return @"生活品味自助餐";
            break;
        case 149:
            return @"瑞美娥自助餐便當";
            break;
        case 150:
            return @"德利鎖店";
            break;
        case 151:
            return @"休閒小站";
            break;
        case 152:
            return @"湘誼小館";
            break;
        case 153:
            return @"大滷桶滷味";
            break;
        case 154:
            return @"芸宣味";
            break;
        case 155:
            return @"好味鴨肉店";
            break;
        case 156:
            return @"太陽堂中藥行";
            break;
        case 157:
            return @"瑞麟美而美";
            break;
        case 158:
            return @"信三肉圓";
            break;
        case 159:
            return @"永和豆漿";
            break;
        case 160:
            return @"紀香無骨炸雞";
            break;
        case 161:
            return @"永亨炸雞(蒜香)";
            break;
        case 162:
            return @"光陽機車";
            break;
        case 163:
            return @"禾豐101診所";
            break;
        case 164:
            return @"海大健保藥局";
            break;
        case 165:
            return @"麥當勞";
            break;
        case 166:
            return @"酒居日本料理";
            break;
        case 167:
            return @"星空義大利麵";
            break;
        case 168:
            return @"愛咖啡";
            break;
        case 169:
            return @"馬德里診所";
            break;
        case 170:
            return @"十三鼎小火鍋";
            break;
        case 171:
            return @"超時代眼鏡";
            break;
        case 172:
            return @"郵局";
            break;
        case 173:
            return @"頂好";
            break;
        case 174:
            return @"博群診所";
            break;
        case 175:
            return @"承泰藥局";
            break;
        case 176:
            return @"漫畫學苑";
            break;
        case 177:
            return @"山海屋鐵板燒";
            break;
        case 178:
            return @"董娘水餃";
            break;
        case 179:
            return @"八方雲集";
            break;
        case 180:
            return @"一頂鍋燒麵";
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



