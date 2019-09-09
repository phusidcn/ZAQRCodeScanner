//
//  QRCodeProcess.m
//  ZAQRCodeScanner
//
//  Created by CPU11899 on 8/21/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "QRDecodeManager.h"
#import <UIKit/UIKit.h>

@implementation QRDecodeManager
- (instancetype) init {
    self = [super init];
    if (self) {
        self.scanComplete = false;
        self.threadSafeQueue = dispatch_queue_create("com.qr.decode.queue", DISPATCH_QUEUE_CONCURRENT);
        self.sessionQueue = [NSOperationQueue new];
        self.operationQueue = [NSOperationQueue new];
        [[self operationQueue] setMaxConcurrentOperationCount:3];
        self.methods = [[MethodArray alloc] init];
        [[self methods] addObject:[[QRScanner_Vision alloc] init]];
        [[self methods] addObject:[[QRScanner_CoreImage alloc] init]];
        [[self methods] addObject:[[QRScanner_ZXing alloc] init]];
    }
    return self;
}

+ (instancetype) managerInstance {
    static QRDecodeManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void) changeScanStatus:(BOOL) status {
    dispatch_barrier_async([[QRDecodeManager managerInstance] threadSafeQueue], ^{
        [[QRDecodeManager managerInstance] setScanComplete:status];
    });
}

- (BOOL) scanCompleteStatus {
    __block BOOL status;
    dispatch_sync([[QRDecodeManager managerInstance] threadSafeQueue], ^{
        status = [[QRDecodeManager managerInstance] scanComplete];
    });
    return status;
}

- (void) decodeImage:(CIImage*)image WithCompletionHandler:(nonnull void(^)(NSString* _Nullable result, NSException* _Nullable exception)) completion {
    NSBlockOperation *blockZXing = [[NSBlockOperation alloc] init];
    NSBlockOperation *blockVision = [[NSBlockOperation alloc] init];
    NSBlockOperation *blockCoreImage = [[NSBlockOperation alloc] init];
    __weak __typeof(NSBlockOperation) *weakZXingBlock = blockZXing;
    __weak __typeof(NSBlockOperation) *weakVisionBlock = blockVision;
    __weak __typeof(NSBlockOperation) *weakCoreImageBlock = blockCoreImage;
    
    [blockVision addExecutionBlock:^{
        id<QRCodeDecodeMethod> method = [[self methods] objectAtIndex:0];
        [method decodeFromImage:image WithCompletionHandler:^(NSString* resultString, NSException* exception) {
            if (resultString && ![weakVisionBlock isCancelled]) {
                [[QRDecodeManager managerInstance] changeScanStatus:true];
                completion(resultString, exception);
                [[NSOperationQueue currentQueue] cancelAllOperations];
            }
        }];
    }];
    
    [blockCoreImage addExecutionBlock:^{
        id<QRCodeDecodeMethod> method = [[self methods] objectAtIndex:1];
        [method decodeFromImage:image WithCompletionHandler:^(NSString* resultString, NSException* exception) {
            if (resultString && ![weakCoreImageBlock isCancelled]) {
                completion(resultString, exception);
                [[NSOperationQueue currentQueue] cancelAllOperations];
            }
        }];
    }];
    
    [blockZXing addExecutionBlock:^{
        id<QRCodeDecodeMethod> method = [[self methods] objectAtIndex:2];
        [method decodeFromImage:image WithCompletionHandler:^(NSString* resultString, NSException* exception) {
            if (resultString && ![weakZXingBlock isCancelled]) {
                completion(resultString, exception);
                [[NSOperationQueue currentQueue] cancelAllOperations];
            }
        }];
    }];
    [[[QRDecodeManager managerInstance] operationQueue] addOperation:blockVision];
    [[[QRDecodeManager managerInstance] operationQueue] addOperation:blockCoreImage];
    [[[QRDecodeManager managerInstance] operationQueue] addOperation:blockZXing];
}

- (void) cancelProcessingRemainImage {
    [[[QRDecodeManager managerInstance] sessionQueue] cancelAllOperations];
}

- (void) addImageToDecodeSession:(CIImage *)image WithCompletionHandler:(void (^)(NSString * _Nonnull, NSException * _Nonnull))completion {
    NSBlockOperation* decodeSession = [[NSBlockOperation alloc] init];
    __weak __typeof(NSBlockOperation) *weakDecodeBlock = decodeSession;
    [decodeSession addExecutionBlock:^{
        [[QRDecodeManager managerInstance] decodeImage:image WithCompletionHandler:^(NSString* _Nullable result, NSException* _Nullable exception) {
            if (result && ![weakDecodeBlock isCancelled]) {
                completion(result, exception);
            }
        }];
    }];
    [[[QRDecodeManager managerInstance] sessionQueue] addOperation:decodeSession];
}
@end
