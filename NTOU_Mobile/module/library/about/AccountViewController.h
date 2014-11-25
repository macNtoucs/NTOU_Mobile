//
//  AccountViewController.h
//  library-登入頁面
//
//  Created by apple on 13/8/22.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIView * loginView;
    UITextField *accounttextField;
    UITextField *passWordtextField;
}
@end
