//
//  LiveCameraComponent.h
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 9/6/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    exportFullImage,
    exportCroppedImage,
    exportCompressImage,
    exportCroppedAndCompressImage
} exportMode;

@protocol CameraCaptureDelegate <NSObject>
@optional
- (void) capturedImage:(CIImage*) image;
- (void) capturedAndCroppedImage:(CIImage*) image;
- (void) capturedAndCompressImage:(CIImage*) image;
- (void) capturedWithCroppedAndCompressImage:(CIImage*) image;
- (void) getPermissionNotification:(NSString*) notify;
@end

@interface LiveCameraComponent : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>
@property AVCaptureDevice* device;
@property AVCaptureDeviceInput* inputDevice;
@property AVCaptureSession* session;
@property dispatch_queue_t sessionQueue;
@property dispatch_queue_t dataOutputQueue;
@property BOOL accessGranted;
@property AVCaptureDevicePosition devicePosition;
@property AVCaptureSessionPreset preset;
@property AVCaptureVideoDataOutput* dataOutput;
@property AVCaptureVideoPreviewLayer* previewView;
@property CGRect recognizeZone;
@property id<CameraCaptureDelegate> delegate;
@property exportMode mode;

- (instancetype) initWithZone:(CGRect) recognizeZone AndMode:(exportMode) mode;
- (void) getPermissionForDevice;
- (void) capturePositionConfiguration;
- (AVCaptureDevice*) selectCaptureDevice;
- (void) previewCaptureScreen;
- (void) startCaptureSession;
- (void) stopCaptureSession;
@end

NS_ASSUME_NONNULL_END
