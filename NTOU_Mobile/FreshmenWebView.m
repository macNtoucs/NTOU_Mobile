//
//  FreshmenWebView.m
//  NTOU_Mobile
//
//  Created by Rick on 2014/9/1.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "FreshmenWebView.h"

@implementation FreshmenWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"newStudent"
                                                             ofType:@"html"
                                                        inDirectory:@"/freshmen" ];
        
        NSString *html = [NSString stringWithContentsOfFile:htmlPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        
        [self loadHTMLString:html baseURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/freshmen/",[[NSBundle mainBundle] bundlePath]]]];
        self.delegate = self;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
