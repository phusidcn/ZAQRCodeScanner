//
//  LiveCameraComponent.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 9/6/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "LiveCameraComponent.h"

@implementation LiveCameraComponent
- (instancetype) initWithZone:(CGRect)recognizeZone AndMode:(exportMode) mode {
    self = [super init];
    if (self) {
        self.mode = mode;
        self.sessionQueue = dispatch_queue_create("com.camera.session", DISPATCH_QUEUE_SERIAL);
        [self getPermissionForDevice];
        self.session = [[AVCaptureSession alloc] init];
        self.recognizeZone = recognizeZone;
    }
    return self;
}

- (void) getPermissionForDevice {
    __weak __typeof(self) weakSelf = self;
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusDenied:
            self.accessGranted = false;
            [[self delegate] getPermissionNotification:@"Access Denined"];
            break;
        case AVAuthorizationStatusAuthorized:
            self.accessGranted = true;
            break;
        case AVAuthorizationStatusRestricted:
            self.accessGranted = false;
            [[self delegate] getPermissionNotification:@"Access Restricted"];
            break;
        case AVAuthorizationStatusNotDetermined:
            dispatch_suspend(self.sessionQueue);
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                weakSelf.accessGranted = granted;
                if (!granted) {
                    [[self delegate] getPermissionNotification:@"Access not granted"];
                }
                dispatch_resume(self.sessionQueue);
            }];
            break;
    }
}

- (void) capturePositionConfiguration {
    self.devicePosition = AVCaptureDevicePositionBack;
    self.preset = AVCaptureSessionPresetHigh;
    self.device = [self selectCaptureDevice];
    self.inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if ([[self session] canAddInput:self.inputDevice]) {
        [[self session] addInput:self.inputDevice];
        self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];
        self.dataOutputQueue = dispatch_queue_create("data.output.queue", DISPATCH_QUEUE_SERIAL);
        [[self dataOutput] setSampleBufferDelegate:self queue:self.dataOutputQueue];
        if ([[self session] canAddOutput:self.dataOutput]) {
            [[self session] addOutput:self.dataOutput];
            [self previewCaptureScreen];
        }
    }
}

- (AVCaptureDevice*) selectCaptureDevice {
    NSArray<AVCaptureDeviceType>* deviceTypes = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInDualCamera, AVCaptureDeviceTypeBuiltInTrueDepthCamera];
    NSArray* devices = [[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack] devices];
    return devices.firstObject;
}

- (void) captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage* ciImage = [CIImage imageWithCVImageBuffer:imageBuffer];
    __weak __typeof(self) weakSelf = self;
    dispatch_sync(self.sessionQueue, ^{
        [[weakSelf delegate] capturedImage:ciImage];
        switch (weakSelf.mode) {
            case exportFullImage:
                [[weakSelf delegate] capturedImage:ciImage];
                break;
            case exportCroppedImage: {
                [weakSelf cropImage:ciImage WithCompletionHandler:^(CIImage* croppedImage) {
                    [[weakSelf delegate] capturedAndCroppedImage:croppedImage];
                }];
                break;
            }
            case exportCompressImage: {
                [weakSelf compressImage:ciImage WithCompletionHandler:^(CIImage* compressImage) {
                    [[weakSelf delegate] capturedAndCompressImage:compressImage];
                }];
                break;
            }
            case exportCroppedAndCompressImage: {
                [weakSelf cropImage:ciImage WithCompletionHandler:^(CIImage* croppedImage) {
                    [weakSelf compressImage:croppedImage WithCompletionHandler:^(CIImage* finalImage) {
                        [[weakSelf delegate] capturedWithCroppedAndCompressImage:finalImage];
                    }];
                }];
            }
        }
    });
}

/*
 func crop(image:UIImage, cropRect:CGRect) -> UIImage? {
 UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
 let origin = CGPoint(x: cropRect.origin.x * CGFloat(-1), y: cropRect.origin.y * CGFloat(-1))
 image.draw(at: origin)
 let result = UIGraphicsGetImageFromCurrentImageContext()
 UIGraphicsEndImageContext();
 
 return result
 }
 */
/*
var ciRect = rect
ciRect.origin.y = ciImage.extent.height - ciRect.origin.y - ciRect.height
let ciCroppedImage = ciImage.cropped(to: ciRect)
return UIImage(ciImage: ciCroppedImage)*/

- (void) cropImage:(CIImage*) image WithCompletionHandler:(void(^)(CIImage* _Nullable)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect ciRect = self.recognizeZone;
        ciRect.origin.y = image.extent.size.height - ciRect.origin.y - ciRect.size.height;
        CIImage* croppedImage = [image imageByCroppingToRect:ciRect];
        completion(croppedImage);
    });
}

- (void) compressImage:(CIImage*) image WithCompletionHandler:(void(^)(CIImage* _Nullable)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
        UIImage* originImage = [UIImage imageWithCIImage:image];
        NSData* compressedData = UIImageJPEGRepresentation(originImage, 0.6);
        CIImage* result = [CIImage imageWithData:compressedData];
         */
        CGImageRef cgImg = [context createCGImage:croppedImage fromRect:[croppedImage extent]];
        UIImage *returnedImage = [UIImage imageWithCGImage:cgImg scale:1.0f orientation:UIImageOrientationUp];
        completion(returnedImage.CIImage);
    });
}

- (void) previewCaptureScreen {
    self.previewView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    if (self.previewView) {
        self.previewView.videoGravity = AVLayerVideoGravityResizeAspect;
        self.previewView.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
}

- (void) startCaptureSession {
    self.session.startRunning;
}

- (void) stopCaptureSession {
    self.session.stopRunning;
}
@end
