//
//  QRCameraViewController.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "QRCameraViewController.h"

@interface QRCameraViewController ()
@property UIView* cameraLiveView;
@property UIImageView* imageView;
@property BOOL qrCodeRecognized;
@property CIContext* context;
@property LiveCameraComponent* cameraComponent;
@property UIView* recognizeZoneView;
@property CGRect recognizeRect;
@property int frameCounter;
@end

@implementation QRCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cameraLiveView = [[UIView alloc] init];
    self.recognizeZoneView = [[UIView alloc] init];
    self.imageView = [[UIImageView alloc] init];
    CGSize viewSize = self.view.bounds.size;
    self.recognizeRect = CGRectMake(viewSize.width / 2 - viewSize.width / 4, viewSize.height / 2 - viewSize.width / 4, viewSize.width / 2, viewSize.width / 2);
    [self loadViews];
    self.cameraComponent = [[LiveCameraComponent alloc] initWithZone:self.recognizeRect AndMode:exportCroppedImage];
    self.cameraComponent.delegate = self;
    self.qrCodeRecognized = false;
    self.frameCounter = 0;
    self.context = [[CIContext alloc] init];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self cameraComponent] capturePositionConfiguration];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cameraLiveView.layer addSublayer:self.cameraComponent.previewView];
        self.cameraComponent.startCaptureSession;
    });
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.cameraComponent.stopCaptureSession;
}

#pragma mark: - layout view in screen
- (void) loadViews {
    self.navigationItem.title = @"Scan";
    self.navigationItem.backBarButtonItem.title = @"Back";
    self.view.backgroundColor = [UIColor whiteColor];
    self.cameraLiveView.backgroundColor = [UIColor blackColor];
    self.recognizeZoneView.backgroundColor = [UIColor clearColor];
    self.recognizeZoneView.layer.borderColor = [UIColor blueColor].CGColor;
    self.recognizeZoneView.layer.borderWidth = 4.0;
    //[[self view] addSubview:self.cameraLiveView];
    [[self view] addSubview:self.imageView];
    [[self imageView] addSubview:self.recognizeZoneView];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize viewSize = self.view.frame.size;
    self.cameraLiveView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    self.imageView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    self.recognizeZoneView.frame = self.recognizeRect;
}

- (void) capturedAndCroppedImage:(CIImage *)image {
    self.frameCounter++;
    __weak __typeof(self) weakSelf = self;
    if (!self.qrCodeRecognized) {
        [[QRDecodeManager managerInstance] addImageToDecodeSession:image WithCompletionHandler:^(NSString* result, NSException* exception) {
            if (result) {
                [[QRDecodeManager managerInstance] cancelProcessingRemainImage];
                weakSelf.qrCodeRecognized = true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf showScanResult:result];
                });
            }
        }];
    }
}

- (void) capturedWithCroppedAndCompressImage:(CIImage *)image {
    __weak __typeof(self) weakSelf = self;
    if (!self.qrCodeRecognized) {
        [[QRDecodeManager managerInstance] addImageToDecodeSession:image WithCompletionHandler:^(NSString* result, NSException* exception) {
            if (result) {
                [[QRDecodeManager managerInstance] cancelProcessingRemainImage];
                weakSelf.qrCodeRecognized = true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf showScanResult:result];
                });
            }
        }];
    }
}

- (void) capturedImage:(CIImage *)image {
    CIImage* ciImage = [image imageByApplyingCGOrientation:kCGImagePropertyOrientationRight];
    if (self.frameCounter == 100) {
        self.cameraComponent.stopCaptureSession;
        
        UIImage *croppedImg = nil;
        [UI]
        
        DemoViewController* demo = [[DemoViewController alloc] initWithImage:croppedImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self navigationController] pushViewController:demo animated:true];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = [UIImage imageWithCIImage:ciImage];
    });
}

- (void) showScanResult:(NSString*) result {
    __weak __typeof(self) weakSelf = self;
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Scanning result" message:result preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* copyAction = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = result;
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
        weakSelf.qrCodeRecognized = false;
    }];
    [alertController addAction:copyAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void) getPermissionNotification:(NSString *)notify {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Access Permission" message:notify preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}
@end
