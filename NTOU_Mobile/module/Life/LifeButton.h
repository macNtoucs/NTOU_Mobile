//
//  LifeButton.h
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/12/5.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeButton : UIButton

@property (nonatomic,retain)NSDictionary* data; //存放json內的資料

/* Example (詳細情況參閱Android組API說明)
 
 {
 "id":"L24",
 "phone":"__",
 "street":"祥豐街",
 "name":"香米湯湯",
 "longitude":"121.771704",
 "latitude":"25.149361",
 "type":"早午晚餐/休閒食品"
 }
 
*/

@end
