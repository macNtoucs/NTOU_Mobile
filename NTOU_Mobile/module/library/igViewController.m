//
//  igViewController.m
//  ScanBarCodes
//  條碼掃描
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "igViewController.h"
#import "SearchResultViewController.h"
@interface igViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    NSString *detectStr;
    UIView *_highlightView;
    BOOL hasBeenDetect;   // UILabel *_label;
}
@end

@implementation igViewController
@synthesize mainview;
@synthesize switchCon;
-(void) viewWillAppear:(BOOL)animated{
    [self setComponent];
    [super viewWillAppear:animated];
}



-(void) viewWillDisappear:(BOOL)animated{
    [switchCon.another setTitle:@"條碼掃描"];
    [super viewDidDisappear:animated];
}


-(void) setComponent{
    hasBeenDetect = NO;
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
      _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setComponent];
    //[self.view bringSubviewToFront:_label];
}

-(void)search : (NSString*)str{
 
    SearchResultViewController * display = [[SearchResultViewController alloc]initWithStyle:UITableViewStylePlain];
    display.data = [[NSMutableArray alloc] init];
    display.inputtext = str;
    display.book_count = 10;
    display.start = NO;
    display.Searchpage=1;
    display.searchType = @"i";
    [display search];
    [mainview.navigationController pushViewController:display animated:YES];
    [display release];

}



/*
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==0) {
        [self search:detectStr];
    }
}


-(void)askShouldSearch:(NSString*) str{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"搜尋" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];

}*/

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
    if (  hasBeenDetect ==YES ) return;
    
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
      _highlightView.frame = highlightViewRect;
        detectStr = detectionString;
        if (detectionString != nil && [detectStr intValue]){
            hasBeenDetect =YES;
            [_session stopRunning];
            _session = nil;
            _device= nil;
           _input= nil;
           _output= nil;
           _prevLayer= nil;
           [self.view removeFromSuperview];
           [self search :detectionString];
        }
    
    }

}

@end