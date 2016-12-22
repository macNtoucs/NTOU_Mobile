//
//  StreetViewViewController.h
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/12/22.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreetViewViewController : UIViewController{
    double m_latitude;
    double m_longitude;
}

-(void)setLatitude:(double)latitude setLongitude:(double)longitude;

@end
